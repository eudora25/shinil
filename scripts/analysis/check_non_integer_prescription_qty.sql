-- performance_records_absorption에서 prescription_qty가 정수가 아닌 데이터 조회
-- 목적: 소수점이 있는 prescription_qty 데이터의 id값 확인

-- 1. prescription_qty가 정수가 아닌 데이터의 id값만 조회
SELECT 
    id,
    prescription_qty,
    settlement_month,
    company_id,
    client_id
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL 
  AND prescription_qty != FLOOR(prescription_qty)
ORDER BY id;

-- 2. 정수가 아닌 데이터의 개수 확인
SELECT 
    'Non-Integer Count' as info,
    COUNT(*) as non_integer_count,
    (SELECT COUNT(*) FROM performance_records_absorption WHERE prescription_qty IS NOT NULL) as total_non_null_count,
    ROUND(
        (COUNT(*)::numeric / (SELECT COUNT(*) FROM performance_records_absorption WHERE prescription_qty IS NOT NULL)) * 100, 
        2
    ) as percentage
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL 
  AND prescription_qty != FLOOR(prescription_qty);

-- 3. 소수점이 있는 데이터의 샘플 (처음 10개)
SELECT 
    'Sample Non-Integer Data' as info,
    id,
    prescription_qty,
    prescription_qty - FLOOR(prescription_qty) as decimal_part,
    settlement_month
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL 
  AND prescription_qty != FLOOR(prescription_qty)
ORDER BY id
LIMIT 10; 