-- performance_records_absorption 테이블 백업 스크립트
-- 생성일: 2025-01-06
-- 목적: prescription_qty 컬럼 타입 변경 전 안전한 백업

-- 1. 전체 테이블 백업 (구조 + 데이터)
CREATE TABLE performance_records_absorption_backup_20250106 AS 
SELECT * FROM performance_records_absorption;

-- 2. 백업 테이블에 인덱스 추가 (빠른 복구를 위해)
CREATE INDEX idx_backup_settlement_month ON performance_records_absorption_backup_20250106(settlement_month);
CREATE INDEX idx_backup_company_id ON performance_records_absorption_backup_20250106(company_id);
CREATE INDEX idx_backup_client_id ON performance_records_absorption_backup_20250106(client_id);

-- 3. 백업 완료 확인
SELECT 
    'Original Table' as table_name,
    COUNT(*) as record_count,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM performance_records_absorption
UNION ALL
SELECT 
    'Backup Table' as table_name,
    COUNT(*) as record_count,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM performance_records_absorption_backup_20250106;

-- 4. prescription_qty 컬럼 데이터 분포 확인
SELECT 
    'prescription_qty 데이터 분포' as info,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    AVG(prescription_qty) as avg_value,
    COUNT(*) as total_records,
    COUNT(DISTINCT prescription_qty) as unique_values
FROM performance_records_absorption;

-- 5. 현재 테이블 구조 백업
SELECT 
    'Current Table Structure' as info,
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length,
    numeric_precision,
    numeric_scale
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
ORDER BY ordinal_position; 