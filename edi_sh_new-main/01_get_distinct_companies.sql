-- 설명: 흡수율 분석 화면에서 '업체' 필터 목록을 동적으로 생성하기 위한 함수입니다.
--      특정 정산월에 '완료' 상태인 실적 데이터에 연결된 모든 업체의 목록을 중복 없이 가져옵니다.

CREATE OR REPLACE FUNCTION get_distinct_companies_from_analysis(p_settlement_month TEXT)
RETURNS TABLE (id UUID, company_name TEXT)
LANGUAGE sql
AS $$
    WITH company_ids AS (
        -- 관리자가 직접 추가한 실적의 업체 ID
        SELECT company_id_add AS company_id 
        FROM absorption_analysis
        WHERE prescription_month_modify = p_settlement_month
          AND review_status = '완료' 
          AND company_id_add IS NOT NULL
        
        UNION
        
        -- 사용자가 업로드한 실적의 업체 ID
        SELECT pr.company_id 
        FROM absorption_analysis aa
        JOIN performance_records pr ON aa.performance_record_id = pr.id
        WHERE pr.settlement_month = p_settlement_month
          AND aa.review_status = '완료' 
          AND aa.performance_record_id IS NOT NULL
    )
    SELECT c.id, c.company_name 
    FROM company_ids ci
    JOIN companies c ON ci.company_id = c.id
    GROUP BY c.id, c.company_name;
$$; 