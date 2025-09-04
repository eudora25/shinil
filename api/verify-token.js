// 토큰 검증 API (04_토큰_검증.xlsx 형식에 맞춤)
import express from 'express'
import { createClient } from '@supabase/supabase-js'

<<<<<<< HEAD
export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  // POST 요청만 처리
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, message: 'Method not allowed' })
  }

  try {
    // 환경 변수에서 Supabase 설정 가져오기
    const supabaseUrl = process.env.VITE_SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({ 
        success: false, 
        message: 'Supabase configuration missing' 
=======
const router = express.Router()

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

// POST /api/verify-token - JWT 토큰 유효성 검증 (04_토큰_검증.xlsx 형식에 맞춤)
router.post('/', async (req, res) => {
  try {
    const { token } = req.body
    
    // 필수 파라미터 검증
    if (!token) {
      return res.status(400).json({
        success: false,
        valid: false,
        message: '토큰이 필요합니다.',
        error: 'TOKEN_MISSING'
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
      })
    }

    // Supabase 클라이언트 생성
<<<<<<< HEAD
    const supabase = createClient(supabaseUrl, supabaseAnonKey)

    // Authorization 헤더 또는 요청 본문에서 토큰 가져오기
    let token = req.headers.authorization
    if (token && token.startsWith('Bearer ')) {
      token = token.substring(7)
    } else {
      // 헤더에 없으면 본문에서 가져오기
      const { token: bodyToken } = req.body
      if (bodyToken) {
        token = bodyToken
      }
    }

    if (!token) {
      return res.status(400).json({ 
        success: false, 
        message: 'Token is required' 
      })
    }

    // 토큰 검증
    const { data: { user }, error } = await supabase.auth.getUser(token)

    if (error || !user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired token' 
      })
    }

    // 성공 응답
    res.status(200).json({
      success: true,
      message: 'Token is valid',
      data: {
        user: {
          id: user.id,
          email: user.email,
          user_metadata: user.user_metadata
=======
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        valid: false,
        message: '서버 설정 오류',
        error: 'Supabase client initialization failed'
      })
    }

    // JWT 토큰 유효성 검증
    try {
      const { data: { user }, error: tokenError } = await supabase.auth.getUser(token)
      
      if (user && !tokenError) {
        // 토큰이 유효함
        console.log(`✅ 토큰 검증 성공: 사용자 ${user.email}`)
        
        // 04_토큰_검증.xlsx 형식에 맞춘 응답
        const response = {
          success: true,
          valid: true,
          user: {
            id: user.id,
            email: user.email,
            created_at: user.created_at,
            last_sign_in_at: user.last_sign_in_at,
            user_metadata: user.user_metadata || {}
          },
          message: '토큰이 유효합니다.'
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
        }
        
        res.json(response)
        
      } else {
        // 토큰이 유효하지 않음
        console.log(`❌ 토큰 검증 실패: ${tokenError?.message}`)
        
        const response = {
          success: false,
          valid: false,
          message: '토큰이 유효하지 않습니다.',
          error: tokenError?.message || 'Invalid token'
        }
        
        res.status(401).json(response)
      }
      
    } catch (verificationError) {
      console.error('Token verification error:', verificationError)
      
      const response = {
        success: false,
        valid: false,
        message: '토큰 검증 중 오류가 발생했습니다.',
        error: verificationError.message
      }
      
      res.status(500).json(response)
    }

  } catch (error) {
    console.error('Verify token API error:', error)
<<<<<<< HEAD
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
=======
    res.status(500).json({
      success: false,
      valid: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
    })
  }
})

export default router
