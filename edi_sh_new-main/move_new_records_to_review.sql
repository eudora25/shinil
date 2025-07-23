CREATE OR REPLACE FUNCTION public.move_new_records_to_review(
    p_settlement_month TEXT,
    p_company_id UUID DEFAULT NULL,
    p_client_id BIGINT DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
    records_to_move RECORD;
BEGIN
    -- 1. 조건에 맞는 '대기' 상태의 performance_records를 루프를 돌며 처리
    FOR records_to_move IN
        SELECT pr.id
        FROM performance_records pr
        -- 이미 absorption_analysis에 있는지 확인하여 중복 방지
        LEFT JOIN absorption_analysis aa ON pr.id = aa.performance_record_id
        WHERE pr.settlement_month = p_settlement_month
          AND pr.user_edit_status = '대기'
          -- 선택적 필터 조건 적용
          AND (p_company_id IS NULL OR pr.company_id = p_company_id)
          AND (p_client_id IS NULL OR pr.client_id = p_client_id)
          -- 중복 제외
          AND aa.performance_record_id IS NULL
    LOOP
        -- 2. absorption_analysis 테이블에 performance_record_id만 삽입
        -- review_status는 기본값 '검수중'으로 자동 설정됨
        INSERT INTO absorption_analysis (performance_record_id)
        VALUES (records_to_move.id);

        -- 3. 원본 performance_records 테이블의 상태를 '검수중'으로 업데이트
        UPDATE performance_records
        SET user_edit_status = '검수중'
        WHERE id = records_to_move.id;
    END LOOP;
END;
$$ LANGUAGE plpgsql; 