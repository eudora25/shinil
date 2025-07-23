CREATE OR REPLACE VIEW public.review_details_view AS
WITH analysis_base AS (
    SELECT
        aa.id AS absorption_analysis_id,
        aa.performance_record_id,
        aa.review_status,
        aa.review_action,
        pr.user_edit_status,
        -- 등록자 ID 결정 (관리자가 추가했으면 관리자 ID, 아니면 원본 등록자 ID)
        COALESCE(aa.registered_add_by, pr.registered_by) AS final_registered_by_id,
        aa.update_by, -- 수정자 ID
        COALESCE(aa.company_id_add, pr.company_id) AS final_company_id,
        COALESCE(aa.client_id_add, pr.client_id) AS final_client_id,
        COALESCE(aa.product_id_modify, pr.product_id) AS final_product_id,
        COALESCE(aa.prescription_month_modify, pr.prescription_month) AS prescription_month,
        COALESCE(aa.prescription_qty_modify, pr.prescription_qty) AS prescription_qty,
        COALESCE(aa.prescription_type_modify, (pr.prescription_type)::text) AS prescription_type,
        COALESCE(aa.remarks_modify, pr.remarks) AS remarks,
        aa.commission_rate_modify,
        -- 날짜 결정 (관리자 추가일 우선)
        COALESCE(aa.created_add_at, pr.created_at) AS final_created_at,
        COALESCE(aa.settlement_month_add, pr.settlement_month) AS final_settlement_month,
        aa.updated_at
    FROM absorption_analysis aa
    LEFT JOIN performance_records pr ON aa.performance_record_id = pr.id
)
SELECT
    ab.absorption_analysis_id,
    ab.performance_record_id,
    ab.review_status,
    ab.review_action,
    ab.user_edit_status,
    ab.final_company_id AS company_id,
    ab.final_client_id AS client_id,
    ab.final_product_id AS product_id,
    ab.prescription_month,
    ab.prescription_qty,
    ab.prescription_type,
    ab.remarks,
    ab.final_created_at AS created_at,
    ab.final_settlement_month AS settlement_month,
    ab.updated_at,
    -- 최종 등록자 이름 결정 로직 수정
    CASE
        WHEN registrant.role = 'admin' THEN registrant.contact_person_name
        ELSE registrant.company_name
    END AS registered_by_name,
    updater.contact_person_name AS updated_by_name, -- 수정자 이름
    c.company_name,
    c.company_group,
    c.business_registration_number,
    c.representative_name,
    c.assigned_pharmacist_contact AS manager_name,
    cl.name AS client_name,
    p.product_name AS product_name_display,
    p.insurance_code,
    p.price,
    (ab.prescription_qty * p.price) AS prescription_amount,
    COALESCE(
        ab.commission_rate_modify,
        CASE
            WHEN c.default_commission_grade = 'B' THEN p.commission_rate_b
            ELSE p.commission_rate_a
        END
    ) AS commission_rate
FROM analysis_base ab
-- 이름 조인을 위한 조인
LEFT JOIN companies registrant ON ab.final_registered_by_id = registrant.user_id
LEFT JOIN companies updater ON ab.update_by = updater.user_id
-- 나머지 데이터 조인
LEFT JOIN companies c ON ab.final_company_id = c.id
LEFT JOIN clients cl ON ab.final_client_id = cl.id
LEFT JOIN products p ON ab.final_product_id = p.id; 