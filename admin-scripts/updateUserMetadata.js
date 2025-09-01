// updateUserMetadata.js

// ESM 스타일 import를 사용하기 위해 require 대신 import 사용
// package.json에 "type": "module"을 추가하거나, .mjs 확장자를 사용해야 할 수 있으나,
// 우선 이대로 시도해보고 안되면 수정하겠습니다.
import { createClient } from '@supabase/supabase-js';

// 사용자로부터 입력을 받기 위한 readline 모듈 (Node.js 기본 제공)
import readline from 'readline';

// Supabase 프로젝트 URL과 서비스 역할 키를 여기에 입력하세요.
// 중요: 서비스 역할 키는 절대 프론트엔드나 공개된 곳에 노출되면 안 됩니다.
const supabaseUrl = 'https://vaeolqywqckiwwtspxfp.supabase.co'; // 예: https://xxxxxxxxxx.supabase.co
const supabaseServiceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g';

// 서비스 역할 키로 Supabase Admin 클라이언트 생성
const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey);

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// 여러 질문을 순차적으로 하기 위한 async/await 헬퍼 함수
function askQuestion(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function main() {
  if (supabaseUrl === 'YOUR_SUPABASE_URL' || supabaseServiceRoleKey === 'YOUR_SUPABASE_SERVICE_ROLE_KEY') {
    console.error('\n오류: Supabase URL 또는 서비스 역할 키가 스크립트에 설정되지 않았습니다.');
    console.log('updateUserMetadata.js 파일을 열어 supabaseUrl과 supabaseServiceRoleKey 변수를 실제 값으로 채워주세요.');
    rl.close();
    return;
  }

  console.log('\n--- 사용자 User Metadata 업데이트 스크립트 ---');

  try {
    const userIdToUpdate = await askQuestion('업데이트할 사용자의 ID (Supabase Auth User ID)를 입력하세요: ');
    if (!userIdToUpdate) {
      console.log('사용자 ID가 입력되지 않았습니다. 스크립트를 종료합니다.');
      rl.close();
      return;
    }

    const newUserType = await askQuestion(`새로운 user_type을 입력하세요 (예: admin, user): `);
    const newApprovalStatus = await askQuestion(`새로운 approval_status를 입력하세요 (예: approved, pending, rejected): `);

    if (!newUserType || !newApprovalStatus) {
      console.log('user_type 또는 approval_status가 입력되지 않았습니다. 스크립트를 종료합니다.');
      rl.close();
      return;
    }

    console.log(`\n사용자 ID: ${userIdToUpdate}`);
    console.log(`새로운 user_type: ${newUserType}`);
    console.log(`새로운 approval_status: ${newApprovalStatus}`);

    const confirm = await askQuestion('\n위 정보로 업데이트 하시겠습니까? (y/n): ');

    if (confirm.toLowerCase() !== 'y') {
      console.log('업데이트가 취소되었습니다.');
      rl.close();
      return;
    }

    const { data, error } = await supabaseAdmin.auth.admin.updateUserById(
      userIdToUpdate,
      { 
        user_metadata: { 
          user_type: newUserType, 
          approval_status: newApprovalStatus 
          // 참고: 기존 user_metadata에 다른 정보가 있었다면 이 작업으로 덮어쓰여질 수 있습니다.
          // 만약 기존 정보를 보존하면서 추가/수정하려면, 먼저 해당 사용자의 메타데이터를 읽어와서 병합하는 로직이 필요합니다.
          // 지금은 단순화를 위해 전체를 새로 설정합니다.
        } 
      }
    );

    if (error) {
      console.error('\n오류: User metadata 업데이트 중 에러 발생');
      console.error(error.message || error);
    } else {
      console.log('\n성공: User metadata가 성공적으로 업데이트되었습니다.');
      console.log('업데이트된 정보:', data.user.user_metadata);
    }

  } catch (err) {
    console.error('\n스크립트 실행 중 예기치 않은 오류 발생:', err);
  } finally {
    rl.close();
  }
}

main();