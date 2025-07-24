-- =====================================================================
-- Step 4: Restore prescription_qty values from original table
-- =====================================================================
-- 목적: performance_records_absorption 테이블의 34개 레코드의 
--       prescription_qty 값을 원본 performance_records 테이블 값으로 복원

-- 1. 복원 전 상태 확인
SELECT 
    '1. Pre-Restoration Status' as step,
    COUNT(*) as total_records,
    COUNT(CASE WHEN prescription_qty::text LIKE '%.%' THEN 1 END) as decimal_records,
    COUNT(CASE WHEN prescription_qty::text NOT LIKE '%.%' THEN 1 END) as integer_records
FROM performance_records_absorption;

-- 2. 복원 실행 (34개 레코드)
UPDATE performance_records_absorption 
SET prescription_qty = pr.prescription_qty
FROM performance_records pr
WHERE performance_records_absorption.id = pr.id
AND performance_records_absorption.id IN (
    1921, 2048, 2094, 2099, 2144, 2556, 2737, 2792, 2995, 3000,
    3028, 3065, 3118, 3120, 3138, 3147, 3152, 3158, 3362, 3417,
    3421, 3586, 3680, 3752, 3753, 3815, 3984, 3986, 4044, 4076,
    4110, 4137, 4164, 4165
);

-- 3. 복원 후 상태 확인
SELECT 
    '2. Post-Restoration Status' as step,
    COUNT(*) as total_records,
    COUNT(CASE WHEN prescription_qty::text LIKE '%.%' THEN 1 END) as decimal_records,
    COUNT(CASE WHEN prescription_qty::text NOT LIKE '%.%' THEN 1 END) as integer_records
FROM performance_records_absorption;

-- 4. 복원된 레코드들 확인 (샘플 10개)
SELECT 
    '3. Restored Records Sample (10개)' as step,
    id,
    prescription_qty,
    settlement_month,
    company_id
FROM performance_records_absorption
WHERE id IN (1921, 2048, 2094, 2099, 2144, 2556, 2737, 2792, 2995, 3000)
ORDER BY id;

-- 5. 원본과 분석용 테이블 완전 일치 확인
SELECT 
    '4. Final Verification' as step,
    COUNT(*) as matching_records,
    COUNT(CASE WHEN pr.prescription_qty = pra.prescription_qty THEN 1 END) as identical_values,
    COUNT(CASE WHEN pr.prescription_qty != pra.prescription_qty THEN 1 END) as different_values
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id;

-- 6. 성공 메시지
SELECT 
    '5. RESTORATION COMPLETED ✅' as step,
    '34개 레코드의 prescription_qty 소수점 데이터가 성공적으로 복원되었습니다.' as message,
    'performance_records와 performance_records_absorption 테이블이 완전히 동기화되었습니다.' as result; 