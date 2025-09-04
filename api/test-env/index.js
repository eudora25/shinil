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
    let tableStructure = null
    let debugInfo = {}
    
    if (process.env.VITE_SUPABASE_URL && process.env.VITE_SUPABASE_ANON_KEY) {
      try {
        const { createClient } = await import('@supabase/supabase-js')
        const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY)
        
        // 테이블 구조 확인 (모든 컬럼 조회)
        console.log('=== Supabase 쿼리 시작 ===')
        const { data: structureData, error: structureError } = await supabase
          .from('products')
          .select('*')
          .limit(1)
        
        console.log('=== 쿼리 결과 ===')
        console.log('Data:', structureData)
        console.log('Error:', structureError)
        console.log('Data length:', structureData ? structureData.length : 'null')
        
        if (structureError) {
          supabaseConnection = `연결 실패: ${structureError.message}`
          debugInfo.error = structureError
        } else {
          supabaseConnection = '연결 성공'
          if (structureData && structureData.length > 0) {
            tableStructure = Object.keys(structureData[0])
            supabaseData = structureData[0]
            debugInfo.dataLength = structureData.length
            debugInfo.firstRecord = structureData[0]
          } else {
            debugInfo.dataLength = 0
            debugInfo.message = '데이터가 없습니다'
          }
        }
      } catch (err) {
        supabaseConnection = `연결 오류: ${err.message}`
        debugInfo.exception = err.message
      }
    }

    res.status(200).json({
      success: true,
      message: 'Environment variables and Supabase connection test',
      environment: envVars,
      supabase: {
        connection: supabaseConnection,
        tableStructure: tableStructure,
        testData: supabaseData
      },
      debug: debugInfo,
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
