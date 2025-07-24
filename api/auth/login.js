const jwt = require('jsonwebtoken')

// 간단한 JWT 시크릿 (실제로는 환경변수 사용)
const JWT_SECRET = 'shinil-secret-key-2024'

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

  // POST 요청만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      error: 'method_not_allowed',
      message: 'POST 메서드만 허용됩니다'
    })
  }

  try {
    const { email, password } = req.body

    // 입력 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'missing_credentials',
        message: '이메일과 비밀번호를 입력해주세요'
      })
    }

    // 간단한 테스트 로그인
    if (email === 'admin@shinil.com' && password === 'admin123') {
      // JWT 토큰 생성
      const token = jwt.sign(
        {
          id: 'admin-user-id',
          email: email,
          role: 'admin',
          name: '관리자'
        },
        JWT_SECRET,
        { expiresIn: '24h' }
      )

      return res.status(200).json({
        success: true,
        data: {
          token,
          user: {
            id: 'admin-user-id',
            email: email,
            role: 'admin',
            name: '관리자'
          }
        },
        message: '로그인 성공'
      })
    } else {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

  } catch (error) {
    console.error('Login error:', error)
    return res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 