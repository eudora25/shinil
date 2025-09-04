// Express.js 라우터 형식으로 변경 (19_실적증빙파일.xlsx 형식에 맞춤)
import express from 'express'
import { createClient } from '@supabase/supabase-js'
import { tokenValidationMiddleware } from '../middleware/tokenValidation.js'

const router = express.Router()

<<<<<<< HEAD
export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  // GET 요청만 처리
  if (req.method !== 'GET') {
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
      })
    }
=======
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
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_SERVICE_ROLE_KEY
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

// GET /api/performance-evidence-files - 실적증빙파일 정보 조회 (19_실적증빙파일.xlsx 형식에 맞춤)
// Bearer Token 인증 필요
router.get('/', tokenValidationMiddleware, async (req, res) => {
  try {
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0

    // Supabase 클라이언트 생성
    const supabase = createClient(supabaseUrl, supabaseAnonKey)

    // Authorization 헤더 확인
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        message: 'Unauthorized: Access token is required' 
      })
    }

    const token = authHeader.substring(7)

    // 토큰 검증
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired token' 
      })
    }

<<<<<<< HEAD
    // 쿼리 파라미터 파싱
    const { page = 1, limit = 100, startDate, endDate } = req.query

    // 기본 쿼리 시작
=======
    // 쿼리 파라미터 파싱 (19_실적증빙파일.xlsx 형식에 맞춤)
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

    // 기본 쿼리 설정
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
    let query = supabase
      .from('performance_evidence_files')
      .select('*', { count: 'exact' })

    // 날짜 필터링 (uploaded_at 기준)
    if (startDate && endDate) {
      const start = new Date(startDate)
      const end = new Date(endDate)
      query = query.gte('uploaded_at', start.toISOString()).lte('uploaded_at', end.toISOString())
    }

    // 정렬 및 페이지네이션
    query = query
      .order('uploaded_at', { ascending: false })
      .range((page - 1) * limit, page * limit - 1)

<<<<<<< HEAD
    // 데이터 조회
    const { data: files, error: filesError, count: totalCount } = await query
=======
    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.gte('uploaded_at', startDate)
    }
    if (endDate) {
      query = query.lte('uploaded_at', endDate)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0

    if (filesError) {
      console.error('Performance evidence files query error:', filesError)
      return res.status(500).json({ 
        success: false, 
        message: 'Database query failed' 
      })
    }

<<<<<<< HEAD
    // 성공 응답
    res.status(200).json({
      success: true,
      data: files || [],
      totalCount: totalCount || 0,
      filters: {
        startDate: startDate ? new Date(startDate).toISOString() : null,
        endDate: endDate ? new Date(endDate).toISOString() : null,
        page: parseInt(page),
        limit: parseInt(limit)
      }
    })
=======
    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 19_실적증빙파일.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '실적 증빙 파일 목록 조회 성공',
      data: data || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0

  } catch (error) {
    console.error('Performance evidence files API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
})

export default router
