// ES 모듈 import (Vercel 호환)
import { createClient } from '@supabase/supabase-js'
import { refreshAccessToken, verifyToken } from '../lib/tokenRefresh.js'

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
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Refresh-Token')
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