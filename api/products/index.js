import { createClient } from '@supabase/supabase-js'

export default async function handler(req, res) {
  console.log('🚀 === Products API 호출 시작 ===')
  console.log('📝 Method:', req.method)
  console.log('📝 URL:', req.url)
  console.log('📝 Query params:', req.query)
  console.log('📝 Headers keys:', Object.keys(req.headers))

  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.method === 'OPTIONS') {
    console.log('✅ CORS preflight 처리 완료')
    return res.status(200).end()
  }

  // GET 요청만 처리
  if (req.method !== 'GET') {
    console.log('❌ Method not allowed:', req.method)
    return res.status(405).json({ success: false, message: 'Method not allowed' })
  }

  console.log('✅ GET 요청 확인됨')

  try {
    console.log('🔧 === 환경 변수 확인 시작 ===')
    
    // 환경 변수에서 Supabase 설정 가져오기 (Vercel Functions 호환)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || "https://selklngerzfmuvagcvvf.supabase.co"
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U"

    console.log('🔧 Supabase URL:', supabaseUrl)
    console.log('🔧 Supabase Key:', supabaseAnonKey ? '설정됨 (길이: ' + supabaseAnonKey.length + ')' : '설정되지 않음')
    console.log('🔧 NODE_ENV:', process.env.NODE_ENV)
    console.log('🔧 VERCEL_ENV:', process.env.VERCEL_ENV)

    if (!supabaseUrl || !supabaseAnonKey) {
      console.log('❌ Supabase 설정 누락')
      return res.status(500).json({ 
        success: false, 
        message: 'Supabase configuration missing' 
      })
    }

    console.log('✅ Supabase 설정 확인 완료')

    // Supabase 클라이언트 생성
    console.log('🔧 === Supabase 클라이언트 생성 시작 ===')
    const supabase = createClient(supabaseUrl, supabaseAnonKey)
    console.log('✅ Supabase 클라이언트 생성 완료')

    // Authorization 헤더 확인
    console.log('🔧 === 인증 헤더 확인 시작 ===')
    const authHeader = req.headers.authorization
    console.log('🔧 Authorization header:', authHeader ? authHeader.substring(0, 50) + '...' : '없음')
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log('❌ Authorization 헤더 누락 또는 잘못된 형식')
      return res.status(401).json({ 
        success: false, 
        message: 'Unauthorized: Access token is required' 
      })
    }

    const token = authHeader.substring(7)
    console.log('🔧 Token 길이:', token.length)
    console.log('🔧 Token 시작 부분:', token.substring(0, 20) + '...')
    console.log('✅ Authorization 헤더 확인 완료')

    // 토큰 검증
    console.log('🔧 === 토큰 검증 시작 ===')
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    
    if (authError || !user) {
      console.log('❌ 토큰 검증 실패')
      console.log('❌ Auth error:', authError)
      console.log('❌ User data:', user)
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired token' 
      })
    }

    console.log('✅ 토큰 검증 성공')
    console.log('✅ User ID:', user.id)
    console.log('✅ User email:', user.email)

    // 페이지·리미트 파라미터 (메타 정보로 응답에 포함)
    console.log('🔧 === 쿼리 파라미터 파싱 시작 ===')
    const page = parseInt(req.query.page) || 1
    const limit = parseInt(req.query.limit) || 100
    console.log('🔧 Page:', page, 'Limit:', limit)

    // 날짜 필터 파라미터 처리 (기본: 2025-01-01 ~ 2025-12-31)
    const { startDate: qsStart, endDate: qsEnd } = req.query
    console.log('🔧 Raw startDate:', qsStart)
    console.log('🔧 Raw endDate:', qsEnd)
    
    // 날짜 유틸리티 함수들 (로컬과 동일)
    function parseDateOnly(input) {
      if (!input) return null
      const date = new Date(input)
      const isValid = !isNaN(date.getTime())
      console.log('🔧 parseDateOnly input:', input, 'result:', date, 'valid:', isValid)
      return isValid ? date : null
    }

    function startOfDay(date) {
      const d = new Date(date)
      d.setHours(0, 0, 0, 0)
      console.log('🔧 startOfDay input:', date, 'result:', d)
      return d
    }

    function endOfDay(date) {
      const d = new Date(date)
      d.setHours(23, 59, 59, 999)
      console.log('🔧 endOfDay input:', date, 'result:', d)
      return d
    }

    function getDefaultDateRange() {
      // 기본값을 과거 데이터가 있는 기간으로 설정 (2025-01-01 ~ 2025-12-31)
      const start = new Date('2025-01-01')
      const end = new Date('2025-12-31')
      console.log('🔧 getDefaultDateRange result:', { start, end })
      return { start, end }
    }

    console.log('🔧 === 날짜 처리 시작 ===')
    const { start: defaultStart, end: defaultEnd } = getDefaultDateRange()
    console.log('🔧 Default start:', defaultStart)
    console.log('🔧 Default end:', defaultEnd)
    
    const parsedStart = parseDateOnly(qsStart)
    const parsedEnd = parseDateOnly(qsEnd)
    console.log('🔧 Parsed start:', parsedStart)
    console.log('🔧 Parsed end:', parsedEnd)
    
    const startDate = startOfDay(parsedStart || defaultStart)
    const endDate = endOfDay(parsedEnd || defaultEnd)
    console.log('🔧 Final startDate:', startDate.toISOString())
    console.log('🔧 Final endDate:', endDate.toISOString())

    if (startDate > endDate) {
      console.log('❌ 날짜 범위 오류: startDate > endDate')
      return res.status(400).json({
        success: false,
        message: 'startDate must be less than or equal to endDate'
      })
    }

    console.log('✅ 날짜 처리 완료')

    // 제품 정보 조회 (전체 건수 포함) - 로컬과 동일한 쿼리
    console.log('🔧 === 제품 쿼리 시작 ===')
    let query = supabase
      .from('products')
      .select('*', { count: 'exact' })
      .order('updated_at', { ascending: false })

    console.log('🔧 Base query created')

    // created_at OR updated_at 기준 날짜 필터 - 로컬과 동일한 구문
    const firstFilter = `created_at.gte.${startDate.toISOString()},updated_at.gte.${startDate.toISOString()}`
    const secondFilter = `created_at.lte.${endDate.toISOString()},updated_at.lte.${endDate.toISOString()}`
    
    console.log('🔧 First filter:', firstFilter)
    console.log('🔧 Second filter:', secondFilter)
    
    query = query.or(firstFilter)
    console.log('🔧 First OR filter applied')
    
    query = query.or(secondFilter)
    console.log('🔧 Second OR filter applied')

    console.log('🔧 === 쿼리 실행 시작 ===')
    const { data: products, error: productsError, count: totalCount } = await query
    
    console.log('🔧 === 쿼리 결과 ===')
    console.log('🔧 Products data type:', typeof products)
    console.log('🔧 Products is array:', Array.isArray(products))
    console.log('🔧 Products length:', products ? products.length : 'null')
    console.log('🔧 Total count:', totalCount)
    console.log('🔧 Products error:', productsError)
    
    if (productsError) {
      console.log('❌ 제품 쿼리 오류')
      console.error('❌ Products query error:', productsError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch products',
        error: productsError.message
      })
    }

    console.log('✅ 제품 쿼리 성공')
    
    // products_standard_code 정보 조회 - 로컬과 동일
    console.log('🔧 === 표준 코드 쿼리 시작 ===')
    const { data: standardCodes, error: standardCodesError } = await supabase
      .from('products_standard_code')
      .select('*')
      .eq('status', 'active')
    
    console.log('🔧 === 표준 코드 쿼리 결과 ===')
    console.log('🔧 Standard codes data type:', typeof standardCodes)
    console.log('🔧 Standard codes is array:', Array.isArray(standardCodes))
    console.log('🔧 Standard codes length:', standardCodes ? standardCodes.length : 'null')
    console.log('🔧 Standard codes error:', standardCodesError)
    
    if (standardCodesError) {
      console.log('❌ 표준 코드 쿼리 오류')
      console.error('❌ Standard codes query error:', standardCodesError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch standard codes',
        error: standardCodesError.message
      })
    }

    console.log('✅ 표준 코드 쿼리 성공')
    
    // insurance_code를 기준으로 데이터 조합 - 로컬과 동일
    console.log('🔧 === 데이터 조합 시작 ===')
    console.log('🔧 Products count for mapping:', products ? products.length : 'null')
    console.log('🔧 Standard codes count for mapping:', standardCodes ? standardCodes.length : 'null')
    
    const productsWithStandardCode = products.map((product, index) => {
      if (index < 3) { // 처음 3개만 로그
        console.log('🔧 Processing product', index, ':', {
          id: product.id,
          insurance_code: product.insurance_code,
          created_at: product.created_at,
          updated_at: product.updated_at
        })
      }
      
      const standardCode = standardCodes.find(sc => sc.insurance_code === product.insurance_code)
      if (index < 3) {
        console.log('🔧 Found standard code for product', index, ':', standardCode ? 'yes' : 'no')
      }
      
      return {
        ...product,
        standard_code: standardCode?.standard_code || null,
        unit_packaging_desc: standardCode?.unit_packaging_desc || null,
        unit_quantity: standardCode?.unit_quantity || null
      }
    })
    
    console.log('🔧 === 최종 데이터 ===')
    console.log('🔧 Final products count:', productsWithStandardCode.length)
    console.log('🔧 First product sample:', productsWithStandardCode.length > 0 ? {
      id: productsWithStandardCode[0].id,
      insurance_code: productsWithStandardCode[0].insurance_code,
      standard_code: productsWithStandardCode[0].standard_code
    } : 'no data')
    
    // 응답 구조 - 로컬과 동일
    const response = {
      success: true,
      data: productsWithStandardCode || [],
      totalCount: totalCount || 0,
      filters: {
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        page,
        limit
      }
    }
    
    console.log('🔧 === 응답 준비 완료 ===')
    console.log('🔧 Response data length:', response.data.length)
    console.log('🔧 Response totalCount:', response.totalCount)
    console.log('🔧 Response filters:', response.filters)
    
    console.log('✅ === Products API 성공적으로 완료 ===')
    res.json(response)

  } catch (error) {
    console.log('❌ === Products API 오류 발생 ===')
    console.error('❌ Products API error:', error)
    console.error('❌ Error stack:', error.stack)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
} 