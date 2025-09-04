import { createSupabaseClient } from './supabase.js'

/**
 * 쿠키에서 refresh token을 추출하는 함수
 */
function getRefreshTokenFromCookies(req) {
  const cookies = req.headers.cookie
  if (!cookies) return null
  
  const cookieArray = cookies.split(';')
  for (const cookie of cookieArray) {
    const [name, value] = cookie.trim().split('=')
    if (name === 'refreshToken') {
      return decodeURIComponent(value)
    }
  }
  return null
}

/**
 * 응답에 인증 관련 쿠키를 설정하는 함수
 */
function setAuthCookies(res, session) {
  const secure = process.env.NODE_ENV === 'production'
  const sameSite = 'lax'
  
  // Access token 쿠키 (짧은 만료시간)
  res.setHeader('Set-Cookie', [
    `accessToken=${session.access_token}; HttpOnly; Path=/; SameSite=${sameSite}${secure ? '; Secure' : ''}; Max-Age=3600`,
    `refreshToken=${session.refresh_token}; HttpOnly; Path=/; SameSite=${sameSite}${secure ? '; Secure' : ''}; Max-Age=2592000` // 30일
  ])
}

/**
 * 토큰 인증 및 자동 갱신 미들웨어
 */
export async function authenticateToken(req, res) {
  try {
    const supabase = createSupabaseClient()
    
    // 1. Authorization 헤더에서 access token 추출
    const authHeader = req.headers.authorization
    let accessToken = null
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      accessToken = authHeader.substring(7)
    }
    
    // 2. 먼저 access token으로 검증 시도
    if (accessToken) {
      const { data: userData, error: userError } = await supabase.auth.getUser(accessToken)
      
      if (!userError && userData?.user) {
        // Access token이 유효함
        return {
          success: true,
          user: userData.user,
          newTokens: null
        }
      }
    }
    
    // 3. Access token이 없거나 만료된 경우, refresh token으로 갱신 시도
    const refreshToken = getRefreshTokenFromCookies(req)
    
    if (!refreshToken) {
      return {
        success: false,
        error: 'No valid tokens found',
        statusCode: 401
      }
    }
    
    // 4. Refresh token으로 세션 갱신
    const { data: refreshData, error: refreshError } = await supabase.auth.refreshSession({
      refresh_token: refreshToken
    })
    
    if (refreshError || !refreshData?.session) {
      return {
        success: false,
        error: 'Refresh token expired or invalid',
        statusCode: 401
      }
    }
    
    // 5. 새로운 토큰 발급 성공
    const newSession = refreshData.session
    
    // 응답에 새로운 쿠키 설정
    setAuthCookies(res, newSession)
    
    return {
      success: true,
      user: refreshData.user,
      newTokens: {
        accessToken: newSession.access_token,
        refreshToken: newSession.refresh_token,
        expiresAt: new Date(newSession.expires_at * 1000).toISOString()
      }
    }
    
  } catch (error) {
    console.error('Authentication middleware error:', error)
    return {
      success: false,
      error: 'Authentication failed',
      statusCode: 500
    }
  }
}

/**
 * API 엔드포인트에서 사용할 수 있는 인증 래퍼 함수
 */
export function withAuth(handler) {
  return async function(req, res) {
    const authResult = await authenticateToken(req, res)
    
    if (!authResult.success) {
      return res.status(authResult.statusCode || 401).json({
        success: false,
        message: authResult.error || 'Authentication required'
      })
    }
    
    // 인증된 사용자 정보를 req 객체에 추가
    req.user = authResult.user
    req.newTokens = authResult.newTokens
    
    // 원래 핸들러 실행
    return handler(req, res)
  }
}
