CREATE OR REPLACE FUNCTION public.get_settlement_summary_by_company(p_settlement_month text)
RETURNS TABLE(
    company_id uuid,
    company_group text,
    company_name text,
    business_registration_number text,
    representative_name text,
    manager_name text,
    client_count bigint,
    total_records bigint,
    total_prescription_amount double precision,
    total_payment_amount double precision,
    is_shared boolean,
    settlement_share_id bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    WITH summary AS (
        SELECT
            c.id AS company_id,
            c.company_group,
            c.company_name,
            c.business_registration_number,
            c.representative_name,
            c.assigned_pharmacist_contact AS manager_name,
            COUNT(DISTINCT pra.client_id) AS client_count,
            COUNT(*) AS total_records,
            COALESCE(SUM(pra.prescription_amount), 0)::double precision AS total_prescription_amount,
            COALESCE(SUM(pra.payment_amount), 0)::double precision AS total_payment_amount
        FROM
            public.performance_records_absorption pra
        JOIN
            public.companies c ON pra.company_id = c.id
        WHERE
            pra.settlement_month = p_settlement_month
        GROUP BY
            c.id, c.company_group, c.company_name, c.business_registration_number, c.representative_name, c.assigned_pharmacist_contact
    )
    SELECT
        s.company_id,
        s.company_group,
        s.company_name,
        s.business_registration_number,
        s.representative_name,
        s.manager_name,
        s.client_count,
        s.total_records,
        s.total_prescription_amount,
        s.total_payment_amount,
        COALESCE(ss.share_enabled, false) AS is_shared,
        ss.id AS settlement_share_id
    FROM
        summary s
    LEFT JOIN
        public.settlement_share ss ON s.company_id = ss.company_id AND ss.settlement_month = p_settlement_month;
END;
$$;

CREATE OR REPLACE FUNCTION public.create_settlement_summary(p_settlement_month text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- 1. Clear existing data for the settlement month
    DELETE FROM absorption_analysis_summary WHERE settlement_month = p_settlement_month;
    DELETE FROM absorption_analysis WHERE settlement_month = p_settlement_month;

    -- 2. Insert base data from performance_records
    INSERT INTO absorption_analysis (
        performance_record_id,
        settlement_month,
        company_id,
        client_id,
        product_id
        -- removed_at, update_by, and created_add_at are intentionally left NULL
    )
    SELECT
        pr.id,
        pr.settlement_month,
        pr.company_id,
        pr.client_id,
        pr.product_id
    FROM
        performance_records pr
    WHERE
        pr.settlement_month = p_settlement_month;

    -- 3. Update details from other tables
    -- Update prescription details from performance_records
    UPDATE absorption_analysis aa
    SET
        prescription_qty = pr.prescription_qty,
        prescription_type = pr.prescription_type
    FROM performance_records pr
    WHERE aa.performance_record_id = pr.id AND aa.settlement_month = p_settlement_month;

    -- (The rest of the function remains the same)
    -- ...
END;
$function$
; 