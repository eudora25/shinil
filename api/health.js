import express from 'express'
import { createClient } from '@supabase/supabase-js'

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

// 서버 시작 시간 기록 (uptime 계산용)
const serverStartTime = Date.now()

// GET /api/health - 시스템 상태 확인
router.get('/', async (req, res) => {
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

    // 데이터베이스 연결 테스트
    const { data, error } = await supabase
      .from('notices')
      .select('count', { count: 'exact', head: true })

    if (error) {
      return res.status(500).json({
        success: false,
        message: 'Database connection failed',
        error: error.message
      })
    }

    // 02_시스템_헬스체크.xlsx 파일 형식에 맞춘 응답
    const currentTime = Date.now()
    const uptimeSeconds = Math.floor((currentTime - serverStartTime) / 1000)

    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: uptimeSeconds,
      environment: process.env.NODE_ENV || 'development'
    })

  } catch (error) {
    console.error('Health check API error:', error)
    res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
})

export default router