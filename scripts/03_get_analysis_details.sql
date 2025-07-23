-- 설명: 흡수율 분석 화면의 메인 데이터를 조회하는 함수입니다.
--      사용자가 선택한 필터(정산월, 업체, 거래처)에 따라 '완료' 상태의 모든 실적 상세 정보를 계산하고 조합하여 반환합니다.

CREATE OR REPLACE FUNCTION get_absorption_analysis_details(
    p_settlement_month TEXT,
    p_company_id UUID,
    p_client_id UUID
)
RETURNS TABLE (
    id BIGINT,
    company_name TEXT,
    client_name TEXT,
    prescription_month TEXT,
    product_name_display TEXT,
    insurance_code TEXT,
    price NUMERIC,
    prescription_qty INT4,
    prescription_amount NUMERIC,
    prescription_type TEXT,
    commission_rate NUMERIC,
    payment_amount NUMERIC,
    remarks TEXT,
    created_at TIMESTAMPTZ,
    created_by TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH analysis_base AS (
        SELECT
            aa.id,
            -- 조인을 위한 ID 통합
            COALESCE(aa.company_id_add, pr.company_id) AS company_id,
            pr.client_id,
            COALESCE(aa.product_id_modify, pr.product_id) AS product_id,
            
            -- 조인을 위한 처방월 통합
            COALESCE(aa.prescription_month_modify, pr.prescription_month) AS prescription_month,
            
            -- 수정값을 우선으로 하는 데이터 통합
            COALESCE(aa.prescription_qty_modify, pr.prescription_qty) AS prescription_qty,
            COALESCE(aa.prescription_type_modify, pr.prescription_type) AS prescription_type,
            COALESCE(aa.remarks_modify, pr.remarks) AS remarks,

            -- 메타데이터
            pr.created_at,
            pr.registered_by
        FROM absorption_analysis aa
        LEFT JOIN performance_records pr ON aa.performance_record_id = pr.id
        WHERE aa.review_status = '완료'
          -- 월 필터링 로직 수정
          AND (
            (aa.performance_record_id IS NOT NULL AND pr.settlement_month = p_settlement_month) OR
            (aa.performance_record_id IS NULL AND aa.prescription_month_modify = p_settlement_month)
          )
    )
    SELECT
        ab.id,
        c.company_name,
        cl.name AS client_name,
        ab.prescription_month,
        p.product_name AS product_name_display,
        p.insurance_code,
        p.price,
        ab.prescription_qty,
        (p.price * ab.prescription_qty) AS prescription_amount,
        ab.prescription_type,
        
        -- 수수료율 계산
        CASE
            WHEN c.default_commission_grade = 'B' THEN p.commission_rate_b
            ELSE p.commission_rate_a
        END AS commission_rate,
        
        -- 지급액 계산 (수정된 로직 반영)
        ((p.price * ab.prescription_qty) * 
            (CASE
                WHEN c.default_commission_grade = 'B' THEN p.commission_rate_b
                ELSE p.commission_rate_a
            END)
        ) AS payment_amount,
        
        ab.remarks,
        ab.created_at,
        
        -- 등록자 정보 처리
        CASE 
            WHEN ab.registered_by IS NULL THEN '관리자'
            ELSE ab.registered_by::text
        END AS created_by
        
    FROM analysis_base ab
    JOIN companies c ON ab.company_id = c.id
    LEFT JOIN clients cl ON ab.client_id = cl.id -- 관리자 추가 건은 client_id가 없을 수 있으므로 LEFT JOIN
    JOIN products p ON ab.product_id = p.id AND ab.prescription_month = p.base_month
    LEFT JOIN companies reg_c ON ab.registered_by = reg_c.user_id
    WHERE (p_company_id IS NULL OR ab.company_id = p_company_id)
      AND (p_client_id IS NULL OR ab.client_id = p_client_id);
END;
$$; 