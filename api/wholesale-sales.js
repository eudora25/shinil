import { createClient } from '@supabase/supabase-js'
import { getEnvironmentVariables } from './lib/supabase.js'

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

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        message: 'Method not allowed. Only GET is supported.'
      })
    }

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

    // 쿼리 파라미터 파싱
    const page = parseInt(req.query.page) || 1
    const limit = parseInt(req.query.limit) || 100
    const search = req.query.search || ''
    const pharmacyCode = req.query.pharmacy_code
    const standardCode = req.query.standard_code
    const startDate = req.query.start_date
    const endDate = req.query.end_date

    // 페이지네이션 유효성 검사
    if (page < 1 || limit < 1 || limit > 1000) {
      return res.status(400).json({
        success: false,
        message: '잘못된 페이지네이션 파라미터입니다.',
        error: 'Invalid pagination parameters'
      })
    }

    const offset = (page - 1) * limit

    // 도매 매출 목록 조회
    let query = supabase
      .from('wholesale_sales')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 약국 코드 필터링
    if (pharmacyCode) {
      query = query.eq('pharmacy_code', pharmacyCode)
    }

    // 표준 코드 필터링
    if (standardCode) {
      query = query.eq('standard_code', standardCode)
    }

    // 날짜 범위 필터링
    if (startDate) {
      query = query.gte('sales_date', startDate)
    }
    if (endDate) {
      query = query.lte('sales_date', endDate)
    }

    // 검색 기능
    if (search && search.trim()) {
      const searchTerm = search.trim()
      query = query.or(`pharmacy_name.ilike.%${searchTerm}%,product_name.ilike.%${searchTerm}%`)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limit - 1)

    const { data, error, count } = await query

    if (error) {
      console.error('Wholesale sales query error:', error)
      return res.status(500).json({
        success: false,
        message: '도매 매출 목록 조회 중 오류가 발생했습니다.',
        error: error.message
      })
    }

    // 페이지네이션 정보 계산
    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / limit)
    const hasNextPage = page < totalPages
    const hasPrevPage = page > 1

    return res.status(200).json({
      success: true,
      message: '도매 매출 목록 조회 성공',
      data: data || [],
      pagination: {
        currentPage: page,
        limit,
        totalCount,
        totalPages,
        hasNextPage,
        hasPrevPage
      }
    })

  } catch (error) {
    console.error('Wholesale sales API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
