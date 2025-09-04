// Vercel 서버리스 함수 형식 (07_병원정보_조회.xlsx 형식에 맞춤)
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
    // 토큰 검증
    await validateToken(req)

    // Supabase 클라이언트 생성
    const supabase = createSupabaseClient()

    // 쿼리 파라미터 파싱 (07_병원정보_조회.xlsx 형식에 맞춤)
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
      .from('clients')
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
    const { data: clients, error: getError, count } = await query

    if (getError) {
      console.error('Clients fetch error:', getError)
      return res.status(500).json({
        success: false,
        message: '병원 정보 조회 중 오류가 발생했습니다.',
        error: getError.message
      })
    }

    // 07_병원정보_조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '병원 정보 조회 성공',
      data: clients || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    }

    res.json(response)

  } catch (error) {
    console.error('Clients API error:', error)
    
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
    
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
}
