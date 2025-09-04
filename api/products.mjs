// Vercel 서버리스 함수 형식 (06_제품정보_조회.xlsx 형식에 맞춤)
import { createClient } from '@supabase/supabase-js'

function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  return { supabaseUrl, supabaseAnonKey, serviceRoleKey }
}

function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey, serviceRoleKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  
  try {
    // RLS 문제 해결을 위해 service role key 사용
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

// 토큰 검증 미들웨어
async function validateToken(req) {
  const authHeader = req.headers.authorization
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Authorization header missing or invalid')
  }

  const token = authHeader.substring(7)
  if (!token) {
    throw new Error('Token missing')
  }

  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey)
  const { data: { user }, error } = await supabase.auth.getUser(token)

  if (error || !user) {
    throw new Error('Invalid token')
  }

  // admin 타입 사용자만 허용
  if (user.user_metadata?.user_type !== 'admin') {
    throw new Error('Admin access required')
  }

  return user
}

export default async (req, res) => {
  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed'
    })
  }

  try {
    console.log('🔍 Products API 호출됨')

    // 토큰 검증
    const user = await validateToken(req)
    console.log('🔍 req.user:', user?.email)

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

    // 06_제품정보_조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '제품 정보 조회 성공',
      data: products || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)

  } catch (error) {
    console.error('Products API error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })
    
    if (error.message === 'Authorization header missing or invalid' || 
        error.message === 'Token missing' || 
        error.message === 'Invalid token' ||
        error.message === 'Admin access required') {
      return res.status(401).json({
        success: false,
        message: '인증이 필요합니다.',
        error: error.message
      })
    }
    
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
