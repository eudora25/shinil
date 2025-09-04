// Express.js 라우터 형식으로 변경 (05_회사정보_조회.xlsx 형식에 맞춤)
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

// GET /api/companies - 회사정보 조회 (05_회사정보_조회.xlsx 형식에 맞춤)
// Bearer Token 인증 필요
router.get('/', tokenValidationMiddleware, async (req, res) => {
  try {
    // 쿼리 파라미터 파싱 (05_회사정보_조회.xlsx 형식에 맞춤)
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

    // 입력값 검증 (05_회사정보_조회.xlsx 요구사항에 맞춤)
    if (pageNum < 1 || limitNum < 1 || limitNum > 1000) {
      return res.status(400).json({
        success: false,
        message: '페이지 번호는 1 이상, 페이지당 항목 수는 1~1000 사이여야 합니다.',
        error: 'INVALID_PAGINATION_PARAMETERS'
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
      })
    }

    // Supabase 클라이언트 생성
<<<<<<< HEAD
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

    // 쿼리 파라미터 파싱
    const { page = 1, limit = 100, startDate, endDate } = req.query

    // 기본 쿼리 시작
    let query = supabase
      .from('companies')
      .select('*', { count: 'exact' })

    // 날짜 필터링 (created_at OR updated_at)
    if (startDate && endDate) {
      const start = new Date(startDate)
      const end = new Date(endDate)
      query = query.or(`created_at.gte.${start.toISOString()},updated_at.gte.${start.toISOString()}`)
        .or(`created_at.lte.${end.toISOString()},updated_at.lte.${end.toISOString()}`)
    }

    // 정렬 및 페이지네이션
    query = query
      .order('updated_at', { ascending: false })
      .range((page - 1) * limit, page * limit - 1)

    // 데이터 조회
    const { data: companies, error: companiesError, count: totalCount } = await query

    if (companiesError) {
      console.error('Companies query error:', companiesError)
      return res.status(500).json({ 
        success: false, 
        message: 'Database query failed' 
      })
    }

    // 성공 응답
    res.status(200).json({
      success: true,
      data: companies || [],
      totalCount: totalCount || 0,
      filters: {
        startDate: startDate ? new Date(startDate).toISOString() : null,
        endDate: endDate ? new Date(endDate).toISOString() : null,
        page: parseInt(page),
        limit: parseInt(limit)
      }
    })

  } catch (error) {
    console.error('Companies API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
=======
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        message: '서버 설정 오류',
        error: 'Supabase client initialization failed'
      })
    }

    // 기본 쿼리 설정 (clients 테이블을 companies로 사용)
    let query = supabase
      .from('clients')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    // created_at과 updated_at 두 필드를 모두 검색
    if (startDate) {
      query = query.or(`created_at.gte.${startDate},updated_at.gte.${startDate}`)
    }
    if (endDate) {
      query = query.or(`created_at.lte.${endDate},updated_at.lte.${endDate}`)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    // 데이터 조회
    const { data: companies, error: getError, count } = await query

    if (getError) {
      console.error('Companies fetch error:', getError)
      return res.status(500).json({
        success: false,
        message: '회사 정보 조회 중 오류가 발생했습니다.',
        error: getError.message
      })
    }

    // 05_회사정보_조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '회사 정보 조회 성공',
      data: companies || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)

  } catch (error) {
    console.error('Companies API error:', error)
    res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
    })
  }
})

export default router
