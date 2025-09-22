// Vercel 서버리스 함수 형식 (03_사용자_로그인.xlsx 형식에 맞춤)
import { createClient } from '@supabase/supabase-js'

// Vercel에서는 환경 변수가 자동으로 로드됨
console.log('✅ Vercel 환경 변수 로드됨')


// IP 제한 함수 (Vercel 환경용)
function checkIPAccess(req) {
  // Vercel에서는 IP 제한을 비활성화하거나 간소화
  console.log('🔓 Vercel 환경: IP 제한 비활성화')
  return { allowed: true }

}

// 환경 변수 확인 함수 (Vercel용)
function getEnvironmentVariables() {
  // Vercel 환경 변수 또는 하드코딩된 값 사용
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://vaeolqywqckiwwtspxfp.supabase.co'
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30'
  
  console.log('🔍 환경 변수 확인:')
  console.log('Supabase URL:', supabaseUrl ? '설정됨' : '미설정')
  console.log('Supabase Key:', supabaseAnonKey ? '설정됨' : '미설정')
  
  return { supabaseUrl, supabaseAnonKey }
}

// Supabase 클라이언트 생성 함수 (Vercel용)
function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('❌ Supabase 환경 변수가 설정되지 않았습니다')
    console.error('VITE_SUPABASE_URL:', supabaseUrl)
    console.error('VITE_SUPABASE_ANON_KEY:', supabaseAnonKey ? '설정됨' : '미설정')
    throw new Error('Supabase configuration missing')
  }
  
  try {
    console.log('✅ Supabase 클라이언트 생성 중...')
    const client = createClient(supabaseUrl, supabaseAnonKey)
    console.log('✅ Supabase 클라이언트 생성 완료')
    return client
  } catch (error) {
    console.error('❌ Supabase 클라이언트 생성 실패:', error)
    throw error
  }
}

// POST /api/auth - 사용자 로그인 (03_사용자_로그인.xlsx 형식에 맞춤)
export default async (req, res) => {
  console.log('🚀 Auth API 호출됨:', req.method, req.url)
  
  // IP 접근 권한 확인
  const ipCheck = checkIPAccess(req)
  if (!ipCheck.allowed) {
    console.log('❌ IP 접근 거부됨')
    return res.status(403).json({
      success: false,
      token: null,
      user: null,
      message: 'IP 접근이 제한되었습니다.'
    })
  }

  // POST 메서드만 허용
  if (req.method !== 'POST') {
    console.log('❌ 잘못된 HTTP 메서드:', req.method)
    return res.status(405).json({
      success: false,
      token: null,
      user: null,
      message: 'Method not allowed'
    })
  }
  
  try {
    console.log('📝 요청 본문:', JSON.stringify(req.body, null, 2))
    const { email, password } = req.body
    
    // 필수 파라미터 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        token: null,
        user: null,
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
        token: null,
        user: null,
        message: '이메일 또는 비밀번호가 올바르지 않습니다.'
      })
    }

    if (!data.user || !data.session) {
      return res.status(401).json({
        success: false,
        token: null,
        user: null,
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

    // 03_사용자_로그인.xlsx 스펙에 맞춘 응답
    const response = {
      success: true,
      token: data.session.access_token,
      user: userData || {
        id: data.user.id,
        email: data.user.email,
        created_at: data.user.created_at,
        last_sign_in_at: data.user.last_sign_in_at,
        user_metadata: data.user.user_metadata || {}
      },
      message: '인증 성공'
    }

    res.json(response)

  } catch (error) {
    console.error('Auth API error:', error)
    res.status(500).json({
      success: false,
      token: null,
      user: null,
      message: '서버 오류가 발생했습니다.'
    })
  }
}