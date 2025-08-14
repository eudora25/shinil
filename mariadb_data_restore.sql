-- =====================================================
-- MariaDB용 신일 프로젝트 데이터 복원 파일
-- =====================================================
-- 
-- 이 파일은 Supabase PostgreSQL에서 내보낸 데이터를 MariaDB에 삽입하기 위한
-- 데이터 복원 스크립트입니다.
-- 
-- 주의사항:
-- 1. 실제 데이터로 교체 후 실행하세요
-- 2. UUID 값들을 실제 값으로 변경하세요
-- 3. 비밀번호는 암호화된 형태로 저장하세요
-- 4. 외래키 관계를 고려하여 삽입 순서를 지켜주세요
-- 
-- 실행 순서:
-- 1. mariadb_schema_restore.sql 실행 완료 후
-- 2. 실제 데이터로 교체
-- 3. 이 스크립트 실행
-- 
-- 작성일: 2024-08-13
-- 버전: 1.0
-- =====================================================

-- =====================================================
-- 1. 데이터베이스 설정
-- =====================================================

-- 신일 프로젝트 데이터베이스 사용
USE shinil_project;

-- UTF-8 문자셋 설정 (한글 데이터 지원)
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET character_set_connection=utf8mb4;

-- =====================================================
-- 2. 기존 데이터 정리 (선택사항)
-- =====================================================

-- 데이터 삽입 전 기존 데이터 정리
-- 주의: 이 부분을 활성화하면 기존 데이터가 모두 삭제됩니다!
-- TRUNCATE TABLE performance_records_absorption;
-- TRUNCATE TABLE performance_records;
-- TRUNCATE TABLE settlement_share;
-- TRUNCATE TABLE wholesale_sales;
-- TRUNCATE TABLE direct_sales;
-- TRUNCATE TABLE client_company_assignments;
-- TRUNCATE TABLE client_pharmacy_assignments;
-- TRUNCATE TABLE product_company_assignments;

-- =====================================================
-- 3. 사용자 데이터 삽입
-- =====================================================

-- 사용자 데이터 삽입 (Supabase auth.users에서 변환)
-- 실제 데이터는 별도로 준비해야 합니다
-- 주의: 비밀번호는 반드시 암호화된 형태로 저장하세요!
INSERT INTO users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_user_meta_data) VALUES
-- 여기에 실제 사용자 데이터를 삽입하세요
-- 예시:
-- ('user-uuid-1', 'admin@shinil.com', 'encrypted_password_hash', NOW(), NOW(), NOW(), '{"user_type": "admin", "approval_status": "approved"}'),
-- ('user-uuid-2', 'user@shinil.com', 'encrypted_password_hash', NOW(), NOW(), NOW(), '{"user_type": "user", "approval_status": "approved"}')
;

-- =====================================================
-- 4. 제품 표준 코드 데이터 삽입
-- =====================================================

-- 제품 표준 코드 데이터 삽입
-- 보험 코드, 표준 코드, 포장 단위 정보
INSERT INTO products_standard_code (id, insurance_code, standard_code, unit_packaging_desc, unit_quantity, status, created_at, updated_at) VALUES
-- 여기에 실제 제품 표준 코드 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'A01BC01', 'STD001', '정제 100mg', 1, 'active', NOW(), NOW()),
-- (UUID(), 'A01BC02', 'STD002', '정제 200mg', 1, 'active', NOW(), NOW())
;

-- =====================================================
-- 5. 제품 데이터 삽입
-- =====================================================

-- 제품 데이터 삽입
-- 제품 기본 정보, 가격, 제조사 등
INSERT INTO products (id, product_name, product_code, insurance_code, manufacturer, unit_price, unit_quantity, unit_packaging_desc, standard_code, status, created_at, updated_at) VALUES
-- 여기에 실제 제품 데이터를 삽입하세요
-- 예시:
-- (UUID(), '아스피린', 'PROD001', 'A01BC01', '제조사A', 1000.00, 1, '정제 100mg', 'STD001', 'active', NOW(), NOW()),
-- (UUID(), '이부프로펜', 'PROD002', 'A01BC02', '제조사B', 1500.00, 1, '정제 200mg', 'STD002', 'active', NOW(), NOW())
;

-- =====================================================
-- 6. 클라이언트(병원) 데이터 삽입
-- =====================================================

-- 클라이언트(병원) 데이터 삽입
-- 병원 정보, 연락처, 담당자 등
INSERT INTO clients (id, client_name, client_code, address, phone, email, contact_person, status, created_at, updated_at) VALUES
-- 여기에 실제 클라이언트 데이터를 삽입하세요
-- 예시:
-- (UUID(), '서울대병원', 'HOSP001', '서울시 강남구', '02-1234-5678', 'contact@seoulhospital.com', '김의사', 'active', NOW(), NOW()),
-- (UUID(), '연세대병원', 'HOSP002', '서울시 서대문구', '02-2345-6789', 'contact@yonseihospital.com', '이의사', 'active', NOW(), NOW())
;

-- 회사 데이터 삽입
-- 제약회사, 제조사 정보
INSERT INTO companies (id, company_name, company_code, address, phone, email, contact_person, status, created_at, updated_at) VALUES
-- 여기에 실제 회사 데이터를 삽입하세요
-- 예시:
-- (UUID(), '신일제약', 'COMP001', '서울시 강남구', '02-3456-7890', 'contact@shinilpharma.com', '박과장', 'active', NOW(), NOW()),
-- (UUID(), '대한제약', 'COMP002', '서울시 서초구', '02-4567-8901', 'contact@daehanpharma.com', '최과장', 'active', NOW(), NOW())
;

-- 약국 데이터 삽입
-- 약국 정보, 연락처, 담당자 등
INSERT INTO pharmacies (id, pharmacy_name, pharmacy_code, address, phone, email, contact_person, status, created_at, updated_at) VALUES
-- 여기에 실제 약국 데이터를 삽입하세요
-- 예시:
-- (UUID(), '건강약국', 'PHARM001', '서울시 강남구', '02-5678-9012', 'contact@healthpharmacy.com', '정약사', 'active', NOW(), NOW()),
-- (UUID(), '행복약국', 'PHARM002', '서울시 서초구', '02-6789-0123', 'contact@happypharmacy.com', '한약사', 'active', NOW(), NOW())
;

-- 공지사항 데이터 삽입
-- 시스템 공지사항, 조회수 관리
INSERT INTO notices (id, title, content, author_id, view_count, status, created_at, updated_at) VALUES
-- 여기에 실제 공지사항 데이터를 삽입하세요
-- 예시:
-- (UUID(), '시스템 점검 안내', '2024년 8월 15일 새벽 2시부터 4시까지 시스템 점검이 예정되어 있습니다.', 'admin-user-id', 0, 'active', NOW(), NOW()),
-- (UUID(), '신규 기능 업데이트', '실적 관리 기능이 업데이트되었습니다. 더욱 편리한 기능을 제공합니다.', 'admin-user-id', 0, 'active', NOW(), NOW())
;

-- =====================================================
-- 7. 관계 매핑 데이터 삽입
-- =====================================================

-- 병원-회사 매핑 데이터 삽입
-- 병원과 제약회사 간의 관계 설정
INSERT INTO client_company_assignments (id, client_id, company_id, status, created_at, updated_at) VALUES
-- 여기에 실제 매핑 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'client-uuid-1', 'company-uuid-1', 'active', NOW(), NOW()),
-- (UUID(), 'client-uuid-2', 'company-uuid-1', 'active', NOW(), NOW())
;

-- 병원-약국 매핑 데이터 삽입
-- 병원과 약국 간의 관계 설정
INSERT INTO client_pharmacy_assignments (id, client_id, pharmacy_id, status, created_at, updated_at) VALUES
-- 여기에 실제 매핑 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'client-uuid-1', 'pharmacy-uuid-1', 'active', NOW(), NOW()),
-- (UUID(), 'client-uuid-2', 'pharmacy-uuid-2', 'active', NOW(), NOW())
;

-- 제품-업체 매핑 데이터 삽입
-- 제품과 제약회사 간의 관계 설정
INSERT INTO product_company_assignments (id, product_id, company_id, status, created_at, updated_at) VALUES
-- 여기에 실제 매핑 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'product-uuid-1', 'company-uuid-1', 'active', NOW(), NOW()),
-- (UUID(), 'product-uuid-2', 'company-uuid-2', 'active', NOW(), NOW())
;

-- =====================================================
-- 8. 실적 데이터 삽입
-- =====================================================

-- 실적 데이터 삽입
-- 병원별 제품 실적, 수량, 금액, 수수료 정보
INSERT INTO performance_records (id, client_id, product_id, company_id, settlement_month, prescription_qty, unit_price, total_amount, commission_rate, commission_amount, evidence_file_url, status, created_at, updated_at) VALUES
-- 여기에 실제 실적 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'client-uuid-1', 'product-uuid-1', 'company-uuid-1', '2024-08', 100.00, 1000.00, 100000.00, 5.00, 5000.00, 'https://example.com/evidence1.pdf', 'active', NOW(), NOW()),
-- (UUID(), 'client-uuid-2', 'product-uuid-2', 'company-uuid-2', '2024-08', 50.00, 1500.00, 75000.00, 3.00, 2250.00, 'https://example.com/evidence2.pdf', 'active', NOW(), NOW())
;

-- 실적-흡수율 데이터 삽입
-- 실적 정보에 흡수율 정보 추가 (수수료 흡수율 관리)
INSERT INTO performance_records_absorption (id, client_id, product_id, company_id, settlement_month, prescription_qty, unit_price, total_amount, commission_rate, commission_amount, absorption_rate, absorption_amount, evidence_file_url, status, created_at, updated_at) VALUES
-- 여기에 실제 실적-흡수율 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'client-uuid-1', 'product-uuid-1', 'company-uuid-1', '2024-08', 100.00, 1000.00, 100000.00, 5.00, 5000.00, 2.00, 2000.00, 'https://example.com/evidence1.pdf', 'active', NOW(), NOW()),
-- (UUID(), 'client-uuid-2', 'product-uuid-2', 'company-uuid-2', '2024-08', 50.00, 1500.00, 75000.00, 3.00, 2250.00, 1.50, 1125.00, 'https://example.com/evidence2.pdf', 'active', NOW(), NOW())
;

-- 정산내역서 데이터 삽입
-- 병원-회사별 월별 정산 내역 관리
INSERT INTO settlement_share (id, client_id, company_id, settlement_month, total_prescription_qty, total_amount, total_commission_amount, total_absorption_amount, status, created_at, updated_at) VALUES
-- 여기에 실제 정산내역서 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'client-uuid-1', 'company-uuid-1', '2024-08', 100.00, 100000.00, 5000.00, 2000.00, 'active', NOW(), NOW()),
-- (UUID(), 'client-uuid-2', 'company-uuid-2', '2024-08', 50.00, 75000.00, 2250.00, 1125.00, 'active', NOW(), NOW())
;

-- =====================================================
-- 9. 매출 데이터 삽입
-- =====================================================

-- 도매매출 데이터 삽입
-- 회사별 도매 매출 정보 관리
INSERT INTO wholesale_sales (id, company_id, product_id, settlement_month, sales_qty, unit_price, total_amount, status, created_at, updated_at) VALUES
-- 여기에 실제 도매매출 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'company-uuid-1', 'product-uuid-1', '2024-08', 500.00, 800.00, 400000.00, 'active', NOW(), NOW()),
-- (UUID(), 'company-uuid-2', 'product-uuid-2', '2024-08', 300.00, 1200.00, 360000.00, 'active', NOW(), NOW())
;

-- 직거래매출 데이터 삽입
-- 회사별 직거래 매출 정보 관리
INSERT INTO direct_sales (id, company_id, product_id, settlement_month, sales_qty, unit_price, total_amount, status, created_at, updated_at) VALUES
-- 여기에 실제 직거래매출 데이터를 삽입하세요
-- 예시:
-- (UUID(), 'company-uuid-1', 'product-uuid-1', '2024-08', 200.00, 900.00, 180000.00, 'active', NOW(), NOW()),
-- (UUID(), 'company-uuid-2', 'product-uuid-2', '2024-08', 150.00, 1300.00, 195000.00, 'active', NOW(), NOW())
;

-- =====================================================
-- 10. 완료 및 검증
-- =====================================================

-- 데이터 복원 완료 메시지
SELECT 'MariaDB 데이터 복원이 완료되었습니다.' AS message;

-- 테이블별 데이터 개수 확인 (검증용)
SELECT '테이블별 데이터 개수:' AS info;
SELECT 'users' AS table_name, COUNT(*) AS count FROM users
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS count FROM products
UNION ALL
SELECT 'clients' AS table_name, COUNT(*) AS count FROM clients
UNION ALL
SELECT 'companies' AS table_name, COUNT(*) AS count FROM companies
UNION ALL
SELECT 'pharmacies' AS table_name, COUNT(*) AS count FROM pharmacies
UNION ALL
SELECT 'notices' AS table_name, COUNT(*) AS count FROM notices
UNION ALL
SELECT 'performance_records' AS table_name, COUNT(*) AS count FROM performance_records
UNION ALL
SELECT 'settlement_share' AS table_name, COUNT(*) AS count FROM settlement_share;
