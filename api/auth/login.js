import jwt from 'jsonwebtoken'
import { createClient } from '@supabase/supabase-js'

// Supabase 클라이언트 설정 (하드코딩으로 테스트)
const supabaseUrl = 'https://selklngerzfmuvagcvvf.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U'

const supabase = createClient(supabaseUrl, supabaseKey)

// JWT 설정 (하드코딩으로 테스트)
const JWT_SECRET = 'shinil-pms-secret-key-2024'
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

    // 간단한 테스트 응답 (Supabase 연결 없이)
    if (email === 'admin@shinil.com' && password === 'admin123') {
      // JWT 토큰 생성
      const token = jwt.sign(
        {
          id: 'test-user-id',
          email: email,
          role: 'admin',
          name: '관리자'
        },
        JWT_SECRET,
        { expiresIn: JWT_EXPIRES_IN }
      )

      return res.status(200).json({
        success: true,
        data: {
          token,
          user: {
            id: 'test-user-id',
            email: email,
            role: 'admin',
            name: '관리자'
          }
        },
        message: '로그인 성공'
      })
    } else {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

  } catch (error) {
    console.error('로그인 에러:', error)
    res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다: ' + error.message
    })
  }
} 