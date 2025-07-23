-- 변경 사항 확인 함수
CREATE OR REPLACE FUNCTION check_for_updates(p_settlement_month TEXT)
RETURNS JSON AS $$
DECLARE
    last_calculated_time TIMESTAMP;
    result JSON;
BEGIN
    -- 해당 정산월의 마지막 계산 시각 조회
    SELECT MAX(calculated_at) INTO last_calculated_time
    FROM absorption_analysis_summary
    WHERE settlement_month = p_settlement_month;
    
    -- 계산된 데이터가 없으면 모든 변경사항을 0으로 반환
    IF last_calculated_time IS NULL THEN
        result := json_build_object(
            'updated_reviews', 0,
            'updated_mappings', 0,
            'updated_sales', 0,
            'has_changes', false
        );
        RETURN result;
    END IF;
    
    -- 각 항목별 변경 건수 계산
    WITH changes AS (
        -- 검수 완료 변경 건수
        SELECT COUNT(*) as review_changes
        FROM absorption_analysis
        WHERE settlement_month = p_settlement_month
        AND review_status = '완료'
        AND updated_at > last_calculated_time
        
        UNION ALL
        
        -- 병원-약국 매핑 변경 건수
        SELECT COUNT(*)
        FROM client_pharmacy_assignments cpa
        JOIN clients c ON cpa.client_id = c.id
        JOIN absorption_analysis aa ON c.id = aa.client_id
        WHERE aa.settlement_month = p_settlement_month
        AND aa.review_status = '완료'
        AND cpa.created_at > last_calculated_time
        
        UNION ALL
        
        -- 매출자료 변경 건수 (도매매출 + 직거래매출)
        SELECT COUNT(*)
        FROM (
            SELECT updated_at FROM wholesale_sales
            WHERE TO_CHAR(sales_date, 'YYYY-MM') = p_settlement_month AND updated_at > last_calculated_time
            UNION ALL
            SELECT updated_at FROM direct_sales
            WHERE TO_CHAR(sales_date, 'YYYY-MM') = p_settlement_month AND updated_at > last_calculated_time
        ) sales_changes
    )
    SELECT json_build_object(
        'updated_reviews', (SELECT review_changes FROM changes LIMIT 1),
        'updated_mappings', (SELECT review_changes FROM changes OFFSET 1 LIMIT 1),
        'updated_sales', (SELECT review_changes FROM changes OFFSET 2 LIMIT 1),
        'has_changes', (
            (SELECT review_changes FROM changes LIMIT 1) > 0 OR
            (SELECT review_changes FROM changes OFFSET 1 LIMIT 1) > 0 OR
            (SELECT review_changes FROM changes OFFSET 2 LIMIT 1) > 0
        )
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql; 