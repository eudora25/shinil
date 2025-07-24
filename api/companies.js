module.exports = function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  // GET 요청만 허용
  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      error: 'method_not_allowed',
      message: 'GET 메서드만 허용됩니다'
    })
  }

  try {
    // 간단한 토큰 검증 (실제 JWT 대신)
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'access_token_required',
        message: '액세스 토큰이 필요합니다'
      })
    }

    // 테스트 데이터
    const testCompanies = [
      {
        id: 1,
        company_name: '신일제약',
        representative_name: '김신일',
        email: 'contact@shinil.com',
        approval_status: 'approved',
        created_at: '2024-01-01T00:00:00Z'
      },
      {
        id: 2,
        company_name: '대한제약',
        representative_name: '이대한',
        email: 'contact@daehan.com',
        approval_status: 'approved',
        created_at: '2024-01-02T00:00:00Z'
      },
      {
        id: 3,
        company_name: '한국제약',
        representative_name: '박한국',
        email: 'contact@korea.com',
        approval_status: 'pending',
        created_at: '2024-01-03T00:00:00Z'
      }
    ]

    // 테스트 데이터 반환
    return res.status(200).json({
      success: true,
      data: testCompanies,
      total_count: testCompanies.length,
      user: {
        id: 'admin-user-id',
        email: 'admin@shinil.com',
        role: 'admin',
        name: '관리자'
      },
      timestamp: new Date().toISOString()
    })

  } catch (error) {
    console.error('Companies API error:', error)
    return res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 