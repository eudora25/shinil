// Express.js 라우터 형식으로 변경 (10_병원업체_관계정보.xlsx 형식에 맞춤)
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

=======
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  return { supabaseUrl, supabaseAnonKey }
}

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

// GET /api/hospital-company-mappings - 병원-업체 관계 정보 조회 (10_병원업체_관계정보.xlsx 형식에 맞춤)
// Bearer Token 인증 필요
router.get('/', tokenValidationMiddleware, async (req, res) => {
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
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

<<<<<<< HEAD
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

    // 쿼리 파라미터 파싱
    const { page = 1, limit = 100, startDate, endDate } = req.query

    // 기본 쿼리 시작
    let query = supabase
      .from('hospital_company_mappings')
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
    const { data: mappings, error: mappingsError, count: totalCount } = await query

    if (mappingsError) {
      console.error('Hospital company mappings query error:', mappingsError)
      return res.status(500).json({ 
        success: false, 
        message: 'Database query failed' 
      })
    }

    // 성공 응답
    res.status(200).json({
      success: true,
      data: mappings || [],
      totalCount: totalCount || 0,
      filters: {
        startDate: startDate ? new Date(startDate).toISOString() : null,
        endDate: endDate ? new Date(endDate).toISOString() : null,
        page: parseInt(page),
        limit: parseInt(limit)
      }
    })
=======
    // 쿼리 파라미터 파싱 (10_병원업체_관계정보.xlsx 형식에 맞춤)
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
    let query = supabase
      .from('client_company_assignments')
      .select(`
        *,
        clients:client_id(id, name, address, business_registration_number, client_code, owner_name),
        companies:company_id(id, company_name, business_registration_number, representative_name)
      `, { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.gte('created_at', startDate)
    }
    if (endDate) {
      query = query.lte('created_at', endDate)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    // 데이터 조회
    const { data: mappings, error: getError, count } = await query

    if (getError) throw getError

    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 10_병원업체_관계정보.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '병원-회사 매핑 목록 조회 성공',
      data: mappings || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)
>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0

  } catch (error) {
    console.error('Hospital company mappings API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
<<<<<<< HEAD
}
=======
})

export default router

>>>>>>> 2f1998dc3c49490144efab1f822ea3a02743a4f0
