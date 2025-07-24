const { createClient } = require('@supabase/supabase-js');

// Supabase Admin 클라이언트 생성
const supabase = createClient(
  'https://mctzuqctekhhdfwimxek.supabase.co',
  process.env.SUPABASE_SERVICE_ROLE_KEY || 'your-service-role-key-here'
);

// 사용자 데이터
const users = [
  {
    email: 'admin@admin.com',
    password: 'admin123',
    user_metadata: {
      user_type: 'admin',
      email_verified: true,
      phone_verified: false,
      approval_status: 'approved'
    }
  },
  {
    email: 'user1@user.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: true,
      phone_verified: false,
      approval_status: 'pending'
    }
  },
  {
    email: 'user2@user.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: true,
      phone_verified: false,
      approval_status: 'pending'
    }
  },
  {
    email: 'user3@user.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      company_name: '업체3',
      email_verified: true,
      phone_verified: false
    }
  },
  {
    email: 'tt1@tt.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: true,
      phone_verified: false,
      approval_status: 'pending'
    }
  },
  {
    email: 'moonmvp@twosun.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: true,
      phone_verified: false,
      approval_status: 'pending'
    }
  },
  {
    email: 'sjchoi@twosun.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: false,
      phone_verified: false,
      approval_status: 'pending'
    }
  },
  {
    email: 'd1@123.com',
    password: 'user123',
    user_metadata: {
      user_type: 'user',
      email_verified: false,
      phone_verified: false,
      approval_status: 'pending'
    }
  }
];

async function createUsers() {
  console.log('사용자 생성 시작...');
  
  for (const user of users) {
    try {
      console.log(`${user.email} 사용자 생성 중...`);
      
      const { data, error } = await supabase.auth.admin.createUser({
        email: user.email,
        password: user.password,
        email_confirm: true,
        user_metadata: user.user_metadata
      });

      if (error) {
        console.error(`❌ ${user.email} 생성 실패:`, error.message);
      } else {
        console.log(`✅ ${user.email} 생성 성공:`, data.user.id);
      }
    } catch (err) {
      console.error(`❌ ${user.email} 생성 중 오류:`, err.message);
    }
  }
  
  console.log('사용자 생성 완료!');
}

// 스크립트 실행
createUsers().catch(console.error); 