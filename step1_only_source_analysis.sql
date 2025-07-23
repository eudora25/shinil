-- 1단계만: performance_records 소수점 데이터 분석
-- 목적: 원본 데이터에서 소수점 데이터 현황 파악

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