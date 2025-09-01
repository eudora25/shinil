import { createClient } from '@supabase/supabase-js'
import { getEnvironmentVariables } from './lib/supabase.js'

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
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')

  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    if (req.method !== 'GET') {
      return res.status(405).json({ success: false, message: 'Method not allowed. Only GET is supported.' })
    }

    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({ success: false, message: 'Server configuration error', error: 'Supabase client initialization failed', details: configError.message })
    }

    // 데이터베이스 연결 테스트
    const { data, error } = await supabase
      .from('notices')
      .select('count', { count: 'exact', head: true })

    if (error) {
      return res.status(500).json({ success: false, message: 'Database connection failed', error: error.message })
    }

    // 사용 가능한 API 엔드포인트 목록
    const availableApis = [
      { path: '/api/auth', method: 'POST', description: '사용자 로그인' },
      { path: '/api/verify-token', method: 'POST', description: '토큰 검증' },
      { path: '/api/health', method: 'GET', description: '시스템 상태 확인' },
      { path: '/api/companies', method: 'GET', description: '회사정보 조회' },
      { path: '/api/products', method: 'GET', description: '제품정보 조회' },
      { path: '/api/clients', method: 'GET', description: '병원정보 조회' },
      { path: '/api/pharmacies', method: 'GET', description: '약국정보 조회' },
      { path: '/api/notices', method: 'GET', description: '공지사항 조회' },
      { path: '/api/hospital-company-mappings', method: 'GET', description: '병원-업체 관계 정보' },
      { path: '/api/hospital-pharmacy-mappings', method: 'GET', description: '병원-약국 관계 정보' },
      { path: '/api/wholesale-sales', method: 'GET', description: '도매 매출 조회' },
      { path: '/api/direct-sales', method: 'GET', description: '직매 매출 조회' },
      { path: '/api/client-company-assignments', method: 'GET', description: '병원-업체 매핑정보' },
      { path: '/api/client-pharmacy-assignments', method: 'GET', description: '병원-약국 매핑정보' },
      { path: '/api/product-company-not-assignments', method: 'GET', description: '제품-업체 미배정 매핑' },
      { path: '/api/settlement-months', method: 'GET', description: '정산월 목록 조회' },
      { path: '/api/performance-records', method: 'GET', description: '실적정보 목록 조회' },
      { path: '/api/performance-records-absorption', method: 'GET', description: '실적-흡수율 정보' },
      { path: '/api/performance-evidence-files', method: 'GET', description: '실적 증빙 파일' },
      { path: '/api/settlement-share', method: 'GET', description: '정산내역서 목록 조회' }
    ]

    return res.status(200).json({
      name: "Sinil PMS API",
      version: "1.0.0",
      status: "running",
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'development',
      database: "connected"
    })
  } catch (error) {
    console.error('API index error:', error)
    return res.status(500).json({ success: false, message: '서버 오류가 발생했습니다.', error: error.message, timestamp: new Date().toISOString() })
  }
}
