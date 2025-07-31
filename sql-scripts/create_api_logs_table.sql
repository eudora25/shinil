-- API 호출 로그 테이블 생성
CREATE TABLE IF NOT EXISTS api_logs (
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

-- 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_api_logs_endpoint ON api_logs(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_logs_user_id ON api_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_api_logs_created_at ON api_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_api_logs_method ON api_logs(method);

-- RLS (Row Level Security) 정책 설정
ALTER TABLE api_logs ENABLE ROW LEVEL SECURITY;

-- 관리자만 모든 로그를 볼 수 있도록 정책 설정
CREATE POLICY "Admin can view all api logs" ON api_logs
    FOR SELECT USING (
        auth.jwt() ->> 'user_metadata' ->> 'user_type' = 'admin'
    );

-- 모든 사용자가 자신의 로그만 볼 수 있도록 정책 설정
CREATE POLICY "Users can view their own api logs" ON api_logs
    FOR SELECT USING (
        auth.uid() = user_id
    );

-- 로그 삽입 정책 (서버에서만 삽입 가능)
CREATE POLICY "Server can insert api logs" ON api_logs
    FOR INSERT WITH CHECK (true);

-- 로그 업데이트 정책 (서버에서만 업데이트 가능)
CREATE POLICY "Server can update api logs" ON api_logs
    FOR UPDATE USING (true);

-- 로그 삭제 정책 (관리자만 삭제 가능)
CREATE POLICY "Admin can delete api logs" ON api_logs
    FOR DELETE USING (
        auth.jwt() ->> 'user_metadata' ->> 'user_type' = 'admin'
    );

-- 테이블 설명 추가
COMMENT ON TABLE api_logs IS 'API 호출 로그를 저장하는 테이블';
COMMENT ON COLUMN api_logs.endpoint IS 'API 엔드포인트 경로';
COMMENT ON COLUMN api_logs.method IS 'HTTP 메서드 (GET, POST, PUT, DELETE 등)';
COMMENT ON COLUMN api_logs.user_id IS '요청한 사용자의 UUID';
COMMENT ON COLUMN api_logs.user_email IS '요청한 사용자의 이메일';
COMMENT ON COLUMN api_logs.request_ip IS '요청 IP 주소';
COMMENT ON COLUMN api_logs.request_headers IS '요청 헤더 (JSON 형태)';
COMMENT ON COLUMN api_logs.request_body IS '요청 본문 (JSON 형태)';
COMMENT ON COLUMN api_logs.response_status IS '응답 상태 코드';
COMMENT ON COLUMN api_logs.response_body IS '응답 본문 (JSON 형태)';
COMMENT ON COLUMN api_logs.execution_time_ms IS 'API 실행 시간 (밀리초)'; 