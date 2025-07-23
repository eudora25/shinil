-- 1단계: 타입 변경 전 최종 상태 확인
-- 생성일: 2025-01-06
-- 목적: prescription_qty 컬럼 타입 변경 전 현재 상태 완전 검증

-- 1-1. 현재 테이블 구조 확인
SELECT 
    '1-1. Current Column Structure' as check_point,
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length,
    numeric_precision,
    numeric_scale
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 1-2. 현재 데이터 분포 및 통계
SELECT 
    '1-2. Current Data Distribution' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    COUNT(*) - COUNT(prescription_qty) as null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value,
    COUNT(DISTINCT prescription_qty) as unique_values
FROM performance_records_absorption;

-- 1-3. 백업 테이블 존재 및 데이터 일치 확인
SELECT 
    '1-3. Backup Table Verification' as check_point,
    (SELECT COUNT(*) FROM performance_records_absorption) as original_count,
    (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) as backup_count,
    CASE 
        WHEN (SELECT COUNT(*) FROM performance_records_absorption) = 
             (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) 
        THEN 'MATCH ✅' 
        ELSE 'MISMATCH ❌' 
    END as status;

-- 1-4. prescription_qty 값들의 정수 여부 확인 (numeric 변환 안전성 검증)
SELECT 
    '1-4. Integer Value Verification' as check_point,
    COUNT(*) as total_non_null,
    COUNT(CASE WHEN prescription_qty = FLOOR(prescription_qty) THEN 1 END) as integer_values,
    COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END) as decimal_values,
    CASE 
        WHEN COUNT(CASE WHEN prescription_qty != FLOOR(prescription_qty) THEN 1 END) = 0 
        THEN 'ALL INTEGER - SAFE ✅' 
        ELSE 'HAS DECIMALS - CHECK ⚠️' 
    END as conversion_safety
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL;

-- 1-5. 샘플 데이터 확인 (처음 10개)
SELECT 
    '1-5. Sample Data (First 10)' as check_point,
    id,
    prescription_qty,
    settlement_month,
    company_id,
    client_id
FROM performance_records_absorption 
WHERE prescription_qty IS NOT NULL
ORDER BY id 
LIMIT 10;

-- 1-6. 극값 데이터 확인 (최소, 최대값 레코드)
SELECT 
    '1-6. Extreme Values' as check_point,
    'MIN VALUE' as value_type,
    id,
    prescription_qty,
    settlement_month
FROM performance_records_absorption 
WHERE prescription_qty = (SELECT MIN(prescription_qty) FROM performance_records_absorption)
LIMIT 3

UNION ALL

SELECT 
    '1-6. Extreme Values' as check_point,
    'MAX VALUE' as value_type,
    id,
    prescription_qty,
    settlement_month
FROM performance_records_absorption 
WHERE prescription_qty = (SELECT MAX(prescription_qty) FROM performance_records_absorption)
LIMIT 3;

-- 1-7. 최종 준비 상태 체크
SELECT 
    '1-7. Final Readiness Check' as check_point,
    'prescription_qty 컬럼 타입 변경 준비 완료' as message,
    'integer → numeric 변환 안전성 확인됨' as safety_status,
    NOW() as check_time; 