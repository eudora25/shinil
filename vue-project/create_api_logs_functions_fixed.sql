-- API 로그를 위한 PostgreSQL 함수들 생성 (기존 정책 삭제 후)

-- 1. 기존 정책 삭제
DROP POLICY IF EXISTS "Admin can view all api logs" ON public.api_logs;
DROP POLICY IF EXISTS "Server can insert api logs" ON public.api_logs;

-- 2. 기존 함수 완전 삭제 (CASCADE 사용)
DROP FUNCTION IF EXISTS public.log_api_call(VARCHAR, VARCHAR, UUID, VARCHAR, VARCHAR, JSONB, JSONB, INTEGER, JSONB, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS public.get_api_logs(INTEGER, INTEGER, VARCHAR, VARCHAR, VARCHAR) CASCADE;
DROP FUNCTION IF EXISTS public.get_api_logs_stats() CASCADE;

-- 3. API 로그 테이블 생성 (이미 있다면 무시)
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

-- 4. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_api_logs_endpoint ON public.api_logs(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_logs_method ON public.api_logs(method);
CREATE INDEX IF NOT EXISTS idx_api_logs_user_id ON public.api_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_api_logs_created_at ON public.api_logs(created_at);

-- 5. RLS 정책 설정
ALTER TABLE public.api_logs ENABLE ROW LEVEL SECURITY;

-- 관리자만 모든 로그를 볼 수 있음
CREATE POLICY "Admin can view all api logs" ON public.api_logs
FOR SELECT USING (
    (auth.jwt()::jsonb ->> 'user_metadata')::jsonb ->> 'user_type' = 'admin'
);

-- 서버에서 로그를 삽입할 수 있음
CREATE POLICY "Server can insert api logs" ON public.api_logs
FOR INSERT WITH CHECK (true);

-- 6. API 로그 기록 함수
CREATE OR REPLACE FUNCTION public.log_api_call(
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
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.api_logs (
        endpoint,
        method,
        user_id,
        user_email,
        request_ip,
        request_headers,
        request_body,
        response_status,
        response_body,
        execution_time_ms
    ) VALUES (
        p_endpoint,
        p_method,
        p_user_id,
        p_user_email,
        p_request_ip,
        p_request_headers,
        p_request_body,
        p_response_status,
        p_response_body,
        p_execution_time_ms
    );
END;
$$;

-- 7. API 로그 조회 함수 (관리자용)
CREATE OR REPLACE FUNCTION public.get_api_logs(
    p_limit INTEGER DEFAULT 100,
    p_offset INTEGER DEFAULT 0,
    p_endpoint VARCHAR(255) DEFAULT NULL,
    p_method VARCHAR(10) DEFAULT NULL,
    p_user_email VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE (
    id INTEGER,
    endpoint VARCHAR(255),
    method VARCHAR(10),
    user_id UUID,
    user_email VARCHAR(255),
    request_ip VARCHAR(45),
    response_status INTEGER,
    execution_time_ms INTEGER,
    created_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- 관리자 권한 확인
    IF (auth.jwt()::jsonb ->> 'user_metadata')::jsonb ->> 'user_type' != 'admin' THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;
    
    RETURN QUERY
    SELECT 
        al.id,
        al.endpoint,
        al.method,
        al.user_id,
        al.user_email,
        al.request_ip,
        al.response_status,
        al.execution_time_ms,
        al.created_at
    FROM public.api_logs al
    WHERE (p_endpoint IS NULL OR al.endpoint = p_endpoint)
      AND (p_method IS NULL OR al.method = p_method)
      AND (p_user_email IS NULL OR al.user_email = p_user_email)
    ORDER BY al.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;

-- 8. API 로그 통계 함수 (관리자용)
CREATE OR REPLACE FUNCTION public.get_api_logs_stats()
RETURNS TABLE (
    total_calls BIGINT,
    unique_endpoints BIGINT,
    unique_users BIGINT,
    avg_execution_time NUMERIC,
    total_errors BIGINT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- 관리자 권한 확인
    IF (auth.jwt()::jsonb ->> 'user_metadata')::jsonb ->> 'user_type' != 'admin' THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;
    
    RETURN QUERY
    SELECT 
        COUNT(*) as total_calls,
        COUNT(DISTINCT endpoint) as unique_endpoints,
        COUNT(DISTINCT user_email) as unique_users,
        ROUND(AVG(execution_time_ms), 2) as avg_execution_time,
        COUNT(*) FILTER (WHERE response_status >= 400) as total_errors
    FROM public.api_logs;
END;
$$;

-- 9. 함수 권한 설정
GRANT EXECUTE ON FUNCTION public.log_api_call TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_api_logs TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_api_logs_stats TO anon, authenticated;

-- 10. 테이블 권한 설정
GRANT SELECT ON public.api_logs TO anon, authenticated;
GRANT INSERT ON public.api_logs TO anon, authenticated;

-- 11. 테스트 로그 삽입
SELECT public.log_api_call(
    '/test',
    'GET',
    NULL,
    'test@test.com',
    '127.0.0.1',
    '{}'::jsonb,
    '{}'::jsonb,
    200,
    '{"test": true}'::jsonb,
    100
);

-- 12. 생성 확인
SELECT 'API Logs Functions Created Successfully' as status;
SELECT COUNT(*) as api_logs_count FROM public.api_logs; 