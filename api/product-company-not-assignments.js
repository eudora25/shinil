// Vercel 서버리스 함수 형식으로 변경 (14_제품업체_미배정매핑.xlsx 형식에 맞춤)
import { createClient } from '@supabase/supabase-js'



// 환경 변수 로드
const nodeEnv = process.env.NODE_ENV || 'development'
const envFile = nodeEnv === 'production' ? '.env.production' : '.env.local'

try {
  config({ 
    path: path.join(__dirname, '..', envFile),
    override: true
  })
  console.log(`✅ 환경 파일 로드 성공: ${envFile}`)


// IP 제한 함수
function checkIPAccess(req) {
  console.log("🔓 Vercel 환경: IP 제한 비활성화")
  return { allowed: true }
}
// IP 주소를 long으로 변환
function ipToLong(ip) {
  return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0) >>> 0
}
} catch (error) {
  console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
}

export default async function handler(req, res) {
  try {
    // GET 메서드만 허용
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 환경 변수 확인
    const supabaseUrl = (process.env.VITE_SUPABASE_URL || "https://vaeolqywqckiwwtspxfp.supabase.co" || process.env.SUPABASE_URL)?.trim()
    const supabaseAnonKey = (process.env.VITE_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30" || process.env.SUPABASE_ANON_KEY)?.trim()
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g"?.trim()

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // Supabase 클라이언트 생성 (Service Role Key 사용)
    let supabase
    if (serviceRoleKey) {
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      supabase = createClient(supabaseUrl, supabaseAnonKey)
    }

    // 연결 테스트
    const { data: testData, error: testError } = await supabase
      .from('products')
      .select('id')
      .limit(1)

    if (testError) {
      return res.status(500).json({
        success: false,
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // Authorization 헤더 확인
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

    // 토큰 검증
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      return res.status(401).json({ 
        success: false, 
        data: [],
        count: 0,
        page: 1,
        limit: 100
      })
    }

    // 쿼리 파라미터 파싱 (14_제품업체_미배정매핑.xlsx 형식에 맞춤)
    const { 
      page = 1, 
      limit = 100, 
      startDate, 
      endDate,
      company_id
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

    // 기본 쿼리 설정 (모든 상태의 제품 조회)
    let query = supabase
      .from('products')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.gte('created_at', startDate)
    }
    if (endDate) {
      query = query.lte('created_at', endDate)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    const { data: products, error: queryError, count } = await query

    if (queryError) {
      console.error('Product company not assignments query error:', queryError)
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

    // 14_제품업체_미배정매핑.xlsx 스펙에 맞춘 응답
    const response = {
      success: true,
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
    console.error('Product company not assignments API error:', error)
    res.status(500).json({ 
      success: false, 
      data: [],
      count: 0,
      page: 1,
      limit: 100
    })
  }
}
