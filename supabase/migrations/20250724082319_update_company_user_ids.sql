-- Update company user_ids to match newly created users

-- First, let's see the current companies and their user_ids
SELECT id, user_id, company_name FROM public.companies;

-- Update companies with new user IDs
-- admin@admin.com -> 523907e7-b0d6-45b7-93a0-a93d9ee64951
UPDATE public.companies 
SET user_id = '523907e7-b0d6-45b7-93a0-a93d9ee64951'
WHERE email = 'admin@admin.com';

-- user1@user.com -> a8632469-d2b6-4f1f-9243-45d43aae5cde
UPDATE public.companies 
SET user_id = 'a8632469-d2b6-4f1f-9243-45d43aae5cde'
WHERE email = 'user1@user.com';

-- user2@user.com -> ad319386-6cdc-403b-b75f-26e08aa1d543
UPDATE public.companies 
SET user_id = 'ad319386-6cdc-403b-b75f-26e08aa1d543'
WHERE email = 'user2@user.com';

-- tt1@tt.com -> b93612c6-8d1a-4c81-8be3-de30c44acba9
UPDATE public.companies 
SET user_id = 'b93612c6-8d1a-4c81-8be3-de30c44acba9'
WHERE email = 'tt1@tt.com';

-- moonmvp@twosun.com -> 51e84167-925a-4c27-96d1-a18b48f657a9
UPDATE public.companies 
SET user_id = '51e84167-925a-4c27-96d1-a18b48f657a9'
WHERE email = 'moonmvp@twosun.com';

-- Also update created_by and updated_by fields
UPDATE public.companies 
SET created_by = '523907e7-b0d6-45b7-93a0-a93d9ee64951'
WHERE created_by = '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a';

UPDATE public.companies 
SET updated_by = '523907e7-b0d6-45b7-93a0-a93d9ee64951'
WHERE updated_by = '0e085a22-2267-4e7a-9c1e-5c7bf4f3034a';

UPDATE public.companies 
SET created_by = 'a8632469-d2b6-4f1f-9243-45d43aae5cde'
WHERE created_by = '5f474ca1-75e5-4382-b6af-2d33abe54d31';

UPDATE public.companies 
SET updated_by = 'a8632469-d2b6-4f1f-9243-45d43aae5cde'
WHERE updated_by = '5f474ca1-75e5-4382-b6af-2d33abe54d31';

UPDATE public.companies 
SET created_by = 'ad319386-6cdc-403b-b75f-26e08aa1d543'
WHERE created_by = '1d3ce10a-a53a-4f92-827d-8af539a4450c';

UPDATE public.companies 
SET updated_by = 'ad319386-6cdc-403b-b75f-26e08aa1d543'
WHERE updated_by = '1d3ce10a-a53a-4f92-827d-8af539a4450c';

UPDATE public.companies 
SET created_by = 'b93612c6-8d1a-4c81-8be3-de30c44acba9'
WHERE created_by = 'db493775-9caa-4401-9277-d9c046f0e6a3';

UPDATE public.companies 
SET updated_by = 'b93612c6-8d1a-4c81-8be3-de30c44acba9'
WHERE updated_by = 'db493775-9caa-4401-9277-d9c046f0e6a3';

UPDATE public.companies 
SET created_by = '51e84167-925a-4c27-96d1-a18b48f657a9'
WHERE created_by = 'f19113ee-432b-4f29-9c20-15cfe4001376';

UPDATE public.companies 
SET updated_by = '51e84167-925a-4c27-96d1-a18b48f657a9'
WHERE updated_by = 'f19113ee-432b-4f29-9c20-15cfe4001376';
