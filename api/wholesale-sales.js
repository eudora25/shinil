// Vercel 서버리스 함수 형식으로 변경 (15_도매매출_조회.xlsx 형식에 맞춤)
import { createClient } from '@supabase/supabase-js'

// Vercel에서는 환경 변수가 자동으로 로드됨
console.log('✅ Vercel 환경 변수 로드됨')

// IP 제한 함수 (Vercel 환경용)
function checkIPAccess(req) {
  console.log("🔓 Vercel 환경: IP 제한 비활성화")
  return { allowed: true }
}

export default async function handler(req, res) {
  try {
    // 환경 변수 확인 (Vercel용 - fallback 포함)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://vaeolqywqckiwwtspxfp.supabase.co'
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30'
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g'

    // 환경 변수 디버깅
    console.log('Wholesale Sales API - Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
    })

    // 환경 변수가 없으면 기본값 사용 (개발용)
    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    const token = authHeader.substring(7)
    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    if (authError || !user || user.user_metadata?.user_type !== 'admin') {
      return res.status(401).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // Supabase 클라이언트 생성 (RLS 정책 무시를 위해 Service Role Key 사용)
    let supabase
    if (serviceRoleKey) {
      console.log('🔍 Using Service Role Key for RLS bypass')
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      console.log('🔍 Service Role Key not available, using Anon Key')
      supabase = createClient(supabaseUrl, supabaseAnonKey)
    }

    // 연결 테스트 (간단한 쿼리)
    const { data: testData, error: testError } = await supabase
      .from('wholesale_sales')
      .select('id')
      .limit(1)

    if (testError) {
      console.error('Supabase connection test failed:', testError)
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 쿼리 파라미터 파싱 (15_도매매출_조회.xlsx 형식에 맞춤)
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
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 기본 쿼리 설정
    let query = supabase
      .from('wholesale_sales')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.gte('sales_date', startDate)
    }
    if (endDate) {
      query = query.lte('sales_date', endDate)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    // 데이터 조회
    const { data, error, count } = await query

    console.log('🔍 Wholesale Sales query result:', { data: data?.length, error, count })

    if (error) {
      console.error('Wholesale Sales fetch error:', error)
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 100
      })
    }

    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 15_도매매출_조회.xlsx 스펙에 맞춘 응답
    const response = {
      success: true,
      data: data || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum,
      totalPages,
      hasNextPage,
      hasPrevPage
    }

    res.json(response)

  } catch (error) {
    console.error('Wholesale Sales API error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })

    return res.status(500).json({
      success: false,
      data: [],
      count: 0,
      page: 1,
      limit: 100
    })
  }
}
