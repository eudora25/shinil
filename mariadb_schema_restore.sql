-- =====================================================
-- MariaDB용 신일 프로젝트 데이터베이스 스키마 복원 파일
-- =====================================================
-- 
-- 이 파일은 Supabase PostgreSQL 데이터베이스를 MariaDB로 마이그레이션하기 위한
-- 스키마 생성 스크립트입니다.
-- 
-- 주요 변환 사항:
-- 1. PostgreSQL 스키마(auth, public) → MariaDB 단일 데이터베이스
-- 2. UUID 타입 → VARCHAR(255)
-- 3. JSONB → JSON
-- 4. TIMESTAMP WITH TIME ZONE → TIMESTAMP
-- 5. 인덱스 및 외래키 최적화
-- 
-- 실행 순서:
-- 1. MariaDB 서버 시작
-- 2. 이 스크립트 실행: mysql -u root -p < mariadb_schema_restore.sql
-- 3. 데이터 복원: mysql -u root -p < mariadb_data_restore.sql
-- 
-- 작성일: 2024-08-13
-- 버전: 1.0
-- =====================================================

-- =====================================================
-- 1. 데이터베이스 생성 및 설정
-- =====================================================

-- 신일 프로젝트 전용 데이터베이스 생성
-- utf8mb4 문자셋 사용으로 이모지 및 특수문자 지원
CREATE DATABASE IF NOT EXISTS shinil_project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 생성된 데이터베이스 사용
USE shinil_project;

-- =====================================================
-- 2. 문자셋 및 연결 설정
-- =====================================================

-- UTF-8 문자셋 설정 (한글 및 특수문자 지원)
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET character_set_connection=utf8mb4;

-- =====================================================
-- 3. 사용자 관리 테이블
-- =====================================================

-- 사용자 테이블 (Supabase auth.users 대체)
-- 인증, 권한 관리, 사용자 정보 저장
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    encrypted_password VARCHAR(255),
    email_confirmed_at TIMESTAMP NULL,
    invited_at TIMESTAMP NULL,
    confirmation_token VARCHAR(255),
    confirmation_sent_at TIMESTAMP NULL,
    recovery_token VARCHAR(255),
    recovery_sent_at TIMESTAMP NULL,
    email_change_token_new VARCHAR(255),
    email_change VARCHAR(255),
    email_change_sent_at TIMESTAMP NULL,
    last_sign_in_at TIMESTAMP NULL,
    raw_app_meta_data JSON,
    raw_user_meta_data JSON,
    is_super_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    phone VARCHAR(20),
    phone_confirmed_at TIMESTAMP NULL,
    phone_change VARCHAR(255),
    phone_change_token VARCHAR(255),
    phone_change_sent_at TIMESTAMP NULL,
    email_change_token_current VARCHAR(255) DEFAULT '',
    email_change_confirm_status SMALLINT DEFAULT 0,
    banned_until TIMESTAMP NULL,
    reauthentication_token VARCHAR(255),
    reauthentication_sent_at TIMESTAMP NULL,
    INDEX idx_users_email (email),
    INDEX idx_users_phone (phone)
);

-- =====================================================
-- 4. 제품 관리 테이블
-- =====================================================

-- 제품 정보 테이블
-- 제품 기본 정보, 가격, 제조사 등 관리
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_code VARCHAR(100),
    insurance_code VARCHAR(100),
    manufacturer VARCHAR(255),
    unit_price DECIMAL(10,2),
    unit_quantity INTEGER,
    unit_packaging_desc VARCHAR(255),
    standard_code VARCHAR(100),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_products_insurance_code (insurance_code),
    INDEX idx_products_status (status)
);

-- 제품 표준 코드 테이블
-- 보험 코드, 표준 코드, 포장 단위 정보 관리
CREATE TABLE IF NOT EXISTS products_standard_code (
    id VARCHAR(255) PRIMARY KEY,
    insurance_code VARCHAR(100) UNIQUE NOT NULL,
    standard_code VARCHAR(100),
    unit_packaging_desc VARCHAR(255),
    unit_quantity INTEGER,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_products_standard_code_insurance_code (insurance_code)
);

-- =====================================================
-- 5. 고객 관리 테이블
-- =====================================================

-- 클라이언트(병원) 정보 테이블
-- 병원 정보, 연락처, 담당자 등 관리
CREATE TABLE IF NOT EXISTS clients (
    id VARCHAR(255) PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_code VARCHAR(100),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_clients_status (status)
);

-- 회사 정보 테이블
-- 제약회사, 제조사 정보 관리
CREATE TABLE IF NOT EXISTS companies (
    id VARCHAR(255) PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    company_code VARCHAR(100),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_companies_status (status)
);

-- 약국 정보 테이블
-- 약국 정보, 연락처, 담당자 등 관리
CREATE TABLE IF NOT EXISTS pharmacies (
    id VARCHAR(255) PRIMARY KEY,
    pharmacy_name VARCHAR(255) NOT NULL,
    pharmacy_code VARCHAR(100),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_pharmacies_status (status)
);

-- =====================================================
-- 6. 시스템 관리 테이블
-- =====================================================

-- 공지사항 테이블
-- 시스템 공지사항, 조회수 관리
CREATE TABLE IF NOT EXISTS notices (
    id VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id VARCHAR(255),
    view_count INTEGER DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_notices_status (status),
    INDEX idx_notices_created_at (created_at)
);

-- 정산월 테이블
-- 정산 월별 관리 (YYYY-MM 형식)
CREATE TABLE IF NOT EXISTS settlement_months (
    id VARCHAR(255) PRIMARY KEY,
    settlement_month VARCHAR(7) NOT NULL, -- YYYY-MM 형식
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_settlement_month (settlement_month),
    INDEX idx_settlement_months_status (status)
);

-- =====================================================
-- 7. 실적 관리 테이블
-- =====================================================

-- 실적 정보 테이블
-- 병원별 제품 실적, 수량, 금액, 수수료 관리
CREATE TABLE IF NOT EXISTS performance_records (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    prescription_qty DECIMAL(10,2) DEFAULT 0,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    commission_rate DECIMAL(5,2) DEFAULT 0,
    commission_amount DECIMAL(12,2) DEFAULT 0,
    evidence_file_url TEXT,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_performance_records_client_id (client_id),
    INDEX idx_performance_records_product_id (product_id),
    INDEX idx_performance_records_company_id (company_id),
    INDEX idx_performance_records_settlement_month (settlement_month),
    INDEX idx_performance_records_status (status)
);

-- 실적-흡수율 정보 테이블
-- 실적 정보에 흡수율 정보 추가 (수수료 흡수율 관리)
CREATE TABLE IF NOT EXISTS performance_records_absorption (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    prescription_qty DECIMAL(10,2) DEFAULT 0,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    commission_rate DECIMAL(5,2) DEFAULT 0,
    commission_amount DECIMAL(12,2) DEFAULT 0,
    absorption_rate DECIMAL(5,2) DEFAULT 0,
    absorption_amount DECIMAL(12,2) DEFAULT 0,
    evidence_file_url TEXT,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_performance_records_absorption_client_id (client_id),
    INDEX idx_performance_records_absorption_product_id (product_id),
    INDEX idx_performance_records_absorption_company_id (company_id),
    INDEX idx_performance_records_absorption_settlement_month (settlement_month),
    INDEX idx_performance_records_absorption_status (status)
);

-- 정산내역서 테이블
-- 병원-회사별 월별 정산 내역 관리
CREATE TABLE IF NOT EXISTS settlement_share (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    total_prescription_qty DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    total_commission_amount DECIMAL(12,2) DEFAULT 0,
    total_absorption_amount DECIMAL(12,2) DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_settlement_share (client_id, company_id, settlement_month),
    INDEX idx_settlement_share_client_id (client_id),
    INDEX idx_settlement_share_company_id (company_id),
    INDEX idx_settlement_share_settlement_month (settlement_month)
);

-- =====================================================
-- 8. 매출 관리 테이블
-- =====================================================

-- 도매매출 정보 테이블
-- 회사별 도매 매출 정보 관리
CREATE TABLE IF NOT EXISTS wholesale_sales (
    id VARCHAR(255) PRIMARY KEY,
    company_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    sales_qty DECIMAL(10,2) DEFAULT 0,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wholesale_sales_company_id (company_id),
    INDEX idx_wholesale_sales_product_id (product_id),
    INDEX idx_wholesale_sales_settlement_month (settlement_month)
);

-- 직거래매출 정보 테이블
-- 회사별 직거래 매출 정보 관리
CREATE TABLE IF NOT EXISTS direct_sales (
    id VARCHAR(255) PRIMARY KEY,
    company_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    sales_qty DECIMAL(10,2) DEFAULT 0,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_direct_sales_company_id (company_id),
    INDEX idx_direct_sales_product_id (product_id),
    INDEX idx_direct_sales_settlement_month (settlement_month)
);

-- =====================================================
-- 9. 관계 매핑 테이블
-- =====================================================

-- 병원-회사 매핑 테이블
-- 병원과 제약회사 간의 관계 관리
CREATE TABLE IF NOT EXISTS client_company_assignments (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_client_company (client_id, company_id),
    INDEX idx_client_company_assignments_client_id (client_id),
    INDEX idx_client_company_assignments_company_id (company_id)
);

-- 병원-약국 매핑 테이블
-- 병원과 약국 간의 관계 관리
CREATE TABLE IF NOT EXISTS client_pharmacy_assignments (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    pharmacy_id VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_client_pharmacy (client_id, pharmacy_id),
    INDEX idx_client_pharmacy_assignments_client_id (client_id),
    INDEX idx_client_pharmacy_assignments_pharmacy_id (pharmacy_id)
);

-- 제품-업체 매핑 테이블
-- 제품과 제약회사 간의 관계 관리
CREATE TABLE IF NOT EXISTS product_company_assignments (
    id VARCHAR(255) PRIMARY KEY,
    product_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_product_company (product_id, company_id),
    INDEX idx_product_company_assignments_product_id (product_id),
    INDEX idx_product_company_assignments_company_id (company_id)
);

-- =====================================================
-- 10. 시스템 로그 테이블
-- =====================================================

-- API 로그 테이블
-- API 호출 로그, 성능 모니터링, 디버깅용
CREATE TABLE IF NOT EXISTS api_logs (
    id VARCHAR(255) PRIMARY KEY,
    endpoint VARCHAR(255) NOT NULL,
    method VARCHAR(10) NOT NULL,
    request_ip VARCHAR(45),
    request_headers JSON,
    request_body JSON,
    response_status INTEGER,
    response_body JSON,
    execution_time INTEGER,
    user_id VARCHAR(255),
    user_email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_api_logs_endpoint (endpoint),
    INDEX idx_api_logs_method (method),
    INDEX idx_api_logs_user_id (user_id),
    INDEX idx_api_logs_created_at (created_at)
);

-- =====================================================
-- 11. 외래키 제약조건 설정
-- =====================================================

-- 데이터 무결성을 위한 외래키 제약조건 추가
-- CASCADE 옵션으로 부모 레코드 삭제 시 자식 레코드도 함께 삭제

-- 실적 정보 테이블 외래키
ALTER TABLE performance_records 
ADD CONSTRAINT fk_performance_records_client 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_performance_records_product 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_performance_records_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE performance_records_absorption 
ADD CONSTRAINT fk_performance_records_absorption_client 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_performance_records_absorption_product 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_performance_records_absorption_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE settlement_share 
ADD CONSTRAINT fk_settlement_share_client 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_settlement_share_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE wholesale_sales 
ADD CONSTRAINT fk_wholesale_sales_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_wholesale_sales_product 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

ALTER TABLE direct_sales 
ADD CONSTRAINT fk_direct_sales_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_direct_sales_product 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

ALTER TABLE client_company_assignments 
ADD CONSTRAINT fk_client_company_assignments_client 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_client_company_assignments_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE client_pharmacy_assignments 
ADD CONSTRAINT fk_client_pharmacy_assignments_client 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_client_pharmacy_assignments_pharmacy 
FOREIGN KEY (pharmacy_id) REFERENCES pharmacies(id) ON DELETE CASCADE;

ALTER TABLE product_company_assignments 
ADD CONSTRAINT fk_product_company_assignments_product 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
ADD CONSTRAINT fk_product_company_assignments_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

-- =====================================================
-- 12. 뷰 생성
-- =====================================================

-- 실적 정보 상세 조회 뷰
-- 실적 정보와 관련 테이블을 조인하여 상세 정보 제공
CREATE OR REPLACE VIEW performance_records_with_details AS
SELECT 
    pr.*,
    c.client_name,
    p.product_name,
    p.insurance_code,
    comp.company_name,
    sm.settlement_month
FROM performance_records pr
LEFT JOIN clients c ON pr.client_id = c.id
LEFT JOIN products p ON pr.product_id = p.id
LEFT JOIN companies comp ON pr.company_id = comp.id
LEFT JOIN settlement_months sm ON pr.settlement_month = sm.settlement_month
WHERE pr.status = 'active';

-- =====================================================
-- 13. 트리거 생성
-- =====================================================

-- updated_at 필드 자동 업데이트 트리거
-- 레코드 수정 시 updated_at 필드를 현재 시간으로 자동 설정
DELIMITER //
CREATE TRIGGER update_users_updated_at 
BEFORE UPDATE ON users 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

CREATE TRIGGER update_products_updated_at 
BEFORE UPDATE ON products 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

CREATE TRIGGER update_clients_updated_at 
BEFORE UPDATE ON clients 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

CREATE TRIGGER update_companies_updated_at 
BEFORE UPDATE ON companies 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

CREATE TRIGGER update_pharmacies_updated_at 
BEFORE UPDATE ON pharmacies 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

CREATE TRIGGER update_notices_updated_at 
BEFORE UPDATE ON notices 
FOR EACH ROW 
SET NEW.updated_at = CURRENT_TIMESTAMP;
//

DELIMITER ;

-- =====================================================
-- 14. 기본 데이터 삽입
-- =====================================================

-- 정산월 기본 데이터 삽입 (2024년 1월~12월)
-- 시스템 초기화 시 필요한 기본 데이터
INSERT INTO settlement_months (id, settlement_month, status) VALUES 
(UUID(), '2024-01', 'active'),
(UUID(), '2024-02', 'active'),
(UUID(), '2024-03', 'active'),
(UUID(), '2024-04', 'active'),
(UUID(), '2024-05', 'active'),
(UUID(), '2024-06', 'active'),
(UUID(), '2024-07', 'active'),
(UUID(), '2024-08', 'active'),
(UUID(), '2024-09', 'active'),
(UUID(), '2024-10', 'active'),
(UUID(), '2024-11', 'active'),
(UUID(), '2024-12', 'active')
ON DUPLICATE KEY UPDATE status = 'active';

-- =====================================================
-- 15. 완료 메시지
-- =====================================================

-- 스키마 생성 완료 메시지 출력
SELECT 'MariaDB 스키마 복원이 완료되었습니다.' AS message;
