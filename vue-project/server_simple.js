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

  // JSON body parser 미들웨어 추가
  app.use(express.json())

  // API 루트 엔드포인트
  app.get('/api', (req, res) => {
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
  app.get('/api/health', (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development'
    })
  })

  // 제품 목록 엔드포인트
  app.get('/api/products', async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { createClient } = await import('@supabase/supabase-js')
      const supabaseUrl = process.env.VITE_SUPABASE_URL
      const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
      const supabase = createClient(supabaseUrl, supabaseAnonKey)
      
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
  app.get('/api/clients', async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { createClient } = await import('@supabase/supabase-js')
      const supabaseUrl = process.env.VITE_SUPABASE_URL
      const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
      const supabase = createClient(supabaseUrl, supabaseAnonKey)
      
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
  app.get('/api/notices', async (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Access-Control-Allow-Origin', '*')
    
    try {
      const { createClient } = await import('@supabase/supabase-js')
      const supabaseUrl = process.env.VITE_SUPABASE_URL
      const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
      const supabase = createClient(supabaseUrl, supabaseAnonKey)
      
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

  // 토큰 검증 엔드포인트 (간단한 버전)
  app.post('/api/verify-token', async (req, res) => {
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
      
      const { createClient } = await import('@supabase/supabase-js')
      const supabaseUrl = process.env.VITE_SUPABASE_URL
      const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
      const supabase = createClient(supabaseUrl, supabaseAnonKey)
      
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
const port = process.env.PORT || 3000
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