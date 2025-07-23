-- 1-2단계: 문제 범위 분석 (안전한 조회만)
-- 목적: performance_records의 소수점 데이터와 불일치 현황 파악

-- 1. 문제 범위 분석: performance_records에서 소수점 데이터가 얼마나 있는지 확인
SELECT 
    '1. Source Data Analysis (performance_records)' as step,
    COUNT(*) as total_records,
    COUNT(CASE WHEN prescription_qty IS NOT NULL THEN 1 END) as non_null_records,
    COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END) as decimal_records,
    ROUND(
        (COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END)::numeric / 
         COUNT(CASE WHEN prescription_qty IS NOT NULL THEN 1 END)) * 100, 
        2
    ) as decimal_percentage
FROM performance_records;

-- 2. 두 테이블 간 불일치 데이터 분석
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

-- 3. 레코드 개수 비교 확인
SELECT 
    '3. Record Count Comparison' as step,
    (SELECT COUNT(*) FROM performance_records) as performance_records_count,
    (SELECT COUNT(*) FROM performance_records_absorption) as performance_records_absorption_count,
    (SELECT COUNT(*) FROM performance_records) - 
    (SELECT COUNT(*) FROM performance_records_absorption) as difference,
    (SELECT COUNT(*) FROM performance_records pr 
     JOIN performance_records_absorption pra ON pr.id = pra.id) as matching_id_count; 