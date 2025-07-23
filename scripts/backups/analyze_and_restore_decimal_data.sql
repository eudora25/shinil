-- performance_records에서 소수점 데이터를 performance_records_absorption으로 복원
-- 목적: int4 타입 때문에 잘린 소수점 데이터 복원

-- 1. 문제 범위 분석: performance_records에서 소수점이 있는 데이터 확인
SELECT 
    '1. Source Data Analysis' as step,
    COUNT(*) as total_records,
    COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END) as decimal_records,
    ROUND(
        (COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END)::numeric / COUNT(*)) * 100, 
        2
    ) as decimal_percentage
FROM performance_records
WHERE prescription_qty IS NOT NULL;

-- 2. 매칭 가능한 레코드 분석 (performance_records와 performance_records_absorption 간)
SELECT 
    '2. Matching Records Analysis' as step,
    COUNT(*) as matching_records,
    COUNT(CASE WHEN pr.prescription_qty != FLOOR(pr.prescription_qty) THEN 1 END) as decimal_source_records,
    COUNT(CASE WHEN pr.prescription_qty != pra.prescription_qty THEN 1 END) as mismatched_records
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL;

-- 3. 실제 복원 대상 레코드 확인 (소수점이 잘린 경우)
SELECT 
    '3. Restoration Target Records' as step,
    pr.id,
    pr.prescription_qty as original_value,
    pra.prescription_qty as current_value,
    pr.prescription_qty - pra.prescription_qty as lost_decimal,
    pr.settlement_month
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL
  AND pr.prescription_qty != pra.prescription_qty
  AND pr.prescription_qty != FLOOR(pr.prescription_qty)  -- 원본이 소수점 있는 경우
ORDER BY pr.id
LIMIT 10;

-- 4. 복원 대상 레코드 개수 확인
SELECT 
    '4. Restoration Count' as step,
    COUNT(*) as records_to_restore,
    MIN(pr.prescription_qty - pra.prescription_qty) as min_lost_decimal,
    MAX(pr.prescription_qty - pra.prescription_qty) as max_lost_decimal,
    AVG(pr.prescription_qty - pra.prescription_qty) as avg_lost_decimal
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL
  AND pr.prescription_qty != pra.prescription_qty
  AND pr.prescription_qty != FLOOR(pr.prescription_qty);

-- 5. 실제 복원 실행 (주석 해제 후 실행)
/*
UPDATE performance_records_absorption pra
SET prescription_qty = pr.prescription_qty,
    updated_at = NOW()
FROM performance_records pr
WHERE pra.id = pr.id
  AND pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL
  AND pr.prescription_qty != pra.prescription_qty
  AND pr.prescription_qty != FLOOR(pr.prescription_qty);
*/

-- 6. 복원 후 검증 (복원 실행 후 주석 해제)
/*
SELECT 
    '6. Post-Restoration Verification' as step,
    COUNT(*) as total_checked,
    COUNT(CASE WHEN pr.prescription_qty = pra.prescription_qty THEN 1 END) as matching_records,
    COUNT(CASE WHEN pr.prescription_qty != pra.prescription_qty THEN 1 END) as still_mismatched,
    COUNT(CASE WHEN pra.prescription_qty != FLOOR(pra.prescription_qty) THEN 1 END) as decimal_records_restored
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL;
*/ 