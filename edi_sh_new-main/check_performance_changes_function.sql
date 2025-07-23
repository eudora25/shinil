CREATE OR REPLACE FUNCTION check_performance_changes(p_settlement_month text)
RETURNS jsonb AS $$
DECLARE
    v_calculated_at timestamp with time zone;
    v_added_count integer;
    v_modified_count integer;
    v_deleted_count integer;
BEGIN
    -- 1. 해당 정산월의 마지막 분석 시간(calculated_at)을 가져옵니다.
    SELECT MAX(calculated_at) INTO v_calculated_at
    FROM absorption_analysis_summary
    WHERE settlement_month = p_settlement_month;

    -- 2. 추가된 건수 계산
    -- absorption_analysis_summary에는 없고, review_details_view에는 '완료' 상태로 있는 건수
    SELECT COUNT(*) INTO v_added_count
    FROM review_details_view v
    WHERE v.settlement_month = p_settlement_month
      AND v.user_edit_status = '완료'
      AND NOT EXISTS (
        SELECT 1
        FROM absorption_analysis_summary s
        WHERE s.settlement_month = p_settlement_month
          AND s.absorption_analysis_id = v.absorption_analysis_id
      );

    -- 3. 변경된 건수 계산
    -- 마지막 분석 시간(calculated_at) 이후에 updated_at이 변경된 '완료' 상태의 건수
    -- v_calculated_at이 NULL이면(최초 분석) 결과는 0이 됩니다.
    SELECT COUNT(*) INTO v_modified_count
    FROM review_details_view v
    JOIN absorption_analysis_summary s ON v.absorption_analysis_id = s.absorption_analysis_id AND v.settlement_month = s.settlement_month
    WHERE v.settlement_month = p_settlement_month
      AND v.user_edit_status = '완료'
      AND v.updated_at > v_calculated_at;

    -- 4. 삭제된 건수 계산
    -- absorption_analysis_summary에는 있었지만, 현재 review_details_view에는 '완료' 상태가 아닌 건수
    SELECT COUNT(*) INTO v_deleted_count
    FROM absorption_analysis_summary s
    WHERE s.settlement_month = p_settlement_month
      AND NOT EXISTS (
        SELECT 1
        FROM review_details_view v
        WHERE v.settlement_month = p_settlement_month
          AND v.absorption_analysis_id = s.absorption_analysis_id
          AND v.user_edit_status = '완료'
      );

    -- 5. 결과를 JSON 형태로 반환
    RETURN jsonb_build_object(
        'added_count', v_added_count,
        'modified_count', v_modified_count,
        'deleted_count', v_deleted_count
    );
END;
$$ LANGUAGE plpgsql; 