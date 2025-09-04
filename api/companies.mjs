// 단순화된 Vercel 서버리스 함수 형식
import { createClient } from '@supabase/supabase-js'

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed'
    })
  }

  try {
    // 환경 변수 직접 사용
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

    if (!supabaseUrl || !supabaseAnonKey) {
      console.error('Missing Supabase configuration')
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Missing Supabase configuration'
      })
    }

    // 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Authorization header missing or invalid'
      })
    }

    const token = authHeader.substring(7)
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token missing'
      })
    }

    // Supabase 클라이언트 생성 (토큰 검증용)
    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    if (authError || !user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token'
      })
    }

    // admin 타입 사용자만 허용
    if (user.user_metadata?.user_type !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Admin access required'
      })
    }

    // 데이터 조회용 Supabase 클라이언트 (Service Role Key 사용)
    const supabase = serviceRoleKey 
      ? createClient(supabaseUrl, serviceRoleKey)
      : createClient(supabaseUrl, supabaseAnonKey)

    // 쿼리 파라미터 파싱
    const { 
      page = 1, 
      limit = 100, 
      startDate, 
      endDate 
    } = req.query
    
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    // 입력값 검증
    if (pageNum < 1 || limitNum < 1 || limitNum > 1000) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pagination parameters'
      })
    }

    // 기본 쿼리 설정
    let query = supabase
      .from('clients')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링
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
        message: 'Failed to fetch companies',
        error: getError.message
      })
    }

    // 응답
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
      message: 'Internal server error',
      error: error.message
    })
  }
}