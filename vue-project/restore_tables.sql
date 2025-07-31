-- Shinil PMS Database Tables Restoration
-- 주요 테이블들 생성

-- 1. clients 테이블
CREATE TABLE IF NOT EXISTS public.clients (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_code text,
    name text NOT NULL,
    business_registration_number text NOT NULL,
    owner_name text,
    address text,
    remarks text,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 2. companies 테이블
CREATE TABLE IF NOT EXISTS public.companies (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid,
    company_name text NOT NULL,
    business_registration_number text NOT NULL,
    representative_name text NOT NULL,
    business_address text NOT NULL,
    landline_phone text,
    contact_person_name text NOT NULL,
    mobile_phone text NOT NULL,
    mobile_phone_2 text,
    email text NOT NULL,
    default_commission_grade text DEFAULT 'A'::text,
    remarks text,
    approval_status text DEFAULT 'pending'::text,
    status text DEFAULT 'active'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    user_type text DEFAULT 'user'::text,
    company_group text,
    assigned_pharmacist_contact text,
    receive_email text,
    created_by uuid,
    approved_at timestamp with time zone DEFAULT now(),
    updated_by uuid
);

-- 3. products 테이블
CREATE TABLE IF NOT EXISTS public.products (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    product_name text NOT NULL,
    insurance_code text,
    price integer,
    commission_rate_a numeric NOT NULL,
    commission_rate_b numeric,
    commission_rate_c numeric,
    standard_code text NOT NULL,
    unit_packaging_desc text,
    unit_quantity integer,
    remarks text,
    status text DEFAULT 'active'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    base_month text NOT NULL
);

-- 4. notices 테이블
CREATE TABLE IF NOT EXISTS public.notices (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text NOT NULL,
    content text NOT NULL,
    is_pinned boolean DEFAULT false,
    view_count integer DEFAULT 0,
    author_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    file_url text,
    links text
);

-- 5. api_logs 테이블 (API 로깅용)
CREATE TABLE IF NOT EXISTS public.api_logs (
    id SERIAL PRIMARY KEY,
    endpoint VARCHAR(255) NOT NULL,
    method VARCHAR(10) NOT NULL,
    user_id UUID,
    user_email VARCHAR(255),
    request_ip VARCHAR(45),
    request_headers JSONB,
    request_body JSONB,
    response_status INTEGER,
    response_body JSONB,
    execution_time_ms INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_api_logs_endpoint ON public.api_logs(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_logs_user_email ON public.api_logs(user_email);
CREATE INDEX IF NOT EXISTS idx_api_logs_created_at ON public.api_logs(created_at);

-- RLS 정책 설정
ALTER TABLE public.api_logs ENABLE ROW LEVEL SECURITY;

-- 관리자만 API 로그 조회 가능
CREATE POLICY "Admin can view all api logs" ON public.api_logs 
FOR SELECT USING ((auth.jwt()::jsonb ->> 'user_metadata')::jsonb ->> 'user_type' = 'admin');

-- 서버는 API 로그 삽입 가능
CREATE POLICY "Server can insert api logs" ON public.api_logs 
FOR INSERT WITH CHECK (true);

-- API 로그 저장 함수
CREATE OR REPLACE FUNCTION log_api_call(
    p_endpoint VARCHAR(255),
    p_method VARCHAR(10),
    p_user_id UUID DEFAULT NULL,
    p_user_email VARCHAR(255) DEFAULT NULL,
    p_request_ip VARCHAR(45) DEFAULT NULL,
    p_request_headers JSONB DEFAULT NULL,
    p_request_body JSONB DEFAULT NULL,
    p_response_status INTEGER DEFAULT NULL,
    p_response_body JSONB DEFAULT NULL,
    p_execution_time_ms INTEGER DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    INSERT INTO api_logs (
        endpoint, method, user_id, user_email, request_ip,
        request_headers, request_body, response_status,
        response_body, execution_time_ms
    ) VALUES (
        p_endpoint, p_method, p_user_id, p_user_email, p_request_ip,
        p_request_headers, p_request_body, p_response_status,
        p_response_body, p_execution_time_ms
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- API 로그 조회 함수
CREATE OR REPLACE FUNCTION get_api_logs(
    p_limit INTEGER DEFAULT 100,
    p_offset INTEGER DEFAULT 0,
    p_endpoint_filter VARCHAR(255) DEFAULT NULL,
    p_user_email_filter VARCHAR(255) DEFAULT NULL,
    p_date_from TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_date_to TIMESTAMP WITH TIME ZONE DEFAULT NULL
) RETURNS TABLE (
    id INTEGER,
    endpoint VARCHAR(255),
    method VARCHAR(10),
    user_id UUID,
    user_email VARCHAR(255),
    request_ip VARCHAR(45),
    request_headers JSONB,
    request_body JSONB,
    response_status INTEGER,
    response_body JSONB,
    execution_time_ms INTEGER,
    created_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        al.id, al.endpoint, al.method, al.user_id, al.user_email,
        al.request_ip, al.request_headers, al.request_body,
        al.response_status, al.response_body, al.execution_time_ms,
        al.created_at
    FROM api_logs al
    WHERE (p_endpoint_filter IS NULL OR al.endpoint ILIKE '%' || p_endpoint_filter || '%')
      AND (p_user_email_filter IS NULL OR al.user_email ILIKE '%' || p_user_email_filter || '%')
      AND (p_date_from IS NULL OR al.created_at >= p_date_from)
      AND (p_date_to IS NULL OR al.created_at <= p_date_to)
    ORDER BY al.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- API 로그 통계 함수
CREATE OR REPLACE FUNCTION get_api_logs_stats(
    p_date_from TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_date_to TIMESTAMP WITH TIME ZONE DEFAULT NULL
) RETURNS TABLE (
    total_calls BIGINT,
    unique_users BIGINT,
    avg_execution_time NUMERIC,
    most_used_endpoint VARCHAR(255),
    success_rate NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_calls,
        COUNT(DISTINCT user_email)::BIGINT as unique_users,
        AVG(execution_time_ms)::NUMERIC as avg_execution_time,
        (SELECT endpoint FROM api_logs 
         WHERE (p_date_from IS NULL OR created_at >= p_date_from)
           AND (p_date_to IS NULL OR created_at <= p_date_to)
         GROUP BY endpoint 
         ORDER BY COUNT(*) DESC 
         LIMIT 1) as most_used_endpoint,
        (COUNT(CASE WHEN response_status >= 200 AND response_status < 300 THEN 1 END) * 100.0 / COUNT(*))::NUMERIC as success_rate
    FROM api_logs
    WHERE (p_date_from IS NULL OR created_at >= p_date_from)
      AND (p_date_to IS NULL OR created_at <= p_date_to);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 