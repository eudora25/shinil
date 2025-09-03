import { createClient } from '@supabase/supabase-js'

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

  // 디버깅을 위한 로그 추가
  console.log('=== Products API 호출 시작 ===')
  console.log('Query params:', req.query)
  console.log('Headers:', req.headers)

  try {
    // 환경 변수에서 Supabase 설정 가져오기 (Vercel Functions 호환)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || "https://selklngerzfmuvagcvvf.supabase.co"
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U"

    console.log('=== Supabase 설정 ===')
    console.log('URL:', supabaseUrl)
    console.log('Key:', supabaseAnonKey ? '설정됨' : '설정되지 않음')

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({ 
        success: false, 
        message: 'Supabase configuration missing' 
      })
    }

    // Supabase 클라이언트 생성
    const supabase = createClient(supabaseUrl, supabaseAnonKey)
    console.log('=== Supabase 클라이언트 생성 완료 ===')

    // Authorization 헤더 확인
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        message: 'Unauthorized: Access token is required' 
      })
    }

    const token = authHeader.substring(7)
    console.log('=== 토큰 확인 완료 ===')

    // 토큰 검증
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      console.log('=== 토큰 검증 실패 ===')
      console.log('Auth error:', authError)
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired token' 
      })
    }

    console.log('=== 토큰 검증 성공 ===')
    console.log('User:', user.email)

    // 쿼리 파라미터 파싱
    const page = parseInt(req.query.page) || 1
    const limit = parseInt(req.query.limit) || 100
    const { startDate: qsStart, endDate: qsEnd } = req.query

    console.log('=== 쿼리 파라미터 ===')
    console.log('Page:', page, 'Limit:', limit)
    console.log('StartDate:', qsStart, 'EndDate:', qsEnd)

    // 날짜 유틸리티 함수들
    function parseDateOnly(input) {
      if (!input) return null
      const date = new Date(input)
      return isNaN(date.getTime()) ? null : date
    }

    function startOfDay(date) {
      const d = new Date(date)
      d.setHours(0, 0, 0, 0)
      return d
    }

    function endOfDay(date) {
      const d = new Date(date)
      d.setHours(23, 59, 59, 999)
      return d
    }

    function getDefaultDateRange() {
      // 기본값을 과거 데이터가 있는 기간으로 설정 (2025-01-01 ~ 2025-12-31)
      const start = new Date('2025-01-01')
      const end = new Date('2025-12-31')
      return { start, end }
    }

    // 날짜 필터 파라미터 처리 (기본: 2025-01-01 ~ 2025-12-31)
    const { start: defaultStart, end: defaultEnd } = getDefaultDateRange()
    const startDate = startOfDay(parseDateOnly(qsStart) || defaultStart)
    const endDate = endOfDay(parseDateOnly(qsEnd) || defaultEnd)

    console.log('=== 날짜 필터 ===')
    console.log('StartDate:', startDate.toISOString())
    console.log('EndDate:', endDate.toISOString())

    if (startDate > endDate) {
      return res.status(400).json({
        success: false,
        message: 'startDate must be less than or equal to endDate'
      })
    }

    // 제품 정보 조회 (전체 건수 포함)
    console.log('=== 제품 쿼리 시작 ===')
    let query = supabase
      .from('products')
      .select('*', { count: 'exact' })
      .order('updated_at', { ascending: false })

    // created_at OR updated_at 기준 날짜 필터
    const dateFilter = `created_at.gte.${startDate.toISOString()},updated_at.gte.${startDate.toISOString()}`
    console.log('=== 날짜 필터 적용 ===')
    console.log('Date filter:', dateFilter)
    
    query = query.or(dateFilter)
      .or(`created_at.lte.${endDate.toISOString()},updated_at.lte.${endDate.toISOString()}`)

    console.log('=== 쿼리 실행 ===')
    const { data: products, error: productsError, count: totalCount } = await query
    
    console.log('=== 쿼리 결과 ===')
    console.log('Products count:', products ? products.length : 'null')
    console.log('Total count:', totalCount)
    console.log('Error:', productsError)
    
    if (productsError) {
      console.error('Products query error:', productsError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch products',
        error: productsError.message
      })
    }
    
    // products_standard_code 정보 조회
    console.log('=== 표준 코드 쿼리 시작 ===')
    const { data: standardCodes, error: standardCodesError } = await supabase
      .from('products_standard_code')
      .select('*')
      .eq('status', 'active')
    
    console.log('=== 표준 코드 쿼리 결과 ===')
    console.log('Standard codes count:', standardCodes ? standardCodes.length : 'null')
    console.log('Standard codes error:', standardCodesError)
    
    if (standardCodesError) {
      console.error('Standard codes query error:', standardCodesError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch standard codes',
        error: standardCodesError.message
      })
    }
    
    // insurance_code를 기준으로 데이터 조합
    console.log('=== 데이터 조합 시작 ===')
    const productsWithStandardCode = products.map(product => {
      const standardCode = standardCodes.find(sc => sc.insurance_code === product.insurance_code)
      return {
        ...product,
        standard_code: standardCode?.standard_code || null,
        unit_packaging_desc: standardCode?.unit_packaging_desc || null,
        unit_quantity: standardCode?.unit_quantity || null
      }
    })
    
    console.log('=== 최종 데이터 ===')
    console.log('Final products count:', productsWithStandardCode.length)
    
    // 성공 응답 (로컬과 동일한 구조)
    res.status(200).json({
      success: true,
      data: productsWithStandardCode || [],
      totalCount: totalCount || 0,
      filters: {
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        page,
        limit
      }
    })

  } catch (error) {
    console.error('Products API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
} 