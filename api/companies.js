const { createClient } = require('@supabase/supabase-js')

module.exports = async function handler(req, res) {
  try {
    // 환경 변수 확인
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

    console.log('Environment variables updated:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing',
      allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE'))
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

    // 데이터 조회 (Service Role Key만 사용)
    if (!serviceRoleKey) {
      return res.status(500).json({
        success: false,
        message: 'Service Role Key not configured',
        debug: {
          serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
        }
      })
    }
    
    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    })

    const { page = 1, limit = 100 } = req.query
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    const { data: companies, error: getError, count } = await supabase
      .from('clients')
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