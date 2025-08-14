import { createClient } from '@supabase/supabase-js'

// Vercel 환경에서 환경 변수 확인
const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY

// 환경 변수 검증
if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing Supabase environment variables:', {
    supabaseUrl: !!supabaseUrl,
    supabaseAnonKey: !!supabaseAnonKey
  })
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

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
    // 환경 변수 검증
    if (!supabaseUrl || !supabaseAnonKey) {
      console.error('Supabase configuration missing')
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase configuration not found'
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
    
    console.log('Attempting authentication for:', email)
    
    // Supabase를 사용한 실제 인증
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
    })
    
    if (error) {
      console.error('Supabase auth error:', error)
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password',
        error: error.message
      })
    }
    
    // 사용자 메타데이터에서 역할 정보 가져오기
    const userRole = data.user.user_metadata?.user_type || 'user'
    const approvalStatus = data.user.user_metadata?.approval_status || 'pending'
    
    // 승인되지 않은 사용자는 로그인 차단
    if (approvalStatus === 'pending' && userRole !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Account is pending approval. Please contact administrator.'
      })
    }
    
    console.log('Authentication successful for user:', data.user.id)
    
    // 인증 성공 시 토큰 반환
    return res.status(200).json({
      success: true,
      message: 'Authentication successful',
      data: {
        token: data.session.access_token,
        refreshToken: data.session.refresh_token,
        user: {
          id: data.user.id,
          email: data.user.email,
          role: userRole,
          approvalStatus: approvalStatus,
          createdAt: data.user.created_at,
          lastSignIn: data.user.last_sign_in_at
        },
        expiresIn: '24h',
        expiresAt: new Date(data.session.expires_at * 1000).toISOString()
      }
    })
    
  } catch (error) {
    console.error('Auth error:', error)
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
} 