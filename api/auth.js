<<<<<<< HEAD
=======
// Express.js 라우터 형식으로 변경 (03_사용자_로그인.xlsx 형식에 맞춤)
import express from 'express'
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
import { createClient } from '@supabase/supabase-js'

const router = express.Router()

<<<<<<< HEAD
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
=======
// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  
  return { supabaseUrl, supabaseAnonKey }
}

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  
  try {
    return createClient(supabaseUrl, supabaseAnonKey)
  } catch (error) {
    console.error('Failed to create Supabase client:', error)
    throw error
  }
}

// POST /api/auth - 사용자 로그인 (03_사용자_로그인.xlsx 형식에 맞춤)
router.post('/', async (req, res) => {
  try {
    const { email, password } = req.body
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
    
    // 필수 파라미터 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: '이메일과 비밀번호가 필요합니다.',
        error: 'Missing required parameters'
      })
    }
    
    // Supabase 클라이언트 생성
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        message: '서버 설정 오류',
        error: 'Supabase client initialization failed'
      })
    }

<<<<<<< HEAD
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
=======
    // Supabase Auth를 사용한 로그인
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
    })

    if (error) {
      console.error('Login error:', error)
<<<<<<< HEAD
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
=======
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
      return res.status(401).json({
        success: false,
        message: '로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.',
        error: error.message
      })
    }
<<<<<<< HEAD
    
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
=======

    // 사용자 정보는 auth.users에서 가져온 data.user를 사용
    // 별도의 users 테이블 조회는 제거 (테이블이 존재하지 않음)
    const userData = null // users 테이블이 존재하지 않으므로 null로 설정

    // 이미지에 표시된 응답 형식에 맞춤
    const response = {
      success: true,
      message: '인증 성공',
      data: {
        token: data.session.access_token,
        refreshToken: data.session.refresh_token,
        user: userData || {
          id: data.user.id,
          email: data.user.email,
          created_at: data.user.created_at,
          last_sign_in_at: data.user.last_sign_in_at,
          user_metadata: data.user.user_metadata || {}
        },
        expiresIn: '24h',
        expiresAt: new Date(data.session.expires_at * 1000).toISOString()
      }
    }

    res.json(response)
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0

  } catch (error) {
    console.error('Auth API error:', error)
    res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
<<<<<<< HEAD
}
=======
})

export default router 
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
