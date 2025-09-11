// Vercel 서버리스 함수 형식 (03_사용자_로그인.xlsx 형식에 맞춤)
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

// POST /api/auth - 사용자 로그인 (03_사용자_로그인.xlsx 형식에 맞춤)
export default async (req, res) => {
  // POST 메서드만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed'
    })
  }
  try {
    const { email, password } = req.body
    
    // 필수 파라미터 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: '이메일과 비밀번호를 입력해주세요.'
      })
    }

    // Supabase 클라이언트 생성
    const supabase = createSupabaseClient()

    // 사용자 인증
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
    })

    if (error) {
      console.error('Authentication error:', error)
      return res.status(401).json({
        success: false,
        message: '이메일 또는 비밀번호가 올바르지 않습니다.',
        error: error.message
      })
    }

    if (!data.user || !data.session) {
      return res.status(401).json({
        success: false,
        message: '인증에 실패했습니다.'
      })
    }

    // 사용자 메타데이터 조회 (선택사항)
    let userData = null
    try {
      const { data: profileData, error: profileError } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', data.user.id)
        .single()

      if (!profileError && profileData) {
        userData = profileData
      }
    } catch (profileError) {
      console.log('Profile fetch error (non-critical):', profileError)
    }

    // 03_사용자_로그인.xlsx 형식에 맞춘 응답
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

  } catch (error) {
    console.error('Auth API error:', error)
    res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
}