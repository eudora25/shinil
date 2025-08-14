import { createClient } from '@supabase/supabase-js'

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }
  
  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed. Use GET.'
    })
  }
  
  try {
    // 환경 변수 확인
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
    
    const debugInfo = {
      environment: {
        hasSupabaseUrl: !!supabaseUrl,
        hasSupabaseKey: !!supabaseAnonKey,
        nodeEnv: process.env.NODE_ENV,
        vercelEnv: process.env.VERCEL_ENV,
        supabaseUrlLength: (supabaseUrl || '').length,
        supabaseKeyLength: (supabaseAnonKey || '').length,
        supabaseUrlPreview: supabaseUrl ? supabaseUrl.substring(0, 30) + '...' : 'missing',
        allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE'))
      },
      tests: {}
    }
    
    // 1. 기본 네트워크 테스트
    try {
      const testResponse = await fetch('https://httpbin.org/json', { 
        method: 'GET',
        signal: AbortSignal.timeout(5000)
      })
      debugInfo.tests.basicNetwork = testResponse.ok ? 'Success' : `Failed: ${testResponse.status}`
    } catch (error) {
      debugInfo.tests.basicNetwork = `Failed: ${error.message}`
    }
    
    // 2. Supabase URL 직접 접근 테스트
    if (supabaseUrl) {
      try {
        const supabaseResponse = await fetch(`${supabaseUrl}/rest/v1/`, {
          method: 'GET',
          headers: {
            'apikey': supabaseAnonKey || '',
            'Authorization': `Bearer ${supabaseAnonKey || ''}`
          },
          signal: AbortSignal.timeout(10000)
        })
        debugInfo.tests.supabaseDirectAccess = supabaseResponse.ok ? 'Success' : `Failed: ${supabaseResponse.status}`
      } catch (error) {
        debugInfo.tests.supabaseDirectAccess = `Failed: ${error.name} - ${error.message}`
      }
    }
    
    // 3. Supabase 클라이언트 테스트
    if (supabaseUrl && supabaseAnonKey) {
      try {
        const supabase = createClient(supabaseUrl, supabaseAnonKey)
        debugInfo.tests.supabaseClientCreation = 'Success'
        
        // 간단한 auth 세션 확인
        try {
          const { data, error } = await supabase.auth.getSession()
          if (error) {
            debugInfo.tests.supabaseAuthCheck = `Auth Error: ${error.message}`
          } else {
            debugInfo.tests.supabaseAuthCheck = 'Success - No active session (expected)'
          }
        } catch (authError) {
          debugInfo.tests.supabaseAuthCheck = `Auth Failed: ${authError.name} - ${authError.message}`
        }
        
      } catch (error) {
        debugInfo.tests.supabaseClientCreation = `Failed: ${error.name} - ${error.message}`
      }
    }
    
    // 4. DNS 해석 테스트
    if (supabaseUrl) {
      try {
        const url = new URL(supabaseUrl)
        debugInfo.tests.urlParsing = `Success - Host: ${url.hostname}`
      } catch (error) {
        debugInfo.tests.urlParsing = `Failed: ${error.message}`
      }
    }
    
    return res.status(200).json({
      success: true,
      message: 'Network debug information',
      timestamp: new Date().toISOString(),
      ...debugInfo
    })
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Debug error',
      error: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })
  }
}
