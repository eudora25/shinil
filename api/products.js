const { createClient } = require('@supabase/supabase-js')

module.exports = async function handler(req, res) {
  try {
    // 환경 변수 확인 (개행 문자 제거)
    const supabaseUrl = (process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL)?.trim()
    const supabaseAnonKey = (process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY)?.trim()
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()

    // 환경 변수 디버깅
    console.log('Products API - Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
    })

    // 환경 변수가 없으면 기본값 사용 (개발용)
    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase environment variables not configured',
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing'
        }
      })
    }

    // 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    const token = authHeader.substring(7)
    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    if (authError || !user || user.user_metadata?.user_type !== 'admin') {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    // Supabase 클라이언트 생성 (RLS 정책 무시를 위해 Service Role Key 사용)
    let supabase
    if (serviceRoleKey) {
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      supabase = createClient(supabaseUrl, supabaseAnonKey)
    }
    
    // 연결 테스트 (간단한 쿼리)
    const { data: testData, error: testError } = await supabase
      .from('products')
      .select('id')
      .limit(1)
    
    if (testError) {
      console.error('Supabase connection test failed:', testError)
      return res.status(500).json({
        success: false,
        message: 'Supabase connection failed',
        error: testError.message,
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
          serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing',
          testError: testError
        }
      })
    }

    // 쿼리 파라미터 파싱 (06_제품정보_조회.xlsx 형식에 맞춤)
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
      .from('products')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.or(`created_at.gte.${startDate},updated_at.gte.${startDate}`)
    }
    if (endDate) {
      query = query.or(`created_at.lte.${endDate},updated_at.lte.${endDate}`)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    // 데이터 조회
    const { data: products, error: productsError, count } = await query
    
    console.log('🔍 Products query result:', { data: products?.length, error: productsError, count })
    
    if (productsError) {
      console.error('Products fetch error:', productsError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch products',
        error: productsError.message
      })
    }

    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 06_제품정보_조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '제품 정보 조회 성공',
      data: products || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum,
      totalPages,
      hasNextPage,
      hasPrevPage
    }

    res.json(response)

  } catch (error) {
    console.error('Products API error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })
    
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}