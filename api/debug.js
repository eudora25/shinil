export default function handler(req, res) {
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
    const envCheck = {
      hasSupabaseUrl: !!process.env.VITE_SUPABASE_URL || !!process.env.SUPABASE_URL,
      hasSupabaseKey: !!process.env.VITE_SUPABASE_ANON_KEY || !!process.env.SUPABASE_ANON_KEY,
      nodeEnv: process.env.NODE_ENV,
      vercelEnv: process.env.VERCEL_ENV,
      supabaseUrlLength: (process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || '').length,
      supabaseKeyLength: (process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || '').length,
      allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE'))
    }
    
    // Supabase 클라이언트 생성 테스트
    let supabaseTest = null
    let supabaseError = null
    
    try {
      const { createClient } = require('@supabase/supabase-js')
      const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
      const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
      
      if (supabaseUrl && supabaseAnonKey) {
        supabaseTest = createClient(supabaseUrl, supabaseAnonKey)
        supabaseTest = 'Success'
      } else {
        supabaseTest = 'Missing credentials'
      }
    } catch (error) {
      supabaseError = error.message
    }
    
    return res.status(200).json({
      success: true,
      message: 'Debug information',
      timestamp: new Date().toISOString(),
      environment: envCheck,
      supabaseTest: supabaseTest,
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
