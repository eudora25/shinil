import { createClient } from '@supabase/supabase-js'

// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  
  return { supabaseUrl, supabaseAnonKey }
}

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  
  try {
    return createClient(supabaseUrl, supabaseAnonKey)
  } catch (error) {
    console.error('Failed to create Supabase client:', error)
    throw error
  }
}

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        message: 'Method not allowed. Only GET is supported.'
      })
    }

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

    // 쿼리 파라미터 파싱
    const page = parseInt(req.query.page) || 1
    const limit = parseInt(req.query.limit) || 100
    const search = req.query.search || ''
    const clientId = req.query.client_id
    const pharmacyId = req.query.pharmacy_id

    // 페이지네이션 유효성 검사
    if (page < 1 || limit < 1 || limit > 1000) {
      return res.status(400).json({
        success: false,
        message: '잘못된 페이지네이션 파라미터입니다.',
        error: 'Invalid pagination parameters'
      })
    }

    const offset = (page - 1) * limit

    // 중복 관계 문제를 해결하기 위해 관계를 사용하지 않고 기본 데이터만 조회
    let query = supabase
      .from('client_pharmacy_assignments')
      .select('id, client_id, pharmacy_id, created_at', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 병원 ID 필터링
    if (clientId) {
      query = query.eq('client_id', clientId)
    }

    // 약국 ID 필터링
    if (pharmacyId) {
      query = query.eq('pharmacy_id', pharmacyId)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limit - 1)

    const { data: assignments, error, count } = await query

    if (error) {
      console.error('Hospital-pharmacy mappings query error:', error)
      return res.status(500).json({
        success: false,
        message: '병원-약국 관계 정보 목록 조회 중 오류가 발생했습니다.',
        error: error.message
      })
    }

    // 별도로 병원과 약국 정보를 조회
    let enrichedData = []
    if (assignments && assignments.length > 0) {
      // 고유한 client_id와 pharmacy_id 추출
      const clientIds = [...new Set(assignments.map(item => item.client_id))]
      const pharmacyIds = [...new Set(assignments.map(item => item.pharmacy_id))]

      // 병원 정보 조회
      const { data: clients, error: clientsError } = await supabase
        .from('clients')
        .select('id, name, address, business_registration_number, client_code, owner_name')
        .in('id', clientIds)

      if (clientsError) {
        console.error('Clients query error:', clientsError)
        return res.status(500).json({
          success: false,
          message: '병원 정보 조회 중 오류가 발생했습니다.',
          error: clientsError.message
        })
      }

      // 약국 정보 조회
      const { data: pharmacies, error: pharmaciesError } = await supabase
        .from('pharmacies')
        .select('id, name, business_registration_number, address, pharmacy_code')
        .in('id', pharmacyIds)

      if (pharmaciesError) {
        console.error('Pharmacies query error:', pharmaciesError)
        return res.status(500).json({
          success: false,
          message: '약국 정보 조회 중 오류가 발생했습니다.',
          error: pharmaciesError.message
        })
      }

      // 클라이언트와 약국 정보를 맵으로 변환
      const clientsMap = new Map(clients.map(client => [client.id, client]))
      const pharmaciesMap = new Map(pharmacies.map(pharmacy => [pharmacy.id, pharmacy]))

      // 데이터 결합
      enrichedData = assignments.map(assignment => ({
        ...assignment,
        client: clientsMap.get(assignment.client_id) || null,
        pharmacy: pharmaciesMap.get(assignment.pharmacy_id) || null
      }))
    }

    // 페이지네이션 정보 계산
    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / limit)
    const hasNextPage = page < totalPages
    const hasPrevPage = page > 1

    return res.status(200).json({
      success: true,
      message: '병원-약국 관계 정보 목록 조회 성공',
      data: enrichedData,
      pagination: {
        currentPage: page,
        limit,
        totalCount,
        totalPages,
        hasNextPage,
        hasPrevPage
      }
    })

  } catch (error) {
    console.error('Hospital-pharmacy mappings API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
