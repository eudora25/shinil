-- 설명: 흡수율 분석을 실행하고, 각 실적별로 연결된 도매/직거래 매출액을 계산하는 함수입니다.
--      최신 review_details_view를 사용하도록 로직을 전면 수정합니다.

-- 1. 기존 함수가 존재하면 삭제
DROP FUNCTION IF EXISTS public.calculate_absorption_rates(p_settlement_month text);

-- 2. 새로운 함수 정의
CREATE OR REPLACE FUNCTION public.calculate_absorption_rates(p_settlement_month text)
RETURNS TABLE(
    analysis_id bigint, 
    wholesale_revenue numeric, 
    direct_revenue numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- 1. 선택된 정산월에 해당하는 '완료' 상태의 모든 실적 데이터를 review_details_view에서 가져옴
    performance_base AS (
        SELECT 
            rdv.absorption_analysis_id,
            rdv.client_id,
            rdv.product_id,
            p.insurance_code,
            p.standard_code, -- 도매/직거래 매출 매칭을 위한 표준코드
            rdv.prescription_month,
            rdv.prescription_qty
        FROM public.review_details_view rdv
        JOIN products p ON rdv.product_id = p.id
        WHERE rdv.settlement_month = p_settlement_month AND rdv.review_status = '완료'
    ),
    -- 2. 병원-약국 매핑 정보
    client_pharmacy_map AS (
        SELECT cpa.client_id, cpa.pharmacy_id, p.business_registration_number AS pharmacy_brn
        FROM client_pharmacy_assignments cpa
        JOIN pharmacies p ON cpa.pharmacy_id = p.id
    ),
    -- 3. 약국별로 연결된 병원 수 계산 (매출 분배 로직에 사용)
    pharmacy_hospital_count AS (
        SELECT pharmacy_id, COUNT(client_id) AS hospital_count
        FROM client_pharmacy_map
        GROUP BY pharmacy_id
    ),
    -- 4. 약국-제품-월별 총 처방수량 계산 (매출 분배 기준)
    distribution_base AS (
        SELECT
            cpm.pharmacy_brn,
            pb.standard_code,
            pb.prescription_month,
            SUM(pb.prescription_qty) AS total_qty_for_distribution
        FROM performance_base pb
        JOIN client_pharmacy_map cpm ON pb.client_id = cpm.client_id
        WHERE pb.standard_code IS NOT NULL
        GROUP BY cpm.pharmacy_brn, pb.standard_code, pb.prescription_month
    )
    -- 5. 최종 결과 계산
    SELECT 
        pb.absorption_analysis_id AS record_id,
        -- 도매 매출 계산
        SUM(
            COALESCE(ws.sales_amount, 0) * 
            (CASE 
                WHEN phc.hospital_count > 1 THEN (pb.prescription_qty::numeric / NULLIF(tdb.total_qty_for_distribution, 0))
                ELSE 1 
            END)
        ) AS calculated_wholesale,
        -- 직거래 매출 계산
        SUM(
            COALESCE(ds.sales_amount, 0) *
            (CASE 
                WHEN phc.hospital_count > 1 THEN (pb.prescription_qty::numeric / NULLIF(tdb.total_qty_for_distribution, 0))
                ELSE 1 
            END)
        ) AS calculated_direct
    FROM performance_base pb
    -- 병원에 연결된 약국 정보 조인
    JOIN client_pharmacy_map cpm ON pb.client_id = cpm.client_id
    -- 약국의 병원 연결 수 정보 조인
    JOIN pharmacy_hospital_count phc ON cpm.pharmacy_id = phc.id
    -- 도매 매출 정보 조인
    LEFT JOIN wholesale_sales ws 
        ON cpm.pharmacy_brn = ws.business_registration_number
        AND pb.standard_code = ws.product_code
        AND pb.prescription_month = ws.sales_month
    -- 직거래 매출 정보 조인
    LEFT JOIN direct_sales ds 
        ON cpm.pharmacy_brn = ds.business_registration_number
        AND pb.standard_code = ds.product_code
        AND pb.prescription_month = ds.sales_month
    -- 매출 분배 기준(총 수량) 조인
    LEFT JOIN distribution_base tdb
        ON cpm.pharmacy_brn = tdb.pharmacy_brn
        AND pb.standard_code = tdb.standard_code
        AND pb.prescription_month = tdb.prescription_month
    GROUP BY pb.absorption_analysis_id;
END;
$$; 