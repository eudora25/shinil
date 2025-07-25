// 토큰 발행 API 테스트 스크립트

async function testAuthAPI() {
  console.log('🔐 토큰 발행 API 테스트 시작...\n');
  
  try {
    // 1. 토큰 발행 테스트
    console.log('1️⃣ 토큰 발행 테스트...');
    const authResponse = await fetch('https://shinil.vercel.app/api/auth', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: 'admin@admin.com',
        password: 'admin123'
      })
    });
    
    const authData = await authResponse.json();
    console.log('📤 요청:', { email: 'admin@admin.com', password: '***' });
    console.log('📥 응답:', JSON.stringify(authData, null, 2));
    
    if (authData.success && authData.data.token) {
      console.log('✅ 토큰 발행 성공!\n');
      
      // 2. 토큰 검증 테스트
      console.log('2️⃣ 토큰 검증 테스트...');
      const verifyResponse = await fetch('https://shinil.vercel.app/api/verify-token', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          token: authData.data.token
        })
      });
      
      const verifyData = await verifyResponse.json();
      console.log('📤 요청:', { token: authData.data.token.substring(0, 20) + '...' });
      console.log('📥 응답:', JSON.stringify(verifyData, null, 2));
      
      if (verifyData.success) {
        console.log('✅ 토큰 검증 성공!\n');
        
        // 3. 토큰으로 보호된 API 호출 테스트
        console.log('3️⃣ 토큰으로 API 호출 테스트...');
        const apiResponse = await fetch('https://shinil.vercel.app/api/products', {
          headers: {
            'Authorization': `Bearer ${authData.data.token}`
          }
        });
        
        const apiData = await apiResponse.json();
        console.log('📤 요청:', { Authorization: 'Bearer ' + authData.data.token.substring(0, 20) + '...' });
        console.log('📥 응답:', JSON.stringify(apiData, null, 2));
        
        console.log('✅ 모든 테스트 완료!');
        
      } else {
        console.log('❌ 토큰 검증 실패');
      }
      
    } else {
      console.log('❌ 토큰 발행 실패');
    }
    
  } catch (error) {
    console.error('❌ 테스트 중 오류 발생:', error.message);
  }
}

// 테스트 실행
testAuthAPI(); 