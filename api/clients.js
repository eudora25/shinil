const jwt = require('jsonwebtoken')

// JWT 시크릿 (실제로는 환경변수 사용)
const JWT_SECRET = 'shinil-secret-key-2024'

// 테스트 데이터
const testClients = [
  {
    id: 1,
    client_name: '서울대병원',
    client_code: 'SEOUL001',
    contact_person: '김의사',
    phone: '02-1234-5678',
    email: 'contact@seoulhospital.com',
    address: '서울시 종로구',
    created_at: '2024-01-01T00:00:00Z'
  },
  {
    id: 2,
    client_name: '연세대병원',
    client_code: 'YONSEI002',
    contact_person: '이의사',
    phone: '02-2345-6789',
    email: 'contact@yonsei.com',
    address: '서울시 서대문구',
    created_at: '2024-01-02T00:00:00Z'
  },
  {
    id: 3,
    client_name: '고려대병원',
    client_code: 'KOREA003',
    contact_person: '박의사',
    phone: '02-3456-7890',
    email: 'contact@korea.com',
    address: '서울시 성북구',
    created_at: '2024-01-03T00:00:00Z'
  }
]

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
    // JWT 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'access_token_required',
        message: '액세스 토큰이 필요합니다'
      })
    }

    const token = authHeader.substring(7) // 'Bearer ' 제거
    
    try {
      const decoded = jwt.verify(token, JWT_SECRET)
      console.log('토큰 검증 성공:', decoded)
    } catch (jwtError) {
      return res.status(401).json({
        success: false,
        error: 'invalid_token',
        message: '유효하지 않은 토큰입니다'
      })
    }

    // 테스트 데이터 반환
    return res.status(200).json({
      success: true,
      data: testClients,
      total_count: testClients.length,
      user: {
        id: 'admin-user-id',
        email: 'admin@shinil.com',
        role: 'admin',
        name: '관리자'
      },
      timestamp: new Date().toISOString()
    })

  } catch (error) {
    console.error('Clients API error:', error)
    return res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 