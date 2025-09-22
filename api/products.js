// Vercel 서버리스 함수 형식 (06_제품정보_조회.xlsx 형식에 맞춤)
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
    console.log('🚀 Products API 호출됨:', req.method, req.url)
    
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      console.log('❌ IP 접근 거부됨')
      return res.status(403).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // GET 메서드만 허용
    if (req.method !== 'GET') {
      console.log('❌ 잘못된 HTTP 메서드:', req.method)
      return res.status(405).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 환경 변수 확인 (Vercel용 - fallback 포함)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://vaeolqywqckiwwtspxfp.supabase.co'
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30'
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g'

    console.log('🔍 Products API - Supabase 설정 확인:')
    console.log('Supabase URL:', supabaseUrl ? '설정됨' : '미설정')
    console.log('Supabase Key:', supabaseAnonKey ? '설정됨' : '미설정')
    console.log('Service Role Key:', serviceRoleKey ? '설정됨' : '미설정')

    // Supabase 클라이언트 생성 (Service Role Key 사용 - RLS 우회)
    if (!supabaseUrl || !serviceRoleKey) {
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
      console.log('❌ Authorization 헤더가 없거나 Bearer 형식이 아님')
      return res.status(401).json({
        success: false,
        message: 'Authorization 헤더가 필요합니다'
      })
    }

    const token = authHeader.substring(7)
    console.log('🔍 토큰 검증 시작:', token.substring(0, 20) + '...')
    
    const supabaseAuth = createClient(supabaseUrl, serviceRoleKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    console.log('🔍 Supabase 토큰 검증 결과:')
    console.log('- authError:', authError)
    console.log('- user 존재:', !!user)
    console.log('- user_type:', user?.user_metadata?.user_type)

    if (authError) {
      console.log('❌ 토큰 인증 오류:', authError)
      return res.status(401).json({
        success: false,
        message: 'Token authentication failed',
        debug: {
          error: authError.message,
          code: authError.code
        }
      })
    }

    if (!user) {
      console.log('❌ 사용자 정보를 찾을 수 없음')
      return res.status(401).json({
        success: false,
        message: 'User not found'
      })
    }

    if (user.user_metadata?.user_type !== 'admin') {
      console.log('❌ 관리자 권한 부족. 현재 user_type:', user.user_metadata?.user_type)
      return res.status(403).json({
        success: false,
        message: 'Admin access required',
        debug: {
          userType: user.user_metadata?.user_type,
          required: 'admin'
        }
      })
    }

    console.log('✅ 토큰 검증 성공 - Admin 사용자:', user.email)

    console.log('🔑 Service Role Key 사용하여 Supabase 클라이언트 생성')
    const supabase = createClient(supabaseUrl, serviceRoleKey)

    // 쿼리 파라미터 파싱 (06_제품정보_조회.xlsx 형식에 맞춤)
    const { page = 1, limit = 100, search, category, company_id, startDate, endDate } = req.query

    console.log('📝 쿼리 파라미터:', { page, limit, search, category, company_id, startDate, endDate })

    // 먼저 테이블 구조 확인을 위해 간단한 쿼리 실행
    console.log('🔍 테이블 구조 확인 중...')
    const { data: sampleData, error: sampleError } = await supabase
      .from('products')
      .select('*')
      .limit(1)

    if (sampleError) {
      console.error('❌ 테이블 접근 에러:', sampleError)
      return res.status(500).json({
        success: false,
        message: '데이터베이스 테이블 접근 중 오류가 발생했습니다.',
        error: sampleError.message
      })
    }

    console.log('✅ 테이블 구조 확인 완료:', sampleData?.[0] ? Object.keys(sampleData[0]) : '테이블이 비어있음')

    // 기본 쿼리 구성 (실제 컬럼명 사용)
    let query = supabase
      .from('products')
      .select('*', { count: 'exact' })

    // 검색 조건 추가 (실제 컬럼명으로 수정)
    if (search) {
      // product_name 컬럼으로 검색
      query = query.or(`product_name.ilike.%${search}%, product_code.ilike.%${search}%`)
    }

    if (category) {
      query = query.eq('category', category)
    }

    if (company_id) {
      query = query.eq('company_id', company_id)
    }

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    // created_at 또는 updated_at이 지정된 날짜 범위에 포함되는 경우
    if (startDate) {
      query = query.or(`created_at.gte.${startDate},updated_at.gte.${startDate}`)
    }
    if (endDate) {
      query = query.or(`created_at.lte.${endDate},updated_at.lte.${endDate}`)
    }

    // 페이지네이션 적용
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // 정렬 (실제 컬럼명으로 수정)
    query = query.order('product_name', { ascending: true })

    console.log('🔍 Supabase 쿼리 실행 중...')
    const { data, error, count } = await query

    if (error) {
      console.error('❌ Supabase 쿼리 에러:', error)
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: parseInt(page),
        limit: parseInt(limit)
      })
    }

    console.log('✅ 제품 데이터 조회 성공:', data?.length || 0, '개')

    // 06_제품정보_조회.xlsx 스펙에 맞춘 응답
    const response = {
      success: true,
      data: data || [],
      count: count || 0,
      page: parseInt(page),
      limit: parseInt(limit)
    }

    res.json(response)

  } catch (error) {
    console.error('❌ Products API 에러:', error)
    res.status(500).json({
      success: false,
      data: [],
      count: 0,
      page: 1,
      limit: 100
    })
  }
}