import express from 'express'
import path from 'path'
import { config } from 'dotenv'
import { fileURLToPath } from 'url'

// ES 모듈에서 __dirname 대체
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// vue-project의 .env.production 파일 로드
config({ path: path.join(__dirname, '.env.production') })

async function createServer() {
  const app = express()

  // CORS 설정 추가 (쿠키 기반 인증 지원)
  app.use((req, res, next) => {
    const origin = req.headers.origin || '*'
    res.header('Access-Control-Allow-Origin', origin)
    res.header('Vary', 'Origin')
    res.header('Access-Control-Allow-Credentials', 'true')
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-Refresh-Token')
    
    if (req.method === 'OPTIONS') {
      res.sendStatus(200)
    } else {
      next()
    }
  })

  // JSON body parser 미들웨어 추가
  app.use(express.json())

  // Supabase 클라이언트 초기화
  const { createClient } = await import('@supabase/supabase-js')
  const supabaseUrl = process.env.VITE_SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
  const supabase = createClient(supabaseUrl, supabaseAnonKey)

  // API 로깅 미들웨어
  const logApiCall = async (req, res, next) => {
    const startTime = Date.now()
    const originalSend = res.send
    const originalJson = res.json
    
    // 요청 정보 수집
    const requestInfo = {
      endpoint: req.path,
      method: req.method,
      request_ip: req.ip || req.connection.remoteAddress,
      request_headers: req.headers,
      request_body: req.body,
      user_id: null,
      user_email: null
    }

    // JWT 토큰에서 사용자 정보 추출
    const authHeader = req.headers.authorization
    if (authHeader && authHeader.startsWith('Bearer ')) {
      try {
        const token = authHeader.substring(7)
        const { data: { user }, error } = await supabase.auth.getUser(token)
        if (user && !error) {
          requestInfo.user_id = user.id
          requestInfo.user_email = user.email
        }
      } catch (error) {
        console.error('Token verification error:', error)
      }
    }

    // 응답 인터셉트
    res.send = function(data) {
      const executionTime = Date.now() - startTime
      logToDatabase(requestInfo, res.statusCode, data, executionTime)
      return originalSend.call(this, data)
    }

    res.json = function(data) {
      const executionTime = Date.now() - startTime
      logToDatabase(requestInfo, res.statusCode, data, executionTime)
      return originalJson.call(this, data)
    }

    next()
  }

  // 인증 필수 미들웨어
  const requireAuth = async (req, res, next) => {
    try {
      const authHeader = req.headers.authorization
      const bearer = authHeader && authHeader.startsWith('Bearer ')
      const accessToken = bearer ? authHeader.substring(7) : null
      // 1) 우선 access token으로 검증 시도
      if (accessToken) {
        const { data, error } = await supabase.auth.getUser(accessToken)
        if (!error && data?.user) {
          req.user = data.user
          return next()
        }
      }

      // 2) 실패 시 refresh token으로 갱신 시도 (쿠키 또는 헤더)
      const refreshToken = getRefreshTokenFromRequest(req)
      if (!refreshToken) {
        return res.status(401).json({ success: false, message: 'Unauthorized: missing token' })
      }
      const { data: refreshed, error: refreshError } = await supabase.auth.refreshSession({ refresh_token: refreshToken })
      if (refreshError || !refreshed?.session?.access_token || !refreshed?.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized: token refresh failed' })
      }

      // 재발급 토큰 쿠키 저장 및 요청 컨텍스트 업데이트
      setAuthCookies(res, refreshed.session)
      req.user = refreshed.user
      // 다운스트림을 위해 Authorization 헤더 갱신
      req.headers.authorization = `Bearer ${refreshed.session.access_token}`
      return next()
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized: token verification failed'
      })
    }
  }

  // 쿠키 파서 (간단 구현)
  function parseCookies(cookieHeader) {
    const cookies = {}
    if (!cookieHeader) return cookies
    const pairs = cookieHeader.split(';')
    for (const pair of pairs) {
      const idx = pair.indexOf('=')
      if (idx > -1) {
        const key = pair.slice(0, idx).trim()
        const val = decodeURIComponent(pair.slice(idx + 1).trim())
        cookies[key] = val
      }
    }
    return cookies
  }

  function getRefreshTokenFromRequest(req) {
    // 1) 커스텀 헤더 우선
    if (req.headers['x-refresh-token']) return req.headers['x-refresh-token']
    // 2) 쿠키에서 조회
    const cookies = parseCookies(req.headers.cookie || '')
    return cookies['rp_rft'] || null
  }

  function setAuthCookies(res, session) {
    const isProd = (process.env.NODE_ENV || 'development') === 'production'
    const common = {
      httpOnly: true,
      secure: isProd,
      sameSite: isProd ? 'none' : 'lax',
      path: '/'
    }
    // access token은 필요 시 클라이언트가 Authorization에 반영하도록 응답 헤더로도 전달
    res.cookie?.('rp_at', session.access_token, { ...common, maxAge: (session.expires_in || 3600) * 1000 })
    res.cookie?.('rp_rft', session.refresh_token, { ...common, maxAge: 60 * 24 * 60 * 60 * 1000 }) // 60일
    res.setHeader('X-Access-Token', session.access_token)
  }

  // 데이터베이스에 로그 저장
  const logToDatabase = async (requestInfo, statusCode, responseData, executionTime) => {
    try {
      // responseData가 객체인 경우 JSON 문자열로 변환
      const responseBody = typeof responseData === 'object' ? JSON.stringify(responseData) : responseData
      
      const logData = {
        endpoint: requestInfo.endpoint,
        method: requestInfo.method,
        user_id: requestInfo.user_id,
        user_email: requestInfo.user_email,
        request_ip: requestInfo.request_ip,
        request_headers: JSON.stringify(requestInfo.request_headers),
        request_body: JSON.stringify(requestInfo.request_body),
        response_status: statusCode,
        response_body: responseBody,
        execution_time_ms: executionTime
      }

      const { error } = await supabase
        .from('api_logs')
        .insert(logData)

      if (error) {
        console.error('API log insert error:', error)
      }
    } catch (error) {
      console.error('API logging error:', error)
    }
  }

  // API 루트 엔드포인트
  app.get('/api', logApiCall, (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      name: "Shinil PMS API",
      version: "1.0.0",
      status: "running",
      timestamp: new Date().toISOString(),
      environment: "development"
    })
  })

  // 헬스 체크 엔드포인트
  app.get('/api/health', requireAuth, logApiCall, (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development'
    })
  })

  // 제품 목록 엔드포인트 (products_standard_code와 join)
  app.get('/api/products', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      // 제품 정보 조회
      const { data: products, error: productsError } = await supabase
        .from('products')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (productsError) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch products',
          error: productsError.message
        })
      }
      
      // products_standard_code 정보 조회
      const { data: standardCodes, error: standardCodesError } = await supabase
        .from('products_standard_code')
        .select('*')
        .eq('status', 'active')
      
      if (standardCodesError) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch standard codes',
          error: standardCodesError.message
        })
      }
      
      // insurance_code를 기준으로 데이터 조합
      const productsWithStandardCode = products.map(product => {
        const standardCode = standardCodes.find(sc => sc.insurance_code === product.insurance_code)
        return {
          ...product,
          standard_code: standardCode?.standard_code || null,
          unit_packaging_desc: standardCode?.unit_packaging_desc || null,
          unit_quantity: standardCode?.unit_quantity || null
        }
      })
      
      res.json({
        success: true,
        data: productsWithStandardCode || []
      })
      
    } catch (error) {
      console.error('Products API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 클라이언트 목록 엔드포인트
  app.get('/api/clients', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { data, error } = await supabase
        .from('clients')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch clients',
          error: error.message
        })
      }
      
      res.json({
        success: true,
        data: data || []
      })
      
    } catch (error) {
      console.error('Clients API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 공지사항 목록 엔드포인트 (조회수 포함)
  app.get('/api/notices', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      // 공지사항 조회
      const { data: notices, error: noticesError } = await supabase
        .from('notices')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (noticesError) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch notices',
          error: noticesError.message
        })
      }

      // 조회수 정보 조회
      const { data: views, error: viewsError } = await supabase
        .from('notice_views')
        .select('notice_id, viewed_at')
        .order('viewed_at', { ascending: false })

      if (viewsError) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch notice views',
          error: viewsError.message
        })
      }

      // 조회수 계산 및 데이터 조합
      const noticesWithViews = notices.map(notice => {
        const noticeViews = views.filter(view => view.notice_id === notice.id)
        return {
          ...notice,
          view_count: noticeViews.length,
          last_viewed_at: noticeViews.length > 0 ? noticeViews[0].viewed_at : null
        }
      })
      
      res.json({
        success: true,
        data: noticesWithViews || []
      })
      
    } catch (error) {
      console.error('Notices API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 약국정보 목록 엔드포인트
  app.get('/api/pharmacies', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { data, error } = await supabase
        .from('pharmacies')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch pharmacies',
          error: error.message
        })
      }
      
      res.json({
        success: true,
        data: data || []
      })
      
    } catch (error) {
      console.error('Pharmacies API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

    // 회사정보 목록 엔드포인트
  app.get('/api/companies', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('companies')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch companies',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Companies API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 정산월 목록 엔드포인트
  app.get('/api/settlement-months', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('settlement_months')
        .select('*')
        .order('settlement_month', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch settlement months',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Settlement Months API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 실적정보 목록 엔드포인트
  app.get('/api/performance-records', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('performance_records')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch performance records',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Performance Records API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 실적-흡수율 정보 목록 엔드포인트
  app.get('/api/performance-records-absorption', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('performance_records_absorption')
        .select(`
          *,
          clients!inner(
            id,
            name,
            address,
            business_registration_number,
            owner_name,
            status
          ),
          companies!inner(
            id,
            company_name,
            business_registration_number,
            representative_name,
            status
          ),
          products!inner(
            id,
            product_name,
            insurance_code,
            price
          )
        `)
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch performance records absorption',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Performance Records Absorption API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 실적 증빙 파일 목록 엔드포인트
  app.get('/api/performance-evidence-files', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('performance_evidence_files')
        .select(`
          *,
          clients!inner(
            id,
            name,
            address,
            business_registration_number,
            owner_name,
            status
          ),
          companies!inner(
            id,
            company_name,
            business_registration_number,
            representative_name,
            status
          )
        `)
        .order('uploaded_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch performance evidence files',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Performance Evidence Files API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 정산내역서 목록 엔드포인트
  app.get('/api/settlement-share', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('settlement_share')
        .select(`
          *,
          companies!inner(
            id,
            company_name,
            business_registration_number,
            representative_name,
            status,
            email,
            mobile_phone
          )
        `)
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch settlement share',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Settlement Share API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 도매매출정보 목록 엔드포인트
  app.get('/api/wholesale-sales', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('wholesale_sales')
        .select('*')
        .order('sales_date', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch wholesale sales',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Wholesale Sales API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 직거래매출정보 목록 엔드포인트
  app.get('/api/direct-sales', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('direct_sales')
        .select('*')
        .order('sales_date', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch direct sales',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Direct Sales API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 병원-회사 매핑정보 목록 엔드포인트
  app.get('/api/client-company-assignments', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('client_company_assignments')
        .select(`
          *,
          clients!inner(
            id,
            name,
            address,
            business_registration_number,
            client_code,
            owner_name,
            status
          ),
          companies!inner(
            id,
            company_name,
            business_registration_number,
            representative_name,
            status,
            email,
            mobile_phone
          )
        `)
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch client-company assignments',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Client-Company Assignments API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 제품-업체 미배정 매핑 정보 목록 엔드포인트
  app.get('/api/product-company-not-assignments', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      // 매핑 원본 조회
      const { data: mappings, error: mappingsError } = await supabase
        .from('product_company_not_assignments')
        .select('*')
        .order('created_at', { ascending: false })

      if (mappingsError) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch product-company not assignments',
          error: mappingsError.message
        })
      }

      // 데이터 없으면 바로 반환
      if (!mappings || mappings.length === 0) {
        return res.json({ success: true, data: [] })
      }

      // 관련 제품/업체 상세 조회를 위한 ID 수집
      const productIds = Array.from(new Set(
        mappings.map(m => m.product_id).filter(Boolean)
      ))
      const companyIds = Array.from(new Set(
        mappings.map(m => m.company_id).filter(Boolean)
      ))

      // 관련 제품/업체 상세 조회 (존재할 때만)
      let productsById = {}
      let companiesById = {}

      if (productIds.length > 0) {
        const { data: products, error: productsError } = await supabase
          .from('products')
          .select('id, product_name, insurance_code, price')
          .in('id', productIds)
        if (productsError) {
          return res.status(500).json({
            success: false,
            message: 'Failed to fetch products for mappings',
            error: productsError.message
          })
        }
        productsById = (products || []).reduce((acc, p) => {
          acc[p.id] = p
          return acc
        }, {})
      }

      if (companyIds.length > 0) {
        const { data: companies, error: companiesError } = await supabase
          .from('companies')
          .select('id, company_name, business_registration_number, representative_name')
          .in('id', companyIds)
        if (companiesError) {
          return res.status(500).json({
            success: false,
            message: 'Failed to fetch companies for mappings',
            error: companiesError.message
          })
        }
        companiesById = (companies || []).reduce((acc, c) => {
          acc[c.id] = c
          return acc
        }, {})
      }

      // 응답 조합
      const combined = mappings.map(m => ({
        ...m,
        product: m.product_id ? productsById[m.product_id] || null : null,
        company: m.company_id ? companiesById[m.company_id] || null : null
      }))

      res.json({ success: true, data: combined })
    } catch (error) {
      console.error('Product-Company Not Assignments API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 병원-약국 매핑정보 목록 엔드포인트
  app.get('/api/client-pharmacy-assignments', requireAuth, logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')

    try {
      const { data, error } = await supabase
        .from('client_pharmacy_assignments')
        .select(`
          *,
          clients!inner(
            id,
            name,
            address,
            business_registration_number,
            client_code,
            owner_name,
            status
          ),
          pharmacies!inner(
            id,
            name,
            pharmacy_code,
            address,
            status
          )
        `)
        .order('created_at', { ascending: false })

      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch client-pharmacy assignments',
          error: error.message
        })
      }

      res.json({
        success: true,
        data: data || []
      })

    } catch (error) {
      console.error('Client-Pharmacy Assignments API error:', error)
      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })



  app.post('/api/auth', logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    // credentials 허용 CORS
    const origin = req.headers.origin || '*'
    res.setHeader('Access-Control-Allow-Origin', origin)
    res.setHeader('Vary', 'Origin')
    res.setHeader('Access-Control-Allow-Credentials', 'true')
    
    try {
      const { email, password } = req.body
      
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email and password are required'
        })
      }
      
      // Supabase 로그인
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email,
        password: password
      })
      
      if (error) {
        console.error('Login error:', error)
        return res.status(401).json({
          success: false,
          message: 'Login failed',
          error: error.message
        })
      }
      
      // 성공적인 로그인 → 리프레시 토큰 쿠키 저장 및 액세스 토큰 헤더 제공
      setAuthCookies(res, data.session)
      return res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user: {
            id: data.user.id,
            email: data.user.email,
            role: data.user.user_metadata?.user_type || 'user',
            approvalStatus: data.user.user_metadata?.approval_status || 'pending'
          },
          // 보안을 위해 세션 전체를 반환하지 않고 필요한 최소 정보만 반환
          session: {
            access_token: data.session.access_token,
            expires_at: data.session.expires_at
          }
        }
      })
      
    } catch (error) {
      console.error('Auth error:', error)
      return res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // 토큰 검증 엔드포인트
  app.post('/api/verify-token', logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { token } = req.body
      
      if (!token) {
        return res.status(400).json({
          success: false,
          message: 'Token is required'
        })
      }
      
      const { data, error } = await supabase.auth.getUser(token)
      
      if (error) {
        return res.status(401).json({
          success: false,
          message: 'Invalid or expired token',
          error: error.message
        })
      }
      
      return res.status(200).json({
        success: true,
        message: 'Token is valid',
        data: {
          user: {
            id: data.user.id,
            email: data.user.email,
            role: data.user.user_metadata?.user_type || 'user',
            approvalStatus: data.user.user_metadata?.approval_status || 'pending'
          },
          valid: true
        }
      })
      
    } catch (error) {
      console.error('Token verification error:', error)
      return res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: error.message
      })
    }
  })

  // IP 접근 제어 설정 로드
  const IP_ACCESS_CONFIG = await import('./config/ip-access.js')
  IP_ACCESS_CONFIG.default.loadFromEnv()
  
  // IP 접근 미들웨어
  const checkIPAccess = IP_ACCESS_CONFIG.default.createMiddleware()

  // 정적 파일 서빙 (Vue 앱) - Swagger 경로 제외
  app.use(express.static(path.join(__dirname, 'dist'), {
    index: false // 기본 index.html 자동 서빙 비활성화
  }))
  
  // Swagger UI 서빙 (IP 제한 적용)
  app.get('/swagger-ui.html', checkIPAccess, (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'swagger-ui.html'))
  })

  // Swagger spec 파일도 IP 제한 적용
  app.get('/swagger-spec.json', checkIPAccess, (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'swagger-spec.json'))
  })
  
  // SPA 라우팅을 위한 catch-all 핸들러
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'))
  })

  return app
}

// 서버 시작
const port = process.env.PORT || 3001
createServer().then(app => {
  app.listen(port, () => {
    console.log(`🚀 Server is running on port ${port}`)
    console.log(`📊 Health check: http://localhost:${port}/api/health`)
    console.log(`🌐 API docs: http://localhost:${port}/api`)
  })
}).catch(error => {
  console.error('Failed to start server:', error)
  process.exit(1)
})