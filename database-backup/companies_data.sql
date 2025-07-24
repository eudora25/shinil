--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) VALUES ('385e49aa-d016-4c94-a621-9a20dc41fdc5', '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a', '투썬제약', '777-77-77777', '투대표', '경기도 성남시 판교역로 221', NULL, '김팜플', '010-7777-7777', NULL, 'admin@admin.com', 'A', NULL, 'approved', 'active', '2025-07-21 05:12:06.435316+00', '2025-07-21 05:12:06.435316+00', 'admin', NULL, NULL, NULL, '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a', '2025-07-21 05:12:06.435316+00', NULL);
INSERT INTO public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) VALUES ('705eaed7-a1c5-468e-80d8-f4a983cbd60b', 'db493775-9caa-4401-9277-d9c046f0e6a3', 'tt1', '1988082412', '문주영', '한국', NULL, 'MJ', '010-531-4152', NULL, 'tt1@tt.com', 'A', NULL, 'approved', 'active', '2025-07-21 06:21:07.998332+00', '2025-07-21 06:21:15.683+00', 'user', NULL, NULL, NULL, 'db493775-9caa-4401-9277-d9c046f0e6a3', '2025-07-21 06:21:15.684+00', '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a');
INSERT INTO public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) VALUES ('11f63abd-1f3b-4a8e-a7ad-ea47192339e1', 'f19113ee-432b-4f29-9c20-15cfe4001376', 'ediide', '9482391938', 'educ', 'tirepro', NULL, 'iteacher', '01000230001', NULL, 'moonmvp@twosun.com', 'A', NULL, 'pending', 'active', '2025-07-21 06:23:19.447355+00', '2025-07-21 08:53:49.095+00', 'user', NULL, NULL, NULL, 'f19113ee-432b-4f29-9c20-15cfe4001376', '2025-07-21 06:23:37.624+00', '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a');
INSERT INTO public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) VALUES ('32ddfa45-a8ba-40b1-9c9a-2cce24424d8a', '5f474ca1-75e5-4382-b6af-2d33abe54d31', '업체1', '100-10-10000', '일길동', '서울시 일구 일동 111-11', '', '담당당', '010-1000-1000', '', 'user1@user.com', 'A', '', 'approved', 'active', '2025-07-21 05:11:05.892047+00', '2025-07-22 00:50:28.492+00', 'user', '', '', '', '5f474ca1-75e5-4382-b6af-2d33abe54d31', '2025-07-21 05:33:42.29+00', '5f474ca1-75e5-4382-b6af-2d33abe54d31');
INSERT INTO public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) VALUES ('3332cfbd-b161-491b-bee6-b7b537c7cf1a', '1d3ce10a-a53a-4f92-827d-8af539a4450c', '업체2', '200-20-20000', '이길동', '서울시 이구 이동 222-22', '', '담당', '010-1111-1111', '', 'user2@user.com', 'B', '', 'approved', 'active', '2025-07-21 05:34:23.694259+00', '2025-07-22 03:45:10.197+00', 'user', '', '', '', '1d3ce10a-a53a-4f92-827d-8af539a4450c', '2025-07-21 06:00:40.958+00', '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a');


--
-- PostgreSQL database dump complete
--

