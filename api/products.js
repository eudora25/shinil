import { createClient } from '@supabase/supabase-js'

// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  return { supabaseUrl, supabaseAnonKey, supabaseServiceKey }
}

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey, supabaseServiceKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  
  try {
    // 서비스 롤 키가 있으면 사용, 없으면 익명 키 사용
    const key = supabaseServiceKey || supabaseAnonKey
    return createClient(supabaseUrl, key, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    })
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

  try {
    if (req.method !== 'GET') {
      return res.status(405).json({
        success: false,
        message: 'Method not allowed. Only GET is supported.'
      })
    }

    // 인증 토큰 확인
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Authorization header with Bearer token is required'
      })
    }

    const token = authHeader.substring(7) // 'Bearer ' 제거

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

    // 토큰 검증
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token',
        error: authError?.message || 'Token verification failed'
      })
    }

    // 제품 정보 조회
    const { data: products, error: productsError } = await supabase
      .from('products')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (productsError) {
      console.error('Products fetch error:', productsError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch products',
        error: productsError.message
      })
    }
    
    // 디버깅: 제품 개수 확인
    console.log('Products count:', products ? products.length : 0)
    console.log('Supabase URL:', process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL)
    console.log('User ID:', user.id)
    
    // products_standard_code 정보 조회
    const { data: standardCodes, error: standardCodesError } = await supabase
      .from('products_standard_code')
      .select('*')
      .eq('status', 'active')
    
    if (standardCodesError) {
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch standard codes',
        error: standardCodesError.message
      })
    }
    
    // insurance_code를 기준으로 데이터 조합
    const productsWithStandardCode = products.map(product => {
      const standardCode = standardCodes.find(sc => sc.insurance_code === product.insurance_code)
      return {
        ...product,
        standard_code: standardCode?.standard_code || null,
        unit_packaging_desc: standardCode?.unit_packaging_desc || null,
        unit_quantity: standardCode?.unit_quantity || null
      }
    })

    return res.status(200).json({
      success: true,
      message: '제품 목록 조회 성공',
      data: productsWithStandardCode || [],
      debug: {
        productsCount: products ? products.length : 0,
        standardCodesCount: standardCodes ? standardCodes.length : 0,
        supabaseUrl: process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
        userId: user.id
      }
    })

  } catch (error) {
    console.error('Products API error details:', {
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