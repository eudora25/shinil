-- prescription_qty 컬럼 타입 변경 스크립트
-- 생성일: 2025-01-06
-- 목적: prescription_qty 컬럼을 integer에서 numeric으로 변경

-- ⚠️ 주의: 백업 테이블 performance_records_absorption_backup_20250106 생성 완료 후 실행하세요!

-- 1. 변경 전 현재 상태 확인
SELECT 
    'Before Change' as status,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 2. prescription_qty 컬럼 타입 변경 (integer → numeric)
ALTER TABLE performance_records_absorption 
ALTER COLUMN prescription_qty TYPE numeric;

-- 3. 변경 후 상태 확인
SELECT 
    'After Change' as status,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 4. 데이터 무결성 검증
SELECT 
    'Data Integrity Check' as info,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value
FROM performance_records_absorption;

-- 5. 백업 테이블과 비교 검증
SELECT 
    'Backup vs Current Comparison' as info,
    (SELECT COUNT(*) FROM performance_records_absorption) as current_count,
    (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) as backup_count,
    (SELECT COUNT(*) FROM performance_records_absorption) - 
    (SELECT COUNT(*) FROM performance_records_absorption_backup_20250106) as difference;

-- 6. 샘플 데이터 비교 (처음 5개 레코드)
SELECT 
    'Sample Data Comparison' as info,
    'Current Table' as source,
    id,
    prescription_qty,
    settlement_month,
    company_id
FROM performance_records_absorption 
ORDER BY id 
LIMIT 5

UNION ALL

SELECT 
    'Sample Data Comparison' as info,
    'Backup Table' as source,
    id,
    prescription_qty,
    settlement_month,
    company_id
FROM performance_records_absorption_backup_20250106 
ORDER BY id 
LIMIT 5; 