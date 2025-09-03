import { createClient } from '@supabase/supabase-js'
import { authMiddleware, tokenLoggingMiddleware } from '../middleware/authMiddleware.js'

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
    // 로컬과 동일하게 단순하게 생성
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
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Refresh-Token')
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

    // 토큰 로깅 미들웨어 실행 (디버깅용)
    tokenLoggingMiddleware(req, res, () => {});

    // 인증 미들웨어 실행
    await new Promise((resolve, reject) => {
      authMiddleware(req, res, (error) => {
        if (error) {
          reject(error);
        } else {
          resolve();
        }
      });
    });

    // 토큰이 갱신되었는지 확인
    if (req.tokenRefreshed) {
      console.log('토큰이 갱신되었습니다. 새 토큰으로 요청 처리 중...');
      
      // 응답 헤더에 새 토큰 정보 포함
      res.set('X-Token-Refreshed', 'true');
      res.set('X-New-Access-Token', req.newAccessToken);
      res.set('X-New-Refresh-Token', req.newRefreshToken);
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

    // 인증된 사용자 정보 확인
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: '사용자 인증이 필요합니다.',
        error: 'User authentication required'
      })
    }

    // 인증된 사용자 컨텍스트로 새로운 클라이언트 생성
    const currentToken = req.newAccessToken || req.headers.authorization?.substring(7);
    const authenticatedSupabase = createClient(
      process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
      process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY,
      {
        global: {
          headers: {
            Authorization: `Bearer ${currentToken}`
          }
        }
      }
    )

    console.log('제품 정보 조회 중... 사용자 ID:', req.user.id);

    // 제품 정보 조회 (인증된 클라이언트 사용)
    const { data: products, error: productsError } = await authenticatedSupabase
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
    console.log('User ID:', req.user.id)
    
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

    // 응답 데이터 구성
    const responseData = {
      success: true,
      message: '제품 목록 조회 성공',
      data: productsWithStandardCode || [],
      debug: {
        productsCount: products ? products.length : 0,
        standardCodesCount: standardCodes ? standardCodes.length : 0,
        supabaseUrl: process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
        userId: req.user.id
      }
    };

    // 토큰 갱신 정보가 있으면 응답에 포함
    if (req.tokenRefreshed) {
      responseData.tokenInfo = {
        refreshed: true,
        message: '토큰이 자동으로 갱신되었습니다.'
      };
    }

    return res.status(200).json(responseData);

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