import { createClient } from '@supabase/supabase-js'

// 환경 변수 확인 함수
export function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  
  return { supabaseUrl, supabaseAnonKey }
}

// Supabase 클라이언트 생성 함수
export function createSupabaseClient() {
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

// CORS 헤더 설정 함수
export function setCorsHeaders(res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
}

// OPTIONS 요청 처리 함수
export function handleOptionsRequest(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return true
  }
  return false
}

// 에러 응답 생성 함수
export function createErrorResponse(statusCode, message, error = null) {
  return {
    success: false,
    message,
    ...(error && { error: error.message }),
    timestamp: new Date().toISOString()
  }
}
