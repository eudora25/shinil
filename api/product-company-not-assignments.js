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
    const productId = req.query.product_id
    const companyId = req.query.company_id

    // 페이지네이션 유효성 검사
    if (page < 1 || limit < 1 || limit > 1000) {
      return res.status(400).json({
        success: false,
        message: '잘못된 페이지네이션 파라미터입니다.',
        error: 'Invalid pagination parameters'
      })
    }

    const offset = (page - 1) * limit

    // 제품-업체 미배정 매핑 정보 목록 조회
    // 실제로는 product_company_assignments 테이블이 존재하지 않으므로 임시로 제품과 업체 목록을 반환
    let query = supabase
      .from('products')
      .select(`
        id,
        product_name,
        insurance_code,
        status
      `, { count: 'exact' })
      .eq('status', 'active')
      .order('product_name', { ascending: true })

    // 제품 ID 필터링
    if (productId) {
      query = query.eq('id', productId)
    }

    // 검색 기능
    if (search && search.trim()) {
      const searchTerm = search.trim()
      query = query.ilike('product_name', `%${searchTerm}%`)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limit - 1)

    const { data: products, error: productsError, count } = await query

    if (productsError) {
      console.error('Products query error:', productsError)
      return res.status(500).json({
        success: false,
        message: '제품-업체 미배정 매핑 정보 목록 조회 중 오류가 발생했습니다.',
        error: productsError.message
      })
    }

    // 업체 목록도 조회
    const { data: companies, error: companiesError } = await supabase
      .from('companies')
      .select(`
        id,
        company_name,
        business_registration_number,
        status
      `)
      .eq('status', 'active')
      .order('company_name', { ascending: true })

    if (companiesError) {
      console.error('Companies query error:', companiesError)
      return res.status(500).json({
        success: false,
        message: '업체 정보 조회 중 오류가 발생했습니다.',
        error: companiesError.message
      })
    }

    // 임시 매핑 데이터 생성 (실제로는 product_company_assignments 테이블이 필요함)
    const mockAssignments = products.map((product, index) => ({
      id: `mock-${index + 1}`,
      product_id: product.id,
      company_id: null, // 미배정 상태
      status: 'not_assigned',
      created_at: new Date().toISOString(),
      products: product,
      companies: null
    }))

    // 페이지네이션 정보 계산
    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / limit)
    const hasNextPage = page < totalPages
    const hasPrevPage = page > 1

    return res.status(200).json({
      success: true,
      message: '제품-업체 미배정 매핑 정보 목록 조회 성공 (임시 데이터)',
      data: mockAssignments || [],
      pagination: {
        currentPage: page,
        limit,
        totalCount,
        totalPages,
        hasNextPage,
        hasPrevPage
      },
      note: '실제 product_company_assignments 테이블이 필요합니다.'
    })

  } catch (error) {
    console.error('Product-company not assignments API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
