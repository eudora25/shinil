const { createClient } = require('@supabase/supabase-js')

// Supabase 클라이언트 생성
const supabaseUrl = 'https://selklngerzfmuvagcvvf.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MjczNDkwNSwiZXhwIjoyMDY4MzEwOTA1fQ.Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8'

const supabase = createClient(supabaseUrl, supabaseServiceKey)

module.exports = async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  // POST 요청만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      error: 'method_not_allowed',
      message: 'POST 메서드만 허용됩니다'
    })
  }

  try {
    const { email, password } = req.body

    // 입력 검증
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'missing_credentials',
        message: '이메일과 비밀번호를 입력해주세요'
      })
    }

    // Supabase Auth를 사용한 로그인
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
    })

    if (error) {
      console.error('Supabase login error:', error)
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

    // 사용자 정보 조회 (companies 테이블에서)
    const { data: companyData, error: companyError } = await supabase
      .from('companies')
      .select('*')
      .eq('email', email)
      .single()

    if (companyError && companyError.code !== 'PGRST116') {
      console.error('Company lookup error:', companyError)
    }

    // 사용자 역할 결정
    let userRole = 'user'
    let userName = email

    if (companyData) {
      userRole = companyData.approval_status === 'approved' ? 'admin' : 'pending'
      userName = companyData.representative_name || email
    }

    return res.status(200).json({
      success: true,
      data: {
        token: data.session.access_token,
        user: {
          id: data.user.id,
          email: data.user.email,
          role: userRole,
          name: userName
        }
      },
      message: '로그인 성공'
    })

  } catch (error) {
    console.error('Login error:', error)
    return res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 