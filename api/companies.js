const { createClient } = require('@supabase/supabase-js')

module.exports = async function handler(req, res) {
  try {
    // 환경 변수 확인 (개행 문자 제거)
    const supabaseUrl = (process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL)?.trim()
    const supabaseAnonKey = (process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY)?.trim()
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()

    // 환경 변수 디버깅
    console.log('Companies API - Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
    })

    // 환경 변수가 없으면 기본값 사용 (개발용)
    if (!supabaseUrl || !supabaseAnonKey) {
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
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    const token = authHeader.substring(7)
    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    if (authError || !user || user.user_metadata?.user_type !== 'admin') {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    // Supabase 클라이언트 생성 (Anon Key 사용)
    const supabase = createClient(supabaseUrl, supabaseAnonKey)
    
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