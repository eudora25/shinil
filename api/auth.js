// ES 모듈 import (Vercel 호환)
import { createClient } from '@supabase/supabase-js'

// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  
  console.log('Environment check:', {
    hasUrl: !!supabaseUrl,
    hasKey: !!supabaseAnonKey,
    urlStart: supabaseUrl ? supabaseUrl.substring(0, 20) + '...' : 'missing'
  })
  
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

// Vercel 서버리스 함수
export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }
  
  // POST 메서드만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed. Use POST.'
    })
  }
  
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
    
    // 쿠키에 토큰 설정
    const secure = process.env.NODE_ENV === 'production'
    const sameSite = 'lax'
    
    res.setHeader('Set-Cookie', [
      `accessToken=${authData.session.access_token}; HttpOnly; Path=/; SameSite=${sameSite}${secure ? '; Secure' : ''}; Max-Age=3600`,
      `refreshToken=${authData.session.refresh_token}; HttpOnly; Path=/; SameSite=${sameSite}${secure ? '; Secure' : ''}; Max-Age=2592000` // 30일
    ])

    // 성공 응답
    return res.status(200).json({
      success: true,
      message: 'Authentication successful',
      data: {
        token: authData.session.access_token,
        refreshToken: authData.session.refresh_token,
        user: {
          id: authData.user.id,
          email: authData.user.email,
          role: userRole,
          approvalStatus: approvalStatus,
          createdAt: authData.user.created_at,
          lastSignIn: authData.user.last_sign_in_at
        },
        expiresIn: '24h',
        expiresAt: new Date(authData.session.expires_at * 1000).toISOString()
      }
    })
    
  } catch (error) {
    console.error('Auth error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      requestBody: req.body ? { email: req.body.email } : 'missing'
    })
    
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
} 