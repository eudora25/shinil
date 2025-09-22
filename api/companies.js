import { createClient } from '@supabase/supabase-js'

// Vercel에서는 환경 변수가 자동으로 로드됨
console.log('✅ Vercel 환경 변수 로드됨')


// IP 제한 함수 (Vercel 환경용)
function checkIPAccess(req) {
  // Vercel에서는 IP 제한을 비활성화하거나 간소화
  console.log('🔓 Vercel 환경: IP 제한 비활성화')
  return { allowed: true }

}

export default async function handler(req, res) {
  try {
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      return res.status(403).json(ipCheck.error)
    }

    // 환경 변수 확인 (Vercel용 - fallback 포함)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://vaeolqywqckiwwtspxfp.supabase.co'
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDg0MTIsImV4cCI6MjA2MjYyNDQxMn0.Br2-nlOUu2j7_44O5k_lDWAzxTMVnvOQINhNJyYZb30'
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZW9scXl3cWNraXd3dHNweGZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzA0ODQxMiwiZXhwIjoyMDYyNjI0NDEyfQ.fJoKwqr_HvJ5Hz2ZwaQ5gHcqiu9b7oRcZR945Nf2w0g'

    console.log('🔍 Companies API - Supabase 설정 확인:')
    console.log('Supabase URL:', supabaseUrl ? '설정됨' : '미설정')
    console.log('Supabase Key:', supabaseAnonKey ? '설정됨' : '미설정')
    console.log('Service Role Key:', serviceRoleKey ? '설정됨' : '미설정')

    // Supabase 클라이언트 생성 (Service Role Key 사용 - RLS 우회)
    if (!supabaseUrl || !serviceRoleKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase environment variables not configured',
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing'
        }
      })
    }

    // 환경 변수 값 확인 (디버깅용)
    console.log('Supabase URL:', supabaseUrl)
    console.log('Supabase Anon Key (first 20 chars):', supabaseAnonKey?.substring(0, 20))

    console.log('Environment variables updated:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing',
      allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE')),
      actualValues: {
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey ? supabaseAnonKey.substring(0, 20) + '...' : 'Missing',
        serviceRoleKey: serviceRoleKey ? serviceRoleKey.substring(0, 20) + '...' : 'Missing'
      }
    })

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing'
        }
      })
    }

    // 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log('❌ Authorization 헤더가 없거나 Bearer 형식이 아님')
      return res.status(401).json({
        success: false,
        message: 'Authorization 헤더가 필요합니다'
      })
    }

    const token = authHeader.substring(7)
    console.log('🔍 토큰 검증 시작:', token.substring(0, 20) + '...')
    
    const supabaseAuth = createClient(supabaseUrl, serviceRoleKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    console.log('🔍 Supabase 토큰 검증 결과:')
    console.log('- authError:', authError)
    console.log('- user 존재:', !!user)
    console.log('- user_type:', user?.user_metadata?.user_type)

    if (authError) {
      console.log('❌ 토큰 인증 오류:', authError)
      return res.status(401).json({
        success: false,
        message: 'Token authentication failed',
        debug: {
          error: authError.message,
          code: authError.code
        }
      })
    }

    if (!user) {
      console.log('❌ 사용자 정보를 찾을 수 없음')
      return res.status(401).json({
        success: false,
        message: 'User not found'
      })
    }

    if (user.user_metadata?.user_type !== 'admin') {
      console.log('❌ 관리자 권한 부족. 현재 user_type:', user.user_metadata?.user_type)
      return res.status(403).json({
        success: false,
        message: 'Admin access required',
        debug: {
          userType: user.user_metadata?.user_type,
          required: 'admin'
        }
      })
    }

    console.log('✅ 토큰 검증 성공 - Admin 사용자:', user.email)

    // Supabase 클라이언트 생성 (RLS 정책 무시를 위해 Service Role Key 사용)
    let supabase
    
    if (serviceRoleKey) {
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      supabase = createClient(supabaseUrl, serviceRoleKey)
    }
    
    // 연결 테스트 (간단한 쿼리)
    const { data: testData, error: testError } = await supabase
      .from('companies')
      .select('id')
      .limit(1)
    
    if (testError) {
      console.error('Supabase connection test failed:', testError)
      return res.status(500).json({
        success: false,
        message: 'Supabase connection failed',
        error: testError.message,
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
          testError: testError
        }
      })
    }

    const { page = 1, limit = 100 } = req.query
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    const { data: companies, error: getError, count } = await supabase
      .from('companies')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })
      .range(offset, offset + limitNum - 1)

    if (getError) {
      console.error('Database error:', getError)
      return res.status(500).json({
        success: false,
        message: 'Database error',
        error: getError.message
      })
    }

    res.json({
      success: true,
      message: '회사 정보 조회 성공',
      data: companies || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    })

  } catch (error) {
    console.error('Error:', error)
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
}