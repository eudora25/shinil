// Vercel 서버리스 함수 형식 (21_정산내역서_목록조회.xlsx 형식에 맞춤)
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
    console.log('🚀 Settlement Share API 호출됨:', req.method, req.url)
    
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      console.log('❌ IP 접근 거부됨')
      return res.status(403).json(ipCheck.error)
    }

    // GET 메서드만 허용
    if (req.method !== 'GET') {
      console.log('❌ 잘못된 HTTP 메서드:', req.method)
      return res.status(405).json({
        success: false,
        message: 'Method not allowed'
      })
    }

    // 환경 변수 확인 (Vercel용 - fallback 포함)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://vaeolqywqckiwwtspxfp.supabase.co'
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30'
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g'

    console.log('🔍 Settlement Share API - Supabase 설정 확인:')
    console.log('Supabase URL:', supabaseUrl ? '설정됨' : '미설정')
    console.log('Supabase Key:', supabaseAnonKey ? '설정됨' : '미설정')
    console.log('Service Role Key:', serviceRoleKey ? '설정됨' : '미설정')

    // Supabase 클라이언트 생성 (Service Role Key 사용 - RLS 우회)
    if (!supabaseUrl || !serviceRoleKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase environment variables not configured',
        debug: {
          supabaseUrl: !!supabaseUrl,
          serviceRoleKey: !!serviceRoleKey
        }
      })
    }

    console.log('🔑 Service Role Key 사용하여 Supabase 클라이언트 생성')
    const supabase = createClient(supabaseUrl, serviceRoleKey)

    // 쿼리 파라미터 파싱
    const { page = 1, limit = 100, startDate, endDate, settlement_month, client_id } = req.query

    console.log('📝 쿼리 파라미터:', { page, limit, startDate, endDate, settlement_month, client_id })

    // 여러 가능한 테이블명 시도
    const possibleTableNames = [
      'settlement_shares',
      'settlement_share', 
      'settlements',
      'settlement',
      'shares',
      'settlement_data',
      'settlement_list'
    ]

    let tableName = null
    let sampleData = null

    for (const table of possibleTableNames) {
      console.log(`🔍 테이블 "${table}" 확인 중...`)
      const { data, error } = await supabase
        .from(table)
        .select('*')
        .limit(1)

      if (!error) {
        tableName = table
        sampleData = data
        console.log(`✅ 테이블 "${table}" 찾음!`)
        break
      } else {
        console.log(`❌ 테이블 "${table}" 없음:`, error.message)
      }
    }

    if (!tableName) {
      return res.status(500).json({
        success: false,
        message: '정산 관련 테이블을 찾을 수 없습니다.',
        error: 'No settlement table found',
        attempted_tables: possibleTableNames
      })
    }

    console.log('✅ 테이블 구조 확인 완료:', sampleData?.[0] ? Object.keys(sampleData[0]) : '테이블이 비어있음')

    // 기본 쿼리 구성
    let query = supabase
      .from(tableName)
      .select('*', { count: 'exact' })

    // 날짜 필터 적용
    if (startDate && endDate) {
      query = query.gte('settlement_date', startDate).lte('settlement_date', endDate)
    }

    if (settlement_month) {
      query = query.eq('settlement_month', settlement_month)
    }

    if (client_id) {
      query = query.eq('client_id', client_id)
    }

    // 페이지네이션 적용
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // 정렬 (최신순)
    query = query.order('settlement_date', { ascending: false })

    console.log('🔍 Supabase 쿼리 실행 중...')
    const { data, error, count } = await query

    if (error) {
      console.error('❌ Supabase 쿼리 에러:', error)
      return res.status(500).json({
        success: false,
        message: '데이터베이스 조회 중 오류가 발생했습니다.',
        error: error.message
      })
    }

    console.log('✅ 정산내역서 데이터 조회 성공:', data?.length || 0, '개')

    // 21_정산내역서_목록조회.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '정산내역서 목록 조회 성공',
      data: {
        settlement_shares: data || [],
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: count || 0,
          totalPages: Math.ceil((count || 0) / limit)
        },
        filters: {
          startDate: startDate || null,
          endDate: endDate || null,
          settlement_month: settlement_month || null,
          client_id: client_id || null
        }
      },
      timestamp: new Date().toISOString()
    }

    res.json(response)

  } catch (error) {
    console.error('❌ Settlement Share API 에러:', error)
    res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}