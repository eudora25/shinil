export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  // GET 요청만 처리
  if (req.method !== 'GET') {
    return res.status(405).json({ success: false, message: 'Method not allowed' })
  }

  try {
    // 환경 변수 확인
    const envVars = {
      NODE_ENV: process.env.NODE_ENV,
      VITE_SUPABASE_URL: process.env.VITE_SUPABASE_URL,
      VITE_SUPABASE_ANON_KEY: process.env.VITE_SUPABASE_ANON_KEY ? '설정됨' : '설정되지 않음',
      VERCEL_ENV: process.env.VERCEL_ENV,
      VERCEL_REGION: process.env.VERCEL_REGION
    }

    // Supabase 연결 테스트
    let supabaseConnection = '연결 안됨'
    let supabaseData = null
    
    if (process.env.VITE_SUPABASE_URL && process.env.VITE_SUPABASE_ANON_KEY) {
      try {
        const { createClient } = await import('@supabase/supabase-js')
        const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY)
        
        // 간단한 쿼리 테스트
        const { data, error } = await supabase
          .from('products')
          .select('id, name')
          .limit(1)
        
        if (error) {
          supabaseConnection = `연결 실패: ${error.message}`
        } else {
          supabaseConnection = '연결 성공'
          supabaseData = data
        }
      } catch (err) {
        supabaseConnection = `연결 오류: ${err.message}`
      }
    }

    res.status(200).json({
      success: true,
      message: 'Environment variables and Supabase connection test',
      environment: envVars,
      supabase: {
        connection: supabaseConnection,
        testData: supabaseData
      },
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('Test API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Test failed',
      error: error.message 
    })
  }
}
