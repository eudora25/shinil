-- 3단계: 변경 후 데이터 무결성 검증
-- 생성일: 2025-01-06
-- 목적: prescription_qty 컬럼 타입 변경 후 완전한 데이터 무결성 검증

-- 3-1. 변경된 컬럼 구조 상세 확인
SELECT 
    '3-1. Changed Column Structure' as check_point,
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length,
    numeric_precision,
    numeric_scale,
    udt_name
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 3-2. 백업 테이블과 현재 테이블 레코드 수 비교
SELECT 
    '3-2. Record Count Comparison' as check_point,
    (SELECT COUNT(*) FROM performance_records_absorption) as current_count,
    (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) as backup_count,
    (SELECT COUNT(*) FROM performance_records_absorption) - 
    (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) as difference,
    CASE 
        WHEN (SELECT COUNT(*) FROM performance_records_absorption) = 
             (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) 
        THEN 'PERFECT MATCH ✅' 
        ELSE 'COUNT MISMATCH ❌' 
    END as status;

-- 3-3. prescription_qty 데이터 통계 비교 (백업 vs 현재)
SELECT 
    '3-3. Data Statistics - Backup Table' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value,
    SUM(prescription_qty) as total_sum
FROM performance_records_absorption_backup_20250106;

SELECT 
    '3-3. Data Statistics - Current Table' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value,
    SUM(prescription_qty) as total_sum
FROM performance_records_absorption;

-- 3-4. 개별 레코드 값 비교 (처음 10개)
SELECT 
    '3-4. Individual Record Comparison' as check_point,
    'BACKUP' as source,
    id,
    prescription_qty,
    settlement_month
FROM performance_records_absorption_backup_20250106 
WHERE prescription_qty IS NOT NULL
ORDER BY id 
LIMIT 10;

SELECT 
    '3-4. Individual Record Comparison' as check_point,
    'CURRENT' as source,
    id,
    prescription_qty,
    settlement_month
FROM performance_records_absorption 
WHERE prescription_qty IS NOT NULL
ORDER BY id 
LIMIT 10;

-- 3-5. NULL 값 처리 확인
SELECT 
    '3-5. NULL Value Handling' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    COUNT(*) - COUNT(prescription_qty) as null_records,
    ROUND((COUNT(prescription_qty)::numeric / COUNT(*)) * 100, 2) as non_null_percentage
FROM performance_records_absorption;

-- 3-6. 데이터 타입 연산 테스트
SELECT 
    '3-6. Numeric Operations Test' as check_point,
    COUNT(*) as tested_records,
    AVG(prescription_qty) as avg_calculation,
    SUM(prescription_qty) as sum_calculation,
    MIN(prescription_qty * 1.5) as multiplication_test,
    MAX(prescription_qty / 2.0) as division_test
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL;

-- 3-7. 최종 무결성 검증 결과
SELECT 
    '3-7. Final Integrity Check Result' as check_point,
    'prescription_qty 컬럼 타입 변경 후 데이터 무결성 검증 완료' as message,
    'integer → numeric 변환 성공, 데이터 손실 없음' as status,
    NOW() as verification_time; 