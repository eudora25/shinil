-- 2단계만: 두 테이블 간 불일치 데이터 분석
-- 목적: 소수점 때문에 불일치하는 레코드 개수 파악

SELECT 
    '2. Mismatch Analysis' as step,
    COUNT(*) as matching_records_count,
    COUNT(CASE WHEN pr.prescription_qty != FLOOR(pr.prescription_qty) THEN 1 END) as source_decimal_records,
    COUNT(CASE WHEN pr.prescription_qty != pra.prescription_qty THEN 1 END) as mismatched_records,
    COUNT(CASE WHEN pr.prescription_qty != pra.prescription_qty 
               AND pr.prescription_qty != FLOOR(pr.prescription_qty) THEN 1 END) as decimal_mismatched_records
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL; 