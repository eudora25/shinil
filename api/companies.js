import jwt from 'jsonwebtoken'
import { createClient } from '@supabase/supabase-js'

// Supabase 클라이언트 설정
const supabaseUrl = process.env.VERCEL_SUPABASE_URL || 'https://selklngerzfmuvagcvvf.supabase.co'
const supabaseKey = process.env.VERCEL_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U'

const supabase = createClient(supabaseUrl, supabaseKey)

// JWT 설정
const JWT_SECRET = process.env.JWT_SECRET || 'shinil-pms-secret-key-2024'

// JWT 토큰 검증 함수
function verifyToken(req) {
  const authHeader = req.headers.authorization
  const token = authHeader && authHeader.split(' ')[1] // Bearer TOKEN

  if (!token) {
    throw new Error('액세스 토큰이 필요합니다')
  }

  try {
    return jwt.verify(token, JWT_SECRET)
  } catch (error) {
    throw new Error('유효하지 않은 토큰입니다')
  }
}

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  // GET 요청만 허용
  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      error: 'method_not_allowed',
      message: 'GET 메서드만 허용됩니다'
    })
  }

  try {
    // JWT 토큰 검증
    const user = verifyToken(req)

    // Supabase에서 회사 데이터 조회
    const { data: companies, error } = await supabase
      .from('companies')
      .select('*')
      .order('id')
      .limit(50)

    if (error) {
      throw error
    }

    res.status(200).json({
      success: true,
      data: companies,
      total_count: companies.length,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name
      },
      timestamp: new Date().toISOString()
    })

  } catch (error) {
    console.error('회사 데이터 조회 에러:', error)
    
    if (error.message.includes('토큰')) {
      return res.status(401).json({
        success: false,
        error: 'authentication_error',
        message: error.message
      })
    }

    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
} 