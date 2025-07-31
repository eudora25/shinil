-- 관리자 계정 생성 스크립트
-- 주의: auth.users는 Supabase 시스템 테이블이므로 직접 INSERT가 제한될 수 있습니다.

-- 방법 1: Supabase Dashboard에서 직접 생성 (권장)
-- 1. Supabase Dashboard > Authentication > Users
-- 2. "Add user" 클릭
-- 3. Email: admin@admin.com
-- 4. Password: admin1234
-- 5. User metadata에 다음 추가:
--    {
--      "user_type": "admin",
--      "approval_status": "approved",
--      "email_verified": true
--    }

-- 방법 2: SQL로 시도 (제한적)
-- 주의: 이 방법은 Supabase 정책에 따라 실패할 수 있습니다.

-- 먼저 기존 admin 계정이 있는지 확인
SELECT id, email, raw_user_meta_data 
FROM auth.users 
WHERE email = 'admin@admin.com';

-- 기존 계정이 없다면 새로 생성 시도
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    invited_at,
    confirmation_token,
    confirmation_sent_at,
    recovery_token,
    recovery_sent_at,
    email_change_token_new,
    email_change,
    email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    created_at,
    updated_at,
    phone,
    phone_confirmed_at,
    phone_change,
    phone_change_token,
    phone_change_sent_at,
    email_change_token_current,
    email_change_confirm_status,
    banned_until,
    reauthentication_token,
    reauthentication_sent_at,
    is_sso_user,
    deleted_at,
    is_anonymous
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    'admin@admin.com',
    crypt('admin1234', gen_salt('bf')),
    now(),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"sub":"","email":"admin@admin.com","user_type":"admin","email_verified":true,"phone_verified":false,"approval_status":"approved"}',
    NULL,
    now(),
    now(),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    NULL,
    NULL,
    NULL,
    false,
    NULL,
    false
);

-- 생성된 관리자 계정 확인
SELECT 
    id,
    email,
    raw_user_meta_data,
    created_at
FROM auth.users 
WHERE email = 'admin@admin.com';

-- 방법 3: Supabase Auth API 사용 (가장 안전한 방법)
-- 이 방법은 애플리케이션 코드에서 수행해야 합니다.
-- server.js에서 다음과 같은 함수를 추가할 수 있습니다:

/*
async function createAdminUser() {
  const { data, error } = await supabase.auth.admin.createUser({
    email: 'admin@admin.com',
    password: 'admin1234',
    email_confirm: true,
    user_metadata: {
      user_type: 'admin',
      approval_status: 'approved',
      email_verified: true
    }
  });
  
  if (error) {
    console.error('Error creating admin user:', error);
  } else {
    console.log('Admin user created:', data);
  }
}
*/

-- 현재 auth.users 테이블의 모든 사용자 확인
SELECT 
    id,
    email,
    raw_user_meta_data->>'user_type' as user_type,
    created_at
FROM auth.users 
ORDER BY created_at DESC; 