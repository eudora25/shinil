import { createClient } from '@supabase/supabase-js'

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

    const { token } = req.body
    
    // 토큰 필드 검증
    if (!token) {
      return res.status(400).json({
        success: false,
        message: 'Token is required'
      })
    }
    
    // Supabase를 사용한 토큰 검증
    const { data, error } = await supabase.auth.getUser(token)
    
    if (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token',
        error: error.message
      })
    }
    
    // 사용자 메타데이터에서 역할 정보 가져오기
    const userRole = data.user.user_metadata?.user_type || 'user'
    const approvalStatus = data.user.user_metadata?.approval_status || 'pending'
    
    // 토큰 검증 성공
    return res.status(200).json({
      success: true,
      message: 'Token is valid',
      data: {
        user: {
          id: data.user.id,
          email: data.user.email,
          role: userRole,
          approvalStatus: approvalStatus,
          createdAt: data.user.created_at,
          lastSignIn: data.user.last_sign_in_at
        },
        valid: true
      }
    })
    
  } catch (error) {
    console.error('Token verification error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })
    
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
} 