-- Supabase 테이블 생성 SQL
-- 생성일시: 2025-07-24 16:30:43
-- 사용법: Supabase Dashboard > SQL Editor에서 이 파일의 내용을 실행하세요.

-- companies 테이블 생성
CREATE TABLE public.companies (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID,
    company_name TEXT NOT NULL,
    business_registration_number TEXT NOT NULL,
    representative_name TEXT NOT NULL,
    business_address TEXT NOT NULL,
    landline_phone TEXT,
    contact_person_name TEXT NOT NULL,
    mobile_phone TEXT NOT NULL,
    mobile_phone_2 TEXT,
    email TEXT NOT NULL,
    default_commission_grade TEXT NOT NULL DEFAULT 'A'::text,
    remarks TEXT,
    approval_status TEXT NOT NULL DEFAULT 'pending'::text,
    status TEXT NOT NULL DEFAULT 'active'::text,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    user_type TEXT NOT NULL DEFAULT 'user'::text,
    company_group TEXT,
    assigned_pharmacist_contact TEXT,
    receive_email TEXT,
    created_by UUID,
    approved_at TIMESTAMPTZ DEFAULT now(),
    updated_by UUID
);
-- products 테이블 생성
CREATE TABLE public.products (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    product_name TEXT NOT NULL,
    insurance_code TEXT,
    price INTEGER,
    commission_rate_a NUMERIC NOT NULL,
    commission_rate_b NUMERIC NOT NULL,
    commission_rate_c NUMERIC,
    standard_code TEXT NOT NULL,
    unit_packaging_desc TEXT,
    unit_quantity INTEGER,
    remarks TEXT,
    status TEXT NOT NULL DEFAULT 'active'::text,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    base_month TEXT NOT NULL
);
-- clients 테이블 생성
CREATE TABLE public.clients (
    id BIGINT NOT NULL,
    client_code TEXT,
    name TEXT NOT NULL,
    business_registration_number TEXT NOT NULL,
    owner_name TEXT,
    address TEXT,
    remarks TEXT,
    status TEXT NOT NULL DEFAULT 'active'::text,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
-- pharmacies 테이블 생성
CREATE TABLE public.pharmacies (
    id BIGINT NOT NULL,
    pharmacy_code TEXT,
    name TEXT NOT NULL,
    business_registration_number TEXT NOT NULL,
    address TEXT,
    remarks TEXT,
    status TEXT NOT NULL DEFAULT 'active'::text,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
-- wholesale_sales 테이블 생성
CREATE TABLE public.wholesale_sales (
    id BIGINT NOT NULL,
    pharmacy_code TEXT,
    pharmacy_name TEXT,
    business_registration_number TEXT NOT NULL,
    address TEXT,
    standard_code TEXT NOT NULL,
    product_name TEXT,
    sales_amount NUMERIC,
    sales_date DATE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by TEXT,
    updated_by TEXT
);
-- direct_sales 테이블 생성
CREATE TABLE public.direct_sales (
    id BIGINT NOT NULL,
    pharmacy_code TEXT,
    pharmacy_name TEXT,
    business_registration_number TEXT NOT NULL,
    address TEXT,
    standard_code TEXT NOT NULL,
    product_name TEXT,
    sales_amount NUMERIC,
    sales_date DATE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by TEXT,
    updated_by TEXT
);
-- performance_records 테이블 생성
CREATE TABLE public.performance_records (
    id BIGINT NOT NULL,
    company_id UUID NOT NULL,
    settlement_month VARCHAR NOT NULL,
    prescription_month VARCHAR NOT NULL,
    client_id BIGINT NOT NULL,
    product_id UUID NOT NULL,
    prescription_qty NUMERIC NOT NULL,
    prescription_type VARCHAR NOT NULL DEFAULT 'EDI'::character varying,
    remarks TEXT,
    registered_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    review_status TEXT DEFAULT '대기'::text,
    review_action TEXT,
    updated_by UUID,
    commission_rate NUMERIC
);
-- settlement_months 테이블 생성
CREATE TABLE public.settlement_months (
    id BIGINT NOT NULL,
    settlement_month VARCHAR NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    notice TEXT,
    status VARCHAR NOT NULL DEFAULT 'active'::character varying,
    remarks TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
-- notices 테이블 생성
CREATE TABLE public.notices (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    is_pinned BOOLEAN NOT NULL DEFAULT false,
    view_count INTEGER NOT NULL DEFAULT 0,
    author_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    file_url TEXT,
    links TEXT
);
