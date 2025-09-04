const { createClient } = require('@supabase/supabase-js')

module.exports = async function handler(req, res) {
  try {
    // 환경 변수 확인 (하드코딩으로 테스트)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || 'https://selklngerzfmuvagcvvf.supabase.co/'
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U'
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1Mjc3NDkwNSwiZXhwIjoyMDY4MzEwOTA1fQ.gFB7QhW_ZdKtKZO9ok-HjkXh7PQU-eMLWUwVAQXuyvM'

    console.log('Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
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

    // 데이터 조회 (Service Role Key 사용)
    const supabase = createClient(supabaseUrl, serviceRoleKey || supabaseAnonKey)

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