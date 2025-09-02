import { withAuth } from './lib/auth-middleware.js'
import { createSupabaseClient } from './lib/supabase.js'

async function productsHandler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, Cookie')
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

    // 인증된 사용자 정보는 req.user에 있음 (withAuth 미들웨어에서 설정)
    const user = req.user
    console.log('Authenticated user:', { id: user.id, email: user.email })
    
    // 제품 데이터 조회
    const { data: products, error: productsError } = await supabase
      .from('products')
      .select('*')
      .order('created_at', { ascending: false })

    if (productsError) {
      console.error('Products query error:', productsError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch products',
        error: productsError.message
      })
    }

    // 응답 데이터 구성
    const responseData = {
      success: true,
      message: 'Products retrieved successfully',
      data: {
        products: products || [],
        count: products ? products.length : 0,
        user: {
          id: user.id,
          email: user.email,
          role: user.user_metadata?.user_type || 'user'
        }
      }
    }

    // 새로운 토큰이 발급된 경우 응답에 포함
    if (req.newTokens) {
      responseData.data.newTokens = req.newTokens
    }

    return res.status(200).json(responseData)

  } catch (error) {
    console.error('Products API error:', error)
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}

// withAuth 미들웨어로 래핑하여 인증 필요한 엔드포인트로 만듦
export default withAuth(productsHandler)