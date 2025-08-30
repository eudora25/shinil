# 데이터베이스 구조 문서

## 개요
이 문서는 Sinil PMS 시스템의 PostgreSQL 데이터베이스 구조를 설명합니다. 
백업 파일 `db_cluster-22-07-2025@15-25-23.backup`과 현재 API 코드를 기반으로 작성되었습니다.

## 스키마 구조

### 1. public 스키마 (메인 비즈니스 로직)

#### 1.1 clients (병원/고객 정보)
```sql
CREATE TABLE public.clients (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    client_code text,                                    -- 고객 코드
    name text NOT NULL,                                  -- 병원명
    business_registration_number text NOT NULL,          -- 사업자등록번호
    owner_name text,                                     -- 대표자명
    address text,                                        -- 주소
    remarks text,                                        -- 비고
    status text DEFAULT 'active' NOT NULL,               -- 상태 (active/inactive)
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now()    -- 수정일시
);
```
**설명**: 병원 및 고객 정보를 관리하는 테이블입니다. 시스템의 주요 고객 엔티티입니다.

#### 1.2 companies (제약회사 정보)
```sql
CREATE TABLE public.companies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 회사 ID (UUID)
    user_id uuid,                                        -- 연결된 사용자 ID
    company_name text NOT NULL,                          -- 회사명
    business_registration_number text NOT NULL,          -- 사업자등록번호
    representative_name text NOT NULL,                   -- 대표자명
    business_address text NOT NULL,                      -- 사업장 주소
    landline_phone text,                                 -- 대표전화
    contact_person_name text NOT NULL,                   -- 담당자명
    mobile_phone text NOT NULL,                          -- 휴대폰 번호
    mobile_phone_2 text,                                 -- 휴대폰 번호 2
    email text NOT NULL,                                 -- 이메일
    default_commission_grade text DEFAULT 'A' NOT NULL,  -- 기본 수수료 등급
    remarks text,                                        -- 비고
    approval_status text DEFAULT 'pending' NOT NULL,     -- 승인 상태
    status text DEFAULT 'active' NOT NULL,               -- 상태
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    user_type text DEFAULT 'user' NOT NULL,              -- 사용자 타입
    company_group text,                                  -- 회사 그룹
    assigned_pharmacist_contact text,                    -- 배정 약사 연락처
    receive_email text,                                  -- 수신 이메일
    created_by uuid,                                     -- 생성자
    approved_at timestamp with time zone DEFAULT now(),  -- 승인일시
    updated_by uuid                                      -- 수정자
);
```
**설명**: 제약회사 정보를 관리하는 테이블입니다. 승인 프로세스를 포함합니다.

#### 1.3 products (제품 정보)
```sql
CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 제품 ID
    product_name text NOT NULL,                          -- 제품명
    insurance_code text,                                 -- 보험 코드
    price integer,                                       -- 가격
    commission_rate_a numeric NOT NULL,                  -- A등급 수수료율
    commission_rate_b numeric NOT NULL,                  -- B등급 수수료율
    commission_rate_c numeric,                           -- C등급 수수료율
    standard_code text NOT NULL,                         -- 표준 코드
    unit_packaging_desc text,                            -- 단위 포장 설명
    unit_quantity integer,                               -- 단위 수량
    remarks text,                                        -- 비고
    status text DEFAULT 'active' NOT NULL,               -- 상태
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    base_month text NOT NULL                             -- 기준월
);
```
**설명**: 제품 정보와 수수료율을 관리하는 테이블입니다.

#### 1.4 pharmacies (약국 정보)
```sql
CREATE TABLE public.pharmacies (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 약국 ID
    pharmacy_code text,                                  -- 약국 코드
    name text NOT NULL,                                  -- 약국명
    business_registration_number text NOT NULL,          -- 사업자등록번호
    address text,                                        -- 주소
    remarks text,                                        -- 비고
    status text DEFAULT 'active' NOT NULL,               -- 상태
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now()    -- 수정일시
);
```
**설명**: 약국 정보를 관리하는 테이블입니다.

#### 1.5 notices (공지사항)
```sql
CREATE TABLE public.notices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 공지사항 ID
    title text NOT NULL,                                 -- 제목
    content text NOT NULL,                               -- 내용
    is_pinned boolean DEFAULT false NOT NULL,            -- 고정 여부
    view_count integer DEFAULT 0 NOT NULL,               -- 조회수
    author_id uuid,                                      -- 작성자 ID
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    file_url text,                                       -- 첨부파일 URL
    links text                                           -- 링크
);
```
**설명**: 시스템 공지사항을 관리하는 테이블입니다.

#### 1.6 settlement_months (정산월 관리)
```sql
CREATE TABLE public.settlement_months (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 정산월 ID
    settlement_month character varying NOT NULL,         -- 정산월 (YYYY-MM)
    start_date date NOT NULL,                            -- 시작일
    end_date date NOT NULL,                              -- 종료일
    notice text,                                         -- 공지사항
    status character varying DEFAULT 'active' NOT NULL,  -- 상태
    remarks text,                                        -- 비고
    created_at timestamp with time zone DEFAULT now()    -- 생성일시
);
```
**설명**: 정산월 정보를 관리하는 테이블입니다.

#### 1.7 performance_records (실적 기록)
```sql
CREATE TABLE public.performance_records (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 실적 ID
    company_id uuid NOT NULL,                            -- 회사 ID
    settlement_month character varying NOT NULL,         -- 정산월
    prescription_month character varying NOT NULL,       -- 처방월
    client_id bigint NOT NULL,                           -- 고객 ID
    product_id uuid NOT NULL,                            -- 제품 ID
    prescription_qty numeric NOT NULL,                   -- 처방 수량
    prescription_type character varying DEFAULT 'EDI' NOT NULL, -- 처방 타입
    remarks text,                                        -- 비고
    registered_by uuid NOT NULL,                         -- 등록자
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now(),   -- 수정일시
    review_status text DEFAULT '대기',                   -- 검토 상태
    review_action text,                                  -- 검토 액션
    updated_by uuid,                                     -- 수정자
    commission_rate numeric                              -- 수수료율
);
```
**설명**: 실적 정보를 관리하는 핵심 테이블입니다. 검토 프로세스를 포함합니다.

#### 1.8 performance_records_absorption (실적 흡수율 분석)
```sql
CREATE TABLE public.performance_records_absorption (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 분석 ID
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    settlement_month character varying,                  -- 정산월
    company_id uuid,                                     -- 회사 ID
    client_id bigint,                                    -- 고객 ID
    product_id uuid,                                     -- 제품 ID
    prescription_month character varying,                -- 처방월
    prescription_qty numeric,                            -- 처방 수량
    prescription_type character varying,                 -- 처방 타입
    commission_rate numeric,                             -- 수수료율
    remarks text,                                        -- 비고
    registered_by uuid,                                  -- 등록자
    updated_at timestamp with time zone,                 -- 수정일시
    updated_by uuid,                                     -- 수정자
    review_action character varying,                     -- 검토 액션
    wholesale_revenue numeric DEFAULT 0,                 -- 도매 매출
    direct_revenue numeric DEFAULT 0,                    -- 직매 매출
    total_revenue numeric DEFAULT 0,                     -- 총 매출
    absorption_rate numeric DEFAULT 0                    -- 흡수율
);
```
**설명**: 실적 데이터의 흡수율 분석을 위한 테이블입니다.

#### 1.9 performance_evidence_files (실적 증빙 파일)
```sql
CREATE TABLE public.performance_evidence_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 파일 ID
    company_id uuid,                                     -- 회사 ID
    client_id bigint,                                    -- 고객 ID
    settlement_month text NOT NULL,                      -- 정산월
    file_name text NOT NULL,                             -- 파일명
    file_path text NOT NULL,                             -- 파일 경로
    file_size bigint,                                    -- 파일 크기
    uploaded_by uuid,                                    -- 업로드자
    uploaded_at timestamp without time zone DEFAULT now(), -- 업로드일시
    created_at timestamp without time zone DEFAULT now() -- 생성일시
);
```
**설명**: 실적 증빙 파일을 관리하는 테이블입니다.

#### 1.10 wholesale_sales (도매 매출)
```sql
CREATE TABLE public.wholesale_sales (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 매출 ID
    pharmacy_code text,                                  -- 약국 코드
    pharmacy_name text,                                  -- 약국명
    business_registration_number text NOT NULL,          -- 사업자등록번호
    address text,                                        -- 주소
    standard_code text NOT NULL,                         -- 표준 코드
    product_name text,                                   -- 제품명
    sales_amount numeric,                                -- 매출액
    sales_date date,                                     -- 매출일
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now(),   -- 수정일시
    created_by text,                                     -- 생성자
    updated_by text                                      -- 수정자
);
```
**설명**: 도매 매출 정보를 관리하는 테이블입니다.

#### 1.11 direct_sales (직매 매출)
```sql
CREATE TABLE public.direct_sales (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 매출 ID
    pharmacy_code text,                                  -- 약국 코드
    pharmacy_name text,                                  -- 약국명
    business_registration_number text NOT NULL,          -- 사업자등록번호
    address text,                                        -- 주소
    standard_code text NOT NULL,                         -- 표준 코드
    product_name text,                                   -- 제품명
    sales_amount numeric,                                -- 매출액
    sales_date date,                                     -- 매출일
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now(),   -- 수정일시
    created_by text,                                     -- 생성자
    updated_by text                                      -- 수정자
);
```
**설명**: 직매 매출 정보를 관리하는 테이블입니다.

#### 1.12 settlement_share (정산 내역서)
```sql
CREATE TABLE public.settlement_share (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 정산 ID
    settlement_month text NOT NULL,                      -- 정산월
    company_id uuid DEFAULT gen_random_uuid() NOT NULL,  -- 회사 ID
    share_enabled boolean NOT NULL,                      -- 공유 활성화 여부
    created_at timestamp with time zone DEFAULT now() NOT NULL -- 생성일시
);
```
**설명**: 정산 내역서 공유 설정을 관리하는 테이블입니다.

### 2. 관계 테이블 (매핑 테이블)

#### 2.1 client_company_assignments (병원-회사 배정)
```sql
CREATE TABLE public.client_company_assignments (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 배정 ID
    client_id bigint,                                    -- 고객 ID
    company_id uuid,                                     -- 회사 ID
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    company_default_commission_grade text DEFAULT 'A',   -- 기본 수수료 등급
    modified_commission_grade text                       -- 수정된 수수료 등급
);
```
**설명**: 병원과 제약회사 간의 배정 관계를 관리하는 테이블입니다.

#### 2.2 client_pharmacy_assignments (병원-약국 배정)
```sql
CREATE TABLE public.client_pharmacy_assignments (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 배정 ID
    client_id bigint NOT NULL,                           -- 고객 ID
    pharmacy_id bigint NOT NULL,                         -- 약국 ID
    created_at timestamp with time zone DEFAULT now()    -- 생성일시
);
```
**설명**: 병원과 약국 간의 배정 관계를 관리하는 테이블입니다.

#### 2.3 hospital_company_mappings (병원-회사 매핑) - 누락된 테이블
```sql
CREATE TABLE public.hospital_company_mappings (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 매핑 ID
    hospital_id bigint NOT NULL,                         -- 병원 ID
    company_id uuid NOT NULL,                            -- 회사 ID
    start_date date,                                     -- 시작일
    end_date date,                                       -- 종료일
    commission_rate numeric,                             -- 수수료율
    status text DEFAULT 'active',                        -- 상태
    remarks text,                                        -- 비고
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now()    -- 수정일시
);
```
**설명**: 병원과 회사 간의 상세 매핑 정보를 관리하는 테이블입니다. 
API 코드에서 사용되지만 백업 파일에 누락되어 있었습니다.

### 3. auth 스키마 (인증 관련)

#### 3.1 users (사용자 정보)
```sql
CREATE TABLE auth.users (
    instance_id uuid,
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 사용자 ID
    aud character varying,
    role character varying,
    email character varying,
    encrypted_password character varying,
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying,
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying,
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying,
    email_change character varying,
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying,
    phone_change_token character varying,
    phone_change_sent_at timestamp with time zone,
    email_change_token_current character varying,
    email_change_confirm_status smallint,
    banned_until timestamp with time zone,
    reauthentication_token character varying,
    reauthentication_sent_at timestamp with time zone
);
```
**설명**: Supabase 인증 시스템의 사용자 정보를 관리하는 테이블입니다.

### 4. storage 스키마 (파일 저장)

#### 4.1 buckets (저장소 버킷)
```sql
CREATE TABLE storage.buckets (
    id text NOT NULL,                                    -- 버킷 ID
    name text NOT NULL,                                  -- 버킷명
    owner uuid,                                          -- 소유자
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now(),   -- 수정일시
    public boolean DEFAULT false,                        -- 공개 여부
    avif_autodetection boolean DEFAULT false,           -- AVIF 자동감지
    file_size_limit bigint,                             -- 파일 크기 제한
    allowed_mime_types text[],                          -- 허용된 MIME 타입
    owner_id uuid                                        -- 소유자 ID
);
```
**설명**: 파일 저장소의 버킷 정보를 관리하는 테이블입니다.

#### 4.2 objects (저장된 파일)
```sql
CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,          -- 파일 ID
    bucket_id text,                                      -- 버킷 ID
    name text,                                           -- 파일명
    owner uuid,                                          -- 소유자
    created_at timestamp with time zone DEFAULT now(),   -- 생성일시
    updated_at timestamp with time zone DEFAULT now(),   -- 수정일시
    last_accessed_at timestamp with time zone DEFAULT now(), -- 마지막 접근일시
    metadata jsonb,                                      -- 메타데이터
    path_tokens text[]                                   -- 경로 토큰
);
```
**설명**: 저장된 파일의 정보를 관리하는 테이블입니다.

### 5. realtime 스키마 (실시간 기능)

#### 5.1 subscription (실시간 구독)
```sql
CREATE TABLE realtime.subscription (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,     -- 구독 ID
    subscription_id uuid NOT NULL,                       -- 구독 UUID
    entity regclass NOT NULL,                            -- 엔티티
    filters realtime.user_defined_filter[] DEFAULT '{}', -- 필터
    claims jsonb NOT NULL,                               -- 클레임
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);
```
**설명**: 실시간 데이터 구독 정보를 관리하는 테이블입니다.

## 주요 관계

### 1. 고객-회사 관계
- `clients` ↔ `client_company_assignments` ↔ `companies`
- `clients` ↔ `hospital_company_mappings` ↔ `companies`

### 2. 고객-약국 관계
- `clients` ↔ `client_pharmacy_assignments` ↔ `pharmacies`

### 3. 실적 관련 관계
- `performance_records` → `companies` (회사별 실적)
- `performance_records` → `clients` (고객별 실적)
- `performance_records` → `products` (제품별 실적)
- `performance_records_absorption` (실적 분석)

### 4. 매출 관련 관계
- `wholesale_sales` (도매 매출)
- `direct_sales` (직매 매출)

## 인덱스 및 제약조건

### 주요 인덱스
- 모든 ID 컬럼에 대한 기본 키 인덱스
- `performance_records`의 `settlement_month`, `company_id`, `client_id` 복합 인덱스
- `companies`의 `approval_status`, `status` 인덱스
- `clients`의 `status` 인덱스

### 외래 키 제약조건
- `performance_records.company_id` → `companies.id`
- `performance_records.client_id` → `clients.id`
- `performance_records.product_id` → `products.id`
- `client_company_assignments.client_id` → `clients.id`
- `client_company_assignments.company_id` → `companies.id`
- `client_pharmacy_assignments.client_id` → `clients.id`
- `client_pharmacy_assignments.pharmacy_id` → `pharmacies.id`

## 데이터 무결성 규칙

### 1. 상태 관리
- `status` 필드는 대부분 'active'/'inactive' 값을 사용
- `approval_status`는 'pending'/'approved'/'rejected' 값을 사용

### 2. 날짜 관리
- 모든 테이블에 `created_at` 필드 존재
- 주요 테이블에 `updated_at` 필드 존재
- 정산 관련 테이블은 `settlement_month` 형식 사용 (YYYY-MM)

### 3. 수수료율 관리
- 제품별 기본 수수료율: A, B, C 등급
- 고객별 수정된 수수료율 지원
- 실적 기록 시 개별 수수료율 적용 가능

## 백업 및 복구

### 백업 파일 정보
- 파일명: `db_cluster-22-07-2025@15-25-23.backup`
- 생성일: 2025년 7월 22일 15:25:23
- 형식: PostgreSQL 클러스터 덤프

### 누락된 구조
백업 파일에서 누락되었지만 현재 API에서 사용되는 테이블:
- `hospital_company_mappings`: 병원-회사 상세 매핑 정보

## API 엔드포인트 매핑

### 주요 API와 테이블 관계
- `/api/companies` → `clients` (회사 정보)
- `/api/products` → `products` (제품 정보)
- `/api/clients` → `clients` (고객 정보)
- `/api/pharmacies` → `clients` (약국 정보)
- `/api/notices` → `notices` (공지사항)
- `/api/performance-records` → `performance_records` (실적 정보)
- `/api/wholesale-sales` → `wholesale_sales` (도매 매출)
- `/api/direct-sales` → `direct_sales` (직매 매출)
- `/api/settlement-months` → `settlement_months` (정산월)
- `/api/settlement-share` → `settlement_share` (정산 내역서)

## 보안 고려사항

### 1. 인증
- Supabase 인증 시스템 사용
- JWT 토큰 기반 인증
- 역할 기반 접근 제어 (RBAC)

### 2. 데이터 보호
- 민감한 정보 암호화
- API 엔드포인트별 권한 검증
- SQL 인젝션 방지를 위한 파라미터화된 쿼리 사용

### 3. 감사 로그
- `auth.audit_log_entries` 테이블을 통한 사용자 활동 추적
- 데이터 변경 이력 관리

## 성능 최적화

### 1. 인덱스 전략
- 자주 조회되는 컬럼에 인덱스 생성
- 복합 인덱스를 통한 쿼리 최적화
- 부분 인덱스를 통한 저장 공간 절약

### 2. 쿼리 최적화
- 페이지네이션을 통한 대용량 데이터 처리
- 필요한 컬럼만 선택하여 네트워크 트래픽 최소화
- 적절한 WHERE 조건을 통한 데이터 필터링

## 마이그레이션 및 버전 관리

### 1. 스키마 변경
- Supabase 마이그레이션 시스템 사용
- 버전 관리된 스키마 변경 이력
- 롤백 가능한 마이그레이션 구조

### 2. 데이터 마이그레이션
- 기존 데이터 보존을 위한 마이그레이션 스크립트
- 데이터 무결성 검증 프로세스
- 단계별 마이그레이션 지원

---

**문서 버전**: 1.0  
**최종 업데이트**: 2025년 1월 6일  
**작성자**: AI Assistant  
**검토자**: 개발팀
