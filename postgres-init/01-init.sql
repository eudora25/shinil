-- PostgreSQL 초기화 스크립트
-- Supabase 로컬 환경을 위한 기본 설정

-- 1. 필요한 확장 기능들 활성화
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- 2. Supabase가 필요로 하는 설정들
ALTER SYSTEM SET wal_level = logical;
ALTER SYSTEM SET max_replication_slots = 5;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';

-- 3. 기본 데이터베이스 생성 (필요한 경우)
-- CREATE DATABASE IF NOT EXISTS shinil_pms;

-- 4. 기본 사용자 권한 설정
-- GRANT ALL PRIVILEGES ON DATABASE shinil_pms TO postgres;

-- 5. 설정 적용을 위한 재시작 안내
-- 이 스크립트는 컨테이너 시작 시 자동으로 실행됩니다.
-- 일부 설정은 PostgreSQL 재시작 후에 적용됩니다. 