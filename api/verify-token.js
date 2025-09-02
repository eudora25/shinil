import { authenticateToken } from './lib/auth-middleware.js'

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, Cookie')
  res.setHeader('Content-Type', 'application/json')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    if (req.method !== 'POST') {
      return res.status(405).json({
        success: false,
        message: 'Method not allowed. Only POST is supported.'
      })
    }

    // 인증 미들웨어를 통해 토큰 검증 및 자동 갱신
    const authResult = await authenticateToken(req, res)
    
    if (!authResult.success) {
      return res.status(authResult.statusCode || 401).json({
        success: false,
        message: authResult.error || 'Invalid or expired token'
      })
    }

    // 성공 응답 생성
    const responseData = {
      success: true,
      message: 'Token is valid',
      data: {
        user: {
          id: authResult.user.id,
          email: authResult.user.email,
          role: authResult.user.user_metadata?.user_type || 'user',
          approvalStatus: authResult.user.user_metadata?.approval_status || 'pending'
        }
      }
    }

    // 새로운 토큰이 발급된 경우 응답에 포함
    if (authResult.newTokens) {
      responseData.data.newTokens = {
        accessToken: authResult.newTokens.accessToken,
        refreshToken: authResult.newTokens.refreshToken,
        expiresAt: authResult.newTokens.expiresAt
      }
      responseData.message = 'Token refreshed and validated'
    }

    return res.status(200).json(responseData)

  } catch (error) {
    console.error('Token verification API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
