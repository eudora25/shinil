-- 신일제약 실적관리프로그램 전체 스키마 복구 스크립트
-- DBeaver에서 실행하여 전체 데이터베이스를 복구합니다

-- 1. 기존 테이블 정리 (주의: 데이터가 삭제됩니다)
DROP TABLE IF EXISTS performance_records_absorption_backup_20250106 CASCADE;
DROP TABLE IF EXISTS absorption_analysis CASCADE;
DROP TABLE IF EXISTS performance_records CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS settlement_months CASCADE;
DROP TABLE IF EXISTS notices CASCADE;

-- 2. 기본 테이블 생성
-- companies 테이블
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    business_registration_number VARCHAR(20) UNIQUE,
    representative_name VARCHAR(100),
    business_address TEXT,
    landline_phone VARCHAR(20),
    contact_person_name VARCHAR(100),
    mobile_phone VARCHAR(20),
    mobile_phone_2 VARCHAR(20),
    receive_email VARCHAR(255),
    company_group VARCHAR(50),
    default_commission_grade CHAR(1) CHECK (default_commission_grade IN ('A', 'B', 'C')),
    assigned_pharmacist_contact VARCHAR(100),
    remarks TEXT,
    approval_status VARCHAR(20) DEFAULT 'pending' CHECK (approval_status IN ('approved', 'pending', 'rejected')),
    user_id UUID,
    user_type VARCHAR(20) DEFAULT 'user' CHECK (user_type IN ('admin', 'user')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- clients 테이블
CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) CHECK (type IN ('hospital', 'pharmacy', 'clinic')),
    address TEXT,
    phone VARCHAR(20),
    contact_person VARCHAR(100),
    commission_grade CHAR(1) CHECK (commission_grade IN ('A', 'B', 'C')),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- products 테이블
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_name VARCHAR(255) NOT NULL,
    product_code VARCHAR(100),
    category VARCHAR(100),
    description TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- settlement_months 테이블
CREATE TABLE settlement_months (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    settlement_month DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- notices 테이블
CREATE TABLE notices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    author_id UUID,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- performance_records 테이블
CREATE TABLE performance_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    client_id UUID REFERENCES clients(id),
    product_id UUID REFERENCES products(id),
    settlement_month DATE NOT NULL,
    prescription_qty NUMERIC(10,2),
    commission_rate NUMERIC(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- absorption_analysis 테이블
CREATE TABLE absorption_analysis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    client_id UUID REFERENCES clients(id),
    product_id UUID REFERENCES products(id),
    company_name VARCHAR(255),
    client_name VARCHAR(255),
    product_name VARCHAR(255),
    settlement_month DATE,
    prescription_qty NUMERIC(10,2),
    commission_rate NUMERIC(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 인덱스 생성
CREATE INDEX idx_companies_email ON companies(email);
CREATE INDEX idx_companies_approval_status ON companies(approval_status);
CREATE INDEX idx_clients_name ON clients(name);
CREATE INDEX idx_clients_type ON clients(type);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_performance_records_settlement_month ON performance_records(settlement_month);
CREATE INDEX idx_performance_records_company_id ON performance_records(company_id);
CREATE INDEX idx_absorption_analysis_settlement_month ON absorption_analysis(settlement_month);

-- 4. 샘플 데이터 삽입
-- companies 샘플 데이터
INSERT INTO companies (email, company_name, business_registration_number, representative_name, business_address, company_group, default_commission_grade, approval_status, user_type, status) VALUES
('test1@example.com', '(주)테스트제약', '123-45-67890', '홍길동', '서울시 강남구', '제약', 'A', 'approved', 'user', 'active'),
('test2@example.com', '(주)샘플바이오', '234-56-78901', '이순신', '서울시 서초구', '바이오', 'B', 'approved', 'user', 'active');

-- clients 샘플 데이터
INSERT INTO clients (name, type, address, phone, commission_grade, status) VALUES
('서울대병원', 'hospital', '서울시 종로구', '02-1234-5678', 'A', 'active'),
('강남약국', 'pharmacy', '서울시 강남구', '02-2345-6789', 'B', 'active');

-- products 샘플 데이터
INSERT INTO products (product_name, product_code, category, status) VALUES
('테스트약품A', 'TEST001', '항생제', 'active'),
('샘플약품B', 'SAMPLE002', '진통제', 'active');

-- settlement_months 샘플 데이터
INSERT INTO settlement_months (settlement_month, status) VALUES
('2025-01-01', 'open'),
('2025-02-01', 'open');

-- 5. 복구 완료 확인
SELECT 
    'Schema Restore Complete' as status,
    COUNT(*) as total_tables
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE';

-- 6. 테이블별 레코드 수 확인
SELECT 
    'companies' as table_name,
    COUNT(*) as record_count
FROM companies
UNION ALL
SELECT 
    'clients' as table_name,
    COUNT(*) as record_count
FROM clients
UNION ALL
SELECT 
    'products' as table_name,
    COUNT(*) as record_count
FROM products
UNION ALL
SELECT 
    'settlement_months' as table_name,
    COUNT(*) as record_count
FROM settlement_months; 