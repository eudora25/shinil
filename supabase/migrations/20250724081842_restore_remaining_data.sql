-- Restore remaining table data to Supabase

-- Restore clients data
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (9, '', '의료법인 춘혜의료재단 명지춘혜재 활병원', '108-82-08035', '임진', '서울특별시 영등포구 대림로 223, (대림동, 명지춘혜병원)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (10, '', '에스앤유서울병원', '157-92-00844', '이상훈', '서울특별시 강서구 공항대로 237, 에이스타워 마곡 3,4,5,6층 (마곡동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (11, '', '바른길정형외과의원', '279-96-01817', '길경민', '인천광역시 부평구 열우물로 75, 지하1층,지상2~5층 (십정동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (12, '', '중계퍼스트정형외과의원', '546-95-01549', '김태환', '서울특별시 노원구 동일로 1308, 정안프라자 3층 (중계동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (13, '', '서울삼성호매실요양병원', '893-92-00275', '서상혁', '경기도 수원시 권선구 금곡로118번길 10, 일담타워 4~6층 (금곡동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (14, '', '평택삼성요양병원', '278-99-00757', '하창영', '경기도 평택시 비전2로 194, 소사벌 어반테라스 1동 5층~9층층 (비전동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (15, '', '단샘의원', '127-92-54640', '장범순', '경기도 양주시 고읍로 10, (고읍동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (16, '', '삼성바른내과의원(길음)', '337-90-01450', '함철배', '서울특별시 성북구 정릉로 364, 3층 (돈암동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (17, '', '삼성바른내과의원(중계)', '678-97-00365', '유수현', '서울특별시 노원구 한글비석로 270, 스카이타워 5층 (중계동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');
INSERT INTO public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) OVERRIDING SYSTEM VALUE VALUES (18, '', '삼성편한내과의원(상계)', '590-92-01337', '유동훈', '서울특별시 노원구 동일로 1380, 상계동 국민은행 4층 (상계동)', '', 'active', '2025-07-21 06:03:56.284904+00', '2025-07-21 06:03:56.284904+00');

-- Restore pharmacies data (if any)
-- INSERT INTO public.pharmacies (id, pharmacy_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, remarks, status, created_at, updated_at) VALUES (...);

-- Restore notices data (if any)
-- INSERT INTO public.notices (id, title, content, author, status, created_at, updated_at) VALUES (...);

-- Restore other tables data as needed
-- Additional table data will be added here
