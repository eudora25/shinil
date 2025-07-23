-- 업체(companies) 일괄 등록 SQL
-- ⚠️ 주의사항: 
-- 1. user_id는 Supabase Auth에 먼저 사용자가 생성되어야 합니다
-- 2. 관리자가 직접 SQL로 등록하는 경우 user_id를 NULL로 설정할 수 있습니다
-- 3. 사업자등록번호는 중복되면 안 됩니다

INSERT INTO companies (
  email,                        -- 이메일 (로그인 ID)
  company_name,                 -- 업체명
  business_registration_number, -- 사업자등록번호
  representative_name,          -- 대표자명
  business_address,             -- 사업장 소재지
  landline_phone,              -- 유선전화
  contact_person_name,         -- 담당자명
  mobile_phone,                -- 휴대폰 번호
  mobile_phone_2,              -- 휴대폰 번호2
  receive_email,               -- 수신용 이메일
  company_group,               -- 구분/그룹
  default_commission_grade,    -- 수수료 등급 (A, B, C)
  assigned_pharmacist_contact, -- 관리자
  remarks,                     -- 비고
  approval_status,             -- 승인상태 ('approved', 'pending', 'rejected')
  user_id,                     -- Supabase Auth user ID (NULL 가능)
  user_type,                   -- 사용자 유형 ('admin' 또는 'user')
  status,                      -- 상태 ('active' 또는 'inactive')
  created_at,                  -- 생성일시
  updated_at                   -- 수정일시
) VALUES
-- 예시 데이터
('company1@example.com', '(주)테스트제약', '123-45-67890', '홍길동', '서울시 강남구 테헤란로 123', '02-1234-5678', '김담당', '010-1234-5678', NULL, 'company1@example.com', '제약', 'A', '관리자1', '테스트 업체', 'approved', NULL, 'user', 'active', NOW(), NOW()),
('company2@example.com', '(주)샘플바이오', '234-56-78901', '이순신', '서울시 서초구 서초대로 456', '02-2345-6789', '박담당', '010-2345-6789', '010-9876-5432', 'sample@example.com', '바이오', 'B', '관리자2', '', 'approved', NULL, 'user', 'active', NOW(), NOW()),
('company3@example.com', '(주)예시메디칼', '345-67-89012', '세종대왕', '경기도 성남시 분당구 판교로 789', NULL, '최담당', '010-3456-7890', NULL, NULL, '의료기기', 'A', NULL, '신규 업체', 'pending', NULL, 'user', 'active', NOW(), NOW());

-- 등록 결과 확인
SELECT 
  email,
  company_name,
  business_registration_number,
  representative_name,
  default_commission_grade,
  approval_status,
  status
FROM companies 
WHERE created_at >= NOW() - INTERVAL '1 hour'
ORDER BY company_name; 