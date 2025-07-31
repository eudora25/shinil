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

  // CORS 설정 추가
  app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization')
    
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

  // 데이터베이스에 로그 저장
  const logToDatabase = async (requestInfo, statusCode, responseData, executionTime) => {
    try {
      const logData = {
        endpoint: requestInfo.endpoint,
        method: requestInfo.method,
        user_id: requestInfo.user_id,
        user_email: requestInfo.user_email,
        request_ip: requestInfo.request_ip,
        request_headers: requestInfo.request_headers,
        request_body: requestInfo.request_body,
        response_status: statusCode,
        response_body: responseData,
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
  app.get('/api/health', logApiCall, (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development'
    })
  })

  // 제품 목록 엔드포인트
  app.get('/api/products', logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { data, error } = await supabase
        .from('products')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch products',
          error: error.message
        })
      }
      
      res.json({
        success: true,
        data: data || []
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
  app.get('/api/clients', logApiCall, async (req, res) => {
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

  // 공지사항 목록 엔드포인트
  app.get('/api/notices', logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { data, error } = await supabase
        .from('notices')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (error) {
        return res.status(500).json({
          success: false,
          message: 'Failed to fetch notices',
          error: error.message
        })
      }
      
      res.json({
        success: true,
        data: data || []
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

  // 인증 엔드포인트 (GET & POST 모두 지원)
  app.get('/api/auth', logApiCall, (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    res.json({
      success: true,
      message: 'Auth endpoint is working (GET)',
      timestamp: new Date().toISOString(),
      method: 'GET',
      endpoints: {
        verifyToken: '/api/verify-token',
        health: '/api/health',
        products: '/api/products',
        clients: '/api/clients',
        notices: '/api/notices'
      }
    })
  })

  app.post('/api/auth', logApiCall, async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
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
      
      // 성공적인 로그인
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
          session: {
            access_token: data.session.access_token,
            refresh_token: data.session.refresh_token,
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

  // 정적 파일 서빙 (Vue 앱)
  app.use(express.static(path.join(__dirname, 'dist')))
  
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