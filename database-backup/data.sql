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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	5a622167-9245-4072-8dcd-67d03041c773	{"action":"user_confirmation_requested","actor_id":"4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c","actor_username":"d1@123.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-07-21 04:56:11.555379+00	
00000000-0000-0000-0000-000000000000	c4436008-2d90-479e-b043-943b5b099045	{"action":"user_confirmation_requested","actor_id":"843fefaf-fc91-45a4-a117-f1e1a19af93d","actor_username":"sjchoi@twosun.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-07-21 05:06:14.294063+00	
00000000-0000-0000-0000-000000000000	164fe0bc-f3ad-4306-9c75-4fc483e3390c	{"action":"user_confirmation_requested","actor_id":"843fefaf-fc91-45a4-a117-f1e1a19af93d","actor_username":"sjchoi@twosun.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-07-21 05:10:01.821151+00	
00000000-0000-0000-0000-000000000000	898fe287-8ef4-41a9-b7aa-b57ef0d71d2f	{"action":"user_signedup","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-21 05:11:05.717825+00	
00000000-0000-0000-0000-000000000000	e5254459-425a-4307-848a-fb07f1964333	{"action":"login","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:11:05.722173+00	
00000000-0000-0000-0000-000000000000	eec60645-ded8-41b7-a44e-b164ff222eb0	{"action":"logout","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:11:07.352253+00	
00000000-0000-0000-0000-000000000000	8d04d861-d260-445a-a677-c81fabb52446	{"action":"user_signedup","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-21 05:12:06.324153+00	
00000000-0000-0000-0000-000000000000	08038a45-ec25-4a3c-a3fa-a3af15e41d37	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:12:06.327633+00	
00000000-0000-0000-0000-000000000000	0cd3e06c-2637-460b-b203-83a5f8611f1f	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:12:07.478426+00	
00000000-0000-0000-0000-000000000000	59a6492a-adb4-431e-be41-a91e7c2561a4	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:13:44.400777+00	
00000000-0000-0000-0000-000000000000	7bd21a69-4207-4fe2-af59-54b0262c2b98	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:18:38.192076+00	
00000000-0000-0000-0000-000000000000	4cda4244-7c66-445d-bbcf-1df63addb911	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:18:52.278483+00	
00000000-0000-0000-0000-000000000000	32009fed-2503-4251-a3ea-51b0d8a7dc09	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:19:16.430189+00	
00000000-0000-0000-0000-000000000000	0403c9b7-3178-4da7-94ac-3eee3a87576a	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:19:28.275168+00	
00000000-0000-0000-0000-000000000000	e68e26a7-a058-48f8-b911-c7f33ab04bc3	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:33:50.091367+00	
00000000-0000-0000-0000-000000000000	a9d4d886-2ef8-46f5-8db4-573cd7ab34b0	{"action":"user_signedup","actor_id":"1d3ce10a-a53a-4f92-827d-8af539a4450c","actor_username":"user2@user.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-21 05:34:23.553537+00	
00000000-0000-0000-0000-000000000000	5d2d31f4-da55-4f18-a9ff-77ee5176cc26	{"action":"login","actor_id":"1d3ce10a-a53a-4f92-827d-8af539a4450c","actor_username":"user2@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:34:23.557479+00	
00000000-0000-0000-0000-000000000000	0a9a6d55-6a65-4ea0-9e58-c26a115a3173	{"action":"logout","actor_id":"1d3ce10a-a53a-4f92-827d-8af539a4450c","actor_username":"user2@user.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:34:25.122343+00	
00000000-0000-0000-0000-000000000000	c16f2ce7-1af2-4987-a9ae-7b853d970d07	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 05:34:38.48781+00	
00000000-0000-0000-0000-000000000000	36807b98-b34c-45c9-b2e9-874f4cf7d2e7	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 05:34:59.172428+00	
00000000-0000-0000-0000-000000000000	3efc4915-31b9-4d77-8eb0-f26a83c72e75	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:00:32.259884+00	
00000000-0000-0000-0000-000000000000	badfc8f4-efaf-427c-95f0-5ed017518e31	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:08:09.966136+00	
00000000-0000-0000-0000-000000000000	55540b5e-0e3d-441f-931d-82447a6a437d	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:08:43.748069+00	
00000000-0000-0000-0000-000000000000	252d6c7e-8028-491f-8311-8515b2f9396c	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:10:12.480903+00	
00000000-0000-0000-0000-000000000000	54ad482d-d35d-49e3-81c9-a69b82d30e92	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:10:40.301191+00	
00000000-0000-0000-0000-000000000000	1afb78ce-48f3-41ed-ac70-7460ff31f605	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:19:49.573324+00	
00000000-0000-0000-0000-000000000000	d7e2b62f-5f23-4968-87e4-202eedbcdcd3	{"action":"user_signedup","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-21 06:21:07.87945+00	
00000000-0000-0000-0000-000000000000	01b73bb6-5b7f-44c0-9366-05ab04209d19	{"action":"login","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:21:07.883511+00	
00000000-0000-0000-0000-000000000000	af6c937a-9d00-40a0-88f0-5f7ac975b2b2	{"action":"logout","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:21:08.94251+00	
00000000-0000-0000-0000-000000000000	7b634962-9aa1-4761-b1e7-6e0688b8464c	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:21:10.223351+00	
00000000-0000-0000-0000-000000000000	0c5bef2b-2ed5-4eef-8937-d6d52dfe3200	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:21:22.536657+00	
00000000-0000-0000-0000-000000000000	5ea9d65e-b9bc-444d-b06e-572ea50c251b	{"action":"login","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:21:24.144301+00	
00000000-0000-0000-0000-000000000000	8f9435d4-30e2-4aa2-8a32-22eeb559d772	{"action":"logout","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:21:38.578329+00	
00000000-0000-0000-0000-000000000000	00944628-a014-45c7-9737-7116715cbfc5	{"action":"user_signedup","actor_id":"f19113ee-432b-4f29-9c20-15cfe4001376","actor_username":"moonmvp@twosun.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-21 06:23:19.37519+00	
00000000-0000-0000-0000-000000000000	d7c4a5d9-ab07-4ff9-94e2-9b6a9f78dcd6	{"action":"login","actor_id":"f19113ee-432b-4f29-9c20-15cfe4001376","actor_username":"moonmvp@twosun.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:23:19.379283+00	
00000000-0000-0000-0000-000000000000	1c34ddd8-7c4a-4d60-96e8-22ceb452e894	{"action":"logout","actor_id":"f19113ee-432b-4f29-9c20-15cfe4001376","actor_username":"moonmvp@twosun.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:23:20.34086+00	
00000000-0000-0000-0000-000000000000	99ddf8af-b6e1-4409-9bf1-e3917898e4ec	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 06:23:30.165009+00	
00000000-0000-0000-0000-000000000000	97d28c9a-3c6c-4e40-bb41-a5ad9eb8b4fb	{"action":"user_recovery_requested","actor_id":"f19113ee-432b-4f29-9c20-15cfe4001376","actor_username":"moonmvp@twosun.com","actor_via_sso":false,"log_type":"user"}	2025-07-21 06:23:42.67024+00	
00000000-0000-0000-0000-000000000000	361386d7-6ef7-4f56-b213-19ff955277f6	{"action":"login","actor_id":"f19113ee-432b-4f29-9c20-15cfe4001376","actor_username":"moonmvp@twosun.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 06:23:52.058812+00	
00000000-0000-0000-0000-000000000000	92c48e04-693d-4710-82b8-227fad8d43fa	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 08:03:20.488498+00	
00000000-0000-0000-0000-000000000000	75c20fa5-4666-4035-a850-a24bc14264e7	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-21 08:08:02.402914+00	
00000000-0000-0000-0000-000000000000	4173f371-35c6-47e2-a239-6b188d1c8cd1	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 08:08:14.776827+00	
00000000-0000-0000-0000-000000000000	3fef82d5-ad65-4b4e-9eef-2efa3d0fe1d6	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 08:20:02.235793+00	
00000000-0000-0000-0000-000000000000	5bcc87dc-38ac-43ba-ac48-d89fef5ef86e	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-21 08:52:22.842141+00	
00000000-0000-0000-0000-000000000000	c24ff3a9-e131-4224-8b99-465339c44559	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 10:01:15.26925+00	
00000000-0000-0000-0000-000000000000	b52e04b2-14d6-4bbb-b97f-933f72d2473e	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 10:01:15.270091+00	
00000000-0000-0000-0000-000000000000	186ea13d-be20-47d4-851c-d3e44195fb7b	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 10:10:05.179213+00	
00000000-0000-0000-0000-000000000000	31f120dc-8285-4543-96df-8fe615aa5dfc	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 10:10:05.180064+00	
00000000-0000-0000-0000-000000000000	b82d0e28-0d6a-41ed-aa52-ff9234f09b76	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 11:32:57.776738+00	
00000000-0000-0000-0000-000000000000	55eaa7f3-2b20-4253-89dc-11c8315e6c55	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-21 11:32:57.777617+00	
00000000-0000-0000-0000-000000000000	ecf694de-0ba4-4163-a9f4-183bae62231c	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 00:14:07.03162+00	
00000000-0000-0000-0000-000000000000	4954c7ab-80da-4de7-bb95-dc7e567a974b	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 00:14:07.032498+00	
00000000-0000-0000-0000-000000000000	ca088fac-c4d3-4b1c-a1d0-4c0a9375e09e	{"action":"login","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 00:27:13.513967+00	
00000000-0000-0000-0000-000000000000	188017df-f3ee-4243-a0ca-ddfe6ed74e42	{"action":"login","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 00:44:50.563159+00	
00000000-0000-0000-0000-000000000000	245e2128-a5c4-4684-b899-6e5f93e26584	{"action":"logout","actor_id":"db493775-9caa-4401-9277-d9c046f0e6a3","actor_username":"tt1@tt.com","actor_via_sso":false,"log_type":"account"}	2025-07-22 00:44:53.964053+00	
00000000-0000-0000-0000-000000000000	655a604f-a14d-4f3a-81cf-e8fb9c7561aa	{"action":"login","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 00:45:23.531927+00	
00000000-0000-0000-0000-000000000000	688753fe-3ffe-4513-a969-c2519857e647	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 00:53:00.801436+00	
00000000-0000-0000-0000-000000000000	4f56939c-e166-439e-b4df-0d1d18654c2c	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 00:53:00.802332+00	
00000000-0000-0000-0000-000000000000	a43fa901-7a3e-46d4-b4d0-cbb8558803ab	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 01:12:17.880615+00	
00000000-0000-0000-0000-000000000000	9b93fe86-3ca3-421f-bde4-894d45b5f74b	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 01:12:17.881494+00	
00000000-0000-0000-0000-000000000000	fc0238bd-c37e-471f-a376-de62d637e6f1	{"action":"user_signedup","actor_id":"be9a4255-c9f5-4873-9d0a-2c08ad5716a9","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-22 01:21:34.603959+00	
00000000-0000-0000-0000-000000000000	1e1d5c72-d24d-49a5-b597-7b13ed09f7ef	{"action":"login","actor_id":"be9a4255-c9f5-4873-9d0a-2c08ad5716a9","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 01:21:34.608384+00	
00000000-0000-0000-0000-000000000000	af694e4e-f2dd-43f9-9f48-be7fd0998efe	{"action":"logout","actor_id":"be9a4255-c9f5-4873-9d0a-2c08ad5716a9","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"account"}	2025-07-22 01:23:34.378818+00	
00000000-0000-0000-0000-000000000000	aacffd65-64c4-46c7-b787-425051d9c415	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 01:23:36.618909+00	
00000000-0000-0000-0000-000000000000	0ff911a3-1471-41f2-a93b-4b581164c509	{"action":"logout","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account"}	2025-07-22 01:24:31.162549+00	
00000000-0000-0000-0000-000000000000	986eaa23-3ade-44cf-abb9-652a5056cb9b	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 01:24:32.39042+00	
00000000-0000-0000-0000-000000000000	61356ff0-5ef3-4c8f-a2a5-a1d979bd64ff	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 01:33:24.419865+00	
00000000-0000-0000-0000-000000000000	d62b47f9-d58e-4a63-beb2-d39385890e4e	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 01:50:11.000471+00	
00000000-0000-0000-0000-000000000000	42e0df89-183e-45bb-b475-df096beff707	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 01:50:11.001522+00	
00000000-0000-0000-0000-000000000000	133770ce-2a54-4ad5-8d83-4e6073cb0bbd	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:22:41.271186+00	
00000000-0000-0000-0000-000000000000	c99b7d9a-b26d-4b7d-8858-344548050454	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:22:41.272073+00	
00000000-0000-0000-0000-000000000000	08e440f3-9466-41a2-bab5-ea8437c11cd0	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:31:31.979725+00	
00000000-0000-0000-0000-000000000000	f80e1ea6-fec7-4c2d-98b5-6b7e06997341	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:31:31.980705+00	
00000000-0000-0000-0000-000000000000	0a0a6c25-d0b6-4444-a955-db524272a88b	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:48:14.076065+00	
00000000-0000-0000-0000-000000000000	c87572b0-aa4f-48da-8c7e-bdc451fee2f3	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 02:48:14.076968+00	
00000000-0000-0000-0000-000000000000	56a518c4-c9b4-47ca-8dbf-d6349d356507	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 03:37:55.05904+00	
00000000-0000-0000-0000-000000000000	6bb6451c-d24e-45ed-ad28-92bbe0581ef6	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 03:37:55.059897+00	
00000000-0000-0000-0000-000000000000	81fd59f0-0dfb-40f1-80d8-b017bfda1af4	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 04:05:34.352499+00	
00000000-0000-0000-0000-000000000000	c4290075-cf8c-4ef8-aa03-bb414ab5ea3c	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 04:05:34.353427+00	
00000000-0000-0000-0000-000000000000	bf30d89f-4728-45aa-8903-875b79b1d200	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 04:42:01.657831+00	
00000000-0000-0000-0000-000000000000	fe4594bd-9a21-48d6-83df-22b42c03a166	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 04:42:01.658667+00	
00000000-0000-0000-0000-000000000000	a2984f3a-b297-4dc1-bcc3-440e67cf680a	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:06:53.731275+00	
00000000-0000-0000-0000-000000000000	4759fb50-3953-4147-b955-4d81c2077571	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:06:53.732102+00	
00000000-0000-0000-0000-000000000000	82c16d6a-43d5-49e6-98f5-459ea2cadf50	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:11:05.211333+00	
00000000-0000-0000-0000-000000000000	50110dc1-8298-4589-be22-c702c9117433	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:11:05.212206+00	
00000000-0000-0000-0000-000000000000	338d91a2-6686-4362-ad3e-3c5d8b81a822	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:47:01.969545+00	
00000000-0000-0000-0000-000000000000	88565c3e-fb5e-4f02-8547-7330a5ec1c2d	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 05:47:01.970396+00	
00000000-0000-0000-0000-000000000000	7e677218-c8e5-4b90-9884-d4fbc3569f3c	{"action":"login","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 05:51:17.320943+00	
00000000-0000-0000-0000-000000000000	6143db71-8f95-41b0-86d3-f5d45d08e6e6	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 06:15:22.52729+00	
00000000-0000-0000-0000-000000000000	367c25a0-6a53-44fd-be6b-03107a9fba48	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 06:15:22.528097+00	
00000000-0000-0000-0000-000000000000	33edb93b-b13d-4fd3-890e-b1aa53e4b54f	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:24:15.351129+00	
00000000-0000-0000-0000-000000000000	488d753a-4e7c-4106-9fda-dd4fee229427	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:24:15.352092+00	
00000000-0000-0000-0000-000000000000	c4c8018f-5eff-4027-bf81-16ba3b8dc707	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:24:26.988959+00	
00000000-0000-0000-0000-000000000000	d8d180d8-4d22-4a7e-84f2-c5a42c7a546a	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:24:26.989489+00	
00000000-0000-0000-0000-000000000000	059fc251-ba80-4748-bcc5-8d40783b99fb	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:38:56.763804+00	
00000000-0000-0000-0000-000000000000	1ed81648-424e-4ff7-8051-3c4faf80eb2f	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:38:56.764629+00	
00000000-0000-0000-0000-000000000000	5d07a364-b4ac-48e9-a25a-65696a0c1a0c	{"action":"token_refreshed","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:41:16.526279+00	
00000000-0000-0000-0000-000000000000	c6b69c59-bb92-4825-b7a5-fc6c321b212d	{"action":"token_revoked","actor_id":"5f474ca1-75e5-4382-b6af-2d33abe54d31","actor_username":"user1@user.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 07:41:16.527112+00	
00000000-0000-0000-0000-000000000000	66bc840f-3488-4c6a-8dce-3dc0f6e8fb87	{"action":"user_repeated_signup","actor_id":"be9a4255-c9f5-4873-9d0a-2c08ad5716a9","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-07-22 08:11:59.115781+00	
00000000-0000-0000-0000-000000000000	2a00f00e-0c56-43dd-94c6-18c4700ace00	{"action":"token_refreshed","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 08:25:32.611118+00	
00000000-0000-0000-0000-000000000000	e0bc9c56-f1e1-4ce7-9e4d-03f60e02af76	{"action":"token_revoked","actor_id":"0e085a22-2267-4e7a-9c1e-5c7bf4f3034a","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-22 08:25:32.611969+00	
00000000-0000-0000-0000-000000000000	aa6b4c00-60b5-4a98-815a-15617773e34f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"user3@user.com","user_id":"be9a4255-c9f5-4873-9d0a-2c08ad5716a9","user_phone":""}}	2025-07-22 08:37:08.655942+00	
00000000-0000-0000-0000-000000000000	724f4b86-fda2-404a-94f4-ac5930a78be1	{"action":"user_signedup","actor_id":"3c9f358e-e2f5-439f-b894-a59d5382f27f","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-07-22 08:37:58.849687+00	
00000000-0000-0000-0000-000000000000	3d535839-1f2f-48c1-a8f0-f6d04453d626	{"action":"login","actor_id":"3c9f358e-e2f5-439f-b894-a59d5382f27f","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-22 08:37:58.853512+00	
00000000-0000-0000-0000-000000000000	c0d998b1-f251-4223-bf95-fe7da4c5490d	{"action":"user_repeated_signup","actor_id":"3c9f358e-e2f5-439f-b894-a59d5382f27f","actor_username":"user3@user.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-07-22 08:38:19.360248+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	f19113ee-432b-4f29-9c20-15cfe4001376	authenticated	authenticated	moonmvp@twosun.com	$2a$10$ikfB2unnnyNPsX579AkDRuUW7vCRUsQO9nkMwDCMzPqPjfDMZOg0S	2025-07-21 06:23:19.375878+00	\N		\N		2025-07-21 06:23:42.670899+00			\N	2025-07-21 06:23:52.060768+00	{"provider": "email", "providers": ["email"]}	{"sub": "f19113ee-432b-4f29-9c20-15cfe4001376", "email": "moonmvp@twosun.com", "user_type": "user", "email_verified": true, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 06:23:19.368849+00	2025-07-21 06:23:52.062529+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	843fefaf-fc91-45a4-a117-f1e1a19af93d	authenticated	authenticated	sjchoi@twosun.com	$2a$10$tqqfDgepImzR.tO1NY2VNuSHa4UGAPAOgF.NHrVcfO6ahYc6A.kd6	\N	\N	6cc274f1e6f8cb1ce8d7ee571a14324b48652e5b0f2c6f13754b2cb6	2025-07-21 05:10:01.82214+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "843fefaf-fc91-45a4-a117-f1e1a19af93d", "email": "sjchoi@twosun.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 05:06:14.287698+00	2025-07-21 05:10:02.872572+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1d3ce10a-a53a-4f92-827d-8af539a4450c	authenticated	authenticated	user2@user.com	$2a$10$TVvegdMqvjVTq7ldiSM2NuoR3SmP7kV5HYg.VQMN9Cx.xVhu19UIC	2025-07-21 05:34:23.554001+00	\N		\N		\N			\N	2025-07-21 05:34:23.558002+00	{"provider": "email", "providers": ["email"]}	{"sub": "1d3ce10a-a53a-4f92-827d-8af539a4450c", "email": "user2@user.com", "user_type": "user", "email_verified": true, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 05:34:23.547574+00	2025-07-21 05:34:23.560016+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c	authenticated	authenticated	d1@123.com	$2a$10$PcdB7f3K.zkLRkY4wCYBg.PRFPPGNGh/UrOQyy5GyWLKve0NA.oqu	\N	\N	b289cd478248a57840f0f5e110750b0fdc0e458522464192b968d8ca	2025-07-21 04:56:11.555914+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c", "email": "d1@123.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 04:56:11.550867+00	2025-07-21 04:56:12.511862+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	5f474ca1-75e5-4382-b6af-2d33abe54d31	authenticated	authenticated	user1@user.com	$2a$10$K0OfJljdqWKYq2R9L.a09ekGyC.bZE9cHthhhVXB68e8U4dJqBBLC	2025-07-21 05:11:05.718582+00	\N		\N		\N			\N	2025-07-22 00:45:23.532636+00	{"provider": "email", "providers": ["email"]}	{"sub": "5f474ca1-75e5-4382-b6af-2d33abe54d31", "email": "user1@user.com", "user_type": "user", "email_verified": true, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 05:11:05.709169+00	2025-07-22 07:41:16.529224+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	db493775-9caa-4401-9277-d9c046f0e6a3	authenticated	authenticated	tt1@tt.com	$2a$10$uTe6ygjtqDkJ.9ZxbgakQurImrls6VsSZXCJSyv6ZuAd1FaULdtr2	2025-07-21 06:21:07.880133+00	\N		\N		\N			\N	2025-07-22 00:44:50.564194+00	{"provider": "email", "providers": ["email"]}	{"sub": "db493775-9caa-4401-9277-d9c046f0e6a3", "email": "tt1@tt.com", "user_type": "user", "email_verified": true, "phone_verified": false, "approval_status": "pending"}	\N	2025-07-21 06:21:07.873014+00	2025-07-22 00:44:50.566805+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3c9f358e-e2f5-439f-b894-a59d5382f27f	authenticated	authenticated	user3@user.com	$2a$10$J8OtkrVvVcTT/hb/jLAf7Ol9c9dWHE94poxXL4fw5PQke4yl6cRt.	2025-07-22 08:37:58.850241+00	\N		\N		\N			\N	2025-07-22 08:37:58.854072+00	{"provider": "email", "providers": ["email"]}	{"sub": "3c9f358e-e2f5-439f-b894-a59d5382f27f", "email": "user3@user.com", "user_type": "user", "company_name": "업체3", "email_verified": true, "phone_verified": false}	\N	2025-07-22 08:37:58.843426+00	2025-07-22 08:37:58.856431+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	authenticated	authenticated	admin@admin.com	$2b$10$xqn610aO7WFxBNtvkTnqqOxNMtEppOX7EJLLQ.3vqSc4Y1sT3gJSK	2025-07-21 05:12:06.324743+00	\N		\N		\N			\N	2025-07-22 05:51:17.322002+00	{"provider": "email", "providers": ["email"]}	{"sub": "0e085a22-2267-4e7a-9c1e-5c7bf4f3034a", "email": "admin@admin.com", "user_type": "admin", "email_verified": true, "phone_verified": false, "approval_status": "approved"}	\N	2025-07-21 05:12:06.319195+00	2025-07-22 08:25:32.614164+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c	4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c	{"sub": "4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c", "email": "d1@123.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 04:56:11.553245+00	2025-07-21 04:56:11.553296+00	2025-07-21 04:56:11.553296+00	a4736a81-05eb-4297-8111-c8375ceba8cd
843fefaf-fc91-45a4-a117-f1e1a19af93d	843fefaf-fc91-45a4-a117-f1e1a19af93d	{"sub": "843fefaf-fc91-45a4-a117-f1e1a19af93d", "email": "sjchoi@twosun.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 05:06:14.291318+00	2025-07-21 05:06:14.291368+00	2025-07-21 05:06:14.291368+00	966181b0-a0a8-4ef2-9817-ccd4ac2e9297
5f474ca1-75e5-4382-b6af-2d33abe54d31	5f474ca1-75e5-4382-b6af-2d33abe54d31	{"sub": "5f474ca1-75e5-4382-b6af-2d33abe54d31", "email": "user1@user.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 05:11:05.712778+00	2025-07-21 05:11:05.712824+00	2025-07-21 05:11:05.712824+00	3380cb4f-03a5-4fd5-88b5-ce243ad95df5
0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	{"sub": "0e085a22-2267-4e7a-9c1e-5c7bf4f3034a", "email": "admin@admin.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 05:12:06.321576+00	2025-07-21 05:12:06.32162+00	2025-07-21 05:12:06.32162+00	f2126089-e7ff-47c9-9f5c-ae910329b12d
1d3ce10a-a53a-4f92-827d-8af539a4450c	1d3ce10a-a53a-4f92-827d-8af539a4450c	{"sub": "1d3ce10a-a53a-4f92-827d-8af539a4450c", "email": "user2@user.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 05:34:23.550942+00	2025-07-21 05:34:23.550991+00	2025-07-21 05:34:23.550991+00	f7439e6d-a6dc-4785-8bd4-f15a46984882
db493775-9caa-4401-9277-d9c046f0e6a3	db493775-9caa-4401-9277-d9c046f0e6a3	{"sub": "db493775-9caa-4401-9277-d9c046f0e6a3", "email": "tt1@tt.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 06:21:07.876735+00	2025-07-21 06:21:07.876784+00	2025-07-21 06:21:07.876784+00	d617c775-ca69-4797-8d40-e8558a384d43
f19113ee-432b-4f29-9c20-15cfe4001376	f19113ee-432b-4f29-9c20-15cfe4001376	{"sub": "f19113ee-432b-4f29-9c20-15cfe4001376", "email": "moonmvp@twosun.com", "user_type": "user", "email_verified": false, "phone_verified": false, "approval_status": "pending"}	email	2025-07-21 06:23:19.372422+00	2025-07-21 06:23:19.37247+00	2025-07-21 06:23:19.37247+00	ce2cc619-0cb9-4992-81bc-b6e11032d207
3c9f358e-e2f5-439f-b894-a59d5382f27f	3c9f358e-e2f5-439f-b894-a59d5382f27f	{"sub": "3c9f358e-e2f5-439f-b894-a59d5382f27f", "email": "user3@user.com", "user_type": "user", "company_name": "업체3", "email_verified": false, "phone_verified": false}	email	2025-07-22 08:37:58.846748+00	2025-07-22 08:37:58.846811+00	2025-07-22 08:37:58.846811+00	389087d1-8bd4-4306-8b92-9bed910fc944
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
ae599e28-ad21-496c-917c-0701e914fedd	f19113ee-432b-4f29-9c20-15cfe4001376	2025-07-21 06:23:52.060838+00	2025-07-21 06:23:52.060838+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
37d3eefb-9ef4-44e1-83b1-6f3518691a72	5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:27:13.515046+00	2025-07-22 00:27:13.515046+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
f07d2b93-66dd-4811-ba73-0cc81fb34a99	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 05:51:17.322075+00	2025-07-22 07:24:26.99218+00	\N	aal1	\N	2025-07-22 07:24:26.992104	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
0c717ea8-d64e-49be-b29b-9ef81088fdfe	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 01:24:32.391207+00	2025-07-22 07:38:56.768314+00	\N	aal1	\N	2025-07-22 07:38:56.768234	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
57872ab4-dbf8-473e-99c1-d7354379a85b	5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:45:23.532706+00	2025-07-22 07:41:16.530459+00	\N	aal1	\N	2025-07-22 07:41:16.530383	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
7dca2786-048a-4cca-8de0-49094f07aca7	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 01:33:24.420959+00	2025-07-22 08:25:32.615493+00	\N	aal1	\N	2025-07-22 08:25:32.615422	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
d1099776-529b-42a2-b14b-93bd8af395a3	3c9f358e-e2f5-439f-b894-a59d5382f27f	2025-07-22 08:37:58.854142+00	2025-07-22 08:37:58.854142+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	1.214.163.196	\N
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
ae599e28-ad21-496c-917c-0701e914fedd	2025-07-21 06:23:52.062887+00	2025-07-21 06:23:52.062887+00	otp	f36e6df0-d0f6-4162-b84c-7e5f1abbbe25
37d3eefb-9ef4-44e1-83b1-6f3518691a72	2025-07-22 00:27:13.517838+00	2025-07-22 00:27:13.517838+00	password	5804ebfb-2d2b-4003-be04-0d3d4e2e94e1
57872ab4-dbf8-473e-99c1-d7354379a85b	2025-07-22 00:45:23.53461+00	2025-07-22 00:45:23.53461+00	password	6dee61d7-0127-45db-9ebb-f79435913d6e
0c717ea8-d64e-49be-b29b-9ef81088fdfe	2025-07-22 01:24:32.393233+00	2025-07-22 01:24:32.393233+00	password	4589cb20-cb6e-4265-973c-296a16f58c5b
7dca2786-048a-4cca-8de0-49094f07aca7	2025-07-22 01:33:24.42388+00	2025-07-22 01:33:24.42388+00	password	a11c30ac-04e9-4bd4-9797-36b3622f2d9c
f07d2b93-66dd-4811-ba73-0cc81fb34a99	2025-07-22 05:51:17.324883+00	2025-07-22 05:51:17.324883+00	password	0adda03d-506a-4a81-969f-a3f85d68a452
d1099776-529b-42a2-b14b-93bd8af395a3	2025-07-22 08:37:58.856908+00	2025-07-22 08:37:58.856908+00	password	4b94e559-c27f-4e3d-b6f2-f9dae8a5227a
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
1fe4c6bf-0815-48b9-9644-2cf8663d42ee	4b5f0681-6c32-4b1d-baaa-ebea2b79ee6c	confirmation_token	b289cd478248a57840f0f5e110750b0fdc0e458522464192b968d8ca	d1@123.com	2025-07-21 04:56:12.515228	2025-07-21 04:56:12.515228
fc103d35-eace-4f4b-bff0-4c1047d93289	843fefaf-fc91-45a4-a117-f1e1a19af93d	confirmation_token	6cc274f1e6f8cb1ce8d7ee571a14324b48652e5b0f2c6f13754b2cb6	sjchoi@twosun.com	2025-07-21 05:10:02.875136	2025-07-21 05:10:02.875136
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	17	rqepjfwvrwf5	f19113ee-432b-4f29-9c20-15cfe4001376	f	2025-07-21 06:23:52.061572+00	2025-07-21 06:23:52.061572+00	\N	ae599e28-ad21-496c-917c-0701e914fedd
00000000-0000-0000-0000-000000000000	26	xqozixw4tfdj	5f474ca1-75e5-4382-b6af-2d33abe54d31	f	2025-07-22 00:27:13.516162+00	2025-07-22 00:27:13.516162+00	\N	37d3eefb-9ef4-44e1-83b1-6f3518691a72
00000000-0000-0000-0000-000000000000	28	utvmng3royp5	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 00:45:23.53341+00	2025-07-22 01:50:11.002125+00	\N	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	33	vzkzu745vehy	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 01:24:32.391951+00	2025-07-22 02:22:41.272576+00	\N	0c717ea8-d64e-49be-b29b-9ef81088fdfe
00000000-0000-0000-0000-000000000000	34	7ivbzi2ex23f	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 01:33:24.422177+00	2025-07-22 02:31:31.981225+00	\N	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	35	44ajnqfus3jr	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 01:50:11.002845+00	2025-07-22 02:48:14.077478+00	utvmng3royp5	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	37	axkna5c73ryi	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 02:31:31.981929+00	2025-07-22 03:37:55.060472+00	7ivbzi2ex23f	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	38	rrse27ppkp7o	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 02:48:14.078156+00	2025-07-22 04:05:34.353957+00	44ajnqfus3jr	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	39	2o5xyyoomjgo	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 03:37:55.061151+00	2025-07-22 04:42:01.65924+00	axkna5c73ryi	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	40	usf7fuvegl6h	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 04:05:34.354673+00	2025-07-22 05:06:53.732685+00	rrse27ppkp7o	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	36	6fmtduybkiab	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 02:22:41.273238+00	2025-07-22 05:11:05.212723+00	vzkzu745vehy	0c717ea8-d64e-49be-b29b-9ef81088fdfe
00000000-0000-0000-0000-000000000000	41	cyj5aidhssqe	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 04:42:01.659959+00	2025-07-22 05:47:01.970928+00	2o5xyyoomjgo	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	42	p7be62ymxmcx	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 05:06:53.733422+00	2025-07-22 06:15:22.528565+00	usf7fuvegl6h	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	44	at4enoghj2ye	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 05:47:01.971615+00	2025-07-22 07:24:15.352604+00	cyj5aidhssqe	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	45	oagje2ynlrj5	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 05:51:17.323218+00	2025-07-22 07:24:26.990038+00	\N	f07d2b93-66dd-4811-ba73-0cc81fb34a99
00000000-0000-0000-0000-000000000000	48	aalcuighcukv	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	f	2025-07-22 07:24:26.990342+00	2025-07-22 07:24:26.990342+00	oagje2ynlrj5	f07d2b93-66dd-4811-ba73-0cc81fb34a99
00000000-0000-0000-0000-000000000000	43	zwvqvtgyw6yh	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 05:11:05.213399+00	2025-07-22 07:38:56.765239+00	6fmtduybkiab	0c717ea8-d64e-49be-b29b-9ef81088fdfe
00000000-0000-0000-0000-000000000000	49	f76x6lxbe2dq	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	f	2025-07-22 07:38:56.765897+00	2025-07-22 07:38:56.765897+00	zwvqvtgyw6yh	0c717ea8-d64e-49be-b29b-9ef81088fdfe
00000000-0000-0000-0000-000000000000	46	4cov6qwufkwh	5f474ca1-75e5-4382-b6af-2d33abe54d31	t	2025-07-22 06:15:22.529186+00	2025-07-22 07:41:16.527589+00	p7be62ymxmcx	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	50	a7enhwysuaqg	5f474ca1-75e5-4382-b6af-2d33abe54d31	f	2025-07-22 07:41:16.528203+00	2025-07-22 07:41:16.528203+00	4cov6qwufkwh	57872ab4-dbf8-473e-99c1-d7354379a85b
00000000-0000-0000-0000-000000000000	47	d75yfv35fsht	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	t	2025-07-22 07:24:15.353262+00	2025-07-22 08:25:32.612452+00	at4enoghj2ye	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	51	qfpbcb5vp35s	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	f	2025-07-22 08:25:32.613118+00	2025-07-22 08:25:32.613118+00	d75yfv35fsht	7dca2786-048a-4cca-8de0-49094f07aca7
00000000-0000-0000-0000-000000000000	52	muxzwojhgk4h	3c9f358e-e2f5-439f-b894-a59d5382f27f	f	2025-07-22 08:37:58.854981+00	2025-07-22 08:37:58.854981+00	\N	d1099776-529b-42a2-b14b-93bd8af395a3
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, client_code, name, business_registration_number, owner_name, address, remarks, status, created_at, updated_at) FROM stdin;
9		의료법인 춘혜의료재단 명지춘혜재활병원	108-82-08035	임진	서울특별시 영등포구 대림로 223, (대림동, 명지춘혜병원)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
10		에스앤유서울병원	157-92-00844	이상훈	서울특별시 강서구 공항대로 237, 에이스타워 마곡 3,4,5,6층 (마곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
11		바른길정형외과의원	279-96-01817	길경민	인천광역시 부평구 열우물로 75, 지하1층,지상2~5층 (십정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
12		중계퍼스트정형외과의원	546-95-01549	김태환	서울특별시 노원구 동일로 1308, 정안프라자 3층 (중계동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
13		서울삼성호매실요양병원	893-92-00275	서상혁	경기도 수원시 권선구 금곡로118번길 10, 일담타워 4~6층 (금곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
14		평택삼성요양병원	278-99-00757	하창영	경기도 평택시 비전2로 194, 소사벌 어반테라스 1동 5층~9층층 (비전동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
15		단샘의원	127-92-54640	장범순	경기도 양주시 고읍로 10, (고읍동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
16		삼성바른내과의원(길음)	337-90-01450	함철배	서울특별시 성북구 정릉로 364, 3층 (돈암동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
17		삼성바른내과의원(중계)	678-97-00365	유수현	서울특별시 노원구 한글비석로 270, 스카이타워 5층 (중계동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
18		삼성편한내과의원(상계)	590-92-01337	유동훈	서울특별시 노원구 동일로 1380, 상계동 국민은행 4층 (상계동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
19		서울연세의원(동대문)	457-95-01157	유태욱	서울특별시 동대문구 이문로 188, 2,3층 (이문동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
20		서울위(WE)편한내과의원	896-91-00883	양성욱	경기도 용인시 수지구 성복2로 92, 402호 (성복동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
21		성모속튼튼내과의원	150-93-00914	김지훈	경기도 포천시 소흘읍 봉솔로5길 27, 2층 202호		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
22		바른내과의원(의정부)	127-96-13948	조성철	경기도 의정부시 평화로 647, 미건메디컬프라자 109~114호, 204~205호 (의정부동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
23		양주삼성내과의원	212-91-99841	문수영	경기도 양주시 옥정로 214, 5층 502호 (옥정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
24		이병철내과의원	127-90-72741	이병철	경기도 양주시 고암길 306-77, (덕정동, 황금프라자 303호)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
25		한사랑의원	401-90-15274	오민환	서울특별시 동대문구 한천로 55, 2, 3 층 (답십리동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
26		한우식내과의원	564-92-01925	한우식	서울특별시 광진구 천호대로 517, 201,202호 (중곡동, 리마크빌 군자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
27		덕소엔비의원	132-27-40252	엄중호	경기도 남양주시 와부읍 덕소로 93, 5층 (희빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
28		갈매우리내과의원	753-96-00505	최지영	경기도 구리시 갈매순환로 7, 에이스프라자 3층 1호 (갈매동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
29		강내과의원	479-72-00014	강남용	경기도 남양주시 와부읍 덕소로 214, (와부읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
30		고척으뜸내과의원	174-98-01670	김영우	서울특별시 구로구 경인로43길 49, B동 201호 (고척동, 고척아이파크)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
31		더편한내과의원	521-20-01969	박준형	서울특별시 중랑구 상봉로 131, 2층 201-1호 (상봉동, 상봉 듀오트리스)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
32		부천조은내과의원	373-22-01160	이승호	경기도 부천시 소사구 경인로 511, 4층 일부호 (괴안동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
33		삼성맑은내과의원	221-93-32829	이재은	서울특별시 중구 퇴계로 385, 준타워 7층 (흥인동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
34		삼성바른내과의원(구로)	685-92-01713	정환석	서울특별시 구로구 가마산로 246, 대신빌딩 3층 (구로동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
35		삼성바른내과의원(창신)	667-99-00199	정은행	서울특별시 종로구 지봉로 37-1, 2층 (창신동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
36		삼성박내과의원	137-98-41329	박성범	경기도 용인시 수지구 성복2로 51, 데이파크 A동 302호 (성복동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
37		삼성베스트내과의원(동대문)	848-93-01591	이태영	서울특별시 동대문구 답십리로 9, 5층 (전농동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
38		삼성보스톤내과의원	647-40-00595	이경미	서울특별시 종로구 종로 261, 3,4,5층 (종로6가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
39		삼성탑내과의원(부천)	377-91-00645	신동석	경기도 부천시 원미구 길주로 183, 영라이프빌딩 701,501,502,505호 (중동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
40		삼성훈내과의원	132-92-73315	이방훈	경기도 구리시 체육관로80번길 9, 302호 (수택동, 씨앤씨빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
41		수유탑내과의원	326-93-01747	김홍제	서울특별시 강북구 도봉로 333, 정우빌딩 4층 (수유동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
42		연세도곡내과의원	641-96-01496	이제훈	경기도 남양주시 와부읍 덕소로 226, 골드타워 4층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
43		튼튼내과의원	369-93-00202	안태홍	서울특별시 종로구 종로 293, 5층 (창신동, 하나저축은행)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
44		건강그린내과의원	110-92-22927	김청호	서울특별시 은평구 연서로 216, (대조동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
45		다나아정형외과의원	444-96-01065	전보근	경기도 용인시 수지구 성복2로 92, 3층 301~2호 (성복동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
46		서울당신의내과의원	144-93-01577	안지현	서울특별시 성동구 아차산로7길 15-1, 제이제이빌딩 1~2층 (성수동2가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
47		덕은탑이비인후과의원	657-96-01512	박진우	경기도 고양시 덕양구 으뜸로 130, 위프라임트윈타워 305호~308호 (덕은동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
48		부천삼성정형외과의원	680-99-00891	박종현	경기도 부천시 원미구 부천로 108, (원미동, 참솔빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
49		서울바른세상병원	632-94-00164	김형식	서울특별시 금천구 시흥대로 421, (독산동, 건국빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
50		늘품위내과의원	632-90-00754	조현석	서울특별시 동대문구 답십리로 273, 한양빌딩 5층 (장안동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
51		서울아산류마최내과의원	287-92-01770	최원호	경기도 부천시 원미구 길주로 199, 굿모닝프라자 204,205,206호 (중동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
52		속속린내과의원	582-37-01230	이재혁	경기도 성남시 분당구 동판교로 61, 자유퍼스트프라자2 601, 602, 603호 (백현동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
53		연세우리내과의원	117-97-01312	문병섭	경기도 시흥시 배곧3로 86, 센터프라자2 3층 301호~302호 (배곧동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
54		의료법인서준의료재단예천권병원	228-82-02276	권규호	경상북도 예천군 예천읍 시장로 136, (예천읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
55		힘내라내과의원	204-93-46371	이혁	서울특별시 성동구 아차산로 113, 삼진빌딩 3층 301,302호 (성수동2가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
56		88신경외과의원	687-96-01191	장준원	서울특별시 영등포구 도림로 144, 88월드타워 4층 (대림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
57		굿모닝내과의원	210-90-99815	박해규	서울특별시 강북구 한천로105길 7, 2층 (번동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
58		현대병원(남양주)	132-22-76546	김부섭	경기도 남양주시 진접읍 봉현로 21, (진접읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
59		늘푸른정형외과의원	610-95-11576	김종구	경기도 군포시 금산로22번길 6, 태을빌딩 4층 401,402호 (금정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
60		의료법인성화의료재단대한병원	210-82-06271	홍원	서울특별시 강북구 도봉로 301, (수유동, 대한병원)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
61		드림메디임승길내과의원	354-90-00999	임승길	경기도 수원시 장안구 정조로 925, 2층 (영화동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
62		라파가정의학과의원	709-32-00748	신니엘	경기도 의정부시 비우로 110, 2층 (녹양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
63		명성의원	121-91-05241	박상욱	경기도 수원시 장안구 장안로125번길 3, (정자동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
64		삼성플러스내과의원	398-91-01879	권태진	경기도 안양시 동안구 흥안대로 524, 삼우프라자 3층 (관양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
65		서울류내과의원	370-52-00887	류현욱	서울특별시 강북구 한천로 1120, 영우빌딩 2층 (수유동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
66		서울원내과의원	899-91-01182	김기원	경기도 안양시 동안구 흥안대로 527, 스타타워빌딩 5층 (관양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
67		신윤수내과의원	639-92-00986	신윤수	경기도 용인시 처인구 금령로 30, 2층일부 3층 (김량장동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
68		신일병원	210-96-07113	유인협	서울특별시 강북구 덕릉로 73, (수유동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
69		역북참내과의원	176-99-00714	박상훈	경기도 용인시 처인구 명지로40번길 15-15, 3층 301~303호,4층 404호 (역북동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
70		좋은숨김휘정내과의원	559-93-00334	김휘정	경기도 군포시 산본로323번길 16-7, 8층 803호 (산본동, 롯데프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
71		이정헌이비인후과의원	162-91-02186	이정헌	경기도 군포시 산본로323번길 16-36, 삼정빌딩 301호 (산본동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
72		가양성모내과의원	122-95-16337	김보규	서울특별시 강서구 화곡로68길 3, 401호, 404~407호 (등촌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
73		가장편한내과의원	319-94-01649	김민정	서울특별시 동작구 상도로 247, 3층 (상도동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
74		강남바른내과의원	667-99-01413	박주한	서울특별시 강남구 선릉로 324, SH타워 4층 (대치동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
75		강남탑내과의원	422-94-01533	박주한	서울특별시 서초구 효령로 431, 서초동 청화오피스텔 2층 (서초동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
76		강동성모내과의원	601-98-77366	김경희	서울특별시 강동구 올림픽로 806, 2층 (암사동, 까사팔공육)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
77		강동세브란스내과의원	645-95-01792	강민석	서울특별시 강동구 성내로 19, (주)서경산업개발 2층 201,202호 (성내동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
78		고덕바른속내과의원	107-92-01659	이소정	서울특별시 강동구 고덕로 262, 고덕역 효성해링턴 타워 더퍼스트 203~208호 (명일동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
79		고덕성심소아청소년과의원	420-90-01349	고근혁	서울특별시 강동구 고덕로 380, 고덕아르테온아파트(상가2동) 2층 202호 (상일동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
80		마곡중앙내과의원	178-94-00942	이상혁	서울특별시 강서구 공항대로 168, 5층 511,512,513호 (마곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
81		문앤장내과의원	308-99-00927	문형일	서울특별시 강동구 고덕로 390, 고덕아르테온아파트(상가1동) 2층 209,211,212호 (상일제1동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
82		미래탑내과의원	818-91-01349	장주현	서울특별시 동작구 상도로 246, 더라함 2층 (상도동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
83		바른메디내과의원	185-97-01353	신인섭	서울특별시 강서구 공항대로 236, 5층 (마곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
84		부평탑내과의원	291-92-01901	이유창	인천광역시 부평구 시장로 48, 2층 204,205호 (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
85		삼성더건강내과의원	529-90-01796	김학수	서울특별시 강남구 선릉로 34, 4층 (개포동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
86		삼성드림내과의원	108-92-13968	박승식	서울특별시 동작구 만양로 5-1, 1층 101호 (상도동, 나동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
87		삼성바른내과의원(강서)	743-91-00556	송창석	서울특별시 강서구 강서로 231, 2층 209호 (화곡동, 우장산역 해링턴 타워)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
88		삼성바른내과의원(별내)	166-96-01559	윤민용	경기도 남양주시 별내중앙로 24, 이레타워 1동 403호 (별내동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
89		삼성본정형외과의원	739-98-01142	이승희	서울특별시 강동구 올림픽로 651, 예경빌딩 7층 (천호동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
90		서울삼성내과의원(영등포)	321-95-01178	민신영	서울특별시 영등포구 도림로 135, 7층 701호 (대림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
91		삼성탑내과의원(안양)	693-99-01367	김종호	경기도 안양시 동안구 시민대로 175, 동안프라자빌딩 701,702,703,704,708,709호 (비산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
92		삼성편한내과의원(강서)	840-99-01226	채현범	서울특별시 강서구 강서로 173, 터보빌딩 3층 (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
93		서울삼성내과의원(여주)	238-92-00221	이대성	경기도 여주시 세종로 18-1, 3층 (홍문동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
94		서울연합내과의원	132-92-48932	김기찬	경기도 남양주시 별내5로5번길 11, 302,303호 (별내동, 성산메디칼타워)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
95		성모척편한신경외과의원	841-94-00486	김형석	서울특별시 중랑구 면목로 305, 2층 (면목동, 성일빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
96		연세든든내과의원	483-94-00897	김재현	서울특별시 강서구 화곡로 152, CUBE152 2,4층 (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
97		연세위드내과의원	471-92-01604	이욱진	서울특별시 강서구 강서로 59, 4,5층 (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
98		위례탑내과의원	269-99-01257	남재형	경기도 성남시 수정구 위례광장로 310, 우성트램타워 A동 501,502호 (창곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
99		은평진내과의원	540-93-01270	엄유진	서울특별시 은평구 통일로 714, 2층 (불광동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
100		은평탑내과의원	152-99-01207	엄문용	서울특별시 은평구 은평로 116, 위산 일리온시티 2층 201호 (응암동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
101		은평플러스내과의원	560-98-01056	신재령	서울특별시 은평구 연서로 74, 보광빌딩 2층 (역촌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
102		이수리더스내과의원	774-97-01279	안계련	서울특별시 서초구 동작대로 114, (재)원불교 유문빌딩 3층 (방배동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
103		현대정형외과의원	132-91-12946	이휘재	경기도 남양주시 와부읍 덕소로97번길 9, 일신프라자 4층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
104		화도연합내과의원	201-98-68084	홍성훈	경기도 남양주시 화도읍 마석중앙로 51, 3층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
105		미소준내과의원	309-90-04976	이강원	경기도 하남시 미사강변중앙로 220, 우성미사타워 301호 (망월동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
106		프라임내과의원	781-91-02196	이윤수	경기도 군포시 군포로 522, 군포새마을금고 3층 (당동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
107		삼성편한내과의원(동대문)	446-93-01809	김선화	서울특별시 동대문구 휘경로 15, 5층 (이문동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
108		우성용1내과의원	147-91-01266	우성용	서울특별시 동작구 보라매로 110, 영등포농협 3층 (대방동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
109		김경년내과의원	403-90-32323	김경년	전북특별자치도 익산시 부송1로 81, 205호 (부송동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
110		구기선내과의원	403-90-53560	구기선	전북특별자치도 익산시 평동로 748, 2층 (동산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
111		건강플러스내과의원	403-90-60998	김종률	전북특별자치도 익산시 부송1로 47, (부송동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
112		이성호정형외과의원	403-90-22688	이성호	전북특별자치도 익산시 서동로 91, (마동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
113		예일소아청소년과의원	403-90-24838	박경배	전북특별자치도 익산시 무왕로 1089, 2층 (영등동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
114		형근영내과의원	401-90-37206	형근영	전북특별자치도 군산시 의료원로 159, 208호 (나운동, 신일에이상가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
115		제일탑내과의원	123-94-11658	김희식	전북특별자치도 익산시 하나로 434, 3층 (어양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
116		미소가정의학과의원	401-11-85402	서건민	전북특별자치도 군산시 칠성로 120, 2,4층 (산북동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
117		평화로운내과의원	402-91-26562	백현선	전북특별자치도 전주시 완산구 소대배기로 5, 2층 (평화동2가, 성가신협)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
118		복음연합내과의원	402-90-45956	김은화	전북특별자치도 전주시 완산구 당산로 96, (서신동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
119		삼성베스트내과의원	131-92-41256	박현식	인천광역시 부평구 길주로 643, 명윤빌딩 4층 (삼산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
120		서울드림내과의원	104-95-04338	이석영	인천광역시 부평구 부흥로 264, (부평동, 동아웰빙타운)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
121		서울조은내과의원	705-93-01810	주문진	경기도 부천시 원미구 길주로 111, 센타프라자 201,202,203,204호 (상동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
122		영종속시원내과의원	370-93-02078	박진웅	인천광역시 중구 하늘중앙로 197, 5층 501호 (중산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
123		우리가족의원	131-91-08584	조관호	인천광역시 남동구 논고개로 337, (도림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
124		자애내과의원	122-91-27568	김기영	인천광역시 부평구 부평대로 90, 여산빌딩 A동 602호 (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
125		장피부과의원	131-36-05292	장경훈	인천광역시 남동구 남동대로 892, 2층 3층일부호 (간석동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
126		전형식내과의원	122-96-11718	전형식	인천광역시 부평구 부평문화로 38, 202호 (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
127		퍼스트내과의원	316-93-00775	최병호	경기도 김포시 김포한강4로 525, 4층 (구래동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
128		간석굿모닝의원	131-91-48325	지세현	인천광역시 남동구 석산로169번길 17, (간석동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
129		김가정의원	121-91-55737	계원숙	인천광역시 미추홀구 독배로 431, (용현동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
130		김명주산부인과의원	122-91-24498	김명주	인천광역시 부평구 부평대로 9, (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
131		노내과의원	122-96-03071	노수환	인천광역시 부평구 부평문화로 100-1, (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
132		배이비인후과의원	122-96-06345	배규정	인천광역시 계양구 효서로 233-1, (작전동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
133		보람정형외과의원	122-90-74410	이상준	인천광역시 계양구 오조산로 3, 3,4층 (작전동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
134		서울메디의원	469-93-00900	김영주	인천광역시 계양구 계양대로 82, 2층 일부호 (작전동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
135		연세정내과의원	113-90-43553	정경섭	경기도 하남시 미사강변대로 228, 501호 (망월동, 미사메디프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
136		인천계양속편한내과의원	122-90-16351	윤형선	인천광역시 계양구 용종로 2, 202호,304호,305호 (계산동, 계산프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
137		인천한방병원	460-99-00749		인천광역시 서구 염곡로464번길 7, 성도메디피아 6~8층 (가정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
138		최기은정신건강의학과의원	137-96-02787	최기은	인천광역시 부평구 열우물로 21, (십정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
139		한양정형외과내과의원	113-90-16454	한희석	서울특별시 구로구 경인로 164, 대일빌딩 (오류동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
140		이경상내과의원	114-96-07590	이경상	서울특별시 서초구 방배로 125, 2층 (방배동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
141		삼성성인내과의원	132-90-39050	박창영	경기도 남양주시 와부읍 덕소로 93, 8층 (희빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
142		정기수내과의원	109-96-08729	정기수	서울특별시 강서구 화곡로 173, (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
143		삼성우리내과의원	120-90-60211	유광현	서울특별시 강남구 일원로 37, 하나은행 일원중앙 5층 1호 (일원동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
144		최호열내과의원	105-90-06241	최호렬	서울특별시 마포구 백범로 127, 2층 (염리동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
145		위앤장(We&Jang)공내과의원	117-96-03365	공현호	서울특별시 양천구 등촌로 214, (목동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
146		서울조인트내과의원	119-90-91091	이정찬	서울특별시 관악구 양녕로 46, 503호 (봉천동, 메카플러스)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
147		윤앤석내과의원	484-95-01315	석선아	서울특별시 도봉구 도당로13길 16, 301호, 402호 (방학동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
148		임내과의원	132-90-81863	임병훈	경기도 가평군 가평읍 연인1길 1, 2층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
149		해맑은신경과의원	356-94-00372	이정주	경기도 부천시 원미구 길주로 237, 중동메디칼 303호, 305호 (중동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
150		카모마일의원	428-64-00118	김동후	서울특별시 서초구 효령로74길 4, 4층 (서초동, 우담빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
151		서울내과의원	204-93-25075	곽경근	서울특별시 중랑구 공릉로2길 8-4, 2층 203~206호 (묵동, 칼튼테라스)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
152		이상구내과의원	209-90-78881	이상구	서울특별시 성북구 길음로9길 50, 상가동 128,129호 (길음동, 정릉길음9단지 래미안아파트)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
153		한빛내과	128-90-47075	박주일	서울특별시 용산구 효창원로93길 9, 한빛빌딩 1,3층 (효창동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
154		상동정형외과의원	130-91-97935	유청수	경기도 부천시 원미구 상동로 78, 101호 (상동, 상동 동양 파라곤)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
155		더바른성모정형외과의원	543-95-00707	배재호	서울특별시 영등포구 시흥대로 675, 삼성YJ그랜드빌딩 4층 (대림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
156		열린연세소아과의원	117-90-77211	황성욱	서울특별시 양천구 목동중앙북로 11, 2층 (목동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
157		이병진비뇨기과	109-12-86841	이병진	서울특별시 강서구 화곡로 176, (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
158		박석준성모내과의원	108-92-10302	박석준	서울특별시 영등포구 시흥대로 675, 2층 (대림동, 삼성YJ그랜드빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
159		에스엠씨요양병원	105-96-15456	이성원	서울특별시 마포구 월드컵북로 165, 지하1층~5층 (성산동, SMC)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
160		김산내과의원	292-23-00383	김산	경상남도 사천시 주공로 98, 산메디칼빌딩 (용강동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
161		서강의원	152-35-00278	이상훈	경기도 의정부시 추동로 9, 휴먼시티 3층 302호 (신곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
162		안산나래요양병원	153-92-01370	조현	경기도 안산시 단원구 선부광장1로 118, 삼아빌딩 B101, 201, 301, 401, 501호 (선부동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
163		연세실버케어의원	118-96-14128	손한별	경기도 남양주시 진접읍 해밀예당1로 220, 엠타워 608호		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
164		동래봉생병원	263-14-01761	정의화	부산광역시 동래구 안연로109번길 27, (안락동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
165		조한관의원	311-96-02838	조한관	충청남도 예산군 고덕면 고덕중앙로 45-4, (고덕면)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
166		이신내과의원	185-97-00975	이진호	부산광역시 부산진구 중앙대로 808, 금정빌딩 4층,5층 (전포동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
167		양내과의원	246-95-01300	양성우	부산광역시 북구 금곡대로303번길 36, 스페이스303 2층 201호 (화명동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
168		비에이치에스한서병원	617-82-05191	윤철수	부산광역시 수영구 수영로 615, (광안동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
169		춘해병원	602-82-00286	홍세희	부산광역시 부산진구 중앙대로 605, 지상1층~지상9층 (범천동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
170		재단법인천주교부산교구유지재단 메리놀병원	602-82-02227	손삼석	부산광역시 중구 중구로 121, (대청동4가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
171		김철우푸른내과의원	311-90-21643	김철우	충청남도 예산군 예산읍 예산로 247, 247		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
172		덕산의원	412-90-07037	김상철	충청남도 예산군 덕산면 덕산온천로 433, (덕산면)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
173		누가의원	134-90-98735	최두영	경기도 안산시 상록구 각골로 70, (본오동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
174		스타트요양병원	222-90-84839	김성겸	경기도 오산시 청학로 264, W-타워 3-8층 (수청동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
175		광명연세내과의원	130-90-41152	원종현	경기도 광명시 철산로 20, 4층 401호 (철산동, 야우리빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
176		삼성송영봉내과의원	436-93-01705	송영봉	경기도 김포시 김포한강8로 172, 3층 (마산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
177		의료법인백송의료재단 굿모닝병원	125-82-04280	이진수	경기도 평택시 중앙로 338, (합정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
178		인제대학교 해운대백병원	617-82-08373	백대욱	부산광역시 해운대구 해운대로 875, (좌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
179		인제대학교부산백병원	605-82-02148	백대욱	부산광역시 부산진구 복지로 75, 진사로83번길 75, 진사로83번길 81, 1층(일부), 3층 (개금동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
180		학교법인동의병원	605-82-04243	김인도	부산광역시 부산진구 양정로 62, 지상2ㆍ3ㆍ10층 각 일부/ 지하1ㆍ지상1ㆍ지상4~지상8층 전층 (양정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
181		의료법인 은성의료재단 좋은강안병원	617-82-06813	구자성	부산광역시 수영구 수영로 493, (남천동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
182		김용기내과의원	603-91-44085	김용기	부산광역시 서구 보수대로 7, 2,3,4층 (충무동1가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
183		원하트김동수내과의원	596-92-01766	김동수	부산광역시 부산진구 가야대로 494, 대도빌딩 6층 (개금동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
184		부산광역시의료원	607-82-05646	김휘택	부산광역시 연제구 월드컵대로 359, (거제동, 1동, 5동일부)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
185		학교법인 고려중앙학원 고려대학교의과대학부속병원(안암병원)	209-82-04249	김재호	서울특별시 성북구 고려대로 73, 고려대병원 (안암동5가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
186		삶신경과의원	509-96-03512	배대웅	경기도 화성시 동탄오산로 82, 401,402호 (오산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
187		고려대학교의과대학부속안산병원	134-82-00522	김재호	경기도 안산시 단원구 적금로 123, (고잔동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
188		참내과의원	132-92-63699	고영선	경기도 남양주시 화도읍 경춘로 1969-8, 3층, 4층 (송림빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
189		국군함평병원	410-83-00097	국군의무사령관	전라남도 함평군 해보면 신해로 1027, (해보면)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
190		명지성모병원	118-96-01695	허춘웅	서울특별시 영등포구 도림로 156, 명지성모병원 (대림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
191		창원파티마병원	608-82-01416	이일경	경상남도 창원시 의창구 창이대로 45-45, (명서동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
192		연세차내과의원	158-95-01361	차민욱	제주특별자치도 제주시 우평로 338, 4,5층 (외도일동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
193		동국대학교일산불교병원	128-82-08418	강환종	경기도 고양시 일산동구 동국로 27, (식사동, 동국대학교일산병원)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
194		중앙대학교광명병원	153-82-00538	이현순	경기도 광명시 덕안로 110, (일직동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
195		정내과의원	109-12-89173	정경헌	서울특별시 강서구 까치산로4길 3, 2층 (화곡동, 화성빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
196		이이비인후과	212-90-55939	이우섭	서울특별시 강동구 양재대로 1325, 둔촌메디컬센타 (성내동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
197		스마일소아청소년과의원	573-91-00506	이영섭	경기도 하남시 미사강변중앙로 220, 505호 (망월동, 우성미사타워)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
198		서울연합의원한의원	223-07-34999	류현수	경기도 성남시 중원구 광명로 355, 2층 (금광동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
199		새하늘이비인후과의원	210-91-31957	한정욱	서울특별시 노원구 동일로 1548, (상계동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
200		브이아이씨365병원	143-97-00947	신윤혜	경기도 파주시 책향기로 836, 3,4,5층 (와동동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
201		디엠씨성모의원	862-99-01599	연정훈	서울특별시 은평구 수색로 217, 상가동 1층 130~132,138~141호 (수색동, 디엠씨 자이1단지)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
202		한양성모의원	132-90-03076	손제문	경기도 남양주시 진건읍 사릉로 400, 1층, 2층 (노아쇼핑)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
203		청학의원	847-99-01663	김승혜	경기도 남양주시 별내면 청학로68번길 13, 2층 (삼화빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
204		서울의원	132-90-25240	홍순필	경기도 남양주시 진접읍 광릉내로 108, (진접읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
205		휴메디병원	822-98-01648	고지운	경기도 남양주시 진접읍 금강로1521번길 1, 2,3,4층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
206		세란연합의원	132-96-02176	임창섭	경기도 남양주시 퇴계원읍 퇴계원로 16, 202호 (세란빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
207		21세기연세의원	129-92-66273	전철환	경기도 성남시 분당구 성남대로 345, 7층 701~703호 (정자동, 정자역프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
208		현대의원	405-96-02642	최창석	전북특별자치도 김제시 사정거리3길 6, (요촌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
209		삼성메디칼의원	265-93-00346	이창중	경기도 김포시 김포한강9로76번길 37, 5층 (구래동, 경서프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
210		두리이비인후과(포천)	127-96-01103	김기섭	경기도 포천시 중앙로 125, (신읍동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
211		두리이비인후과(오창)	297-92-01516	국진호	충청북도 청주시 청원구 오창읍 중심상업로 31-4, 2층 (엔젤오메가빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
212		향남두리이비인후과의원	898-94-00783	홍현표	경기도 화성시 향남읍 상신하길로328번길 20, 301~304,401~403호		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
213		두리이비인후과(청주)	301-30-30495	황규성	충청북도 청주시 서원구 2순환로 1468, 2~4층 (죽림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
214		두리이비인후과(정왕)	606-92-01030	정명호	경기도 시흥시 정왕대로 220, 403,404호 (정왕동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
215		두리이비인후과(잠실)	122-91-59978	허경회	서울특별시 송파구 올림픽로37길 130, 파크리오 A동 303호,304호 (신천동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
216		두리이비인후과(산본)	123-91-81473	문준환	경기도 군포시 산본천로 43-6, 2층 (산본동, 한숲스포츠센터)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
217		두리이비인후과(오산)	124-92-52245	황수훈	경기도 오산시 경기대로 155, 신한프라자A 201,202호 (원동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
218		두리이비인후과(야탑)	283-97-01360	유지훈	경기도 성남시 중원구 양현로 409, 어반스퀘어 6층 603호 일부604~606호 (여수동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
219		레이크봄봄이비인후과의원	825-55-00433	임병우	경기도 화성시 동탄대로 181, A동 301~303호, 307~309호일부호, 226호 (송동, 동탄린스트라우스더레이크)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
220		두리이비인후과(천안)	312-29-57896	김은석	충청남도 천안시 서북구 쌍용1길 21, 2,3,4층 (쌍용동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
221		바른숨이비인후과	429-22-01764	노민호	충청북도 청주시 흥덕구 오송읍 오송생명7로 136, 501A,501B,502,503A,503B,504호		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
222		이진희정형외과의원	142-90-49477	이진희	경기도 용인시 기흥구 흥덕1로 101, (영덕동, 스타프라자 503호)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
223		유내과의원	508-90-40394	류형국	경상북도 안동시 단원로 120, 2층 (평화동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
224		속편한내과의원(동대문)	204-91-61932	김윤배	서울특별시 동대문구 고산자로 399, 1, 4, 5층 (용두동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
225		에이원이비인후과의원	227-96-04152	하륜	경기도 구리시 경춘로 219, 골든브릿지 8층 801호 (인창동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
226		광명속편한내과의원	140-90-77735	신성희	경기도 광명시 광명로 926, 2~3층 (광명동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
227		순천향대학교부속부천병원	130-82-12287	서교일	경기도 부천시 원미구 조마루로 170, 부흥로 173(1층일부) (중동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
228		이명호내과의원	226-90-35816	이명호	강원특별자치도 강릉시 솔올로5번길 40, 2층 (교동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
229		하와유치과의원	128-90-43079	유은경	경기도 남양주시 미금로 37-6, 202호 (다산동, 연성프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
230		(의)원천의료재단 중화한방병원	123-82-08164	안대종	경기도 안양시 만안구 관악대로 10, 중화한방병원 1~2층 (안양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
231		연세키즈소아청소년과의원	204-93-84088	최성열	서울특별시 동대문구 답십리로 130, (답십리동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
232		센텀정형외과의원	181-95-01551	김정철	인천광역시 남동구 논고개로 121, 에스닷몰 6층 (논현동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
233		삼성조은내과의원	123-92-11090	정재홍	경기도 군포시 금산로 109, 산본두성프라자 201~202호, 301~303호 (산본동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
234		삼성DMC정형외과의원	674-91-01604	고천석	경기도 고양시 덕양구 으뜸로 124, 드림코어 6층 603,604,605,606,607호 (덕은동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
235		서울건강내과의원	408-93-08362	최원제	서울특별시 광진구 자양로15길 51-1, 진덕빌딩 2층 (자양동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
236		연세윤내과의원	117-91-42795	윤상진	서울특별시 양천구 신정중앙로 103, 6층 (신정동, 담우빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
237		안산윤내과의원	218-90-19396	윤대웅	경기도 안산시 단원구 초지동로 35, 2층 (초지동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
238		혜화가정의원	208-90-05314	정승호	서울특별시 종로구 성균관로 34, 혜화가정의원 2층 (명륜1가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
239		서내과의원(대구)	503-96-08902	서영호	대구광역시 서구 달구벌대로 1883, (내당동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
240		익산제일병원	403-90-79537	유광렬	전북특별자치도 익산시 평동로 665, (인화동1가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
241		이재순내과의원	224-96-01985	이재순	강원특별자치도 원주시 원일로115번길 1, (일산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
242		밝은가정의원	471-98-02003	조승환	경기도 시흥시 삼미시장4길 8, 3층 (신천동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
243		드림키즈소아청소년과의원	412-93-18118	박상희	경기도 이천시 중리천로 76, 3층 (중리동, 라온펠리스)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
244		서울베스트의원(시흥)	110-93-73665	김아영	경기도 시흥시 정왕시장길 52, 정왕시장 202-1,203,204호 (정왕동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
245		고려원이비인후과의원	295-93-01759	정광진	서울특별시 강서구 양천로 72, 4층 (방화동, 해성빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
246		의료법인순의료재단효성성모의원	122-82-06445	곽은옥	인천광역시 계양구 마장로 549, 영진빌딩 4층 401,402호 (효성동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
247		365류내과의원	473-99-01818	류태현	부산광역시 부산진구 중앙대로 907, 5,6층 (양정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
248		서울의원(제주)	220-90-88751	한상준	제주특별자치도 제주시 구좌읍 구좌로 51, 1층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
249		서울특별시강서구보건소	109-83-03739	기관장	서울특별시 강서구 공항대로 561, (염창동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
250		김현우내과의원	205-90-04714	김현우	서울특별시 동대문구 전농로 124, 2층 (전농동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
251		서울삼성의원	127-92-99327	이진희	서울특별시 송파구 가락로 214, 2층 201호 (송파동, 창우빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
252		성북구보건소	209-83-00027	성북구청장	서울특별시 성북구 화랑로 63, (하월곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
253		영등포구보건소	107-83-02092	기관장	서울특별시 영등포구 당산로 123, (당산동3가, 영등포구청)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
254		이화웰봄소아청소년과의원	114-94-56554	이경신	인천광역시 연수구 인천타워대로54번길 13, 해승메디피아 2층 (송도동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
255		장덕기내과의원	622-96-01189	장덕기	경상남도 김해시 진영읍 여래로 21, (진영읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
256		장새로내과의원	796-95-01673	정한욱	경기도 성남시 중원구 금빛로 43, 401~405호 (금광동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
257		장앤전내과이비인후과의원	603-90-08874	장천기	경기도 성남시 분당구 내정로173번길 1, 5층 (수내동, 우리은행)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
258		연세준내과의원	870-96-00284	윤영준	서울특별시 영등포구 도림로48길 4, 4층 401호 (대림동, 대림스타빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
259		한길의원	113-15-79879	이경현	서울특별시 구로구 고척로21나길 18, 2층 (개봉동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
260		동산한방병원	750-92-00963	안승열	전라남도 담양군 담양읍 죽향대로 1203-0, (담양읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
261		구로연세의원	113-96-05129	고종영	서울특별시 구로구 구로중앙로 16, 2,3층 (구로동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
262		서울정형외과의원	625-90-01599	양현석	인천광역시 서구 염곡로 468, 드림타워 601호,7층,8층 (가정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
263		더블유의원	217-91-46223	윤성언	서울특별시 도봉구 도봉로 468, 흥일빌딩 3층 301호 (창동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
264		부평내과의원	122-96-09584	한기돈	인천광역시 부평구 부평대로 9, (부평동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
265		서울내과의원	127-90-66633	이규춘	경기도 양주시 회정로 114, (덕정동, 금강프라자 301호)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
266		강태영내과의원	306-96-05662	강태영	대전광역시 대덕구 대덕대로 1592, (석봉동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
267		사랑의병원	490-90-00636	이은석	서울특별시 관악구 남부순환로 1860, -1,1,3,4,5층 (봉천동, )		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
268		유운용내과의원	403-90-23940	유운용	전북특별자치도 김제시 서낭당길 3, (요촌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
269		참조은신내과의원	672-21-00120	신성남	전북특별자치도 전주시 덕진구 가련산로 5, 2층 202호 (덕진동2가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
270		코앤이비인후과의원	834-97-00460	오정현	대전광역시 유성구 배울1로 128, 용산써밋프라자 Ⅱ, 4층 403,404호 (용산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
271		정형진내과의원	212-94-72635	정형진	서울특별시 강동구 천호대로 1199, 3층 (길동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
272		고운봄신경과의원	611-97-01847	김고운	경기도 광명시 철산로 36, 양정타워 302호 (철산동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
273		별내참사랑의원	619-13-60419	이수현	경기도 남양주시 별내3로 318, 301호 (별내동, 리츠프라자 Ⅱ)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
274		유앤지의원	494-21-01854	김동욱	서울특별시 서대문구 증가로 129, 2층 (남가좌동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
275		을지의원	302-90-08419	이계선	대전광역시 서구 계백로1158번길 114, 2층 (가수원동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
276		주내과의원	132-91-43357	주현중	경기도 남양주시 퇴계원읍 퇴계원로 52, 다모아빌딩 3층 304,305호		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
277		태안군보건의료원	310-83-05282	태안군수	충청남도 태안군 태안읍 서해로 1952-16, (태안읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
278		태안군보건의료원	347-70-70020	태안군수	충청남도 태안군 태안읍 서해로 1952-16, (태안읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
279		영양군보건소	508-83-02387	영양군수	경상북도 영양군 영양읍 동서대로 82, (영양읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
280		의료법인명성의료재단영양병원	508-82-03808	이필산	경상북도 영양군 영양읍 동서대로 75, (영양읍)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
281		의료법인승도의료재단메트로요양병원	608-82-16170	손혁준	경상남도 창원시 마산회원구 3·15대로 597, (석전동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
282		메디플러스의원	629-72-00434	최민규	경기도 파주시 문산읍 문향로 93, 4층		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
283		바른병원	126-90-67435	채영호	경기도 이천시 경충대로 2543, 바른병원 (진리동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
284		아산소리이비인후과의원	789-52-00761	손현기	경기도 평택시 지제동삭2로 181-24, 201호 일부, 203호, 204호 (동삭동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
285		삼성탑가정의학과의원	602-94-05377	경문배	서울특별시 양천구 목동동로8길 23, 메리트윈 3층 301호 (신정동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
286		이민규내과의원	747-93-00421	이민규	서울특별시 송파구 새말로 125, 4층 403호 (문정동, 어은회관)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
287		서울삼성내과의원(동대문)	892-91-01575	정호중	서울특별시 동대문구 사가정로 80, 답십리 뉴타운 카운티 에비뉴 4층 (답십리동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
288		미래셀의원	117-98-71964	장용준	서울특별시 영등포구 양평로 133, 5,6,9층 (양평동5가)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
289		골든정형외과의원	204-93-89384	이승용	서울특별시 영등포구 도림로48길 4, 대림스타빌딩 2,3층 (대림동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
290		강북으뜸병원	651-97-00905	김태완	서울특별시 강북구 도봉로 187, 지하1층, 지상1층~지상5층 (미아동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
291		강남고려병원	112-96-00500	김병욱	서울특별시 관악구 관악로 242, (봉천동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
292		강남성모내과의원	108-90-83228	한상국	서울특별시 동작구 동작대로 89, 골든시네마타워 6층 602-1호 (사당동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
293		코튼이비인후과의원	473-12-03023	조형준	서울특별시 영등포구 신풍로 28, 에코동 2층 201~206호 (신길동, 비스타동원)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
294		삼성나은내과의원	453-97-01687	신수린	경기도 구리시 경춘로 223, 명동빌딩 404,405호 (인창동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
295		아미랑의원	696-14-01942	김선만	경기도 수원시 장안구 경수대로1044번길 4, 2,3,4,5층 (파장동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
296		연세의원(남양주)	132-90-66649	이승철	경기도 남양주시 평내로29번길 49, 304호 (평내동, 엠2프라자)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
297		연세의원(강서)	130-96-05783	김금전	서울특별시 강서구 화곡로 197, 1,2층 (화곡동)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
298		정내과의원(군포)	123-91-35023	정철헌	경기도 군포시 금산로22번길 6, 2층 (금정동, 태을빌딩)		active	2025-07-21 06:03:56.284904+00	2025-07-21 06:03:56.284904+00
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, user_id, company_name, business_registration_number, representative_name, business_address, landline_phone, contact_person_name, mobile_phone, mobile_phone_2, email, default_commission_grade, remarks, approval_status, status, created_at, updated_at, user_type, company_group, assigned_pharmacist_contact, receive_email, created_by, approved_at, updated_by) FROM stdin;
385e49aa-d016-4c94-a621-9a20dc41fdc5	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	투썬제약	777-77-77777	투대표	경기도 성남시 판교역로 221	\N	김팜플	010-7777-7777	\N	admin@admin.com	A	\N	approved	active	2025-07-21 05:12:06.435316+00	2025-07-21 05:12:06.435316+00	admin	\N	\N	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-21 05:12:06.435316+00	\N
705eaed7-a1c5-468e-80d8-f4a983cbd60b	db493775-9caa-4401-9277-d9c046f0e6a3	tt1	1988082412	문주영	한국	\N	MJ	010-531-4152	\N	tt1@tt.com	A	\N	approved	active	2025-07-21 06:21:07.998332+00	2025-07-21 06:21:15.683+00	user	\N	\N	\N	db493775-9caa-4401-9277-d9c046f0e6a3	2025-07-21 06:21:15.684+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a
11f63abd-1f3b-4a8e-a7ad-ea47192339e1	f19113ee-432b-4f29-9c20-15cfe4001376	ediide	9482391938	educ	tirepro	\N	iteacher	01000230001	\N	moonmvp@twosun.com	A	\N	pending	active	2025-07-21 06:23:19.447355+00	2025-07-21 08:53:49.095+00	user	\N	\N	\N	f19113ee-432b-4f29-9c20-15cfe4001376	2025-07-21 06:23:37.624+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a
32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	5f474ca1-75e5-4382-b6af-2d33abe54d31	업체1	100-10-10000	일길동	서울시 일구 일동 111-11		담당당	010-1000-1000		user1@user.com	A		approved	active	2025-07-21 05:11:05.892047+00	2025-07-22 00:50:28.492+00	user				5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-21 05:33:42.29+00	5f474ca1-75e5-4382-b6af-2d33abe54d31
3332cfbd-b161-491b-bee6-b7b537c7cf1a	1d3ce10a-a53a-4f92-827d-8af539a4450c	업체2	200-20-20000	이길동	서울시 이구 이동 222-22		담당	010-1111-1111		user2@user.com	B		approved	active	2025-07-21 05:34:23.694259+00	2025-07-22 03:45:10.197+00	user				1d3ce10a-a53a-4f92-827d-8af539a4450c	2025-07-21 06:00:40.958+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a
\.


--
-- Data for Name: client_company_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_company_assignments (id, client_id, company_id, created_at, company_default_commission_grade, modified_commission_grade) FROM stdin;
20	10	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-07-21 08:42:08.20554+00	A	\N
22	11	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-07-21 08:54:30.87099+00	A	\N
23	12	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-07-21 08:54:34.540807+00	A	B
25	9	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-07-21 10:52:37.99412+00	A	\N
26	13	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-07-22 05:14:54.483223+00	A	\N
24	11	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-07-21 08:54:37.003064+00	A	A
27	14	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-07-22 05:47:39.969151+00	A	\N
28	15	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-07-22 05:51:36.510026+00	A	\N
29	16	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-07-22 06:12:21.22158+00	A	\N
30	17	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-07-22 08:13:48.779491+00	A	\N
\.


--
-- Data for Name: pharmacies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pharmacies (id, pharmacy_code, name, business_registration_number, address, remarks, status, created_at, updated_at) FROM stdin;
8		시티프라자약국	131-29-56323			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
9		센트럴시티약국	311-74-00575			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
10		가정약국	769-03-01583			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
11		성수오렌지약국	206-25-54960			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
12		메디팜보배약국	218-07-03664			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
13		덕은온누리약국	642-18-01846			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
14		참솔온누리약국	509-22-12306			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
15		삼성맑은내과의원(중구)	221-93-32829	서울특별시 중구 퇴계로 385, 준타워 7층 (흥인동)		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
16		7층은약국	670-13-02296			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
17		타워약국	620-65-00540			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
18		굿모닝약국	620-03-25669			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
19		메디칼온누리약국	659-27-00610			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
20		더존약국	139-03-15888			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
21		바우약국	406-43-00281			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
22		배곧다온약국	205-55-24475			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
23		배곧정문약국	422-15-00242			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
24		의료법인서준의료재단예천권병원	228-82-02276			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
25		수정온누리약국	504-15-40037			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
26		메디팜인제약국	512-04-84312			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
27		든든약국	751-68-00559			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
28		행복이열리는건강약국	206-17-81517			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
29		원미쎈타약국	130-25-58261			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
30		나은누리약국	108-37-51610			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
31		정화약국	132-05-66148			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
32		더푸른약국	243-04-02786			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
33		정다운약국	222-53-00310			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
34		태광약국	611-03-29657			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
35		데이파크약국	129-33-18546			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
36		이레약국	780-23-00842			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
37		해양약국	136-53-00945			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
38		김약국	132-07-34790			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
39		한중약국	108-20-14150			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
40		참바로약국	206-17-27100			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
41		연주약국	146-08-01320			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
42		한사랑약국	360-09-02714			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
43		으뜸약국	616-32-01178			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
44		장현대학약국	132-17-35726			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
45		정문약국	243-24-01432			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
46		굿모닝건강약국	123-20-40021			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
47		대한병원	210-82-06271			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
48		우리대한약국	238-06-01057			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
49		라라온누리약국	208-07-78208			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
50		로뎀약국	357-07-01660			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
51		수성약국	424-15-02061			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
52		희망온누리약국	604-24-61862			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
53		동인약국	135-23-99225			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
54		플러스약국	298-34-01218			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
55		왕약국	138-04-69694			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
56		샘깊은약국	119-01-58837			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
57		삼성약국	886-10-01718			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
58		서울드림약국	589-13-02480			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
59		대림미소약국	863-01-01839			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
60		온누리대광약국	109-01-69472			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
61		4층약국	714-66-00589			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
62		선한약국	652-01-01995			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
63		민약국	138-03-44721			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
64		다나약국	729-29-00742			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
65		밀알약국	210-13-88092			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
66		신일병원	210-96-07113			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
67		함박약국	445-08-02702			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
68		꿈빛온누리약국	464-06-01092			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
69		금정당약국	877-15-00874			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
70		하박사약국	697-79-00061			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
71		신진약국	123-32-87091			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
72		리본약국	333-56-00396			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
73		바다약국	835-02-01243			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
74		솔약국	408-22-66945			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
75		군포종합약국	503-37-12452			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
76		조은약국	521-55-00472			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
77		다온약국	731-26-00797			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
78		뉴그랜드약국	206-16-57742			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
79		서진약국	118-01-81922			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
80		옥광약국	113-12-43593			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
81		엄마약국	118-05-28134			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
82		의료법인 춘혜의료재단 명지춘혜재활병원	108-82-08035			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
83		밸런스약국	820-48-00537			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
84		마음약국	726-75-00416			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
85		새하늘약국	416-05-90925			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
86		서울삼성호매실요양병원	893-92-00275			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
87		백약국	285-30-01951			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
88		평택삼성요양병원	278-99-00757			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
89		민들레약국	662-36-00656			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
90		메디칼우리약국	458-15-01838			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
91		메디칼수정약국	134-15-46230			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
92		사랑약국	210-04-45451			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
93		하늘약국	205-55-64079			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
94		샘약국	868-16-00955			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
95		보룡약국	569-74-00437			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
96		참말로친절한약국	501-28-79756			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
97		다모아약국	217-16-21225			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
98		노원하나약국	342-33-01293			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
99		아름다운온누리약국	867-36-01454			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
100		행복한정약국	118-33-01496			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
101		혜중약국	880-14-02338			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
102		기린약국	854-55-00504			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
103		송우늘푸른약국	127-42-33000			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
104		미건메디컬약국	216-40-21436			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
105		길약국	127-25-23524			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
106		나무약국	812-17-02151			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
107		프라자약국	131-18-81355			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
108		행복한약국	504-42-00477			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
109		메디팜동아약국	218-22-08527			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
110		군자여기약국	444-01-03709			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
111		푸른온누리약국	206-15-38831			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
112		보원약국	132-10-27436			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
113		와부약국	132-05-62502			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
114		은혜온누리약국	117-09-81435			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
115		온누리좋은약국	113-19-46395			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
116		바다보다 넓은약국	129-40-01572			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
117		정수메디컬약국	860-77-00156			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
118		미사약국	670-44-00953			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
119		365약국	537-66-00231			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
120		시티약국	186-25-01005			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
121		씨엘약국	230-20-01796			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
122		상봉도담약국	858-07-02880			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
123		하늘약국	201-10-44954			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
124		대해약국	105-14-72937			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
125		맑은샘약국	401-15-43486			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
126		수인약국	713-21-01769			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
127		다나을약국	399-22-01143			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
128		7번약국	427-15-01004			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
129		다나약국	132-19-48583			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
130		카이로약국	123-12-96893			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
131		메디칼3층약국	132-01-91111			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
132		평내약국	850-26-01495			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
133		참빛약국	204-03-67884			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
134		또봄약국	650-20-01762			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
135		종로온누리약국	311-34-32542			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
136		건강약국	108-20-96768			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
137		오리약국	789-05-02673			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
138		사랑약국	132-11-24076			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
139		덕소메디칼약국	436-78-00168			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
140		보성약국	726-02-02860			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
141		혜인온누리약국	322-18-01393			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
142		봄날약국	510-21-66635			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
143		민중약국	208-32-21686			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
144		하얀약국	637-18-02085			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
145		맘온누리약국(전문)	276-63-00432			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
146		마곡스타약국(전문)	216-07-69812			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
147		세란온누리약국	624-52-00504			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
148		여주사랑약국	360-68-00237			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
149		이안온누리약국	204-26-34209			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
150		참약사플러스약국	466-11-02465			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
151		홍약국	208-61-00041			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
152		365밝은약국	503-09-38968			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
153		건강밝은약국	110-18-70884			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
154		수민약국	109-51-37636			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
155		가양하늘약국	177-03-02371			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
156		성모약국	108-18-46794			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
157		강남백년가약국	404-28-01296			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
158		강동천사약국	694-47-00794			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
159		새힘약국	460-04-02682			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
160		두루미약국(전문)	163-21-01265			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
161		새빛약국	222-10-23581			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
162		고덕하나약국	212-24-97098			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
163		고덕경희온누리약국	804-04-02432			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
164		코끼리약국	279-44-00857			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
165		봄날약국	201-22-93079			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
166		상일약국	808-08-02937			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
167		모주현약국	653-15-01151			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
168		메디슨약국	684-46-01144			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
169		스마일약국	212-21-55817			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
170		송약국(전문)	148-19-01337			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
171		민들레약국(마곡)	288-38-00883			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
172		가장큰이대약국	690-76-00190			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
173		코리아약국	672-16-02065			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
174		개포플러스약국	209-07-42095			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
175		이룸약국	720-77-00498			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
176		별빛약국	354-27-01015			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
177		비타민약국	556-32-01371			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
178		정감약국	396-07-02311			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
179		소원약국	226-20-51701			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
180		연세약국	134-22-00154			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
181		대생약국	109-37-02316			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
182		시민약국	132-26-82992			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
183		소망약국	509-17-02575			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
184		엔젤약국	678-02-01510			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
185		다정한약국	731-12-02027			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
186		위례중앙약국	260-59-00541			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
187		위례다나약국	293-19-00278			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
188		365열린큰약국	331-25-01094			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
189		다모아약국	798-37-01062			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
190		불광우리들약국	124-41-28364			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
191		은평스타약국(일반)	827-52-00516			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
192		원약국	110-20-74850			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
193		은평마리약국	709-65-00367			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
194		곰약국	660-64-00217			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
195		참진약국	824-07-01480			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
196		방배세명약국	526-06-01463			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
197		방배대한약국	113-10-84057			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
198		행복한온누리약국	869-24-00875			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
199		바로약국	809-07-03096			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
200		맑은온누리약국	227-53-00479			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
201		문정수약국	256-32-01035			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
202		중의당약국	437-27-01775			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
203		엄마약국	204-01-35296			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
204		선유도온누리약국	592-02-02291			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
205		행복약국	371-03-00053			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
206		행운약국	685-41-00901			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
207		웰빙약국	210-01-59255			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
208		강북김약국	289-28-00738			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
209		다나온누리약국	112-07-45347			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
210		동보당약국	331-05-02722			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
211		제중당건강약국	108-18-46509			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
212		골드약국	108-15-23145			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
213		우리마음약국	337-19-02557			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
214		코리아약국	423-43-01266			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
215		태양약국	256-42-01261			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
216		구리탄탄약국	399-07-02800			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
217		아미랑의원	696-14-01942			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
218		좋은약국	403-15-12674			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
219		건강이열리는약국	403-04-40698			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
220		슈바이쳐약국	687-52-00878			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
221		밝은약국	403-11-31673			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
222		보람약국	403-08-25996			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
223		광종합약국	403-08-48719			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
224		범생종합약국	403-01-90746			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
225		광제약국	403-06-41556			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
226		내가본약국	409-01-73196			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
227		백화점약국	305-19-69319			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
228		은파약국	491-38-01116			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
229		다정한약국	291-21-00601			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
230		제일종합약국	148-10-01616			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
231		익산고려종합약국	403-05-36283			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
232		하나로약국	403-07-58262			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
233		군산진약국	325-34-00506			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
234		건강한약국	402-15-46832			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
235		온심약국	418-07-90115			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
236		소망약국	418-12-03614			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
237		평화프라자약국	527-05-02245			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
238		완산종로약국	575-08-01853			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
239		서신종로약국	402-20-30412			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
240		종로프라자약국	117-13-69307			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
241		서신태평양약국	402-22-84270			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
242		서신이마트약국	577-02-00542			active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
243		대학약국	793-41-00648	서울특별시 강서구 화곡로 152, CUBE152 2,4층 (화곡동)		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
244		나나약국	321-20-02223	경기도 하남시 미사강변대로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
245		미사보룡약국	455-39-01193	경기도 하남시 미사강변대로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
246		명가한약국	703-90-00342	경기도 하남시 미사강변대로226번길		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
247		종로밝은약국	294-78-00429	서울특별시 종로구 종로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
248		종로세란약국	201-09-21066	서울특별시 종로구 종로41길		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
249		바른약국(동대문)	147-56-00529	서울특별시 동대문구 사가정로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
250		녹십자약국	127-09-31946	서울특별시 영등포구 대림로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
251		삼정약국	312-17-36694	경기도 군포시 산본로323번길		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
252		역곡큰약국	840-29-00786	경기도 부천시 소사구 경인로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
253		우정약국	121-05-59685	경기도 부천시 소사구  경인로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
254		안약국	123-37-04208	경기도 부천시 소사구 경인로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
255		봄약국	132-23-42441	서울특별시 종로구 지봉로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
256		연신내로데오약국	548-34-01675	서울특별시 은평구 연서로		active	2025-07-21 06:05:14.157353+00	2025-07-21 06:05:14.157353+00
\.


--
-- Data for Name: client_pharmacy_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_pharmacy_assignments (id, client_id, pharmacy_id, created_at) FROM stdin;
\.


--
-- Data for Name: direct_sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.direct_sales (id, pharmacy_code, pharmacy_name, business_registration_number, address, standard_code, product_name, sales_amount, sales_date, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: notices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notices (id, title, content, is_pinned, view_count, author_id, created_at, updated_at, file_url, links) FROM stdin;
aedde07b-67c8-48a6-8cb7-8f38ab7dd23d	🔔 [필수] 시스템 점검 안내	정기 시스템 점검이 예정되어 있습니다.\n\n일시: 2025년 1월 15일 02:00~04:00\n내용: 데이터베이스 최적화 및 보안 업데이트\n점검 시간 중에는 시스템 접속이 일시적으로 제한될 수 있습니다.	t	25	\N	2025-07-21 03:56:53.292732+00	2025-07-21 03:56:53.292732+00	[]	\N
60b72ffa-7c67-44f6-9d52-b625811f67a0	📊 실적 입력 방법 안내	새로운 실적 입력 방법에 대해 안내드립니다.\n\n1. 월별 실적 입력 시 정확한 처방전 수량 확인\n2. 증빙서류 첨부 필수\n3. 검수 완료 후 정산 진행\n\n문의사항은 고객지원팀으로 연락 바랍니다.	f	48	\N	2025-07-21 03:56:53.292732+00	2025-07-21 03:56:53.292732+00	[]	\N
8073b781-1203-4997-984c-51c9c3a23bba	🆕 새로운 제품 등록 안내	2025년 1월 신규 제품이 등록되었습니다.\n\n네오민정 Plus 100mg\n헬스케어캡슐 50mg\n바이탈정 75mg\n\n자세한 제품 정보는 제품 목록에서 확인하세요.	f	15	\N	2025-07-21 03:56:53.292732+00	2025-07-21 03:56:53.292732+00	[]	\N
4310a046-5145-41ca-a3bf-cfc676d6652d	💰 1월 정산 일정 공지	1월 정산 관련 일정을 안내드립니다.\n\n실적 마감: 1월 31일 18:00\n검수 기간: 2월 1일~5일\n정산 완료: 2월 10일 예정\n\n정확한 실적 입력 부탁드립니다.	f	32	\N	2025-07-21 03:56:53.292732+00	2025-07-21 03:56:53.292732+00	[]	\N
\.


--
-- Data for Name: performance_evidence_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.performance_evidence_files (id, company_id, client_id, settlement_month, file_name, file_path, file_size, uploaded_by, uploaded_at, created_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, product_name, insurance_code, price, commission_rate_a, commission_rate_b, commission_rate_c, standard_code, unit_packaging_desc, unit_quantity, remarks, status, created_at, updated_at, base_month) FROM stdin;
d4736eda-bb81-4887-a712-8d0c74b92a54	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
566e0312-d565-4cf3-ac24-caac744ea366	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063713	8정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1a1085f9-0ba0-4438-9c94-b66e28f2bd97	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047218	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4204d94f-f4f6-4cfd-b375-338bfbcb9cab	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1169bc4c-e1c6-4145-9c7b-5a7ab744ceb2	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013428	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
baa541b4-fa88-453d-ab32-7004b74a0d38	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063058	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
40748d73-d90c-4a3e-87cb-8f16c764d70b	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027548	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b3a1cded-700d-433c-b029-bc86bcf2802e	에페릭스정	653802110	115	0.35	0.38	0	8806538021126	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
43d69d6f-dc00-4b1f-a98b-05d86cd850e6	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062815	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
691df8fd-0b38-4485-8a96-2524edb3872c	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046914	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
eb808b4c-211f-4236-83af-a468c26ebbab	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058320	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7de10a3a-bd21-46bd-a52d-5a1105f1eb83	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011431	500캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d2252112-f8c6-43e5-bf98-130fc07dccde	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062501	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f846a709-2398-4dc3-9e75-8ddc45946b03	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044101	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
dbce7f61-0642-4cec-be89-389cdd859a89	맥스케어액트정	653805970	275	0.1	0	0	8806538059716	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
545c57ba-598f-40ef-9800-dbf7f7bdecfb	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013404	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1f23ad0c-46ce-4edb-8b9e-a8a6098cf0cf	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021638	100캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
04018bba-7521-41df-924c-580565e1d645	레보라정 25mg	653800330	119	0	0	0	8806538003306		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cdf55baa-4286-4b74-b6d7-92ad2b0d6471	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062853	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
369948a6-d9e9-402d-a96e-4549e75e9396	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063041	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e23be0ad-142c-45ca-9336-66984972161a	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053608	(소분)	120		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
348ec399-1256-4f52-a868-f0961cb49f33	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017617	30캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f3b46afd-4777-4787-a2b3-82f108c49361	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010908	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7c4e39c3-9c5d-4fb5-9ac2-50c57f94c096	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061627	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e43e8575-3bfb-411b-95cc-d1b171a1178e	스티모린에스크림	653800890	4180	0.4	0	0	8806538060019		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f19a84a2-a519-4864-bfad-ac8238c07a3a	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034607	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a4ec0b4a-df2e-4494-99df-e35fa3cd7156	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
17f822b2-d29e-4844-9b1b-0524d40c2dc9	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011080		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
78226754-c441-4616-9546-365d88ee08fe	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027524	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c19afece-b14a-4846-870c-bea76a599075	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062600	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
112171a9-283c-481c-9d00-2ab3d0992736	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1e627823-acf6-4ebd-96b2-2e9a07068422	메코민캡슐	653800570	50	0.1	0	0	8806538005751	180캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
060a9199-a8a2-4b10-b0bb-b6bf7bc31530	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010915	10정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
503aa11e-3927-4395-ad28-056c79b6b4a5	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062020	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9b27c752-7553-4f2a-ac88-9d6b87defcbf	엑세트라정	653802140	162	0.4	0.4	0	8806538021430	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ff3c3115-9ade-4c26-a668-f992e6548a59	신일세티리진정	653801190	161	0.4	0.45	0	8806538011950	500정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5bfe861c-a398-4274-8377-457768363b90	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003665	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e1f0aba1-b9e4-48b5-8cef-e176c5152fb9	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013800	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
76adff86-e52e-41ba-b3d3-3236c4382997	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062716	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e3a74382-b81b-4f37-8a7d-90f1abb71871	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a29f69dc-2ea1-4fb9-88f1-6054d45e7212	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062945	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7aa6a601-fb96-4496-abdb-608674245630	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062723	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
590e3b60-6094-48d7-b833-2e74d251ca96	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
047a8ffd-b015-4f5e-812f-125dace54e4e	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051000	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
033bac49-3818-492a-8e4f-4a5657556b02	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013411	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9dc9621c-d46d-4fb6-b943-500a2d7f6bf3	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061900	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d238c4ef-baf2-452a-a6f5-46bdef112593	신일피리독신정 50mg	653801720	23	0	0	0	8806538017204		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7175fe22-4fc4-401c-b4cb-902287176710	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058115	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7e8797a0-ca35-419c-8014-554809a1afaa	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021607	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
68387d25-3d1a-4ffa-892a-74b671f1ac3f	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013626		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
573bb3c5-f0a5-4914-bc9c-e2ea64104ba1	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052922	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4c062fb7-d742-4fab-b6b4-33daf4a89c5a	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057323	100캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3d3ed7bf-3aee-400b-9014-790613a850d9	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
27aa35c5-458b-4a0f-a834-01259e2cb99c	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044132	90정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de2fe7f0-da54-44a6-9dd8-1da5d6d16f37	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047225	60캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3578f81e-2f31-4016-97ee-c2f809fac2c5	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050157		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7a8a283d-a4c8-490b-afd0-fe2d2c5b0423	신일엠정 500mg	653801400	22	0	0	0	8806538014029		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
55ebf10c-bcdc-459c-89f2-e4036a03e1b3	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012131	100캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a13a10af-8851-4d14-bead-c9e21efbeb11	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062839	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fda6bca1-d2ee-4a88-8cf0-9ff2081eef08	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011400	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c2a2c716-d0f5-419a-b6d8-2129fbef3270	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060316	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f362085d-85cd-4145-9e5a-ce776bc09143	맥스케어알파정	653804520	277	0.05	0	0	8806538045214	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
169aa90f-fad5-45cf-971e-745b29b77e06	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017655	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c26fa940-a4ca-47d3-914a-34c9a1eb3fd4	디누보패취10	653804860	1586	0.3	0.3	0	8806538048611	1매/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
96c32131-be1d-43cd-b9fd-d65f8384d8a1	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004426	100캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8442b133-7340-4970-a9ee-93da60717e60	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052526	100캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5ae19d6c-8734-4372-b148-38d7e429fb7d	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010984	90정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
da850b86-b512-4d9c-a28a-19d8889eb90b	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054520	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
12027a14-4d84-4165-b2d1-5c730bdde360	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061610	28정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
26639e8d-95b5-415a-9e62-c29de5ea01b4	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062136	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
dd24988a-9277-446c-818b-2e525980a98b	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048826	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e51b0ebe-330d-4ec7-befa-bc2a6614046c	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017600	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
17a4ed09-c624-48f2-bd5c-ca553286e332	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012148	500캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2641f137-247c-4504-9212-3078cbf007e9	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011455	100캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a682476f-f373-42f8-b4b5-b085d674c754	레보트로서방정	653805950	189	0.35	0.3	0	8806538059525	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2c80139f-56aa-49ce-bcf7-7a370f89e58c	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053301	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0ee336c4-9b46-4375-b75b-809ad68c7983	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1d4f717c-344b-485d-bc86-538885597cf8	테노브이정	653805260	2505	0.45	0.47	0	8806538052601	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
44fa384e-396e-4481-b728-e38252f8e9c1	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062518	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b63513f8-b59b-4c6d-94f1-477b4c660197	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062549	90정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1fa8ecb8-cf49-4ae1-8ee8-c20c492bc9af	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1f2abd97-0e51-4ba0-b932-39c323d644d9	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
63b04024-7f6a-492f-9863-bfa651f03492	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062822	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de3318b7-9a12-4c7b-9ab1-dbcc5e050210	레보원정	055100040	114	0.2	0.25	0	8800551000410	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
30603f34-6893-4782-8775-b57d45210205	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009025	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
74d784ee-ef01-44b0-a70b-9d539fe5d2ab	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9579203c-9234-43a9-9784-0b0e22238286	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053417	30정/PTP	100		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
22036545-5b78-45be-b97f-e9feca53c827	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003214	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
67c29926-182e-46b7-9b9a-53cae829e076	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061825	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a726de0f-86ae-46c7-85a7-cb25336dbc11	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012100	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b447b515-055f-4596-81b8-8298e253c31e	악세푸정	653801970	637	0.3	0.3	0	8806538019758	50정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fa9534d0-bb2c-4c9d-a8d6-2dc6714bea52	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061313	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
754df423-c134-4d2f-ada8-e4e7b8333953	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059006	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4ef1532f-b4ca-4ca8-bef1-1fbe1327501d	에티브정	653805240	480	0.33	0.3	0	8806538052403	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
84caa573-5922-4b9e-9ff9-9fd1991bf166	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010946	1000정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
535ab13b-55ab-4131-93f7-9b23a4e9f2f1	베포케어정	653805460	126	0.32	0.3	0	8806538054612	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0a101039-33cf-458d-85a1-cd39d5d2d2fe	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021317	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
30ca02f3-6f21-4c37-8006-7e2735e2ed0e	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055602	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
bc593edd-4f3f-4dbb-a7fb-11b284d60804	판스틴정	653806230	88	0.05	0	0	8807000000000	10T*30	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
60586286-51fc-49db-ae63-9f0fe60d26c5	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027531	5정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ff213c71-f5f8-4154-bb21-505d66bd34ea	악세푸정	653801970	637	0.3	0.3	0	8806538019734	10정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
578fada6-e68f-4249-b2a2-c72ccc2ecd3e	맥스케어액트정	653805970	275	0.1	0	0	8806538059709	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e099e482-5f3b-42cc-ae0d-41d1d45684ba	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003641	90정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c699d00c-e0a5-4e99-a003-d78923250094	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057118	60정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cb29930c-6523-45d8-9914-6d3563fb1015	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3e155f7a-4fb6-4142-8469-eacfda685c29	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060415	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
29cdb9e1-50c1-4f68-bd42-240dbda7b464	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049304	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
36487c6f-c2b0-47c4-85f3-8cc9aaf89412	디누보패취5	653804850	1283	0.3	0.3	0	8806538048536	30매/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f9bacb71-c4dc-462c-a27f-beb3a5bfc512	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053202	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b5375dd2-a0f6-416d-af0c-1e56d35dee47	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044118	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
80e1b60e-2b48-48e1-963c-50b9ec11028f	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056425	20포/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7af87bb3-68a3-4357-b002-49f7e2867beb	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060736	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a10c5fcf-ae7b-46ff-a9c0-6cd811ee5a88	코린시럽 500mL	653802381	11	0	0	0	8806538023816		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
21b07856-91de-45c3-8c3d-cb1a534dfc8e	디누보패취5	653804850	1283	0.3	0.3	0	8806538048505	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
92739976-5a80-4aef-b327-5bfb48421807	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012155	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c7753850-927f-4bd5-a242-2eb2563d2731	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062211	56정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c62fea47-2374-41ac-980b-e1b723a44a26	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013640		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e44244e4-9e15-4f78-87cb-99df360dd27a	디누보패취10	653804860	1586	0.3	0.3	0	8806538048604	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f6160f65-a709-4eb8-8c1d-39b0d8b87f30	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062624	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9eb61df2-6601-4700-aa72-e92fa85079fa	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049830	90정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0b4a0aa4-aa16-452a-92cf-eaee8d75ca6e	무코신일정 200mg	653800620	70	0	0	0	8806538006208		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ee54eadb-6a74-46f5-8d9e-93253ded0325	에이낙정	653802100	188	0.4	0.55	0	8806538021010	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7621f604-b1c0-41ed-8f9f-aa32090c2276	맥스케어알파정	653804520	277	0.05	0	0	8806538045207	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c8d191f6-e1fc-40e2-bda4-e467add75d2e	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7a7cc6ad-87b1-4029-b620-45c08a1d070b	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044408	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d38a5c7e-36e3-4bc9-83cd-0b51c92e645f	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021645	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6fcb380e-72d5-45f6-9b27-091c6a3df016	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a3f07f66-513d-4fea-a7f7-6b21315c4541	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056432	100포/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
67e7f613-8591-456c-a596-2081dd80f347	이부프로펜정400mg	653801580	30	0	0	0	8806538015811		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2b94a4af-6e87-4621-ae88-1e85a9362bad	레보트로서방정	653805950	189	0.35	0.3	0	8806538059518	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4c27902c-44ce-410c-81fd-26133b963753	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058214	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fd34ddda-b6fc-42fa-a579-68b55d8a0eb9	베포케어정	653805460	126	0.32	0.3	0	8806538054629	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5ed3bf7d-d0a7-47d3-9741-78c91dde397b	메토르민정	653800580	70	0.2	0.28	0	8806538005829	500정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2a6392db-839a-464f-930b-7acf341e8280	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012117	100캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2f0a240a-9a9c-4dae-9ce4-f9f01c044710	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048208		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
82e8727f-9a6a-43e3-9bf0-67936a39fdb7	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017648	5캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7d0d7e91-42e6-4885-bdf4-9051df9875d2	신일폴산정 1mg	653801510	15	0	0	0	8806538015149		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c9bafd41-cc3d-4fc8-8c99-27d64ab11ee2	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021324	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c863c8b1-d411-4710-aa03-53a5bee638d8	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061412	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ece722af-0df7-493f-83fe-9a337b0803a1	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e42b356c-503d-46bd-9b2b-f48bfe9c662e	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062129	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a32621b5-30e8-4c36-a426-93a363f11ab8	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061405	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8e338d72-38a9-4285-8e7b-df23ee4c0f86	엑세트라정	653802140	162	0.4	0.4	0	8806538021409	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3682a740-ce58-43ed-91c7-73f19517b81b	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048918	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
388b497b-3087-46a1-ab9c-9cb79bbaa1cc	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017631	9캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3ed921b8-8453-4d0e-a0e4-e639b8665c1f	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010991	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7c9ebb84-9ad1-4b03-8341-ab819be2f069	신일세티리진정	653801190	161	0.4	0.45	0	8806538011929	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
16844074-6e15-4d01-8d40-616ac72fac62	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011714		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2b37cf09-68a5-4ca7-a655-45f835153fe5	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052519	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3011be7e-e76a-4466-9a58-4e11280bea4a	메코민캡슐	653800570	50	0.1	0	0	8806538005744	100캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9302d182-3543-409b-a818-97b5c25ac9fb	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058122	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
688649d2-cead-4457-baf9-5cd8e87ec44f	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003610	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fa9ab4a6-24a8-477a-aeb3-660acec41b94	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6a2bbd42-d3af-4733-8b31-643cc45f9e4d	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053622	30정/병	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4003c2aa-3f65-442a-aab0-7c3fe5790672	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053530	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c4f232d2-8b53-4c4d-8868-655d483cbf56	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
81ff0173-526b-460e-b3c5-24e1f79cf768	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060101	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
199d523b-76bc-4aa3-81a5-27d2057c1847	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044033	90정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
19908f3e-53b0-4858-a4e2-0cff7de8af12	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063003	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
dc6f6124-12c6-428b-a6c8-1046f4166474	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048819	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7f832371-2503-4553-88ba-b6872ad73dd3	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062914	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a59471c0-1c68-4ae8-9b14-a9515b408e08	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059112	30정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ec8e8c1f-dfff-451e-8da3-a592dcd41850	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053615	30정/PTP	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a4d13634-dd6e-4c3b-bbcf-85b05731c153	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013817	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2a7829b2-775d-4317-a929-9a3ab5dd43bf	테글리정20mg	653806020	665	0.35	0.35	0	8806538060200	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
be449922-a34a-4566-8509-9c419e0d7e9b	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062730	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
307dd728-167b-4e2e-a37c-f17e9401e20e	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053226	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b2bea9cc-4cee-49e4-945d-2684008ad42e	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013848	120정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d7aded50-545c-49c5-8a6c-4d6a2be5bc14	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ebe76749-a3d5-42e1-8b16-a7d3c6ec019e	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058306	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0c539b0f-2d29-489b-aa74-ebcbe13ee056	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062808	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a41a80f5-09e6-4330-97d1-38fcd04ee26e	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050164		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e6e4308c-7c68-489c-8165-6047c4e08deb	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063034	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5a8bfdaf-6ab4-4cff-a7f3-f8a99e392f26	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013824	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
936682ca-4f25-4b58-ac88-b1a97bc86f1f	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014609		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
68062f3c-9ea2-476d-a4d8-4bcf9ebf9d35	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0ed5c308-07fd-4015-bb56-a976875ca4c5	악세푸정	653801970	637	0.3	0.3	0	8806538019765	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2c281778-2a2b-4c35-8274-92362fe898ea	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013770	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
898bb741-db1c-4024-a4f3-58e93bc14807	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
268bbaed-9424-4e4b-b9c4-d95cb5224a18	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051130	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
07c55f2f-fde4-4af5-9d80-14bd64e25760	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014265		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de815c0c-f90f-4120-91a6-d98dea20db6c	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046938	1000정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2ea660f7-20bf-4e92-ad8d-0187dc9aaa33	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061917	28정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0bcefc5d-3ef0-40fb-8704-419059a6c5a6	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048802	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
342ab509-8cf6-46d1-ac76-980bb6ae94d1	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056616	60정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e89bb1a7-de99-4733-8da0-700d47684075	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017624	50캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c983182a-8f09-4a7c-b0f7-de1e7032682e	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
923e90d8-8f3e-4a1a-b2bb-f57e341dfebb	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062204	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0c3279ad-7e1f-456d-9631-86fec56018e8	엑세트라정	653802140	162	0.4	0.4	0	8806538021423	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c2a10ab7-f3a1-4e76-96a1-492e99fafd22	악세푸정	653801970	637	0.3	0.3	0	8806538019703	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
61121361-ff15-46e6-8373-af08fdf4956e	베포케어정	653805460	126	0.32	0.3	0	8806538054605	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
255fb95c-c49e-4932-98ed-872427245303	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013602		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a7287dd1-92a5-41d5-8d2e-cff7f59eaad9	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051031	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7646da2c-0a29-4e6e-b031-7cc679c4ba42	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011448	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2da0fda1-f076-4702-8189-c3339ac54ce3	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003658	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5ad66824-6c3e-4f79-9615-0c6cbd514a9a	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002712	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9d00bc50-7779-4b25-8e00-34c2535789db	후리코정 5mg	653802890	25	0	0	0	8806538028903		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8b841b1b-38b1-4c67-8bf2-fe3b15fb74f6	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044415	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d2c929be-d2fd-4c18-9f9c-eebac8b87b12	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053233	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
95115ec6-5561-48ae-bad5-448bb3e7a9f4	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003627	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
563a4655-b07f-4487-a1b1-3a5e382c1ada	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053332	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
355fa3b2-a40b-490d-8a2c-174b6113fc52	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012124	500캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3f15c703-3339-4efe-9bfe-826b9661d823	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061801	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8074a6de-7173-41d0-af1c-c2ecdf49b396	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044019	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d5a9bdd3-9b83-40ef-88c1-c3750e408cbd	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050133		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e1e5ec90-5558-436a-9ec9-3440a5f09ab6	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060309	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
bd5edf31-4fcf-4fa5-9534-60644241f589	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053509	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0a053639-4200-4216-ab4d-1481c83b1027	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061504	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0a1a5629-d033-4867-9f1e-078caef0d21b	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053905	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
395c35c1-b180-4da4-819b-e18d9a73f14e	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006314	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7e1378b6-712f-4b56-bde0-432fa8f40469	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053400	(소분)	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6713d973-540d-4a71-807a-b75f5e6b7170	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013749	120정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8a36dfcf-dac6-4200-8add-212742169edc	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062952	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
107007b4-495f-4f89-bddd-619edf51cc24	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062846	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de270985-be9f-4896-a9bf-fa1f0d5a9c7c	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049823	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7d305261-639a-4c5f-b660-e8869b3f1223	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d0c73bf3-b9e1-4444-9f4e-937429012ada	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053424	30정/병	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a5df0a26-d616-4b9c-bcbe-24669153dfb2	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055626	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
30c2f1d6-5e60-490d-a80e-b08b1815200e	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053523	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fb5ca22e-e9a6-448e-b8eb-38d8aed2395c	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013831	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
165337a1-3ca7-4f9a-a77f-edf734164686	테글리정20mg	653806020	665	0.35	0.35	0	8806538060217	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cca17946-6ad7-45e2-9f66-15919c1ec027	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062617	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
62ab3064-fd52-47b7-bba4-6b248a7e55ab	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062921	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
78ce1784-781c-4ab4-8a75-65eddc42318c	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050119		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4acb4f95-5bda-442a-9bed-7a56bd8ffe56	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059105	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
adb456e4-9afb-43a5-976f-7ba6048a7896	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060729	14정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8a19bd27-cbbc-4b97-929c-3bfaf466d666	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3ba31f27-d035-4d32-9648-9140c4dcd239	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053318	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
973f3d9e-1061-42d5-bd55-952269b8e4cd	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004402	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2ec3f562-a69e-4851-a96d-144522a67ddd	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014203		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
14b93650-df7d-4ee9-ba11-02fbb3ea57cc	엑세트라정	653802140	162	0.4	0.4	0	8806538021447	12정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
78bfcce9-6a6c-4351-9b90-232d95f8ae99	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062112	56정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4f563af1-e145-4e33-a3b3-bf4bf5370f95	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021331	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0da91524-e673-4f9d-8e64-4658c2b2b78d	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010953	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
12cf0fcd-e445-47f7-81e6-88b186530685	메토르민정	653800580	70	0.2	0.28	0	8806538005836	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b2ee00f9-b789-4fc9-8e51-2706b7d423a3	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002705	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
22f07407-60fa-4677-9b2e-b83f18f2a2dd	맥스케어알파정	653804520	277	0.05	0	0	8806538045221	7정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e3fc23b5-a470-4cd1-bf7a-f0b772b64c62	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049809	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b98d3ed5-c3b2-464d-8ff2-f8e92056b5bf	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060118	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2709c0cb-533a-46d8-ab5e-a3e4455dcbcf	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013701	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9f7f6840-775b-4970-8685-267bf7b17a07	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0faeaa91-dfdf-4efc-8848-10698bb3fc39	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003603	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
249c34a1-9e15-4523-aaa9-a51623909d26	엑세트라정	653802140	162	0.4	0.4	0	8806538021416	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
105b0ef3-82d0-4522-b377-92e509bd3ad9	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021614	100캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ad0dbd7b-6c1b-4fcb-a9ed-5184b535941c	스티모린에스크림	653800890	4180	0.4	0	0	8806538060026		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b447fbb2-c6ef-43a9-b8fc-1392e1068720	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053516	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
94f612f4-15c3-4788-b530-d3652521d8b0	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0f965f64-21ab-44ef-9b3c-c0edb428ac44	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044002	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
22aa75a3-e8c0-4a14-91dd-31ea2037c4c5	악세푸정	653801970	637	0.3	0.3	0	8806538019741	20정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
40306ab3-5a92-42a3-8e24-df358c21d237	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011035		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
321a2bc3-6407-4a0b-8b27-8f4b13a79da2	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062907	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a1340bb5-dbbe-4e1d-aebd-2c851e1afe82	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063805	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
759a5ddc-f1bc-466b-b454-efc77a39aa03	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009001	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
01199916-7fb9-434f-bf05-777619205027	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063812	8정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de3be0d5-c894-40c4-ba2a-68dba97c8ce2	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011707		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
52c8de7a-bb60-470e-a0f5-1b9e65a351ec	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058207	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a9eebc53-98b8-47b4-b210-9eb1760740d3	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013756	5정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7971075e-f184-49cf-928b-0627a190973e	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003910	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6447dbcc-823c-49c3-a720-341ffb14cb88	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054117	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
81430e63-c772-4bb0-8bbf-945d589763b1	레보라정 25mg	653800330	119	0	0	0	8806538003313		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
61e23852-3d86-4726-927a-67ce1e632ef3	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054001	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6b8150ea-799f-4bd7-95f8-28277e5a0fcb	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052908	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
de222ca0-e2dd-4500-a424-4bc6cf7d21f9	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061207	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
481cc8e9-9b33-452d-83ff-340ff5006a7a	메코민캡슐	653800570	50	0.1	0	0	8806538005720	180캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9cf48ef3-b864-437b-bc64-e789bf060904	무코신일정 200mg	653800620	70	0	0	0	8806538006222		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4f280753-33b4-4490-884c-6cc5a3e40fe0	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009018	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4f24ccbb-db6b-41a4-a2cd-203324135c65	신일세티리진정	653801190	161	0.4	0.45	0	8806538011905	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1fe482ac-a495-441f-9308-878d55b0ecee	신일세티리진정	653801190	161	0.4	0.45	0	8806538011967	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
054a7c2c-3c15-4962-9e7d-337a32ef11a2	신일세티리진정	653801190	161	0.4	0.45	0	8806538011936	1000정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
eb4650dc-9fc8-4095-b920-0ee04dd9d4b9	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048222		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
48101100-8723-4e22-80ac-a8853b3e99d1	에이낙정	653802100	188	0.4	0.55	0	8806538021003	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1cefe75f-f1a6-4be0-86de-cf795126be4d	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046921	180정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
487255c0-1734-44f0-8c24-a4d937b20acf	신일폴산정 1mg	653801510	15	0	0	0	8806538015101		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ba057a0b-da17-4eee-9887-2792fc938353	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054506	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a3dac435-75ec-49d7-8c16-d4713ec91214	에페릭스정	653802110	115	0.35	0.38	0	8806538021133	500정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d7f3c1ef-7fda-41dd-b8ac-a0403e429b02	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051024	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
13b7db6b-b314-499b-ae33-bc3fc0d45cdd	에이낙정	653802100	188	0.4	0.55	0	8806538021027	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d805bef2-d891-49bf-9343-5e5c80d4221d	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061306	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4dd0fe97-cd72-425c-843b-1163554924c6	메코민캡슐	653800570	50	0.1	0	0	8806538005737	500캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
33cb78d9-b6cf-46ea-8950-4373a8c8ccaa	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062235	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
209cedd3-fe7e-41d3-9243-fbc8ea3deba7	에이스낙CR서방정 200mg	653805620	352	0	0	0	8806538056210		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
bbee8409-5383-44cb-b48f-a05f148b3ea5	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062037	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0ef56de0-41bf-489f-b0c0-6a9e69b27ffe	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006338	10정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e11af18d-10ef-4d90-915a-7873948420c2	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061603	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e78bbfa5-b459-47f9-a48e-34bdce889941	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053929	300캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3fe837c3-9718-4111-b714-7a0ba462119b	오로페롤연질캡슐100mg	653802190	115	0.35	0	0	8806538021911	500캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5ece9469-20c6-4943-9244-57dca1d549da	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034614	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
09db9bf4-775a-42d3-98ce-497931fcfa18	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047102	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cabff966-36ec-44a8-9ae0-c7da4c41b3e6	악세푸정	653801970	637	0.3	0.3	0	8806538019727	50정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
56c5862a-d894-44b4-80ab-e4d3c9acd19b	아미나엑스정	653804740	387	0.35	0	0	8806538047416	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b2645cca-eedf-442d-89d2-720e87957626	신일피리독신정 50mg	653801720	23	0	0	0	8806538017259		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
679d432b-4874-4e57-a9fd-788bad80cae2	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010939	180정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
dc0f2805-f8eb-4f6a-be60-292b85e8400a	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048215		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f0ce49fb-d1ea-4754-86b7-19dac1c4d06b	신일엠정 500mg	653801400	22	0	0	0	8806538014005		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9ac0679f-a770-4209-b7ab-748600a0cd42	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013732	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
db192ab2-2b78-46e3-84ed-163becea28b1	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013107		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8337598e-f1d4-4b37-8a79-db028fbf1e44	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051017	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
735cb17d-07c9-46cb-a409-c3487ce8c0ea	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057101	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4c448909-dd39-445c-ac96-6abdcad4cab6	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047119	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a92d6287-2574-4bcd-a323-1710e72b187d	메코민캡슐	653800570	50	0.1	0	0	8806538005713	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3ff9da65-17f9-4ce5-8a81-cd6358e6091e	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004419	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
11f1b65c-48bc-432c-bde4-c7e4b7b64bb3	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058221	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1afa353c-b395-4d72-9a7a-f95308fcc334	테노브이정	653805260	2505	0.45	0.47	0	8806538052618	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
abdf32e7-1daf-4944-8b4e-b62df8592381	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054124	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
47b6b908-ba25-49cc-9800-0b7da58cfb01	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003221	500정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
58904874-8c71-4040-bb05-2195b41c3868	디누보패취10	653804860	1586	0.3	0.3	0	8806538048635	30매/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8f0f9306-e9df-490b-a107-561b2644aecb	디누보패취5	653804850	1283	0.3	0.3	0	8806538048529	30매/통	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
225bc873-a710-48ce-ba7c-907446f2869c	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053431	100정/병	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6a405250-8eba-4c95-9a00-758a3bf17f77	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1e92fa44-86d4-4dcf-8c6b-d05c9abe5b4b	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
66e9d5dd-6370-422f-9dff-78d6d400afb1	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049816	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
37a9e3d5-6f61-424a-98e6-a741aa1f59fb	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2da898d6-a431-4bf9-aaf4-76ea1ff9b999	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034621	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
047fb95a-b1d3-4a71-92b8-bb23d5496a4d	테글리정20mg	653806020	665	0.35	0.35	0	8806538060224	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
af4d4359-be01-46ff-8cc9-49a0a0d81d6c	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057316	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8293ca8b-bf45-40f2-9c31-d60e6095f499	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062105	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1520131f-60a9-47c6-ad34-245523e700d2	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050140		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
61402feb-2ed5-4531-be74-46fe3d3610f7	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062709	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8b84ff25-9324-4aac-b185-44134cbae261	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062631	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e7c9afcf-8f11-4758-a0c0-a93f0cd36b5f	브이디썬정	653805980	113	0.2	0	0	8806538059808	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2482fca7-43b3-4cf5-9004-c6721e74d2fa	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027517	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
76ceb462-3a2c-4783-a95e-5be2ef77f8ed	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057309	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5b00918b-e906-473c-a581-7f3c7a81cc3c	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013763	10정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
62dd817e-7f39-480f-9b08-4e8c03aa9645	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013725	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
aa028afd-4bae-4621-9b51-08190e81fe2e	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044026	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d8b1ee7a-3023-411e-816a-87f75fea2ad7	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7e19b170-4b7c-4d8d-b7a3-f47842411f1f	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049311	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b09d078a-6c73-47a0-b8c6-d0b7e9344d61	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
368643a0-ca49-4f3c-992f-188d6069ec0c	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9f12df36-cc7d-4b9d-9d9e-44844cef5853	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1803d46b-916b-4a54-813f-c8cc6c4c4ced	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
069cdbea-41c3-42d1-9b97-67890d003f8d	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006307	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5be03638-735b-4191-9f68-240f2293e9d6	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062532	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f4f2444d-fd69-4eb0-846e-e262e2ee39fe	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060712	7정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0ff2ee08-f958-479e-bb3b-74c532d9716d	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054018	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6f76df0e-2080-4eb4-aa69-8db8774899bd	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055619	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b8fe14f0-c70f-4543-9315-5e6f5f1c2077	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047126	60캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
594b49a1-73b0-4656-95ec-2564cccc890c	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013718	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cdca231c-adf5-40d4-8188-a68466f427f6	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056418	1포/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e4af3d44-c708-4a02-8c96-e489131d9ee9	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059013	30정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4ed928d8-b8ea-41fb-9719-5fe1c5e7a66f	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060705	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
13a02bb0-f821-4c3c-8bbe-34f463b67ca2	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056401	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7ef09101-6f54-43be-a262-6abe2b03cd22	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006321	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8674f524-1937-48d0-9f92-a7aa8325bc8c	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063010	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
058667dd-e9f6-4ccc-83e4-bc0636688e46	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051109	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
03345528-6349-48f6-a9f9-d41ed710a6ef	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060408	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
29316163-e08e-4726-bbcf-2b536480a52a	메토르민정	653800580	70	0.2	0.28	0	8806538005812	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7b77ac3a-62bf-4ade-9511-74f97fc03b29	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011417	90캡슐/Foil	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
b7ce1c07-4819-4c27-9c5e-132186885169	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062525	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1421dd15-fb1c-4bdd-99be-703cee2258bc	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4fd263e0-a69b-4f10-a7cb-11b3eee3f6fe	신일아시클로버크림	653801351	2400	0	0	0	8806538013510		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
76338407-8aa6-4031-9dda-345b92902014	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048925	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
359eee02-d30d-4929-9e4a-0106e8cdf1ee	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
83eac785-6b7b-420f-9b67-dd1a718e98c4	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053219	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
01efa21e-fa47-4b29-bc8e-ddf53d261658	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021300	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
915cfafa-50bb-4c0e-8246-1716fe62f801	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054100	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8be64442-8453-4add-8660-505aeddf11c0	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058313	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
bcae3d02-9f59-4a8c-b39d-81e4049f8975	디누보패취5	653804850	1283	0.3	0.3	0	8806538048512	1매/포	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7a0e7f53-04b8-4b37-b99e-a04f07edf023	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056609	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
dd26e3c7-ccf9-4f7a-a0ee-22ba671524b7	브이디썬정	653805980	113	0.2	0	0	8806538059815	240정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cce48d1f-b3d0-440d-b6d6-e2aaccf4775b	자누다파정	653805990	846	0.23	0.23	0	8806538059914	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9abc2faa-f3fe-4780-993e-ea253398a801	신일세티리진정	653801190	161	0.4	0.45	0	8806538011943	100정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
a73cfcd9-9775-43e6-a202-1b5082d743ba	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054513	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9053f72f-6c07-47c6-8564-8f57887b4cb3	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049014	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
7ee0a821-06ef-4561-b9ed-0b931c3fd53f	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010977	10정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f444962f-667a-404f-aa53-db74b9c94a76	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014647		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cc8ef1c7-f3f5-4805-8a66-f54c8a309051	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062006	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3f0f94fe-b9fb-426c-8d64-a53bed91a140	에페릭스정	653802110	115	0.35	0.38	0	8806538021102	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4587c1b1-d9da-4e5d-b511-4af34e69104f	에페릭스정	653802110	115	0.35	0.38	0	8806538021119	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5ca166f3-35ea-4f7f-85c0-da5e80911832	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048901	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
43d03040-fc49-49d0-ae71-7f08d6091a03	에티브정	653805240	480	0.33	0.3	0	8806538052410	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3d2a32d2-6a49-477e-ada4-51cefdad91a2	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053912	30캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
645a50ac-fcc2-4e7d-be49-bcb8952ac329	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049007	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
48b4a1ea-d083-49c6-a43f-239f8a34f466	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062013	56정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
fc17d1d0-2755-4a35-875d-b6562aa17654	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021621	10캡슐/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
523d009b-dfdf-4bcc-83f2-874eed74d926	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061924	200정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
45ceaf19-9e24-4bc9-aa51-b121be9605aa	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013121		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1d2afd3f-9f4a-4a49-9be5-ec69b57a3a40	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021348	12정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
39ec377e-67f1-4b4f-9ce2-2d27b7d704f9	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061214	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f38fed78-eedc-4e33-90ac-2ae86cf2123d	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011424	300캡슐/Foil	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d8d8b5c7-77f6-4d43-8b18-e0a002410f5e	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061511	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
429c9413-bee9-4805-8197-32792199e412	액소도스정 60mg	653802050	0	0	0	0	8806538020518		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
54944bb1-a2a8-4681-a017-672064d8fd09	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010922	90정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e311bb04-776e-4c0b-891a-32245fa1d3ff	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053639	100정/병	30		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5bb65c39-8d59-4a28-9ede-707c6d2cf836	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
06c7654e-6421-4957-95c2-b8a2aa708c39	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052502	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1dfdb2a9-8c1d-48f4-b157-cea84e6e31c0	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054025	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
aa20ea7a-de4c-42a6-931a-26e97c4dc1b0	메코민캡슐	653800570	50	0.1	0	0	8806538005706	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1768eacd-f810-4938-822b-3b61d545618e	메토르민정	653800580	70	0.2	0.28	0	8806538005805	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8ba796db-dcaf-46d6-a6a0-cfb07528b6cb	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003903	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
3920fca0-73b8-4150-87f4-4bb744544e9b	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051116	28정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
0026442f-d561-48a9-88a1-b386fef7f22c	자누다파정	653805990	846	0.23	0.23	0	8806538059921	30정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
969330a7-5744-4bad-bf13-87138b730368	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052915	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4d294a27-103a-459d-833d-93de0e6cf14b	레보라정 25mg	653800330	119	0	0	0	8806538003320		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
4dde3406-f5d5-4872-bb47-811a456c4f96	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051123	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
258c9570-7408-4075-b5cd-ce8ed34f7e5e	맥스케어알파정	653804520	277	0.05	0	0	8806538045238	14정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ed09efea-85e5-40d6-82f1-9fbd692bb781	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003634	500정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
01852767-0662-48af-8cff-88b43445c85c	후리코정 5mg	653802890	25	0	0	0	8806538028927		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d2bf22e9-d015-4331-8043-64a1f29de636	레보트로서방정	653805950	189	0.35	0.3	0	8806538059501	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
1012ef90-af1f-48f8-8ee4-f81da31fa86f	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011462	90캡슐/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
f848b2fd-ebc7-4ffd-9be6-24d189fff924	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047201	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
2c181b11-98d3-499e-bb89-9bb60e6d4c3c	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062938	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c8a7ade9-b59a-48c1-bce2-e1e3314c3494	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002729	28정/Alu-Alu	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c16cc8a7-2c25-40aa-8073-54a1d04d5aa5	레보트로시럽 500mL	653800341	18	0.3	0.35	0	8806538003412	500	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
92ff5080-c11e-4a8d-a456-c3d43761a616	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010960	100정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
bc2cbc87-a925-40ce-8e66-35009ccd17ff	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062228	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
06ea9322-ebeb-4af5-be11-77630d014dd3	디누보패취10	653804860	1586	0.3	0.3	0	8806538048628	30매/통	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
428fc7c1-e23e-45f1-9019-6566d5a5e108	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
13d2098c-7ec9-480b-9488-a42142017ea3	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063027	60정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cbe51c09-f17e-4517-80f6-59955ce110ce	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027500	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e29d5a4e-da42-4e0c-8435-e4d12872a382	신일세티리진정	653801190	161	0.4	0.45	0	8806538011912	10정/PTP	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
ab013c16-8c78-404f-adef-b7ed071a2015	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053325	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e22485b8-8baf-4e55-92e0-b649bb7e3339	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
9344f1bb-39d8-43b8-b963-ba07f0dfbc82	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
cfda85eb-5327-4599-8305-27aab1e95a7c	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063706	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
6d1d6f13-8079-421e-9aec-f4b06b09ba38	액소도스정 60mg	653802050	0	0	0	0	8806538020570		0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
c55937d3-ecc0-4cf0-a241-ef0ae12e5138	자누다파정	653805990	846	0.23	0.23	0	8806538059907	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5b5aca5f-e72c-43ec-adb6-30ac32c3219d	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061818	28정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
e33a343f-aca4-403c-8c32-fe035b762660	악세푸정	653801970	637	0.3	0.3	0	8806538019710	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
d1be2e17-32db-406f-9a19-9f9c1e2f8bd5	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009032	300정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
798f6714-20fe-4316-a79f-a86e3b7ff8ba	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058108	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
87b42823-5899-4a84-b101-fc456a6e05d4	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003207	(소분)	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
5744baaf-33c9-44e4-bfc5-a5f0b595ebe5	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044125	30정/병	0		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
8e09b5ff-5a69-438d-879f-54332e616635	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:02:15.780494+00	2025-07-21 06:02:15.780494+00	2025-07
95abd483-ae07-4e3f-8c55-07b09e711914	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063713	8정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
29aab314-10a6-43dc-b40f-1cca6cab47ad	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047218	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
20166be8-71a3-427d-977a-a76ad9b41f78	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9e7e0692-c99d-4c23-af81-2b3310bc978d	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013428	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8c2c3b4a-0c17-495e-a509-5f6c93c95a10	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063058	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a877d3e3-6cb5-410c-b5d7-6ed21fe2bf4a	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027548	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cbfc3a32-8741-4328-b4eb-5154b2d22311	에페릭스정	653802110	115	0.35	0.38	0	8806538021126	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e0276ac0-96fc-4f42-b72e-06702ef8c664	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062815	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b9ef0be3-9cf2-4875-9932-00645228747b	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046914	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
05ece030-58f6-42dd-8e0b-9e3fa38ef13b	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058320	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1e8d22fc-b2ff-4976-bc88-4f7f709271b3	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011431	500캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5539a21c-8756-4100-b831-73d0b636da6b	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062501	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
931c2d9f-697f-4572-a8e8-3ec99edff5cb	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044101	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a1e5737b-cbcf-43d0-aa63-c210f3a80631	맥스케어액트정	653805970	275	0.1	0	0	8806538059716	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7cc5fc77-0ed1-449b-916c-506fb88978b2	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013404	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3aa5f0fe-a29e-41d2-b694-35b45d38db22	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021638	100캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e1c6961c-2ff3-4776-a724-4169790c5846	레보라정 25mg	653800330	119	0	0	0	8806538003306		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
60ccf388-45b1-43e5-9598-d8db31a7f42f	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062853	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
95f48f70-1155-4764-a392-0b0048c911cb	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063041	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1588c018-547a-46d6-8eb3-f766b1808b5f	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053608	(소분)	120		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8aae6828-597a-4343-b607-6c67b595f5d2	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017617	30캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7a437d16-d101-4094-a268-aa53eedf81da	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010908	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cc457297-f52f-4cdc-8a17-86d0fb3aee39	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061627	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e3dd8493-8ce6-496c-b1b0-e15e1aa98353	스티모린에스크림	653800890	4180	0.4	0	0	8806538060019		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2dfd5103-d753-4225-9d80-908f8aa3ebeb	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034607	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
06779bcd-02da-46aa-9729-0da7c925232f	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
52599767-c203-42bb-8d23-c9081ccc9502	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011080		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7f04fe20-6f0a-48e5-936b-7f6bb5d4835b	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027524	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4ced95d3-1eae-4b9d-a9b3-392092d7e298	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062600	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
34208126-e315-45f5-bfcd-aa5bc47696e8	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
329c4914-e334-432e-9cb6-29e88552e523	메코민캡슐	653800570	50	0.1	0	0	8806538005751	180캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d2dfb0d4-2b37-480b-b9c8-39eff4e9d0fd	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010915	10정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b315acac-a17d-4502-bbda-38ae5e3b6f9e	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062020	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fbb40391-02b5-43ec-8486-42d832400890	엑세트라정	653802140	162	0.4	0.4	0	8806538021430	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
17580a62-dd23-4514-9f97-ea5a5901c209	신일세티리진정	653801190	161	0.4	0.45	0	8806538011950	500정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f4356378-94e2-41b7-b25c-3f655c51dd40	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003665	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d601ebbe-4177-406a-a23f-817f5e384666	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013800	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4d3bbb63-5bc6-4a1d-a391-d0ece8b44565	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062716	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
854099ab-d3fd-4384-8a71-d9a368e6b9b4	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c01a1323-a238-43d9-9d0d-69962417d68b	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062945	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
75043c7c-aeff-459b-a0c1-cb3da65ef10e	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062723	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
54775a16-be53-49b5-bfd4-72bef452ba87	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0223c994-daa9-4df0-bfd9-e753348a7de4	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051000	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6a34d5b2-d3c1-4373-9654-953fc79365ae	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013411	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
81af8aec-ccd4-4b43-bb86-7e891c38e45f	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061900	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
49c1175b-fd33-4dbf-856b-c222bd060e77	신일피리독신정 50mg	653801720	23	0	0	0	8806538017204		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bf6f1ee8-74df-408b-a19e-7cdb2e922c4e	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058115	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ce933d20-525a-4be0-85f1-4633390a06b7	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021607	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
70a92a99-f429-4871-b652-46d9778c08f6	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013626		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
89dc6440-e229-458c-b170-3fc396cad57b	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052922	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2546481a-3fa9-4e02-b3b8-57696adec8d0	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057323	100캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
71ea192e-8920-4335-85cb-038c659274d3	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
325a26d8-3f34-4d2e-87ac-4ac2823931dc	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044132	90정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
79db6ed2-cce6-4c39-9712-24436aa267fc	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047225	60캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ffeea1a3-95d5-443a-8679-93cfdb76d23d	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050157		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3d579cb2-817e-43b9-af1a-bb876baa394f	신일엠정 500mg	653801400	22	0	0	0	8806538014029		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
449fb93a-aabb-46a4-8f1e-89e3d53dd99c	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012131	100캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
84a79f74-40ca-47c8-b8f8-b2c7d56c188c	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062839	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2f89e9e9-8d38-4ae8-831e-3383ad439b8b	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011400	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
68f9f8d4-953c-44bd-bf7a-b5725e14ca21	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060316	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
155df552-8a04-418b-b72d-e2c9177358c3	맥스케어알파정	653804520	277	0.05	0	0	8806538045214	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
400c0f5e-a82b-4f4a-aba9-50908ae80b06	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017655	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c432a025-8ba8-422e-9cfb-98958da72388	디누보패취10	653804860	1586	0.3	0.3	0	8806538048611	1매/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ea0458b7-f82d-4b13-8063-7a8c33bd9c3f	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004426	100캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9f42eed0-9ebc-4c8a-a5aa-e0aee0029187	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052526	100캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cf04070b-5da3-4670-9163-ce8c97a027d3	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010984	90정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
876157a9-466d-4336-b7ee-569356dd041e	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054520	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
008052ac-48f5-4a6c-afc3-dde2a584790d	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061610	28정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ad10c6cd-967b-455d-8399-7daa6b8578c9	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062136	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
94ba9926-faea-4b93-8902-7c2b0ec72bb1	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048826	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3a67ffb7-4601-4e31-9ce3-c22951b6f4f1	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017600	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f72e2ed5-c10e-4739-b4bf-d3c1095c1034	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012148	500캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e3cc2df9-ff25-4caa-b01b-a81a6a1d29de	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011455	100캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fb8dab3e-41fb-4442-80a8-3624d538f9df	레보트로서방정	653805950	189	0.35	0.3	0	8806538059525	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
af040c7a-c970-42da-9e40-c5c9b2d39c43	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053301	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
70337674-8d86-4678-90ba-5951dda3e635	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0478bddc-af0d-4675-88a5-c5979aa4a632	테노브이정	653805260	2505	0.45	0.47	0	8806538052601	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
dfb45495-16e0-4267-98ad-7210adcf96a4	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062518	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d21f1e32-137c-41a5-a6be-1ceaa6d7e7cf	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062549	90정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2653beab-5dc5-42e9-a409-0443df99b38f	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ff1fbf8a-68ec-4b25-9a15-e488cf024435	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
65667695-4356-4814-9bf6-982484a74e17	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062822	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
93c618df-f5f8-4ddf-89e6-1bf16e310367	레보원정	055100040	114	0.2	0.25	0	8800551000410	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9d9291ae-ca35-48fe-88c9-270c4073afef	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009025	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a150bde4-8a33-4b4c-a8b3-590642de790e	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8d156f5c-33e6-4700-901b-21becc5fc008	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053417	30정/PTP	100		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
33e1f646-166d-4fdd-a47e-4d167b85d900	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003214	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
23e4f703-0405-44dc-9af3-6976d1adabf7	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061825	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3fda6c71-52f9-4fb0-85cf-0f120f7f6e0c	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012100	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6c626691-ce07-4ede-8b3e-dd43bedaddfd	악세푸정	653801970	637	0.3	0.3	0	8806538019758	50정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
caf82d89-2982-4ff2-a4b2-db9a46183bb6	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061313	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6ada02e1-9dfa-42cb-9269-4beb8697c49c	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059006	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2513a002-3e3d-40bd-94bf-887ba2bcf3b4	에티브정	653805240	480	0.33	0.3	0	8806538052403	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
294c9e60-a2a2-404e-941d-a341bda6a0c6	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010946	1000정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
62bf44cb-08ff-4fc2-b345-7630b04543a2	베포케어정	653805460	126	0.32	0.3	0	8806538054612	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c533b4e6-c45e-4def-9f49-5f31368f969a	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021317	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c8163388-2ae4-4604-be62-52534c2732ee	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055602	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1122e39c-f909-4fbe-8661-bb851f0a844a	판스틴정	653806230	88	0.05	0	0	8807000000000	10T*30	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
849ff35a-fc3e-4c6f-b993-dc5a2aeff1e3	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027531	5정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2c98564e-48ba-4f8c-a29c-55e2dc1fa289	악세푸정	653801970	637	0.3	0.3	0	8806538019734	10정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2d1841bd-a2e0-490e-83cf-bfeab5792dfb	맥스케어액트정	653805970	275	0.1	0	0	8806538059709	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
87489f85-ec8e-48b4-b572-67c84265a9af	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003641	90정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ae264a73-4891-4d7c-b1d6-60119e2adc89	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057118	60정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4834eee1-727c-42e6-930f-664f58c114fd	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
11cb2159-893d-428c-8672-56d5685b9b4f	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060415	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
aef3538e-61b1-47a9-91da-b64bf6e51eb2	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049304	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
877849e6-6b42-4e05-b046-9e5b88c9517e	디누보패취5	653804850	1283	0.3	0.3	0	8806538048536	30매/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
55a8c9f5-9f5e-43e6-a0fa-f30779539802	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053202	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a0b71523-cc01-4062-8994-ae49817b033a	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044118	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0c07474b-44be-4a18-9b89-b0da69373d8a	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056425	20포/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
79511af2-60b7-48c2-84e3-dbc18319257a	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060736	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
298cd383-23de-4aa7-bd05-c3b25bdbe3dd	코린시럽 500mL	653802381	11	0	0	0	8806538023816		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a5721c04-db20-447f-8e05-13246c4cc05e	디누보패취5	653804850	1283	0.3	0.3	0	8806538048505	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0e22ed64-3618-4524-b369-8ed9419d9faf	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012155	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
35f8b662-8037-4296-8d22-2c0936befbc0	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062211	56정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f018a696-459c-4a61-9573-87bef3f9deff	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013640		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8e4bb3a8-63a5-48ed-887d-b35ba26a8d99	디누보패취10	653804860	1586	0.3	0.3	0	8806538048604	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1b5b07fc-7d2c-49e5-a6f0-d4a48cf133c2	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062624	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3e89abe3-2f93-4939-96e9-17179fcaf080	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049830	90정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ec0e4f71-b231-4513-8bf6-0da30ae17bb2	무코신일정 200mg	653800620	70	0	0	0	8806538006208		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5525cae9-65c0-4c1a-9dc5-0c312628ac3f	에이낙정	653802100	188	0.4	0.55	0	8806538021010	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4e570eb7-c359-454f-a091-a80508ff6d4b	맥스케어알파정	653804520	277	0.05	0	0	8806538045207	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4a10c5d2-0662-444d-bd7a-bb8743c12a3b	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7f381cfe-5580-4e82-a6b1-9852cc214f8f	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044408	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
22e97e25-4a5f-491d-a186-4cf33cc713e7	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021645	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a00192d1-cbbd-4fdf-b562-50c9451668b6	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4f21c691-7270-4090-bfb2-e02dc2f9b4fd	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056432	100포/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
42645a2b-37dd-488b-8be8-3f6a4487711c	이부프로펜정400mg	653801580	30	0	0	0	8806538015811		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
575893cc-ab2d-48b3-ae2b-a61f26895000	레보트로서방정	653805950	189	0.35	0.3	0	8806538059518	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f4675b9e-f212-4309-a853-548fd6f211e8	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058214	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
78259b1f-f31b-4fe3-9bed-cc046a8d091f	베포케어정	653805460	126	0.32	0.3	0	8806538054629	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4e150486-60e9-450f-888a-9a46dffc8ddd	메토르민정	653800580	70	0.2	0.28	0	8806538005829	500정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
04ee31f4-3fb0-4bae-8d9c-bef8ca871daf	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012117	100캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
658a770c-8a12-400d-8abe-13f8e5c60492	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048208		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cfceb027-780a-47ef-92e0-595f885b5ba9	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017648	5캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6e223db2-a5f9-4cb6-a76f-b73c5215bd7c	신일폴산정 1mg	653801510	15	0	0	0	8806538015149		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0bc0b4d6-c748-4721-83fb-e88072e99bfe	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021324	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
899002e4-6ed8-48ba-a3fb-23c3d1c23878	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061412	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a145d9de-dd2c-48f1-a56b-4cee05b59212	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
36f94187-96a0-484c-8129-874a61c19f50	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062129	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c90b9f69-030f-4c4a-88ca-3f0614b752fe	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061405	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f88f1d2f-c137-4093-ad7e-df77218907bb	엑세트라정	653802140	162	0.4	0.4	0	8806538021409	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3c4a0c7d-10a4-4deb-ab26-d62a703ec3c5	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048918	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6be8639c-8e9e-4383-aaf5-a93e46d2b5a5	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017631	9캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
495808db-1753-4bce-b422-1a8a55571f0e	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010991	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
183635ae-1d37-4a4b-a7ba-44643e9c7459	신일세티리진정	653801190	161	0.4	0.45	0	8806538011929	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
12160551-c934-44ef-bdfc-a8c3c5b5d649	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011714		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0fda362b-c15c-4932-8bda-925229feb80c	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052519	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
27ab4031-05e5-4ba7-8a58-7ebe20103332	메코민캡슐	653800570	50	0.1	0	0	8806538005744	100캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d71c6fbf-039a-4eac-9206-f05e7baed9ef	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058122	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
eaa2d64b-a6a7-4450-8e2c-c947b51962ca	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003610	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7e2aa58a-4f7d-4460-9927-aa79ad1beb13	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
336192ae-39d4-4c87-97a4-573c0e9b6a8b	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053622	30정/병	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bf76c88c-8365-4ad6-924b-538a495d9517	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053530	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b7276848-0b9f-4d74-ad99-08f63d55e370	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4264677a-e5b1-488e-b3c0-c24834b20b72	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060101	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
61a681a8-75b3-4bae-9c57-349db586e603	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044033	90정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bc8f1fb8-21e3-461a-83bf-03b0fc3e3e59	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063003	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
750c2209-f46e-4386-aa66-8bc508425311	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048819	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a1c71012-ba18-426e-99fe-9e528c7bc1e7	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062914	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c1bfa1a6-578a-4a21-a9bf-1ba9f4c2000f	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059112	30정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5da44f65-d4bb-41c2-8f99-5c619633d897	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053615	30정/PTP	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3332200d-d458-4839-a887-fe13ecae794a	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013817	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
328a92f1-f694-4ca3-aab3-6fa6e3978e6b	테글리정20mg	653806020	665	0.35	0.35	0	8806538060200	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c619dc5c-d05e-4cd1-9d30-9d4e11f848df	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062730	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fa073a7a-559a-46d6-b497-28f297a1cd40	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053226	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a2ec1675-8c57-4a1f-8e20-be225a188d00	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013848	120정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bb12d5f6-7034-4fef-a90b-9c4bc2ded0dd	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e925e0cb-5efc-4f7e-9a87-d196accf87a0	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058306	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f038a135-8a1a-49b5-b0dc-ff6843b0af91	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062808	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
163fe1c8-41c4-4fe1-9013-ac031e2eaed1	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050164		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5480dc45-b16e-409c-a249-5072bd5772ff	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063034	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e38e1fd7-db92-4258-b231-65d999de2178	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013824	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b19a4480-2048-4e8f-bd78-4c0c9cd88d5c	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014609		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a52069a4-d722-4b65-8d88-398fdf3d2ac5	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c91dec81-2225-4a8b-93c8-7564127eb020	악세푸정	653801970	637	0.3	0.3	0	8806538019765	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bbc29c7e-c3a8-464c-873e-c2d1d26f8126	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013770	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
16ecb328-194b-49fe-b5d7-bb28998c0960	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
36c5433a-119b-4806-ae34-a72fc8715a22	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051130	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a5131cae-03ed-46d7-8d72-9e846fa4a2a3	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014265		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7b0d62da-f2e9-4aa7-a1f1-61d1f4e9e2e4	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046938	1000정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c56ae6b6-0e48-457c-b532-18ba7a54d38b	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061917	28정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d93896b8-2ccd-4c69-a4bb-54b9de564741	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048802	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ac3f03e6-b541-4da3-93a4-f72dd2d7f664	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056616	60정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
15fe7df5-0eac-4a69-a79e-ca9e7c5bcdbd	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017624	50캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b81c71ab-1158-40ef-89e0-1fe968d90d65	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
08948248-6c69-4dcc-965c-821cc3f623be	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062204	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ad6ac233-60a3-4cc7-bd1e-63761d72f4d0	엑세트라정	653802140	162	0.4	0.4	0	8806538021423	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f0c02d6f-1144-450f-ad38-121ece3299b0	악세푸정	653801970	637	0.3	0.3	0	8806538019703	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
00cf0ed7-1795-4543-9cbb-390c45a78f20	베포케어정	653805460	126	0.32	0.3	0	8806538054605	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
28479c15-75b2-48f3-b2e1-45b44468524c	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013602		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9d6172b5-5294-4b04-ac1e-179a98567cc8	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051031	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9c92e380-864e-4e1b-9567-eb2aa6a97c54	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011448	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a9587e2a-3b27-4710-8fef-621ec58e303f	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003658	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7242622f-c934-40f7-b712-08fe8a806615	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002712	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1313b91f-4989-45fb-82d9-34629dc8a808	후리코정 5mg	653802890	25	0	0	0	8806538028903		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2c5684b9-aa2e-43fb-8f8a-a215ab365719	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044415	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0997b475-917d-4bbf-bb45-d732a3b97714	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053233	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b3b34b73-46a1-4580-9689-3ae4d673f360	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003627	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e72672f9-9dbd-4444-9acd-da6dce238c9c	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053332	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1efcfe11-bbe8-4cb9-8e3d-ee4a690d5829	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012124	500캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f47bfe81-ec05-4c5d-baf8-2bd312863279	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061801	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
042cb1dd-effa-4a5c-a446-91973d0193bc	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044019	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fa674b6e-c31b-4ba5-b70a-324257a8a998	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050133		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b79b7001-0d34-4fcf-9df0-0b579790f037	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060309	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
57ae1003-dc3b-4bd1-865c-2876eeab9d87	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053509	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
866353fd-2e67-4172-ab71-208ac104c586	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061504	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4d9b7f2f-a5e1-4fde-89ce-50d248767834	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053905	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1c56cba5-2306-4fd2-a103-e58582615c0e	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006314	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
65de46e3-fc29-4a09-a866-2fdb1f0940bc	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053400	(소분)	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
67bf738f-f12b-4d8f-bbab-601886e16f1e	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013749	120정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
871886cc-4ecc-4a79-9bbd-8f34ac11de9a	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062952	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
81bb8d90-3d59-459f-9678-b1cd9946c368	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062846	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e6a7f199-9509-4468-b07f-425901eade9d	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049823	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
de1e8f59-dcef-4cf1-be2e-044da90baf92	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
dcf3871f-e3d5-4b69-a778-d3a44c73d5a8	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053424	30정/병	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6d1b2446-a470-4287-bb43-195a9701adbf	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055626	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fef74543-3e42-4943-a834-d58754c6da38	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053523	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
765fb91b-cce9-4dc2-9c38-f46842e7315d	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013831	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f153fc79-03dd-4dd1-acfc-f6f6d4a36287	테글리정20mg	653806020	665	0.35	0.35	0	8806538060217	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cb0a8f9d-8a4a-4678-93dc-65d2cf88c4d7	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062617	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
40184f8c-5215-44c0-be33-c11faaf5faf7	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062921	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
09a6c964-0e04-4fd0-9542-4bc5065d8eca	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1effb197-b775-494a-8f6c-97404879c729	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050119		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f8bb2dbc-70dc-4476-a685-38118249e78d	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059105	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8d214e4b-8963-4832-a737-9bf0c5f5e6c4	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060729	14정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
eabdd861-880c-443e-bf12-f378bf877181	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
295294f0-2cd2-4b05-821b-d7a7ffe599bf	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053318	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cc7da8eb-d41c-45eb-a909-c8b52ca86db5	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004402	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
54c89b99-595b-49cb-b424-49db786317ed	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014203		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
39fff431-71ad-4b02-8f06-9d46aad9ddcd	엑세트라정	653802140	162	0.4	0.4	0	8806538021447	12정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
20ca1636-62b5-4c0b-b079-d538d9963bb1	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062112	56정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a60278a7-46cd-4730-aff7-6ee7dd604f9f	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021331	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
28437389-f70c-41b2-8b24-90b46409bbb7	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010953	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
41a6f2d0-68e9-4cbb-bfd8-5b566eca37bc	메토르민정	653800580	70	0.2	0.28	0	8806538005836	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ad2e40b6-7bf7-4004-ac81-df9c9657c1c1	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002705	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
591b8596-49b8-4f8e-8b22-ba09373410d3	맥스케어알파정	653804520	277	0.05	0	0	8806538045221	7정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
708d9393-e860-4281-bfc4-e59fae102c7b	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049809	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
47f54398-8fc1-446b-9543-63014adc5e53	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060118	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
32607f11-5bae-482d-9d54-f6cc616754f6	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013701	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f4275efe-bc56-4b8d-a8ee-3c821e01b7b1	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ae1e51c9-104f-4c53-a60a-52a510eb057e	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003603	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
15bad58c-d3c6-4a58-a523-aa24e0c5c0d6	엑세트라정	653802140	162	0.4	0.4	0	8806538021416	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
430ec7a6-f003-48bd-8133-cadf800c70a9	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021614	100캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5e193c37-2ea0-47dd-abe9-2291cf7ececd	스티모린에스크림	653800890	4180	0.4	0	0	8806538060026		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e3993e28-756e-4e8c-9e07-8bc13a0ee91a	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053516	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
eac2ab3d-2b60-4ec7-8b10-52082b466970	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a9dc10bc-2a97-4dc3-9076-e76a4beb9598	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044002	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
14e4b81c-9580-4e8c-a7a3-dae7f10f7912	악세푸정	653801970	637	0.3	0.3	0	8806538019741	20정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
33116563-db8b-40e4-951c-5ffb8f8dcfb9	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011035		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
12a4750d-515d-417d-ad4b-3d634c91b03f	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062907	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7e80df53-e7ba-455b-9048-c89b36466e03	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063805	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
75eb9c20-7a04-4ecc-b504-9ba3e9db877b	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009001	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a28e5f54-2339-4485-9be7-63f5230ab1af	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063812	8정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6cc50b9b-e666-49d1-9c57-271b6be89323	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011707		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
068d9b0a-f737-49b4-9f2d-c17661dbd155	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058207	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ac97ec7d-7e95-423c-ac2f-fd985e9e749d	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013756	5정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
859a351d-a67b-4ba6-9cde-ed952b1f29ed	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003910	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b154975e-ad6f-4616-8085-6b2010ca65c2	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054117	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
014ebddb-9ce1-4eba-91be-3f5ad7fd4afd	레보라정 25mg	653800330	119	0	0	0	8806538003313		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8ad80113-b4ca-4950-a1e2-30b840406caa	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054001	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5cea6634-b1ca-4b0a-9805-d396c9d71be7	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052908	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f2c398dd-8cc2-46a1-b521-3ebcec6de727	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061207	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2543bcfd-811e-4eb0-8b60-105be44e2ade	메코민캡슐	653800570	50	0.1	0	0	8806538005720	180캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c78de9c4-04f1-444e-a364-d350cf0c3a11	무코신일정 200mg	653800620	70	0	0	0	8806538006222		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5a556939-dc95-4251-ae1a-11eef9d6e570	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009018	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5a596024-e0e7-4a99-9c7c-22fcaa185d72	신일세티리진정	653801190	161	0.4	0.45	0	8806538011905	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
73333b80-a658-45d9-9ca3-0c78a9f9764a	신일세티리진정	653801190	161	0.4	0.45	0	8806538011967	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
67934fdc-bcf2-4dc9-874d-8fb80a7459ef	신일세티리진정	653801190	161	0.4	0.45	0	8806538011936	1000정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
31581598-26ea-45b9-8056-d009ba5a47db	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048222		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6c9095f8-e6d4-444c-bd63-0f30fa69a472	에이낙정	653802100	188	0.4	0.55	0	8806538021003	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0a91bebc-6333-4671-8af2-804172cef43c	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046921	180정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f16be939-71c5-45e8-b89a-ed0f5ffa17b2	신일폴산정 1mg	653801510	15	0	0	0	8806538015101		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9181c3cb-b1ed-4c52-9604-6f14c54bf1a4	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054506	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2308f582-8d75-4c39-aca9-a6d36df17bcc	에페릭스정	653802110	115	0.35	0.38	0	8806538021133	500정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6c1c3822-3d7e-4cfa-9975-c7a5723a1ca6	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051024	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6718fa64-1263-4a8c-8d4e-39712c4901ed	에이낙정	653802100	188	0.4	0.55	0	8806538021027	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5a575c0b-8d3a-4cb5-9772-47ddbb0c5a95	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061306	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
414e0d8c-56e0-42ee-a8d7-2239da4ebb5f	메코민캡슐	653800570	50	0.1	0	0	8806538005737	500캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b28a9590-d12a-4b80-8995-9d9d30171318	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062235	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2f7dbb86-905a-45aa-ac45-1dd04916e635	에이스낙CR서방정 200mg	653805620	352	0	0	0	8806538056210		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a5820fb3-da1c-46e7-ac2f-205b3217c0a0	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062037	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6eb3d524-969e-456f-8580-5606658ab091	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006338	10정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4019aab0-fcda-47b4-8bd6-5684ea1d8286	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061603	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e486c31e-4d65-4088-9c7d-be1bf7687441	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053929	300캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b6bd0329-0d0b-472e-9a45-1710103329fb	오로페롤연질캡슐100mg	653802190	115	0.35	0	0	8806538021911	500캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
39277836-f1a8-4df2-a295-f362e8d48a17	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034614	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
81d910d8-efdb-42ea-a98c-21ae7d8e4150	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047102	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fbb0f8ce-0e1c-4780-a6e2-d621a86185c2	악세푸정	653801970	637	0.3	0.3	0	8806538019727	50정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
524adbb2-f6dd-4385-8e86-81731a40c7ca	아미나엑스정	653804740	387	0.35	0	0	8806538047416	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
62204d25-7d0d-46b5-8ed8-00fdf0433c66	신일피리독신정 50mg	653801720	23	0	0	0	8806538017259		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
431b90ca-5eb0-4fcc-be5d-cb46d6dd9a72	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010939	180정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
50aef2f1-9b6c-4226-9ab9-8faa19370eec	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048215		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7c04211a-04b9-4368-9157-a5bcb695f504	신일엠정 500mg	653801400	22	0	0	0	8806538014005		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
961b68d1-5284-40c9-8201-5f1985e1429b	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013732	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6c44447c-733c-4938-9090-a320e61ce3c9	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013107		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fa2d1ac2-bbe1-4a1e-88c7-a022523159ad	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051017	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ce51f7d3-1b29-40f8-b2c9-cf3a3b11fe78	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057101	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9df3728d-b8c2-4ff5-afed-5526bc34259c	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047119	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
70ed0421-c8f6-46ea-82e8-28aa97045cd3	메코민캡슐	653800570	50	0.1	0	0	8806538005713	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e6ffe37d-97a2-4b02-8d48-eafe9f320b83	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004419	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e854089c-dff3-46a8-bb04-c33d5fab683b	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058221	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1070febe-509d-4d8f-bae1-a69b36616c9c	테노브이정	653805260	2505	0.45	0.47	0	8806538052618	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
95137a68-d685-425f-b16a-1d93712d3b34	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054124	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d3340511-0de9-40a7-aaf7-7543a51e6732	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003221	500정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
7faf4863-eef1-48be-bcf7-716c96ae815a	디누보패취10	653804860	1586	0.3	0.3	0	8806538048635	30매/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1cc95181-89ea-4699-be8a-fd5f48a4ca25	디누보패취5	653804850	1283	0.3	0.3	0	8806538048529	30매/통	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3e3222b2-b51f-4066-814d-ab0374f20dfe	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053431	100정/병	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ee14e128-0bbf-411e-a766-bcb1ec67724a	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0bbda3f0-f44e-49ee-b228-965bfe46f579	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
96d5b8a1-f6d9-4fbf-8c0c-058abcbd6109	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049816	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
dbe109e7-7f70-4cf2-8f4c-e57394116ab9	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
33b281e1-29ff-442e-bb88-bba61282351b	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034621	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f6f80e23-56d6-414e-8d45-82bcb39e2c2d	테글리정20mg	653806020	665	0.35	0.35	0	8806538060224	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
30c5bd76-d49b-493c-a919-766b2bfb4253	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057316	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8247a73e-efa5-4fee-bcf8-d24a5159c1b2	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062105	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
46101678-7d67-4125-bc79-b29b5993c3ca	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050140		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
118e1b3d-86ae-4a16-aaa1-b7bc02c62843	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062709	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
60b078f4-25f1-404f-804b-e6c5749ddcc5	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062631	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
66eb8795-dce8-4cb9-a7b7-57b0c659308f	브이디썬정	653805980	113	0.2	0	0	8806538059808	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8765f34f-1d9c-437c-9a87-3369cf02c07f	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027517	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c1ba73f6-3966-488c-9039-6ea558008630	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057309	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
985f4a95-5128-4663-a274-7767feced6c4	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013763	10정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d1430f7e-9252-425a-b993-acd75a2bf1f7	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013725	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0cd44a22-d985-4075-adcf-20242f4cac06	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044026	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a7aed463-620e-4d0a-8ad5-d4698901d15a	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
08f88a97-7658-4958-8e21-a55e9a651266	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049311	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
077eec88-ee1b-4d16-aac2-79074dd75241	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
35164407-5f73-4b10-b0c9-c046023f80cd	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6ddb4076-eb06-43de-9763-eaf702676d48	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
fd6f02fa-02ac-489d-992e-402da900f907	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0a485f4a-5454-4fb3-bcc8-eaea34c929a0	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006307	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3cbf12dc-5013-4531-acb8-a0bac51d1e15	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062532	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a8cbf82f-dad4-49c1-87cb-40bf16523996	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060712	7정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b15b8613-57bb-4c0a-9eba-6e4ec9e6165e	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054018	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
12766983-573a-48c8-96da-082e26744707	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055619	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
641ce6bc-0df9-4d92-a707-8217a0699be1	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047126	60캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5197eed8-9ada-493f-bb4c-383cbd5d0581	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013718	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
772de71b-8f0a-4e21-a872-c07fc90a1744	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056418	1포/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
676fb76e-5e05-429c-85cf-dba88a54af4e	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059013	30정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ac1c2de9-9563-46de-b830-14d97bf75628	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060705	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d13f8ce6-85b2-4340-8870-1aa10a0dcaa3	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056401	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0e6c8c9b-24d1-4768-8b7b-457144b7bb58	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006321	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9e1597a2-6de2-42e8-b62f-03c3be722bd8	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063010	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
985c323a-fc53-46d5-8670-5ef7ee4b3d8d	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051109	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cf98712a-6e39-4520-ba4e-8e2e1c7d0a5c	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060408	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4e0abf2a-8dd9-4a2c-afd8-4f1e934750dd	메토르민정	653800580	70	0.2	0.28	0	8806538005812	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8d80e719-9b7f-4669-9f60-69dd061d9992	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011417	90캡슐/Foil	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ec594079-0acd-4649-8678-5945cdf3f82d	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062525	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3f02c473-3913-43bd-b5fe-52f9269671d7	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
240302fe-47c1-4219-893d-6ae5df68f845	신일아시클로버크림	653801351	2400	0	0	0	8806538013510		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f873f1c0-28b3-41de-bd78-9f081ce3fd97	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048925	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
86dd563f-b117-4d94-a026-f4f8618840c5	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
30afb644-42f5-4dd1-ba47-c48c49590e8b	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053219	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
befd839a-d909-4ed7-ad2e-9a9e07f9cf23	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021300	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4d5d7b45-ec92-4060-961a-e2b09beaf838	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054100	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
0a97cb4a-3fff-4a69-88f7-a4706f63e9f5	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058313	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cd104388-bd2d-412b-af7d-4d4c6fca8624	디누보패취5	653804850	1283	0.3	0.3	0	8806538048512	1매/포	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
58b9c852-467b-47a6-9436-26bc86c3c114	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056609	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e71d58bc-1743-4875-90ca-e59e97050ee1	브이디썬정	653805980	113	0.2	0	0	8806538059815	240정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
329a5c3b-5c14-4c38-badb-9d1ab3e85352	자누다파정	653805990	846	0.23	0.23	0	8806538059914	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
069c3de4-763d-47cd-8b1f-4d58affe4d08	신일세티리진정	653801190	161	0.4	0.45	0	8806538011943	100정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
89c1f0c3-98ab-4505-932e-a09e86dbc485	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054513	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9f6ba595-8287-4ad0-b67d-66929907b8d8	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049014	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3d826879-753b-494a-83aa-e2b17a3adf8c	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010977	10정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f4372eac-c935-4e6c-8b2b-0a72446d9e16	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014647		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9cb16791-d031-407c-bb85-45853d4f4b81	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062006	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
47dad93f-6a17-47b5-8557-07cbc53365be	에페릭스정	653802110	115	0.35	0.38	0	8806538021102	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e1da4e1c-4f84-47ef-89d4-e7241f511406	에페릭스정	653802110	115	0.35	0.38	0	8806538021119	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2cb0e439-d85a-4671-bbbb-6b43c96d864e	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048901	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f4eca084-c4b8-4df3-a840-badf3a711bc9	에티브정	653805240	480	0.33	0.3	0	8806538052410	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
84340b47-d092-4503-9faf-e35fe6a5790a	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053912	30캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3dd3685b-117e-4ec7-a25b-6bf9d935d51e	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049007	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2c02b8eb-62ed-4d12-8ea2-f70dc49b855e	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062013	56정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
d5a391eb-06a3-43a4-8f3a-c7ec6056b9bc	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021621	10캡슐/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
95a6bd64-4338-49ab-a9ea-e58394611eaa	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061924	200정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cbed944d-de75-48b4-aa4b-38152f1bdb9e	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013121		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9e137b02-2fc1-4876-8b2b-5f030ca4af77	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021348	12정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
449df276-9c5e-440d-9248-73e1cb80996c	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061214	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
cc15b4d8-5933-43d7-8154-3193803e28cd	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011424	300캡슐/Foil	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
66bb0a02-d8a7-4631-a35c-96c5a36b304d	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061511	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2e833148-a928-4f1a-a910-10e0a300e88e	액소도스정 60mg	653802050	0	0	0	0	8806538020518		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3f34e9f8-8de4-4180-ac45-2066f2540e57	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010922	90정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
20005109-4b5c-4497-88d5-5609bd11bebc	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053639	100정/병	30		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
33e7035f-f960-4524-8985-da2004cc5e5b	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
226ec4d1-4138-4e36-ad27-4ebb4c82d563	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052502	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ce36c134-97a2-439f-be96-4164328fbd7b	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054025	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e07bfa17-42eb-41fb-bc77-b3ae389d26eb	메코민캡슐	653800570	50	0.1	0	0	8806538005706	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4e85647a-a235-4da9-8bfd-61006092a5d2	메토르민정	653800580	70	0.2	0.28	0	8806538005805	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
61ac3489-0d1e-4eef-978b-1e0df25a6879	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003903	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
649d07d7-1476-4f76-8d4c-8b6e6b2e5229	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051116	28정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c7c0f0d5-49bf-45c5-94d0-bdabcc542748	자누다파정	653805990	846	0.23	0.23	0	8806538059921	30정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
453ef128-0789-4931-ac74-e78b63268eac	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052915	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9b011e04-5209-45ce-b58d-c626b9225b55	레보라정 25mg	653800330	119	0	0	0	8806538003320		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
ab094b5e-f5f4-4140-9a61-ac61299d8eed	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051123	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e568036b-0431-4ed5-8a22-1a7328f5efe5	맥스케어알파정	653804520	277	0.05	0	0	8806538045238	14정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f9b04eb4-96a8-4f99-a408-1b55f0c1d18f	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003634	500정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3944289a-4685-462c-b271-eb21f6687919	후리코정 5mg	653802890	25	0	0	0	8806538028927		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2d30d105-bfda-4e8c-af85-4c5e80699f71	레보트로서방정	653805950	189	0.35	0.3	0	8806538059501	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4be9b80a-ba49-4e5f-b46f-e0a80be8361e	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011462	90캡슐/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
f799e052-c9ff-4f7e-a00c-bea5b10604b7	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047201	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
a3441ced-7838-45ba-b693-ab3188058094	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062938	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
4cfacbc4-efb3-4fad-8a99-a9d05f2d83d9	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002729	28정/Alu-Alu	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8bc3dfc9-b21c-44f4-8842-379f61923729	레보트로시럽 500mL	653800341	18	0.3	0.35	0	8806538003412	500	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
b4e110bc-ee22-45e8-b3bc-edbca3e3bba3	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010960	100정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
743b98d5-ffae-48f1-b049-7a5e58d4ded0	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062228	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
1aea9f65-357f-47e8-9cd6-26c532ba0dc4	디누보패취10	653804860	1586	0.3	0.3	0	8806538048628	30매/통	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
70aeaf98-c3de-418c-86aa-2c542c009406	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e3e743e3-1e88-4fdb-a66d-2f123751751a	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063027	60정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
c2ce5615-fb79-4410-b862-5f95bcc50e48	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027500	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
8ae4cd41-0501-4038-973f-b6a3a2ea20b8	신일세티리진정	653801190	161	0.4	0.45	0	8806538011912	10정/PTP	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
79b3ea54-dc34-4f81-b507-48a47e0d8468	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053325	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
6fb01c0d-3f5a-4b08-b422-cfdd0cdec336	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3380b372-967c-42e2-a094-919ccfe573a6	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
bc907b7b-f5bb-40ab-8960-b0727eb5ace1	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063706	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2e96bbef-2e3d-4520-b4b2-8a0fedf5972a	액소도스정 60mg	653802050	0	0	0	0	8806538020570		0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
74d4d533-f4c9-4846-806e-663d06f6f9b3	자누다파정	653805990	846	0.23	0.23	0	8806538059907	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
996b8c54-f3ef-4a85-997c-06e6ac4f3c25	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061818	28정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
3707ee38-2002-4c29-b155-b509f4ad0375	악세푸정	653801970	637	0.3	0.3	0	8806538019710	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e0b30a87-b037-475f-b24f-fce59963ed0e	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009032	300정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
2a4ecfb7-2093-4cf8-8199-2f11f3a47113	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058108	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
9298117e-dee6-43f9-a24a-6268cac1894e	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003207	(소분)	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
730356bd-58fa-4517-b33f-3f8cf6f86a16	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044125	30정/병	0		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
e38beed3-f353-46ee-929a-ef93f73d0739	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:02:48.574436+00	2025-07-21 06:02:48.574436+00	2025-06
5e6a9fcd-a979-469b-908b-c99869bbad23	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063713	8정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c3ee4a4e-8e95-4190-876f-5ee328615073	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047218	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2d79e605-a043-4f5d-bfd1-c9861b7aa611	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f634ce90-5824-4f63-95e2-0b7859e853c8	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013428	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8c2290e5-9c43-4fa5-ab86-219b1c95b750	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063058	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cc6934d7-5ce9-47f9-b55c-503543f12129	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027548	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6441df37-f2a8-4f36-a4aa-d308817c5c7e	에페릭스정	653802110	115	0.35	0.38	0	8806538021126	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
84f7a67f-01e5-4c2a-9aec-f04691735040	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062815	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7100a04f-3a9b-4b8f-a0a1-02f892bfc1b8	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046914	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a6ac3226-1c83-451b-b860-afadd0cc3fab	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058320	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0155ebf2-1191-4809-beda-12748b37ecc2	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011431	500캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0e56e51f-bfd0-4d42-80ca-68d8e3c88fd2	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062501	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e611f672-f649-4005-9ba1-ce4fa1124aaa	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044101	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ed019e7f-b752-4940-9f40-acc1aa123392	맥스케어액트정	653805970	275	0.1	0	0	8806538059716	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e6d447bf-36e2-40e4-b665-e502b4c51f05	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013404	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ac76611e-9b69-47a2-b2aa-c03835dcd1b8	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021638	100캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
985a147e-50ca-4e25-84f7-724f05945576	레보라정 25mg	653800330	119	0	0	0	8806538003306		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
feebb737-baf4-43d0-97a7-50b4a943f435	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062853	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
486eadd8-77f3-46c0-bd48-7d98928f61d9	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063041	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bc1114f2-9be6-4ac0-a450-c96ab4de3b37	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053608	(소분)	120		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6ed9f7c3-eb34-4796-ac8e-3e1748432c0e	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017617	30캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
af013da3-a4ed-4ab0-b1fe-acf1682ffe71	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010908	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fd33d5f2-2c27-4cf8-8c2a-a4bcfc00ccea	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061627	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
36f93826-ab95-4998-bec0-a22be7c82fdc	스티모린에스크림	653800890	4180	0.4	0	0	8806538060019		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f5cab3e4-d800-4775-9b1e-e1a3febc8a72	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034607	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ee5ea512-d5a3-47ea-a37f-23f4c31d5547	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bdc3404a-8f02-4416-9286-6119858d137d	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011080		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d4b3dbc9-05a4-4c7b-8cae-55a1f199c43a	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027524	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3a016aa3-d31b-4ccf-ac6f-afdbab96da22	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062600	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
11606531-a136-4807-9ce9-7056f541b743	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cc9a7c30-fb00-4f91-9f9e-7425e8f187de	메코민캡슐	653800570	50	0.1	0	0	8806538005751	180캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4ad14e3d-5762-499f-90a4-d83a064c8993	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010915	10정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b7b01406-3f8a-480f-a57f-eedef20a9b7e	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062020	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0043ab7e-33d2-488e-b1cc-e6666e4b73f0	엑세트라정	653802140	162	0.4	0.4	0	8806538021430	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8a5795a8-c038-4a33-95db-3b7a23d7a647	신일세티리진정	653801190	161	0.4	0.45	0	8806538011950	500정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8d004d6f-d92a-46be-b7b8-7dd64a51e919	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003665	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
49c5812e-1749-48ab-84b8-a11b5285a5dc	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013800	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3ca3217a-2cb9-44fc-92de-3a1a74715701	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062716	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ecff691f-67b2-4c2d-bc91-89488cf7ad6c	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9d333a21-0fe8-4454-8ae0-90ba956ac5af	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062945	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6e33e022-d3e8-407f-8de4-e841c7598191	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062723	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ba39eb69-b88a-48b2-8055-bfaf57652ee2	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c163a36b-87cd-4256-9b81-0cdbfe55283a	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051000	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8a422d6f-d802-4088-ae19-66e89355115e	신일아시클로버정	653801340	625	0.45	0.52	0	8806538013411	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a0bddb1a-9684-43f5-8024-e7343e0ad72f	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061900	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8a4dca7f-3aa7-4172-b34b-eebe8c33bc36	신일피리독신정 50mg	653801720	23	0	0	0	8806538017204		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
975907ad-7fd4-4697-ba0d-fcc88575e377	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058115	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e13ef951-512c-49f8-9994-10edea6d99df	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021607	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6669d8a7-108a-4c24-9e3c-98c86f6b6137	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013626		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
41c8195c-fa2a-4ce8-844d-7c8a07878f35	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052922	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8bbceeae-f271-4982-9c1e-c09a74e14245	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057323	100캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
99ff47e0-99b3-4b24-b0c9-0289f0e3c50c	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062402	(소분)	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2b97a6ed-47de-409e-ae7d-efd8bf4a07d5	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044132	90정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5c876d2d-44b8-4b92-a135-391b9f5392ad	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047225	60캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
604efc59-3333-433d-ade1-13adb2942744	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050157		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c09d0726-6fd5-4211-abc4-ff33fcbe33fb	신일엠정 500mg	653801400	22	0	0	0	8806538014029		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d2783e4b-7270-4874-adf6-e5672ad4838c	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012131	100캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ca1a2364-69b7-4768-85f8-f777f6f342a3	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062839	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2ed57f7a-9609-4966-85ed-fc140f7f947e	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011400	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
791d2907-4365-49bd-a956-825460fd34f1	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060316	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
66cff566-b126-4738-9ca5-4685e2d0da19	맥스케어알파정	653804520	277	0.05	0	0	8806538045214	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f5d24fc6-501b-43af-9fe2-85d72265b649	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017655	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e59ce394-dd78-45f6-8871-74182731357c	디누보패취10	653804860	1586	0.3	0.3	0	8806538048611	1매/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7db59890-2f62-45fb-89c1-314101640d56	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004426	100캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
634f6815-ccbe-4be6-b7a7-f9bd41d83961	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052526	100캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
04272e21-2a90-4063-bfeb-7f0d0fd61473	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010984	90정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
34cb1e85-a608-4934-8a18-2c859bb7d619	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054520	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e73921a2-24b1-49b5-90d7-33ad31bd5ae6	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061610	28정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ebe8dffa-5564-4214-88f6-3f43b877b126	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062136	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
40b7e8ae-09e6-49bf-b142-bfa649ce5213	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048826	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
16669539-4899-4350-939f-d9cf0e6a6e87	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017600	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
376638c9-f895-4bd6-bc93-edac10be8bba	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012148	500캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
287d03db-9ce3-4199-b4b2-aec285f85891	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011455	100캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0dd63209-5a3b-44ae-a26f-ad39bf9c75f2	레보트로서방정	653805950	189	0.35	0.3	0	8806538059525	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
709836df-1eca-4111-b062-07d87aaae923	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053301	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
69a549a8-f7bd-489f-b1b2-5e21fbbf3e20	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f80d31cd-02bc-4d2f-8b9d-b843338f3734	테노브이정	653805260	2505	0.45	0.47	0	8806538052601	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f77a5078-dcde-480c-8a9b-31fd3ea6c13d	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062518	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a1c66fe0-f92e-4bf5-8cc5-eb40db563a28	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062549	90정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cf40732e-c510-4c5a-8eb2-09a79d04fef2	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
add927d5-da75-435e-9c05-70b5ce258f76	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
77b0ce1f-37d8-4a63-b69f-f341384607b9	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062822	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a7ca4d91-0be0-43c6-926e-eb4556989809	레보원정	055100040	114	0.2	0.25	0	8800551000410	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d2153809-ec23-4530-aa31-5b5b9606d1a6	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009025	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
60c26c23-22a0-434a-ba9a-96fc43a3d6b7	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000220	500정/병	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
15dcc549-3ea0-4016-93bc-3442c70dd3c7	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053417	30정/PTP	100		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b6d1f44e-1f18-4d51-9a7c-220c8e6fc390	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003214	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1430d05e-88e2-434e-98f4-4358608e3350	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061825	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9209c946-bef3-4282-a1f2-a5eeca2d644f	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012100	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fd1e9924-daa8-4eb2-ad78-575835b8d6ea	악세푸정	653801970	637	0.3	0.3	0	8806538019758	50정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
545f2875-bcb2-414a-a7aa-45d8445d14b6	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061313	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
197ee9d5-2a83-4c4b-a2bf-e404dde489fc	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059006	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
71ed8585-d897-4446-869c-34ae81eb6487	에티브정	653805240	480	0.33	0.3	0	8806538052403	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6f24229e-2ca3-4d72-98c8-9f722004b5b2	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010946	1000정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cee5eeea-4cf2-4d3e-86e7-ce0cfa138775	베포케어정	653805460	126	0.32	0.3	0	8806538054612	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6380e24c-633a-4782-9188-fa94fc37cff7	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021317	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8dd0e99b-d085-4479-b360-6196458e2d0f	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055602	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d3bcd1b5-2dbe-47c3-813b-c88dce952dc5	판스틴정	653806230	88	0.05	0	0	8807000000000	10T*30	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ece2ff8e-dd2c-40b3-9271-964646dc62d3	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027531	5정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8beb6119-953f-4e49-9bd5-dd963e99aae6	악세푸정	653801970	637	0.3	0.3	0	8806538019734	10정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9d4690ee-f91c-451b-b1db-af5a0932fc38	맥스케어액트정	653805970	275	0.1	0	0	8806538059709	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4e96f33b-e0d2-4e5c-a26e-46ca30fcecd3	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003641	90정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f402b07a-cea6-4eed-81ce-9e6edddda740	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057118	60정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
24666a6f-ffa6-4e89-8434-a92eb0ceefd8	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fa0f033b-1950-4aa1-924a-3d6134b60216	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060415	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8cb45c51-7f9f-48a5-900d-67aa5e987e45	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049304	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bb10cff1-b3bf-4249-81d0-29c92b07dd28	디누보패취5	653804850	1283	0.3	0.3	0	8806538048536	30매/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
df8f8f84-1466-4495-8a36-a7ee32e0dd64	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053202	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
554d2352-e0b7-40e8-abe3-a6c71b6fbf9f	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044118	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1e710bfa-dfbd-4848-8bd6-9dbee664519c	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056425	20포/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3d6dfc27-a13a-4367-b95d-5f9b1e204c73	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060736	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1d74e2e0-9b8e-43a6-b159-3730d16fa751	코린시럽 500mL	653802381	11	0	0	0	8806538023816		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e5c84a65-65cd-43d6-97bb-48924580635a	디누보패취5	653804850	1283	0.3	0.3	0	8806538048505	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
44679a8b-3482-4f2a-b724-d0f7dd90c3b4	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012155	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a3fc3951-5c94-4695-913b-16d9c8caa904	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062211	56정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
974ebec9-869f-42ae-b8ae-fda3e9898821	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013640		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1a2cd382-7905-46dc-a9ce-74ba7eeaa550	디누보패취10	653804860	1586	0.3	0.3	0	8806538048604	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
12fcaef4-d311-4066-bb82-66a10f53fb71	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062624	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
631aed0a-e886-4e19-bfa1-5436e66ed233	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049830	90정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e18bb43e-4d21-427f-841f-864598b3de73	무코신일정 200mg	653800620	70	0	0	0	8806538006208		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a9e88180-77d5-4890-9b85-926779d21c99	에이낙정	653802100	188	0.4	0.55	0	8806538021010	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ed8cea1b-c935-422d-94f9-b4177e1651ca	맥스케어알파정	653804520	277	0.05	0	0	8806538045207	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3d0ffa03-474f-4ada-9a40-2815d9907c62	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b3294a3a-e632-46e6-8564-b89c21bd6af8	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044408	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8b499d63-d8a8-4075-b804-c11fa8688104	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021645	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a10421c0-65b2-415b-8995-251d4bd94acb	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
90e8797a-b34c-455f-befd-93c3b0ee9c27	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056432	100포/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8c80881b-62fb-46c5-826e-b730da1bc12f	이부프로펜정400mg	653801580	30	0	0	0	8806538015811		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e6ecd23d-2dd4-4a7c-9086-d79bc190304f	레보트로서방정	653805950	189	0.35	0.3	0	8806538059518	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
46d66910-998a-48f4-bdc8-1f38bfba04cb	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058214	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
efaff703-4e19-42c7-bccc-94582843868e	베포케어정	653805460	126	0.32	0.3	0	8806538054629	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2f6d5c92-db60-4fbe-9643-27869c7f9e47	메토르민정	653800580	70	0.2	0.28	0	8806538005829	500정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
346dbf11-a01f-40c8-a0e7-f5f152da8ff8	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012117	100캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2d91223b-8b4e-4bbd-ae5e-ae3589ec5bb6	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048208		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7009cc78-082f-4a7c-b945-81943ce49390	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017648	5캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8e336a4a-3c87-4426-87e1-de70acef2258	신일폴산정 1mg	653801510	15	0	0	0	8806538015149		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e97e8a0f-1cee-4a58-b6f4-243951f40e52	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021324	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ed214d85-8931-4def-85ea-8eec029332b4	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061412	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
91a71da8-eeb1-4040-947e-547812afc594	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
579be8df-fec9-447b-9b1d-11a77a744631	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062129	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ac2d1293-2774-4ed9-a688-ec7b76183f67	자누글리아정 25mg	653806140	200	0.4	0.4	0	8806538061405	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4741ba66-b67e-4513-880c-d26efc76b9ae	엑세트라정	653802140	162	0.4	0.4	0	8806538021409	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ae560a38-54e0-4fa3-af27-33a5cd6f16d5	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048918	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
df1e3010-6546-4fa2-914f-92ae968d9a45	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017631	9캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4b242c2e-de63-4878-afe7-bfca04859629	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010991	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c4f11291-26e8-41c8-bd69-6a6e2cff3ca2	신일세티리진정	653801190	161	0.4	0.45	0	8806538011929	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5a7f135f-1b61-442c-aa92-fa36813d66f5	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011714		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4ba99f61-72c9-4cb3-b9d2-224ccd9b75ab	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052519	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
20063484-3806-4e37-a2c3-4b66174fa231	메코민캡슐	653800570	50	0.1	0	0	8806538005744	100캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3944c1d5-4ce3-472a-95d4-409c3006d073	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058122	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d7492f9b-f677-40e6-86df-438b05f01517	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003610	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
045876fb-61bb-4cba-87f0-02bc45626586	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
32ae33fc-fb6b-49a1-b44d-2b14df4d1269	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053622	30정/병	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d456b29f-b83e-43ca-9a67-dc4006d4554d	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053530	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
47b9729e-e0f0-4788-94a0-6fc0b9f06c4c	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000626	500정/병	28		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0f18458a-542f-44a1-9acb-fd05cb6c04b2	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060101	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c902270a-ad92-4c03-8b72-99f0da0f667c	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044033	90정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e6fd7bcf-83a8-4157-99a5-f1d5ecb7e1bc	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063003	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4cacf3bb-2913-48ca-987b-2536675fc9cc	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048819	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dc54831b-587f-4128-945f-5d8ae4945746	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062914	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
84182dc3-5cf4-41fc-b869-96f9b3c0c95e	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059112	30정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e3875d3b-3da4-471a-a881-670ac5bbb5b2	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053615	30정/PTP	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a91e9a3c-18ee-4154-939b-763c58100b7f	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013817	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ef0389b5-a9ce-4328-a326-bc7976477781	테글리정20mg	653806020	665	0.35	0.35	0	8806538060200	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
72f0c649-cf3f-4264-aa84-41686e254e03	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062730	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3cb7113b-e92a-4358-b69c-7ef2b4c365d3	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053226	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ee501446-7b17-459b-9f0e-f72b90ddf27b	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013848	120정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6be48141-6238-418c-956a-6e58bcf4ec7a	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c5de3add-2c5f-4d16-9c37-15a5d14572f0	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058306	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c7fb0953-fdb4-4a5c-8a55-4ed49e879e49	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062808	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a191f454-fb51-4f0e-a9f4-d979d9a50423	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050164		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
029bcc0d-4e32-4c6f-8fdd-c63268bd38bd	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063034	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6dd00ce8-094f-4f26-b461-3b714cda1129	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013824	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cb1bfeea-9b3c-4847-899c-e75946b8ab4d	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014609		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e3dd312a-bd4f-4aa3-82a1-7d723764821e	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ec0e1faf-c547-48e2-8aec-797767c5d33c	악세푸정	653801970	637	0.3	0.3	0	8806538019765	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
83533a45-95e3-48f2-b662-21807f92dead	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013770	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9759837d-0c82-4c55-8cbc-621f21ed58eb	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
37fdcfea-d4c3-4743-a8d7-17acc3a20aa8	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051130	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
77d0b737-a164-4236-899c-148f091e90a5	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014265		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
76d87344-3958-48b2-b992-b2ad2547968c	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046938	1000정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
881f0bf7-fc9d-4b9f-baca-d7b2d66f06dc	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061917	28정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7d561a7d-0041-4e3d-a0fa-a38fb00babbd	엑스포텐정10/160mg	653804880	959	0.5	0.48	0	8806538048802	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
61e10c29-3002-42d4-99f7-c22f0be4c4ca	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056616	60정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
057cb9c8-83db-48ce-8d98-c77243b94324	신코나졸캡슐	653801760	1784	0.5	0.65	0	8806538017624	50캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3a2eea26-1a86-4ba5-85a6-515e720c44b8	가모피드서방정15mg	653805750	289	0	0	0	8806538057521	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6f6fad45-da51-4932-8f41-73a20345dad1	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062204	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9adf8237-a6da-47d2-a04e-5761173fc02a	엑세트라정	653802140	162	0.4	0.4	0	8806538021423	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
653cac72-4ee1-4676-9057-274b47f8f5ec	악세푸정	653801970	637	0.3	0.3	0	8806538019703	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5b5ca051-0a18-4741-9644-a987e0bac9d9	베포케어정	653805460	126	0.32	0.3	0	8806538054605	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
64c60c33-19e5-44ec-9693-cc8076054739	신일아테놀올정 50mg	653801360	186	0	0	0	8806538013602		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9fd5ade4-5797-4125-8d36-6773968d356a	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051031	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b884da6d-7195-45d8-ad1d-b9bca85270d5	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011448	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ff459d34-6274-41ee-8384-264b55a04ecf	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003658	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
024055c4-7206-4dfa-87e2-773f41ab222c	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002712	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9ec55dc6-731a-410f-9541-1888db66e9a2	후리코정 5mg	653802890	25	0	0	0	8806538028903		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c8bd26bc-f715-4da0-92bb-b55495cdb486	신노바핀정 10mg	653804440	425	0.4	0.4	0	8806538044415	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
976d5884-6ad7-4fdd-a837-3627455cd561	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053233	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
01fd5478-16aa-48c1-ab82-374ba0c131fd	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003627	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
abccf229-5cc9-439e-8a98-3302ab963917	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053332	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ac394131-c9e1-48a7-a4f5-0804966bae5e	신일세파클러수화물캡슐	653801210	438	0.38	0.4	0	8806538012124	500캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
97673106-e678-40d4-a992-a81693595ef1	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061801	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
169798c5-25a1-4a41-8e27-973efa690bed	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044019	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
134a14f7-60d9-4c29-ba7e-0675756fd344	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050133		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
52ccd789-0b7e-4e3d-9509-9835437ef938	테글리엠서방정20/1000mg	653806030	665	0.2	0.25	0	8806538060309	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c02e8839-442a-402a-8031-e46130098eb8	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053509	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6f1e9142-507f-4dbe-a62c-2bebe806531e	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061504	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c22450a3-3282-4112-8791-b4b6794d632d	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053905	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f128b2f6-527f-445e-9d25-ead5b23f56b5	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006314	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8bf44d60-478c-4c1e-9a15-47e0a4747765	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053400	(소분)	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
265b21aa-79d3-4639-a636-df19ac6e5472	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013749	120정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dae69fe2-ff90-4cca-800d-ad76d8b29542	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062952	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
66113dab-a5d9-4aba-b65c-e8747df00dce	트라글립틴듀오정2.5/500mg	653806280	338	0.3	0.35	0	8806538062846	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
df947b19-52a9-4ca1-81ef-2db8449ce656	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049823	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
51a4c219-b930-427b-a5af-473835e39454	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
671c7643-03c8-4273-8128-94d9b06d82e6	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053424	30정/병	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a9e50909-a1ad-4f8e-8fd0-59039484834c	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055626	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bbd2968e-5464-4115-83a1-78a993b24283	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053523	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
03c7c1ec-241c-4c9f-bbe4-3fd989134287	리피칸정 20mg	653801380	712	0.45	0.65	0	8806538013831	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
61e514d3-a23f-4d43-ab30-725e07845441	테글리정20mg	653806020	665	0.35	0.35	0	8806538060217	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3cabf255-c98a-42a2-b153-947138517b9b	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062617	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6802822f-f3e2-47a3-b05d-4ea67aed877d	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062921	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
97b29cf4-fb9b-400f-b986-912a7989fe78	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
eb7db1d9-adad-4e27-b09f-11da83297352	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050119		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d8d5f11c-0f07-4a57-8545-fa8a2e05cdd4	리피젯정10/20mg	653805910	808	0.47	0.5	0	8806538059105	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
adb2eec4-d624-48a4-95b3-7f6bb00b3966	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060729	14정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
af242cfe-9e2c-4296-a13e-a84ffcdd69d3	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
939fde62-2c17-40e5-b9a8-578bbba860eb	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053318	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
92836349-54a9-44b0-8021-1e451c31a1c7	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004402	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1cec0f68-6517-4cc3-b5f4-3e1ba4f03e0b	신일브롬헥신염산염정 8mg	653801420	19	0	0	0	8806538014203		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0b72ee79-955e-4357-9002-2127bcbd1af6	엑세트라정	653802140	162	0.4	0.4	0	8806538021447	12정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
68023710-3ce3-4c67-a1c7-930183b241cf	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062112	56정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ef67242d-006f-4fb5-bc5b-d0227dd3d459	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021331	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2711c2b9-904d-4e1d-bb27-a55a485e3b88	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010953	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b600119b-f78e-4174-a173-c2ef5fb5b5ba	메토르민정	653800580	70	0.2	0.28	0	8806538005836	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
54a784bd-4a48-4a20-b9c9-8b8c9a95d927	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002705	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
65ea8474-02a6-49a1-9288-fe4fef49c078	맥스케어알파정	653804520	277	0.05	0	0	8806538045221	7정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6e3daedc-316a-4b3c-a303-0bd1f9a4e02f	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049809	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
018a6cf8-f69b-4fb8-b60b-240b14abca9e	테글리엠서방정10/500mg	653806010	334	0.2	0.25	0	8806538060118	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1c766380-d7aa-47a0-9b46-491511041495	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013701	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
13de8fdf-66fa-4de1-9ebc-94a0cb40907a	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031811	30정/병	100		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bd7a4867-f3fd-4561-8c8d-b16cb3f41eb9	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003603	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0d57873f-d289-49c6-9ea0-2508a4b32ff5	엑세트라정	653802140	162	0.4	0.4	0	8806538021416	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
097c11e2-9b6c-4c25-a9d7-4cbe2f808e3a	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021614	100캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5e092aaf-2b7d-43bf-a705-de51e3f86e9d	스티모린에스크림	653800890	4180	0.4	0	0	8806538060026		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fe232a0c-5c86-49bd-ac60-811b85e6650e	네오스타정80/5mg	653805350	725	0.5	0.5	0	8806538053516	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b174be28-f8ef-4c75-b91c-8972708c3bac	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000213	30정/병	28		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3835d8a1-34ad-4f8f-b2bb-909d545e45ab	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044002	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3efc5c4e-825e-4ada-9525-00f44799ee9a	악세푸정	653801970	637	0.3	0.3	0	8806538019741	20정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c067ef5c-694b-4665-a802-985680f92220	신일트리메부틴말레산염정 200mg	653801100	64	0	0	0	8806538011035		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d3acac73-6dbf-498f-a02f-77359cb799e9	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062907	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
72f47a58-151d-499c-9a3f-46d345aad5d1	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063805	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
843c7203-1c36-41be-9339-887582b8d427	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009001	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9ec0086b-0c66-4a0a-875d-b67cf8ec935f	실데그라정 50mg	653806380	1320	0.3	0.3	0	8806538063812	8정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b901d359-ca8e-4deb-a074-88eedc10a3e9	신일비사코딜정 5mg	653801170	49	0	0	0	8806538011707		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5f979f86-3778-45eb-b742-1c803dadecff	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058207	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b8a82d05-8ec8-436a-b0cb-9acd04a764df	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013756	5정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
07e64f04-db12-4519-bba7-a3a0993f5e9c	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003910	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9c8b5759-e7e6-4ea7-9d3e-35f0845de7ff	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054117	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a65a2331-132b-4b69-897c-9ed6b2ab2689	레보라정 25mg	653800330	119	0	0	0	8806538003313		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9f0da56c-7001-45a8-9ce5-d014d5c4f436	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054001	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
48a47431-1ba7-474e-8124-9a016d687c86	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052908	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3bf969f7-bc89-4d08-a7cd-b04860c8df2b	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061207	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9619a7b5-b1f6-40de-a5b1-bacb646cdd1e	메코민캡슐	653800570	50	0.1	0	0	8806538005720	180캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5860cba2-b804-45e4-ab89-940b60ea609d	무코신일정 200mg	653800620	70	0	0	0	8806538006222		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5f69505c-8fa1-4173-954d-be4f5e873649	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009018	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ff399be6-14ea-42c2-9074-e37c65118316	신일세티리진정	653801190	161	0.4	0.45	0	8806538011905	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0b887747-4833-47ee-b80c-a6ed68f96a83	신일세티리진정	653801190	161	0.4	0.45	0	8806538011967	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f7c82759-5a21-46be-b814-c67e51eeca25	신일세티리진정	653801190	161	0.4	0.45	0	8806538011936	1000정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
83fbe53e-9474-4a93-ba0d-87a9a2d5f7ec	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048222		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1e0402be-14db-45c7-a0d0-57242b63f523	에이낙정	653802100	188	0.4	0.55	0	8806538021003	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
aed90d8d-5fe2-4d6f-bd4f-a3dd00b90e05	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538046921	180정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
02b14f15-2f95-4d63-8dd7-574d0afb7bf9	신일폴산정 1mg	653801510	15	0	0	0	8806538015101		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7e074e43-4690-488d-9757-efb88f55e185	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054506	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2bb8bdc7-3ad5-412e-9420-7bb019879796	에페릭스정	653802110	115	0.35	0.38	0	8806538021133	500정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4d547d97-8d83-40d0-a303-662948e0c0f4	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051024	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5f6458fc-cd76-4761-b433-425972783786	에이낙정	653802100	188	0.4	0.55	0	8806538021027	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6dca4e5f-d0a8-47a1-8adf-1591ecf2d656	자누글리아정 50mg	653806130	301	0.4	0.4	0	8806538061306	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7c71fc81-4ba0-4a8b-b2f8-75197a9b4452	메코민캡슐	653800570	50	0.1	0	0	8806538005737	500캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d8537c71-bf0c-4d03-83a9-544e9d4cc423	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062235	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b2a269b1-8889-4a57-b1e5-f86334fbe2b8	에이스낙CR서방정 200mg	653805620	352	0	0	0	8806538056210		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
da4580d7-2eba-4d52-ba19-d64d1689e734	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062037	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
41361479-b557-41f1-8254-f4a5de639d74	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006338	10정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
246cf2b8-9029-4963-9511-0875bb43d70e	자누메티아엑스알서방정100/1000mg	653806160	572	0.3	0.3	0	8806538061603	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
88fc28de-16be-4bda-9116-89066ec5adc7	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053929	300캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a6fb5c7f-21ec-4d29-8c96-f7e1a97cff64	오로페롤연질캡슐100mg	653802190	115	0.35	0	0	8806538021911	500캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
096cfbe6-f34c-472d-a225-f356919d0cb0	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034614	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0d316838-37ac-4f8a-a344-e8379246756d	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047102	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
00cea18c-597d-452b-a43b-ee36b4781230	악세푸정	653801970	637	0.3	0.3	0	8806538019727	50정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6ba9990a-c6fc-405b-9df4-6018652484d5	아미나엑스정	653804740	387	0.35	0	0	8806538047416	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c62f3827-1b8b-422f-9f98-a277ce5889a8	신일피리독신정 50mg	653801720	23	0	0	0	8806538017259		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d7d1bfc2-af08-4964-b2ee-ba0d92c1b054	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010939	180정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dd7ca355-2f12-4f0a-89eb-ee70532a79dd	신일아테놀올정 25mg	653804820	94	0	0	0	8806538048215		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dfe9114a-8433-48a5-afae-4503d2d16390	신일엠정 500mg	653801400	22	0	0	0	8806538014005		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
eea21d70-a707-403a-80a7-690895b1e8d7	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013732	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
db4bd231-5461-4c68-b2f2-347e02f37b72	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013107		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b2b3f135-2bea-4332-9f60-7547ae8c27be	신에소메정20mg	653805100	764	0.45	0.6	0	8806538051017	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b54ec4f1-b1fc-4b89-82dc-b3e0dab45a00	에이퀴스정 5mg	653805710	633	0	0.35	0	8806538057101	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9ee8426f-ffac-4224-883a-147bc2cfae74	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047119	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9215395f-d125-4fd5-85ba-960a0c436b79	메코민캡슐	653800570	50	0.1	0	0	8806538005713	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
496d401d-e95e-4c8f-8670-317cd0087ea5	리노스틴서방캡슐	653800440	262	0.1	0.1	0	8806538004419	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c93e51a7-fd9a-43da-ac24-3ed5d82a060c	로타젯정10/5mg	653805820	761	0.47	0.48	0	8806538058221	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3d6e25dd-41b9-4492-bdc0-784be316f4dc	테노브이정	653805260	2505	0.45	0.47	0	8806538052618	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
75f4aadb-8bce-4fb2-8a12-646e25452d6f	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054124	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a9316151-e938-4d36-9870-62a1737b25d5	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003221	500정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a9675aef-f9b4-4fd8-9e99-b9b9de5a0291	디누보패취10	653804860	1586	0.3	0.3	0	8806538048635	30매/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
57b75812-c153-4453-8102-30e4876c13a1	디누보패취5	653804850	1283	0.3	0.3	0	8806538048529	30매/통	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
500151ff-e88c-49d4-8eca-586b186acaed	네오스타정40/10mg	653805340	648	0.5	0.5	0	8806538053431	100정/병	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ad076ff5-6d62-43d3-b3d4-a8aad2c052a8	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031804	(소분)	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b4deb0ce-f1d6-40eb-884e-dd2224d4c65f	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062426	100정/병	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
37ec0752-b77d-4bf2-9c35-bf5832b8532d	하이엘정 5mg	653804980	346	0.45	0.5	0	8806538049816	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2c337dad-0a50-4337-9541-7709974bca29	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2c866630-6998-46b5-b855-d3570fbb92ec	리피칸정 40mg	653803460	1264	0.45	0.6	0	8806538034621	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
803362bc-760f-4488-98e1-4513777119da	테글리정20mg	653806020	665	0.35	0.35	0	8806538060224	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
defe25e2-ca1f-40a0-bb5c-001b2ef0d48c	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057316	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
54e9f287-7c0f-4afe-b8e1-1bcd01712855	자누메티아정50/850mg	653806210	371	0.3	0.36	0	8806538062105	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
eccfaf3f-6a0b-4399-98d6-f7398a482148	트레스오릭스포르테캡슐 1mg	653805010	226	0.2	0	0	8806538050140		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b52211b2-d2cd-4861-9021-7059e5b71c43	포시글리듀오서방정10/500mg	653806270	473	0.25	0.25	0	8806538062709	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
79e4d67e-0b45-479f-934b-89452e3085b3	포시글리듀오서방정10/1000mg	653806260	512	0.25	0.25	0	8806538062631	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
029616d4-187f-43a0-8ed1-7f1a62ec4226	브이디썬정	653805980	113	0.2	0	0	8806538059808	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5d53f013-28b7-4853-b5d8-8ca070f1569c	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027517	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e9e2d39d-be35-4791-bf65-830b62e47758	탐시원서방캡슐 0.4mg	653805730	675	0.38	0.35	0	8806538057309	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2bb81336-f11a-4b23-9b01-e938f0156f4a	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013763	10정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d0a20c9b-5db4-464c-9844-238d8cb2eff4	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013725	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c8ad9514-6a7e-4405-b22e-da30fc623ac0	하이엘정 20mg	653804400	686	0.45	0.6	0	8806538044026	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
19ce936d-adb8-48fb-a9b2-5b3dffe62cef	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031835	100정/PTP	120		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9760dee9-5e00-414b-aa19-962ce2d71712	맥스케어프리미엄정	653804930	302	0.05	0	0	8806538049311	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0d38f19e-39ab-410b-b968-c5097b80c517	가모피드서방정15mg	653805750	289	0	0	0	8806538057514	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
12e1c772-8db0-4ddc-beb5-f7f93d2bb418	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031842	30정/병	5		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
efc20b6d-d330-480b-939e-8079500bb2b7	가모피드서방정15mg	653805750	289	0	0	0	8806538057507	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
53c4ac9e-1d0d-4d4d-954d-de3da12b1cdc	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000602	(소분)	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5dd1c569-0911-476d-bc63-2c669e55d298	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006307	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
166b7d22-2442-4abb-bb2f-643a86a0e63c	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062532	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4f344737-6d76-4da4-8f93-f20389dc4b47	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060712	7정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a633fb33-cb48-4c20-be23-a15f6b7831ab	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054018	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9e187186-b79b-468d-82f5-5529d2029566	다이뉴시드정 480mg	653805560	832	0.3	0.4	0	8806538055619	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7cd9f2e8-116d-4775-a22d-a703b32c1897	프리린캡슐 150mg	653804710	700	0.48	0.45	0	8806538047126	60캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
178bf99f-80bc-4105-8f84-d03952940468	리피칸정 10mg	653801370	663	0.45	0.65	0	8806538013718	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
38f43e95-be61-4966-b75c-fb916e7a08f6	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056418	1포/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e8e070e4-6093-422d-bb74-d68d1138896f	리피젯정10/10mg	653805900	637	0.47	0.5	0	8806538059013	30정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5ad510ed-fe6e-44e4-8379-92b7e3c7cca6	포시글리정 10mg	653806070	393	0.4	0.4	0	8806538060705	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a9d0b076-cbf7-431a-9a1f-2c72b5cfebd1	프로나지액 25mL	653805641	275	0.1	0.1	0	8806538056401	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a4037a21-5aa2-4611-97ab-07950319744e	미디아정 2mg	653800630	185	0.4	0.48	0	8806538006321	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cdf54008-dc4f-4a6e-9568-2583bbc79363	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063010	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
19726429-dd70-4f4c-9f47-46d5c5ed1544	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051109	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
89cde087-2ad1-45e4-8145-98518bfbd98a	테글리엠서방정10/750mg	653806040	334	0.2	0.25	0	8806538060408	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
718ce78b-3bf0-4e66-b933-33a8ff07dc03	메토르민정	653800580	70	0.2	0.28	0	8806538005812	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ec2588fc-8d3c-4f9c-aa6f-2ff99b4c2071	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011417	90캡슐/Foil	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
89a77825-e98c-4411-9f6e-68ba276009d0	트라글립틴정 5mg	653806250	402	0.4	0.5	0	8806538062525	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
00fa48cf-379f-47a2-9da5-9b5a2b11a077	그리펜-에스정 300mg	653800060	115	0.3	0.35	0	8806538000619	30정/병	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
39c64edc-498a-46dd-97a9-dcb5eba27dbd	신일아시클로버크림	653801351	2400	0	0	0	8806538013510		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ecd65480-65e7-402e-8b29-77540a77501f	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048925	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b9a90d95-e094-40fc-87ca-e1383fa1e734	가모피드정 5mg	653800020	103	0.43	0.45	0	8806538000206	(소분)	1		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0cf0a201-1fb9-4352-a6fd-0c7b51671da9	네오텔미정 80mg	653805320	487	0.42	0.4	0	8806538053219	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ae7dbb42-2edd-43f5-90d3-d7e385271ae5	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021300	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
59f95348-0374-44fa-b7a2-d1f9a4a0009a	디멘케어정 5mg	653805410	652	0.47	0.5	0	8806538054100	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f05fb587-b7f0-4afd-a223-7c0ae6f8e2b4	로타젯정10/20mg	653805830	1074	0.47	0.48	0	8806538058313	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
4f5ce7dc-a4be-4a8c-82f2-4e088a4821e2	디누보패취5	653804850	1283	0.3	0.3	0	8806538048512	1매/포	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
41016d6b-d194-44e7-aad7-2b7dd51e6b08	에이퀴스정 2.5mg	653805660	633	0	0.45	0	8806538056609	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
582c24cc-e1c2-45f9-863d-eb88a2892d61	브이디썬정	653805980	113	0.2	0	0	8806538059815	240정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7786551c-292d-4b9d-979b-588385d360de	자누다파정	653805990	846	0.23	0.23	0	8806538059914	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d1845cbb-d76a-4948-849a-fa959eac4bb7	신일세티리진정	653801190	161	0.4	0.45	0	8806538011943	100정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bb4ea153-6ae9-4fa2-a9fe-ed4e7b4cf9e0	안플업서방정 300mg	653805450	1009	0.45	0.5	0	8806538054513	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d8806581-caee-4679-a2ac-fae0821ac251	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049014	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
eee85ed2-01a5-421f-ac60-97896fdb2e81	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010977	10정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dff6c84f-a11d-4e4f-915f-98dec9c1a63a	신일티아민염산염정 10mg	653801460	12	0	0	0	8806538014647		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ab7ec5c5-00e0-4806-916a-6ebb8dbaf93d	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062006	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2207c19d-e487-4c32-9403-8df816cbdf89	에페릭스정	653802110	115	0.35	0.38	0	8806538021102	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
b5170a1d-eaef-45db-9869-e3017db90284	에페릭스정	653802110	115	0.35	0.38	0	8806538021119	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
49a55790-f60c-4732-8606-94deb9002b1b	엑스포텐정5/160mg	653804890	840	0.5	0.48	0	8806538048901	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
1c5a64b6-e4fb-4926-8de8-9e9622681a4d	에티브정	653805240	480	0.33	0.3	0	8806538052410	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bc1ca781-d14c-43a7-ac64-3b6b2a7ade95	엘도네오캡슐	653805390	195	0.25	0.3	0	8806538053912	30캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
f62d0aed-b355-427d-8efc-a770ccb01a6a	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538049007	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5b71805f-0b7e-4e1f-9a83-294361b399be	자누메티아정50/1000mg	653806200	377	0.3	0.36	0	8806538062013	56정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
032e4144-f379-4d86-b718-cafa01fc6abd	엑시캄캡슐7.5mg	653802160	270	0.43	0	0	8806538021621	10캡슐/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ef2ef1aa-70aa-45ce-8cd7-9dcd20047723	자누메티아엑스알서방정50/500mg	653806190	381	0.35	0.35	0	8806538061924	200정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
81a72d2a-0adf-4b01-9e94-ac21bcf2ad2c	신일슈도에페드린정 60mg	653801310	29	0	0	0	8806538013121		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fb55ec05-8ea1-4942-93a4-fe2a6091c511	엑세트라세미정	653802130	107	0.4	0.4	0	8806538021348	12정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
33c3a312-42bd-49ec-9d63-854860ea39ba	자누글리아정 100mg	653806120	453	0.4	0.4	0	8806538061214	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e70ca100-5e29-4429-9165-d5bd3afc05fa	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011424	300캡슐/Foil	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9bd98d27-3373-452b-ba36-76b866259428	엑스포텐정5/80mg	653806150	684	0.5	0.48	0	8806538061511	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6a274eeb-b770-4a8f-a251-6d0c68ad5380	액소도스정 60mg	653802050	0	0	0	0	8806538020518		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dd7b0c56-5584-4afa-b950-676292483f0e	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010922	90정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
543c50ae-5f82-4cf8-9b74-595d168ef92c	네오스타정40/5mg	653805360	600	0.5	0.5	0	8806538053639	100정/병	30		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
899e1527-2141-41af-9542-c3594f15ea5c	레보원정	055100040	114	0.2	0.25	0	8800551000427	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
c36ed82b-87fd-4d52-85bb-a49471aeac1d	셀코빅스캡슐	653805250	521	0.43	0.55	0	8806538052502	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bb432ec6-76b2-40a9-b43c-58159516e5be	디멘케어정 10mg	653805400	1821	0.5	0.6	0	8806538054025	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
cec1cd9c-85e2-4eb9-bc69-d2a59f05fffe	메코민캡슐	653800570	50	0.1	0	0	8806538005706	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
fd14d062-2ecf-4e51-9a27-74dbfed44285	메토르민정	653800580	70	0.2	0.28	0	8806538005805	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6ab5e862-c608-4718-a487-54493ec61665	라피에스정 20mg	058800390	909	0.45	0.45	0	8800588003903	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5bed1cae-aa06-464b-913c-59631bf76958	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051116	28정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e98e7005-d6d7-46ac-b833-7affb79fdbdf	자누다파정	653805990	846	0.23	0.23	0	8806538059921	30정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
2c3d0dcb-531b-4b16-9a17-12e703897893	로피타정 2mg	653805290	477	0.45	0.42	0	8806538052915	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8ccf589d-0831-4e7b-86e6-3d14934f8ac5	레보라정 25mg	653800330	119	0	0	0	8806538003320		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e784de50-d06c-45b7-bfe0-a7d2d08a6014	신에소메정40mg	653805110	1078	0.45	0.6	0	8806538051123	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e1f4bfe7-54c6-4c79-9abb-e2a801077b20	맥스케어알파정	653804520	277	0.05	0	0	8806538045238	14정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
24735397-6d15-4f0b-8366-f740fead28fe	레오빌정 25mg	653800360	182	0.45	0.45	0	8806538003634	500정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8dedb41d-efbf-4064-9312-b19de12d73e8	후리코정 5mg	653802890	25	0	0	0	8806538028927		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
873ed7a4-c5ac-45ac-9945-51e483903374	레보트로서방정	653805950	189	0.35	0.3	0	8806538059501	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6b999859-d9a1-4424-b3a1-921d8bf9d74e	신일모노독시엠캡슐	653801140	141	0.12	0	0	8806538011462	90캡슐/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
3b435c42-e5d3-42c5-8c9e-02bc6004db88	프리린캡슐 75mg	653804720	549	0.48	0.45	0	8806538047201	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
dc6588c2-1f43-43d3-89e8-09a90fc2b725	트라글립틴듀오정2.5/850mg	653806290	338	0.25	0.25	0	8806538062938	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
659d4a4a-abd6-4971-8e37-d067af8af23f	라베리트정 10mg	653800270	454	0.45	0.45	0	8806538002729	28정/Alu-Alu	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
de3254d1-31c8-4dfd-95ab-d82c656275e8	레보트로시럽 500mL	653800341	18	0.3	0.35	0	8806538003412	500	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e59ea0a1-3bfe-4561-bd66-ffedb21cdd9b	신일트리메부틴말레산염정 100mg	653801090	58	0.2	0.2	0	8806538010960	100정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
aa7cdf78-c4e0-46b2-a6ff-8a28d0a8878a	자누메티아정50/500mg	653806220	371	0.3	0.36	0	8806538062228	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
77d3b536-7cb7-4912-9144-91df8542546a	디누보패취10	653804860	1586	0.3	0.3	0	8806538048628	30매/통	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
0447316c-a044-41cf-9234-0ed97a586403	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031866	100정/PTP	100		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
8547ccb7-d19e-4199-b772-32c93e0ae4d3	트라글립틴듀오정2.5/1000mg	653806300	344	0.25	0.25	0	8806538063027	60정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
6d6f9829-e063-4010-9e05-0bc3f79437ef	프라빅정 75mg	653802750	632	0.5	0.6	0	8806538027500	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
e5378ff3-2f26-444d-8435-49115405e89d	신일세티리진정	653801190	161	0.4	0.45	0	8806538011912	10정/PTP	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
66fe66a3-dca2-498b-8ee0-b92a64b616cd	네오텔미정 40mg	653805330	362	0.42	0.4	0	8806538053325	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
10e54102-de8a-47b3-a5f6-adb17803c423	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031859	100정/병	10		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9a6659c4-048c-4246-af82-b77232842c43	네오반정 80mg	653803180	525	0.48	0.48	0	8806538031828	100정/병	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
ed67fea7-d71b-4cb4-bb08-9a71a3e87b3c	실데그라정 100mg	653806370	1540	0.3	0.3	0	8806538063706	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
45228aca-f4d8-4f93-bfa8-dd93db08c6f5	액소도스정 60mg	653802050	0	0	0	0	8806538020570		0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
7abb9f2d-5493-47d0-81af-d49c9d3c95e4	자누다파정	653805990	846	0.23	0.23	0	8806538059907	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
bb67d6ea-1c53-4a3c-8cff-322c673e323f	자누메티아엑스알서방정50/1000mg	653806180	420	0.3	0.3	0	8806538061818	28정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
5fc0ea4d-f855-430b-88f4-ae2330013b3e	악세푸정	653801970	637	0.3	0.3	0	8806538019710	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
9d2e305e-0cce-42b4-b30e-e6256f03bc85	신노바핀정 5mg	653800900	355	0.45	0.55	0	8806538009032	300정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
31e190fe-7fd8-4b0d-91b9-f151115e3897	로타젯정10/10mg	653805810	1063	0.47	0.48	0	8806538058108	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
d58dc6d9-8f8e-419e-911c-b19167c00bea	레바드린정 100mg	653800320	103	0.32	0.35	0	8806538003207	(소분)	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
75bc0fa5-ba75-4431-94e0-3e7d1e268bd7	하이엘정 10mg	653804410	612	0.45	0.6	0	8806538044125	30정/병	0		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
a8f2d36a-a2de-4d91-9772-960776d4a39f	네오반정 160mg	653806240	898	0.48	0.48	0	8806538062419	30정/병	300		active	2025-07-21 06:03:01.765941+00	2025-07-21 06:03:01.765941+00	2025-05
\.


--
-- Data for Name: performance_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.performance_records (id, company_id, settlement_month, prescription_month, client_id, product_id, prescription_qty, prescription_type, remarks, registered_by, created_at, updated_at, review_status, review_action, updated_by, commission_rate) FROM stdin;
28	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	11	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	1	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 03:44:38.139662+00	2025-07-22 03:44:38.139662+00	완료	\N	\N	0.47
29	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	13	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	1	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 05:15:23.131241+00	2025-07-22 05:15:23.131241+00	완료	\N	\N	0.47
30	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	11	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	1	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 05:27:33.51893+00	2025-07-22 05:27:33.51893+00	완료	\N	\N	0.47
31	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	13	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	1	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 05:28:32.924016+00	2025-07-22 05:28:32.924016+00	완료	\N	\N	0.5
32	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	13	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	3	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 05:52:37.980461+00	2025-07-22 05:52:37.980461+00	완료	\N	\N	0.47
33	3332cfbd-b161-491b-bee6-b7b537c7cf1a	2025-06	2025-05	13	197ee9d5-2a83-4c4b-a2bf-e404dde489fc	4	EDI		0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	2025-07-22 06:12:55.86084+00	2025-07-22 06:12:55.86084+00	완료	\N	\N	0.5
23	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	11	c3ee4a4e-8e95-4190-876f-5ee328615073	10	EDI		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:46:06.310483+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.48
26	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	10	a6ac3226-1c83-451b-b860-afadd0cc3fab	100	원내매출		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:47:25.926723+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.47
24	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	10	8c2290e5-9c43-4fa5-ab86-219b1c95b750	100	EDI		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:47:25.926723+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.25
22	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	11	c3ee4a4e-8e95-4190-876f-5ee328615073	51	EDI		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:46:06.310483+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.48
25	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	10	6441df37-f2a8-4f36-a4aa-d308817c5c7e	100	EDI		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:47:25.926723+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.35
21	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-04	11	5e6a9fcd-a979-469b-908b-c99869bbad23	10	EDI		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:46:06.310483+00	2025-07-22 02:20:25.759+00	완료	\N	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.3
27	32ddfa45-a8ba-40b1-9c9a-2cce24424d8a	2025-06	2025-05	10	e611f672-f649-4005-9ba1-ce4fa1124aaa	111	차감		5f474ca1-75e5-4382-b6af-2d33abe54d31	2025-07-22 00:47:25.926723+00	2025-07-22 02:20:47.498+00	검수중	수정	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	0.45
\.


--
-- Data for Name: performance_records_absorption; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.performance_records_absorption (id, created_at, settlement_month, company_id, client_id, product_id, prescription_month, prescription_qty, prescription_type, commission_rate, remarks, registered_by, updated_at, updated_by, review_action, wholesale_revenue, direct_revenue, total_revenue, absorption_rate) FROM stdin;
\.


--
-- Data for Name: settlement_months; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settlement_months (id, settlement_month, start_date, end_date, notice, status, remarks, created_at) FROM stdin;
6	2025-06	2025-07-22	2025-07-31	6월 실적 추가 입력66	active		2025-07-22 00:42:07.220226+00
\.


--
-- Data for Name: settlement_share; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settlement_share (id, settlement_month, company_id, share_enabled, created_at) FROM stdin;
\.


--
-- Data for Name: wholesale_sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wholesale_sales (id, pharmacy_code, pharmacy_name, business_registration_number, address, standard_code, product_name, sales_amount, sales_date, created_at, updated_at, created_by, updated_by) FROM stdin;
8		정화약국(정읍시)	404-13-12988	전북 정읍시 상동	8806538027517	프라빅정 75mg	75840	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
9		동천약국(정읍시)	134-21-72248	전라북도 정읍시 연지동	8806538027517	프라빅정 75mg	75840	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
10		신세계약국(전주완산구)	306-28-58608	전북 전주시 완산구 평화동	8806538056425	프로나지액 25mL	16500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
11		아중백제약국(전주시 덕진구)	418-02-15407	전북 전주시 덕진구 인후동	8806538014647	신일티아민염산염정 10mg	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
12		녹십자약국(전주완산구)	418-01-35745	전북 전주시 완산구 효자동	8806538027517	프라빅정 75mg	-18960	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
13		동천약국(정읍시)	134-21-72248	전라북도 정읍시 연지동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
14		명동약국(전북정읍시)	404-06-48571	전북 정읍시 시기동	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
15		성심약국(전북전주시)	402-20-28648	전북 전주시 완산구 동서학동	8806538003610	레오빌정 25mg	21840	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
16		송신약국(전주완산구)	402-33-61953	전북 전주시 완산구 삼천동	8806538013817	리피칸정 20mg	42720	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
17		익산오약국(익산시)	403-01-62314	전북 익산시 창인동	8806538027517	프라빅정 75mg	56880	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
18		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538058221	로타젯정10/5mg	45660	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
19		임실약국(전북임실군)	418-10-08430	전북 임실군 임실읍	8806538056425	프로나지액 25mL	27500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
20		행복드리는약국(전주덕진구)	418-04-51858	전북 전주시 덕진구 금암동	8806538003610	레오빌정 25mg	21840	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
21		행복드리는약국(전주덕진구)	418-04-51858	전북 전주시 덕진구 금암동	8806538014647	신일티아민염산염정 10mg	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
22		익산허영근약국(익산시)	403-12-53150	전북 익산시 인화동	8806538027517	프라빅정 75mg	18960	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
23		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538003610	레오빌정 25mg	5460	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
24		익산태양약국(익산시)	403-12-55949	전북 익산시 어양동	8806538047225	프리린캡슐 75mg	32940	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
25		익산허영근약국(익산시)	403-12-53150	전북 익산시 인화동	8806538003610	레오빌정 25mg	16380	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
26		익산이약국(익산시)	403-11-90712	전북 익산시 영등동	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
27		익산승민약국(익산시)	403-06-86683	전북 익산시 인화동	8806538003610	레오빌정 25mg	65520	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
28		익산이약국(익산시)	403-11-90712	전북 익산시 영등동	8806538060217	테글리정20mg	59850	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
29		익산오약국(익산시)	403-01-62314	전북 익산시 창인동	8806538026428	티니다진정 150mg	20500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
30		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538027517	프라빅정 75mg	37920	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
31		녹십자약국(전북김제시)	403-09-53688	전북 김제시 요촌동	8806538021430	엑세트라정	48600	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
32		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538058122	로타젯정10/10mg	223230	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
33		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538013718	리피칸정 10mg	59670	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
34		녹십자약국(전북김제시)	403-09-53688	전북 김제시 요촌동	8806538009018	신노바핀정 5mg	31950	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
35		희망약국(익산시)	407-04-86828	전북 익산시 남중동	8806538013510	신일아시클로버크림	7200	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
36		천사약국(익산시)	403-13-54632	전북 익산시 모현동	8806538056425	프로나지액 25mL	5500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
37		행복드리는약국(전주덕진구)	418-04-51858	전북 전주시 덕진구 금암동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
38		군산해동약국(전북군산시)	401-05-65351	전북 군산시 신풍동	8806538044125	하이엘정 10mg	36720	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
39		진약국(전북김제시)	403-10-33072	전라북도 김제시 요촌동	8806538021416	엑세트라정	19440	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
40		녹십자약국(전북김제시)	403-09-53688	전북 김제시 요촌동	8806538051024	신에소메정20mg	114600	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
41		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538006321	미디아정 2mg	37000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
42		모래내태평양약국(전주덕진구)	402-04-78376	전북 전주시 덕진구 인후동	8806538005737	메코민캡슐 500mcg	25000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
43		모래내태평양약국(전주덕진구)	402-04-78376	전북 전주시 덕진구 인후동	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
44		!성모엔젤약국(여의도,조배)	323-29-01752	서울특별시 영등포구 63로	8806538015149	신일폴산정 1mg	30000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
45		온심약국(전북전주시)	418-07-90115	전북 전주시 완산구 평화동	8806538056425	프로나지액 25mL	27500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
46		위드팜	220-81-76044	서울특별시 서초구 서초동	8806538014647	신일티아민염산염정 10mg	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
47		회생당약국(전북익산시)	403-22-16737	전북 익산시 부송동	8806538003610	레오빌정 25mg	16380	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
48		황등온누리약국(전북익산시)	827-65-00059	전북 익산시 황등면	8806538027517	프라빅정 75mg	37920	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
49		익산이약국(익산시)	403-11-90712	전북 익산시 영등동	8806538047119	프리린캡슐 150mg	84000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
50		익산대성약국(익산시)	403-12-55949	전북 익산시 영등동	8806538013817	리피칸정 20mg	42720	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
51		광혜당약국(전북전주시)	402-24-51657	전북 전주시 완산구 효자동	8806538027517	프라빅정 75mg	18960	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
52		익산대성약국(익산시)	403-12-55949	전북 익산시 영등동	8806538027517	프라빅정 75mg	37920	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
53		익산이약국(익산시)	403-11-90712	전북 익산시 영등동	8806538055626	다이뉴시드정 480mg	83200	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
54		다나약국(익산시)	403-05-66846	전라북도 익산시 동산동	8806538058221	로타젯정10/5mg	114150	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
55		영민약국(전북군산시)	401-01-15533	전북 군산시 나운동	8806538044125	하이엘정 10mg	36720	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
56		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538026428	티니다진정 150mg	41000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
57		약국	311-11-29183	충청남도 당진시 교동길 151 (읍내동)	8806538044125	하이엘정 10mg	-73440	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
58		약국	188-17-01137	충청남도 예산군 천변로 208 (예산읍)	8806538044125	하이엘정 10mg	73440	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
59		계명지하철약국 (호산-오하나	106-28-24056	대구 달서구 호산동	8806538015149	신일폴산정 1mg	45000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
60		다나약국(익산시)	403-05-66846	전라북도 익산시 동산동	8806538027517	프라빅정 75mg	56880	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
61		평화약국 (대명	685-26-00612	대구 남구 대명동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
62		(주)씨앤엘메디칼_우정약국	856-86-01522	서울특별시 동작구 서달로	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
63		강남약국 (영천-몰	505-09-39852	경북 영천시 금노동	8806538009902	신일디클로페낙나트륨정 25mg	-9090	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
64		우리약국 (대명	514-12-55216	대구 남구 대명동	8806538003610	레오빌정 25mg	21840	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
65		함열건강약국(익산시)	603-25-40274	전북 익산시 함열읍	8806538013510	신일아시클로버크림	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
66		지엘루비콘(주)(매출)	214-88-51896	경기도 안양시 동안구 평촌대로	8806538014265	신일브롬헥신염산염정 8mg	19000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
67		대창약국(전북군산시)	401-21-13213	전북 군산시 중앙로	8806538056425	프로나지액 25mL	5500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
68		익산고려종합약국(전북익산시)	403-05-36283	전라북도 익산시 어양동	8806538044125	하이엘정 10mg	146880	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
69		지엘루비콘(주)(매출)	214-88-51896	경기도 안양시 동안구 평촌대로	8806538015835	신일이부프로펜정 400mg	30000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
70		!123약국(수원)	124-33-32408	경기도 수원시 영통구 월드컵로	8806538017259	신일피리독신정 50mg	57500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
71		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538013718	리피칸정 10mg	39780	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
72		!(주)도담약품(구월메디칼)	342-87-01506	인천 남동구 구월동	8806538014029	신일엠정 500mg	66000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
73		회생당약국(전북익산시)	403-22-16737	전북 익산시 부송동	8806538060217	테글리정20mg	39900	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
74		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538021416	엑세트라정	48600	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
75		녹십자약국(전북김제시)	403-09-53688	전북 김제시 요촌동	8806538059013	리피젯정10/10mg	382200	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
76		!밝은중앙약국(서울)(오전1배송)	241-33-01025	서울특별시 송파구 강동대로	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
77		(주)씨앤엘메디칼(매출).	856-86-01522	서울특별시 강남구 광평로	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
78		낙원종합약국(전북정읍시)	404-03-98051	전라북도 정읍시 신태인읍	8806538013718	리피칸정 10mg	19890	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
79		메디팜으뜸약국(전주완산구)	402-23-84637	전북 전주시 완산구 중화산동	8806538014029	신일엠정 500mg	44000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
80		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538052915	로피타정 2mg	42930	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
81		건강이열리는약국(전북익산시)	403-04-40698	전북 익산시 부송동	8806538013749	리피칸정 10mg	238680	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
82		!(시흥)목감온누리약국(토X)(조배 1배송)	734-16-00502	경기도 시흥시 목감남서로	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
83		!삼성정문약국(조배1배송)	746-38-01132	서울특별시 강남구 일원로	8806538014647	신일티아민염산염정 10mg	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
84		건강100세약국(김제요촌동)	418-07-85719	전라북도 김제시 요촌동	8806538059013	리피젯정10/10mg	19110	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
85		보건약국（영주	512-01-62485	경북 영주시 영주동	8806538014029	신일엠정 500mg	22000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
86		!의료법인플러스의료재단(구.단원병원)	806-82-00234	경기도 안산시 단원구 원포공원1로	8806538017259	신일피리독신정 50mg	23000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
87		석정약국(전북고창군)	808-15-00072	전북 고창군 고창읍	8806538021911	오로페롤연질캡슐 100mg	-57500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
88		온누리일층약국(전북군산시)	401-11-70118	전북 군산시 문화동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
89		건강일등약국(전북군산시)	401-07-51851	전북 군산시 지곡동	8806538026428	티니다진정 150mg	20500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
90		정성온누리약국(전북익산시)	313-09-68971	전라북도 익산시 모현동1가	8806538003610	레오빌정 25mg	10920	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
91		석정약국(전북고창군)	808-15-00072	전북 고창군 고창읍	8806538017259	신일피리독신정 50mg	11500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
92		익산이약국(익산시)	403-11-90712	전북 익산시 영등동	8806538013718	리피칸정 10mg	39780	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
93		황등온누리약국(전북익산시)	827-65-00059	전북 익산시 황등면	8806538003610	레오빌정 25mg	10920	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
94		우리약국(전북김제시)	403-09-38159	전북 김제시 요촌동	8806538021416	엑세트라정	4860	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
95		편한약국(전북김제시)	403-11-28450	전북 김제시 요촌동	8806538021416	엑세트라정	4860	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
96		참사랑온누리약국(전주시)	296-44-00129	전북 전주시 완산구 중화산동	8806538003610	레오빌정 25mg	27300	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
97		!이화약국(수원)(수X)	754-29-01562	경기도 수원시 장안구 서부로	8806538017259	신일피리독신정 50mg	57500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
98		익산대성약국(익산시)	403-12-55949	전북 익산시 영등동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
99		화타약국(전북김제시)	403-10-47713	전북 김제시 요촌동	8806538021416	엑세트라정	24300	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
100		온누리안일약국 (범어	502-03-73198	대구 수성구 범어동	8806538011431	신일모노독시엠캡슐 100mg	70500	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
101		영남약국 (대명	503-50-01987	대구 남구 대명동	8806538011462	신일모노독시엠캡슐 100mg	12690	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
102		(주)씨앤엘메디칼_동부메디칼약국	856-86-01522	서울특별시 동대문구 무학로	8806538014647	신일티아민염산염정 10mg	12000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
103		(주)씨앤엘메디칼_동부메디칼약국	856-86-01522	서울특별시 동대문구 무학로	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
104		열린약국 (포항	506-10-31368	경북 포항시 북구 창포동	8806538015149	신일폴산정 1mg	15000	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
105		약국	402-30-56935	대전광역시 서구 동서대로 1072 (변동)	8806538013817	리피칸정 20mg	-21360	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
106		약국	311-12-64208	충청남도 당진시 거산3거리길 13 (신평면)	8806538012155	신일세파클러수화물캡슐	-26280	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
107		동천약국(정읍시)	134-21-72248	전라북도 정읍시 연지동	8806538013817	리피칸정 20mg	21360	2025-06-30	2025-07-21 06:06:22.004896+00	2025-07-21 06:06:22.004896+00	0e085a22-2267-4e7a-9c1e-5c7bf4f3034a	\N
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: postgres
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-07-17 06:49:21
20211116045059	2025-07-17 06:49:22
20211116050929	2025-07-17 06:49:23
20211116051442	2025-07-17 06:49:24
20211116212300	2025-07-17 06:49:25
20211116213355	2025-07-17 06:49:26
20211116213934	2025-07-17 06:49:27
20211116214523	2025-07-17 06:49:28
20211122062447	2025-07-17 06:49:29
20211124070109	2025-07-17 06:49:30
20211202204204	2025-07-17 06:49:31
20211202204605	2025-07-17 06:49:32
20211210212804	2025-07-17 06:49:35
20211228014915	2025-07-17 06:49:35
20220107221237	2025-07-17 06:49:36
20220228202821	2025-07-17 06:49:37
20220312004840	2025-07-17 06:49:38
20220603231003	2025-07-17 06:49:39
20220603232444	2025-07-17 06:49:40
20220615214548	2025-07-17 06:49:41
20220712093339	2025-07-17 06:49:42
20220908172859	2025-07-17 06:49:43
20220916233421	2025-07-17 06:49:44
20230119133233	2025-07-17 06:49:45
20230128025114	2025-07-17 06:49:46
20230128025212	2025-07-17 06:49:47
20230227211149	2025-07-17 06:49:48
20230228184745	2025-07-17 06:49:49
20230308225145	2025-07-17 06:49:49
20230328144023	2025-07-17 06:49:50
20231018144023	2025-07-17 06:49:51
20231204144023	2025-07-17 06:49:53
20231204144024	2025-07-17 06:49:54
20231204144025	2025-07-17 06:49:55
20240108234812	2025-07-17 06:49:56
20240109165339	2025-07-17 06:49:57
20240227174441	2025-07-17 06:49:58
20240311171622	2025-07-17 06:49:59
20240321100241	2025-07-17 06:50:02
20240401105812	2025-07-17 06:50:04
20240418121054	2025-07-17 06:50:05
20240523004032	2025-07-17 06:50:08
20240618124746	2025-07-17 06:50:09
20240801235015	2025-07-17 06:50:10
20240805133720	2025-07-17 06:50:11
20240827160934	2025-07-17 06:50:12
20240919163303	2025-07-17 06:50:13
20240919163305	2025-07-17 06:50:14
20241019105805	2025-07-17 06:50:15
20241030150047	2025-07-17 06:50:18
20241108114728	2025-07-17 06:50:20
20241121104152	2025-07-17 06:50:21
20241130184212	2025-07-17 06:50:22
20241220035512	2025-07-17 06:50:23
20241220123912	2025-07-17 06:50:24
20241224161212	2025-07-17 06:50:25
20250107150512	2025-07-17 06:50:26
20250110162412	2025-07-17 06:50:26
20250123174212	2025-07-17 06:50:27
20250128220012	2025-07-17 06:50:28
20250506224012	2025-07-17 06:50:29
20250523164012	2025-07-17 06:50:30
20250714121412	2025-07-21 00:38:53
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: postgres
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.buckets_analytics (id, type, format, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-07-17 06:49:07.835084
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-07-17 06:49:07.841102
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-07-17 06:49:07.848264
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-07-17 06:49:07.863802
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-07-17 06:49:07.875309
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-07-17 06:49:07.882357
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-07-17 06:49:07.889827
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-07-17 06:49:07.897088
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-07-17 06:49:07.903556
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-07-17 06:49:07.914837
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-07-17 06:49:07.921593
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-07-17 06:49:07.92847
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-07-17 06:49:07.93534
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-07-17 06:49:07.941444
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-07-17 06:49:07.947978
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-07-17 06:49:07.967906
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-07-17 06:49:07.980003
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-07-17 06:49:07.985611
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-07-17 06:49:07.995706
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-07-17 06:49:08.003211
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-07-17 06:49:08.009611
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-07-17 06:49:08.018207
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-07-17 06:49:08.032015
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-07-17 06:49:08.043577
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-07-17 06:49:08.049625
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-07-17 06:49:08.055614
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-07-17 06:49:08.061205
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-07-17 06:49:08.076886
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-07-17 06:49:08.087855
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-07-17 06:49:08.093087
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-07-17 06:49:08.097937
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-07-17 06:49:08.105292
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-07-17 06:49:08.11312
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-07-17 06:49:08.123733
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-07-17 06:49:08.125957
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-07-17 06:49:08.133961
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-07-17 06:49:08.143378
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-07-17 06:49:08.152069
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-07-17 06:49:08.158547
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: postgres
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 52, true);


--
-- Name: client_company_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_company_assignments_id_seq', 30, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 298, true);


--
-- Name: direct_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.direct_sales_id_seq', 5, true);


--
-- Name: performance_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.performance_records_id_seq', 33, true);


--
-- Name: pharmacies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pharmacies_id_seq', 256, true);


--
-- Name: settlement_months_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settlement_months_id_seq', 6, true);


--
-- Name: wholesale_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wholesale_sales_id_seq', 107, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: postgres
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

