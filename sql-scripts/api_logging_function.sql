-- API 로그 저장 함수 생성
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
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO api_logs (
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 함수 설명 추가
COMMENT ON FUNCTION log_api_call IS 'API 호출 로그를 저장하는 함수';

-- 로그 조회 함수 (관리자용)
CREATE OR REPLACE FUNCTION get_api_logs(
    p_limit INTEGER DEFAULT 100,
    p_offset INTEGER DEFAULT 0,
    p_endpoint_filter VARCHAR(255) DEFAULT NULL,
    p_user_email_filter VARCHAR(255) DEFAULT NULL,
    p_date_from TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_date_to TIMESTAMP WITH TIME ZONE DEFAULT NULL
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
) AS $$
BEGIN
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
    FROM api_logs al
    WHERE (p_endpoint_filter IS NULL OR al.endpoint ILIKE '%' || p_endpoint_filter || '%')
      AND (p_user_email_filter IS NULL OR al.user_email ILIKE '%' || p_user_email_filter || '%')
      AND (p_date_from IS NULL OR al.created_at >= p_date_from)
      AND (p_date_to IS NULL OR al.created_at <= p_date_to)
    ORDER BY al.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 함수 설명 추가
COMMENT ON FUNCTION get_api_logs IS 'API 로그를 조회하는 함수 (관리자용)';

-- 로그 통계 함수 (관리자용)
CREATE OR REPLACE FUNCTION get_api_logs_stats(
    p_date_from TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_date_to TIMESTAMP WITH TIME ZONE DEFAULT NULL
)
RETURNS TABLE (
    total_calls BIGINT,
    avg_execution_time_ms NUMERIC,
    success_rate NUMERIC,
    top_endpoints JSONB,
    top_users JSONB
) AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as total_calls,
            AVG(execution_time_ms) as avg_execution_time_ms,
            COUNT(CASE WHEN response_status >= 200 AND response_status < 300 THEN 1 END) * 100.0 / COUNT(*) as success_rate
        FROM api_logs al
        WHERE (p_date_from IS NULL OR al.created_at >= p_date_from)
          AND (p_date_to IS NULL OR al.created_at <= p_date_to)
    ),
    endpoint_stats AS (
        SELECT 
            endpoint,
            COUNT(*) as call_count
        FROM api_logs al
        WHERE (p_date_from IS NULL OR al.created_at >= p_date_from)
          AND (p_date_to IS NULL OR al.created_at <= p_date_to)
        GROUP BY endpoint
        ORDER BY call_count DESC
        LIMIT 10
    ),
    user_stats AS (
        SELECT 
            user_email,
            COUNT(*) as call_count
        FROM api_logs al
        WHERE (p_date_from IS NULL OR al.created_at >= p_date_from)
          AND (p_date_to IS NULL OR al.created_at <= p_date_to)
          AND user_email IS NOT NULL
        GROUP BY user_email
        ORDER BY call_count DESC
        LIMIT 10
    )
    SELECT 
        s.total_calls,
        s.avg_execution_time_ms,
        s.success_rate,
        COALESCE(jsonb_agg(jsonb_build_object('endpoint', es.endpoint, 'count', es.call_count)) FILTER (WHERE es.endpoint IS NOT NULL), '[]'::jsonb) as top_endpoints,
        COALESCE(jsonb_agg(jsonb_build_object('email', us.user_email, 'count', us.call_count)) FILTER (WHERE us.user_email IS NOT NULL), '[]'::jsonb) as top_users
    FROM stats s
    LEFT JOIN endpoint_stats es ON true
    LEFT JOIN user_stats us ON true
    GROUP BY s.total_calls, s.avg_execution_time_ms, s.success_rate;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 함수 설명 추가
COMMENT ON FUNCTION get_api_logs_stats IS 'API 로그 통계를 조회하는 함수 (관리자용)'; 