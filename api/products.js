export default function handler(req, res) {
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
    // 간단한 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'access_token_required',
        message: '액세스 토큰이 필요합니다'
      })
    }

    // 테스트 데이터
    const testProducts = [
      {
        id: 1,
        product_name: '아스피린',
        product_code: 'ASP001',
        manufacturer: '신일제약',
        category: '진통제',
        price: 5000,
        created_at: '2024-01-01T00:00:00Z'
      },
      {
        id: 2,
        product_name: '타이레놀',
        product_code: 'TYL002',
        manufacturer: '대한제약',
        category: '해열제',
        price: 3000,
        created_at: '2024-01-02T00:00:00Z'
      },
      {
        id: 3,
        product_name: '비타민C',
        product_code: 'VIT003',
        manufacturer: '한국제약',
        category: '영양제',
        price: 8000,
        created_at: '2024-01-03T00:00:00Z'
      }
    ]

    // 테스트 데이터 반환
    return res.status(200).json({
      success: true,
      data: testProducts,
      total_count: testProducts.length,
      user: {
        id: 'admin-user-id',
        email: 'admin@shinil.com',
        role: 'admin',
        name: '관리자'
      },
      timestamp: new Date().toISOString()
    })

  } catch (error) {
    console.error('Products API error:', error)
    return res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 