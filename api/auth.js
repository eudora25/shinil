export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }
  
  // POST 메서드만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed. Use POST.'
    })
  }
  
  try {
    const { email, password } = req.body
    
    // 필수 필드 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email and password are required'
      })
    }
    
    // 이메일 형식 검증
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid email format'
      })
    }
    
    // 테스트용 인증 로직 (실제로는 Supabase 인증 사용)
    const validCredentials = [
      { email: 'admin@admin.com', password: 'admin123', role: 'admin' },
      { email: 'user@shinil.com', password: 'user123', role: 'user' },
      { email: 'test@example.com', password: 'test123', role: 'user' }
    ]
    
    const user = validCredentials.find(cred => 
      cred.email === email && cred.password === password
    )
    
    if (user) {
      // 간단한 JWT 토큰 생성 (실제로는 더 안전한 방법 사용)
      const token = Buffer.from(JSON.stringify({
        email: user.email,
        role: user.role,
        userId: `user-${Date.now()}`,
        exp: Math.floor(Date.now() / 1000) + (24 * 60 * 60) // 24시간
      })).toString('base64')
      
      return res.status(200).json({
        success: true,
        message: 'Authentication successful',
        data: {
          token: token,
          user: {
            email: user.email,
            role: user.role,
            userId: `user-${Date.now()}`
          },
          expiresIn: '24h'
        }
      })
    } else {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      })
    }
    
  } catch (error) {
    console.error('Auth error:', error)
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
} 