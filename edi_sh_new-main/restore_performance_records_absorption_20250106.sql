-- performance_records_absorption 테이블 복구 스크립트
-- 생성일: 2025-01-06
-- 목적: 백업에서 원본 테이블로 복구

-- ⚠️ 주의: 이 스크립트는 원본 테이블을 완전히 대체합니다!
-- 실행 전 반드시 현재 상태를 확인하세요.

-- 1. 현재 테이블 상태 확인
SELECT 
    'Current Table Status' as info,
    COUNT(*) as current_records,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM performance_records_absorption;

-- 2. 백업 테이블 존재 확인
SELECT 
    'Backup Table Status' as info,
    COUNT(*) as backup_records,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM performance_records_absorption_backup_20250106;

-- 3. 복구 실행 (주의: 원본 테이블 삭제 후 재생성)
-- 실행 전 주석을 해제하고 사용하세요.

/*
-- 3-1. 원본 테이블 삭제
DROP TABLE IF EXISTS performance_records_absorption;

-- 3-2. 백업에서 원본 테이블 복구
CREATE TABLE performance_records_absorption AS 
SELECT * FROM performance_records_absorption_backup_20250106;

-- 3-3. 필요한 인덱스 재생성
CREATE INDEX idx_pra_settlement_month ON performance_records_absorption(settlement_month);
CREATE INDEX idx_pra_company_id ON performance_records_absorption(company_id);
CREATE INDEX idx_pra_client_id ON performance_records_absorption(client_id);
CREATE INDEX idx_pra_product_id ON performance_records_absorption(product_id);
CREATE INDEX idx_pra_created_at ON performance_records_absorption(created_at);

-- 3-4. 복구 완료 확인
SELECT 
    'Restored Table' as info,
    COUNT(*) as restored_records,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM performance_records_absorption;
*/

-- 4. 백업 테이블 정리 (복구 완료 후 실행)
-- DROP TABLE IF EXISTS performance_records_absorption_backup_20250106; 