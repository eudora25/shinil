-- 설명: 흡수율 분석 화면에서 '거래처' 필터 목록을 동적으로 생성하기 위한 함수입니다.
--      특정 정산월과 (선택적으로) 특정 업체에 연결된 모든 거래처의 목록을 중복 없이 가져옵니다.
-- 참고: 이 함수는 사용자가 업로드한 실적에만 존재하는 '거래처' 정보를 기반으로 동작합니다.

CREATE OR REPLACE FUNCTION get_distinct_clients_from_analysis(p_settlement_month TEXT, p_company_id UUID)
RETURNS TABLE (id UUID, name TEXT)
LANGUAGE sql
AS $$
    SELECT 
        c.id, 
        c.name 
    FROM absorption_analysis aa
    JOIN performance_records pr ON aa.performance_record_id = pr.id
    JOIN clients c ON pr.client_id = c.id
    WHERE pr.settlement_month = p_settlement_month
      AND aa.review_status = '완료'
      AND (p_company_id IS NULL OR pr.company_id = p_company_id)
    GROUP BY c.id, c.name;
$$; 