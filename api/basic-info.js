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
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  const { type } = req.query

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

    switch (type) {
      case 'members':
        // 회원 목록 조회
        const { data: members, error: membersError } = await supabase
          .from('companies')
          .select('*')
          .order('created_at', { ascending: false })
        if (membersError) throw membersError
        return res.status(200).json({
          success: true,
          message: '회원 목록 조회 성공',
          data: members
        })

      case 'products':
        // 제품 목록 조회
        const { data: products, error: productsError } = await supabase
          .from('products')
          .select('*')
          .order('created_at', { ascending: false })
        if (productsError) throw productsError
        return res.status(200).json({
          success: true,
          message: '제품 목록 조회 성공',
          data: products
        })

      case 'hospitals':
        // 병원 목록 조회
        const { data: hospitals, error: hospitalsError } = await supabase
          .from('hospitals')
          .select('*')
          .order('created_at', { ascending: false })
        if (hospitalsError) throw hospitalsError
        return res.status(200).json({
          success: true,
          message: '병원 목록 조회 성공',
          data: hospitals
        })

      case 'pharmacies':
        // 약국 목록 조회
        const { data: pharmacies, error: pharmaciesError } = await supabase
          .from('pharmacies')
          .select('*')
          .order('created_at', { ascending: false })
        if (pharmaciesError) throw pharmaciesError
        return res.status(200).json({
          success: true,
          message: '약국 목록 조회 성공',
          data: pharmacies
        })

      default:
        return res.status(400).json({
          success: false,
          message: '유효하지 않은 타입입니다. (members, products, hospitals, pharmacies)'
        })
    }
  } catch (error) {
    console.error('Basic info API error details:', {
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