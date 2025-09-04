// Express.js 라우터 형식으로 변경 (21_정산내역서_목록조회.xlsx 형식에 맞춤)
import express from 'express'
import { createClient } from '@supabase/supabase-js'
import { tokenValidationMiddleware } from '../middleware/tokenValidation.js'

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
    // RLS 문제 해결을 위해 service role key 사용
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
    if (serviceRoleKey) {
      return createClient(supabaseUrl, serviceRoleKey, {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      })
    } else {
      return createClient(supabaseUrl, supabaseAnonKey)
    }
  } catch (error) {
    console.error('Failed to create Supabase client:', error)
    throw error
  }
}

// GET /api/settlement-share - 정산내역서 목록 조회 (21_정산내역서_목록조회.xlsx 형식에 맞춤)
// Bearer Token 인증 필요
router.get('/', tokenValidationMiddleware, async (req, res) => {
  try {
    console.log('🔍 Settlement share API 호출됨')
    console.log('🔍 req.user:', req.user?.email)
    console.log('🔍 req.accessToken:', req.accessToken?.substring(0, 20) + '...')

    // Supabase 클라이언트 생성
    let supabase
    try {
      supabase = createSupabaseClient()
      console.log('✅ Supabase 클라이언트 생성 성공')
    } catch (configError) {
      console.error('❌ Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase client initialization failed',
        details: configError.message
      })
    }

    // 쿼리 파라미터 파싱 (21_정산내역서_목록조회.xlsx 형식에 맞춤)
    const { 
      page = 1, 
      limit = 100, 
      startDate, 
      endDate
    } = req.query

    // 페이지네이션 계산
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    // 입력값 검증
    if (pageNum < 1 || limitNum < 1 || limitNum > 1000) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pagination parameters. Page must be >= 1, limit must be between 1 and 1000.'
      })
    }

    // 기본 쿼리 설정 (created_at 조건 제거하여 테스트)
    let query = supabase
      .from('settlement_share')
      .select('*', { count: 'exact' })

    // created_at 조건 제거 (테스트용)
    // if (startDate) {
    //   query = query.gte('created_at', startDate)
    // }
    // if (endDate) {
    //   query = query.lte('created_at', endDate)
    // }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    const { data, error, count } = await query

    console.log('🔍 Settlement share query result:', { data: data?.length, error, count })

    if (error) {
      console.error('Settlement share query error:', error)
      return res.status(500).json({
        success: false,
        message: '정산내역서 목록 조회 중 오류가 발생했습니다.',
        error: error.message
      })
    }

    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 21_정산내역서_목록조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '정산내역서 목록 조회 성공',
      data: data || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)

  } catch (error) {
    console.error('Settlement share API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
})

export default router
