import jwt from 'jsonwebtoken'
import { createClient } from '@supabase/supabase-js'

// Supabase 클라이언트 설정
const supabaseUrl = process.env.VERCEL_SUPABASE_URL || 'https://selklngerzfmuvagcvvf.supabase.co'
const supabaseKey = process.env.VERCEL_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U'

const supabase = createClient(supabaseUrl, supabaseKey)

// JWT 설정
const JWT_SECRET = process.env.JWT_SECRET || 'shinil-pms-secret-key-2024'
const JWT_EXPIRES_IN = '24h'

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')

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

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'missing_credentials',
        message: '이메일과 비밀번호를 입력해주세요'
      })
    }

    // Supabase에서 사용자 조회
    const { data: users, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('email', email)
      .limit(1)

    if (error || !users || users.length === 0) {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

    const user = users[0]

    // 비밀번호 검증 (실제로는 해시된 비밀번호와 비교)
    const validPassword = password === 'admin123' // 실제로는 bcrypt.compare 사용

    if (!validPassword) {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

    // JWT 토큰 생성
    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
        role: user.user_type || 'user',
        name: user.full_name || user.email
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    )

    res.status(200).json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          email: user.email,
          role: user.user_type || 'user',
          name: user.full_name || user.email
        }
      },
      message: '로그인 성공'
    })

  } catch (error) {
    console.error('로그인 에러:', error)
    res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다'
    })
  }
} 