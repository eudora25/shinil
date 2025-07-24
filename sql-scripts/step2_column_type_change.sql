-- 2단계: prescription_qty 컬럼 타입 변경 (integer → numeric)
-- 생성일: 2025-01-06
-- 목적: 안전한 컬럼 타입 변경 실행

-- 2-1. 변경 전 마지막 상태 확인
SELECT 
    '2-1. Before Change - Final Check' as check_point,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 2-2. 실제 컬럼 타입 변경 실행
ALTER TABLE performance_records_absorption 
ALTER COLUMN prescription_qty TYPE numeric;

-- 2-3. 변경 후 즉시 상태 확인
SELECT 
    '2-3. After Change - Immediate Check' as check_point,
    column_name,
    data_type,
    is_nullable,
    column_default,
    numeric_precision,
    numeric_scale
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 2-4. 변경 후 데이터 무결성 즉시 검증
SELECT 
    '2-4. Data Integrity - Immediate Verification' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    COUNT(*) - COUNT(prescription_qty) as null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value
FROM performance_records_absorption;

-- 2-5. 변경 후 샘플 데이터 확인 (처음 5개)
SELECT 
    '2-5. Sample Data After Change' as check_point,
    id,
    prescription_qty,
    settlement_month,
    company_id
FROM performance_records_absorption 
WHERE prescription_qty IS NOT NULL
ORDER BY id 
LIMIT 5;

-- 2-6. 변경 완료 확인
SELECT 
    '2-6. Change Completion Status' as check_point,
    'prescription_qty 컬럼 타입 변경 완료' as message,
    'integer → numeric 변환 성공' as status,
    NOW() as completion_time; 