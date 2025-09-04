import { createClient } from '@supabase/supabase-js'
import { refreshAccessToken, verifyToken } from '../lib/tokenRefresh.js'

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
<<<<<<< HEAD
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
=======
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Refresh-Token')
  res.setHeader('Content-Type', 'application/json')
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  // POST 요청만 처리
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, message: 'Method not allowed' })
  }

  try {
<<<<<<< HEAD
    // 환경 변수에서 Supabase 설정 가져오기
    const supabaseUrl = process.env.VITE_SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({ 
        success: false, 
        message: 'Supabase configuration missing' 
      })
    }

    // Supabase 클라이언트 생성
    const supabase = createClient(supabaseUrl, supabaseAnonKey)

    // 요청 본문 파싱
    const { email, password } = req.body

=======
    const { action, email, password, refreshToken } = req.body
    
    // 액션 타입에 따른 처리
    switch (action) {
      case 'login':
        return await handleLogin(req, res, email, password)
      case 'refresh':
        return await handleTokenRefresh(req, res, refreshToken)
      case 'verify':
        return await handleTokenVerification(req, res)
      default:
        return res.status(400).json({
          success: false,
          message: 'Invalid action. Use "login", "refresh", or "verify".'
        })
    }
    
  } catch (error) {
    console.error('Auth error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      requestBody: req.body ? { action: req.body.action, email: req.body.email } : 'missing'
    })
    
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}

/**
 * 로그인 처리
 */
async function handleLogin(req, res, email, password) {
  try {
    // Supabase 클라이언트 생성
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase client initialization failed',
        details: configError.message
      })
    }

    // 필수 필드 검증
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
    if (!email || !password) {
      return res.status(400).json({ 
        success: false, 
        message: 'Email and password are required' 
      })
    }

    // 로그인 시도
    const { data: { user, session }, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })

    if (error) {
      console.error('Login error:', error)
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid login credentials' 
      })
    }
<<<<<<< HEAD

    if (!user || !session) {
      return res.status(401).json({ 
        success: false, 
        message: 'Login failed' 
      })
    }

=======
    
    console.log('로그인 시도:', { email, timestamp: new Date().toISOString() });
    
    // Supabase 인증 (상세한 에러 로깅 포함)
    let authData, authError
    try {
      const authResult = await supabase.auth.signInWithPassword({
        email: email,
        password: password
      })
      authData = authResult.data
      authError = authResult.error
      
      // 상세한 로깅
      console.log('Auth attempt details:', {
        email: email,
        hasData: !!authData,
        hasError: !!authError,
        errorType: authError?.name,
        errorCode: authError?.status,
        timestamp: new Date().toISOString()
      })
      
    } catch (networkError) {
      console.error('Network error during auth:', {
        errorName: networkError.name,
        errorMessage: networkError.message,
        errorStack: networkError.stack,
        timestamp: new Date().toISOString()
      })
      
      return res.status(500).json({
        success: false,
        message: 'Network connection failed',
        error: networkError.message,
        errorType: networkError.name,
        details: 'Unable to connect to authentication service'
      })
    }
    
    if (authError) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password',
        error: authError.message,
        errorCode: authError.status
      })
    }
    
    // 사용자 메타데이터 확인
    const userRole = authData.user.user_metadata?.user_type || 'user'
    const approvalStatus = authData.user.user_metadata?.approval_status || 'pending'
    
    // 승인되지 않은 사용자 차단
    if (approvalStatus === 'pending' && userRole !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Account is pending approval. Please contact administrator.'
      })
    }
    
    console.log('로그인 성공:', { email, userId: authData.user.id, role: userRole });
    
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
    // 성공 응답
    res.status(200).json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: user.id,
          email: user.email,
          user_metadata: user.user_metadata
        },
        session: {
          access_token: session.access_token,
          refresh_token: session.refresh_token,
          expires_at: session.expires_at
        }
      }
    })

  } catch (error) {
<<<<<<< HEAD
    console.error('Auth API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
=======
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Login failed',
      error: error.message
    });
  }
}

/**
 * 토큰 갱신 처리
 */
async function handleTokenRefresh(req, res, refreshToken) {
  try {
    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        message: 'Refresh token is required'
      })
    }
    
    console.log('토큰 갱신 요청 처리 중...');
    
    // 토큰 갱신 시도
    const newTokens = await refreshAccessToken(refreshToken);
    
    if (!newTokens) {
      return res.status(401).json({
        success: false,
        message: 'Token refresh failed',
        error: 'Invalid or expired refresh token'
      })
    }
    
    console.log('토큰 갱신 성공');
    
    // 응답 헤더에 새 토큰 정보 포함
    res.set('X-New-Access-Token', newTokens.accessToken);
    res.set('X-New-Refresh-Token', newTokens.refreshToken);
    res.set('X-Token-Refreshed', 'true');
    
    return res.status(200).json({
      success: true,
      message: 'Token refreshed successfully',
      data: {
        token: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
        user: newTokens.user,
        expiresIn: newTokens.expiresIn,
        expiresAt: new Date(Date.now() + (newTokens.expiresIn * 1000)).toISOString()
      }
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
    })
    
  } catch (error) {
    console.error('Token refresh error:', error);
    return res.status(401).json({
      success: false,
      message: 'Token refresh failed',
      error: error.message
    });
  }
}

/**
 * 토큰 검증 처리
 */
async function handleTokenVerification(req, res) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Authorization header with Bearer token is required'
      })
    }
    
    const token = authHeader.substring(7);
    console.log('토큰 검증 요청 처리 중...');
    
    // 토큰 검증
    const { valid, user, error } = await verifyToken(token);
    
    if (!valid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token',
        error: error
      })
    }
    
    console.log('토큰 검증 성공');
    
    return res.status(200).json({
      success: true,
      message: 'Token is valid',
      data: {
        user: {
          id: user.id,
          email: user.email,
          role: user.user_metadata?.user_type || 'user',
          approvalStatus: user.user_metadata?.approval_status || 'pending'
        }
      }
    })
    
  } catch (error) {
    console.error('Token verification error:', error);
    return res.status(500).json({
      success: false,
      message: 'Token verification failed',
      error: error.message
    });
  }
}
