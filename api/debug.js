import { createClient } from '@supabase/supabase-js'

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
  res.setHeader('Content-Type', 'application/json')
  
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
    // 환경 변수 확인 (민감한 정보는 제외)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
    
    const envCheck = {
      hasSupabaseUrl: !!supabaseUrl,
      hasSupabaseKey: !!supabaseAnonKey,
      nodeEnv: process.env.NODE_ENV,
      vercelEnv: process.env.VERCEL_ENV,
      supabaseUrlLength: (supabaseUrl || '').length,
      supabaseKeyLength: (supabaseAnonKey || '').length,
      supabaseUrlStart: supabaseUrl ? supabaseUrl.substring(0, 30) + '...' : 'missing',
      allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE'))
    }
    
    // Supabase 클라이언트 생성 테스트
    let supabaseClientTest = 'Not tested'
    let supabaseConnectionTest = 'Not tested'
    let supabaseError = null
    
    try {
      if (supabaseUrl && supabaseAnonKey) {
        // 클라이언트 생성 테스트
        const supabase = createClient(supabaseUrl, supabaseAnonKey)
        supabaseClientTest = 'Success'
        
        // 실제 연결 테스트 (간단한 쿼리)
        try {
          const { data, error } = await supabase.from('auth.users').select('count').limit(1)
          if (error) {
            supabaseConnectionTest = `Connection failed: ${error.message}`
          } else {
            supabaseConnectionTest = 'Connection successful'
          }
        } catch (connectionError) {
          supabaseConnectionTest = `Connection error: ${connectionError.message}`
        }
      } else {
        supabaseClientTest = 'Missing credentials'
      }
    } catch (error) {
      supabaseError = error.message
      supabaseClientTest = 'Client creation failed'
    }
    
    return res.status(200).json({
      success: true,
      message: 'Debug information',
      timestamp: new Date().toISOString(),
      environment: envCheck,
      supabaseClientTest: supabaseClientTest,
      supabaseConnectionTest: supabaseConnectionTest,
      supabaseError: supabaseError
    })
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
}
