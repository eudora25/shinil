-- 설명: 흡수율 분석 화면에서 '정산월' 필터 목록을 동적으로 생성하기 위한 함수입니다.
--      '완료' 상태인 모든 실적 데이터에서 정산월을 중복 없이 가져옵니다.

CREATE OR REPLACE FUNCTION get_distinct_settlement_months_from_analysis()
RETURNS TABLE (settlement_month TEXT)
LANGUAGE sql
AS $$
    -- 관리자가 직접 추가한 실적의 월
    SELECT DISTINCT prescription_month_modify AS settlement_month
    FROM absorption_analysis
    WHERE review_status = '완료' AND company_id_add IS NOT NULL

    UNION

    -- 사용자가 업로드한 실적의 월
    SELECT DISTINCT pr.settlement_month
    FROM absorption_analysis aa
    JOIN performance_records pr ON aa.performance_record_id = pr.id
    WHERE aa.review_status = '완료' AND aa.performance_record_id IS NOT NULL;
$$; 