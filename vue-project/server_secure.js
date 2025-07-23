import express from 'express'
import pg from 'pg'
import cors from 'cors'
import jwt from 'jsonwebtoken'
import bcrypt from 'bcryptjs'

const { Pool } = pg

const app = express()
const port = 3001

// JWT 시크릿 키 (실제 운영에서는 환경변수로 관리)
const JWT_SECRET = 'shinil-pms-secret-key-2024'
const JWT_EXPIRES_IN = '24h'

// CORS 설정
app.use(cors())
app.use(express.json())

// PostgreSQL 연결 설정
const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'shinil_pms',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres'
})

// JWT 토큰 검증 미들웨어
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization']
  const token = authHeader && authHeader.split(' ')[1] // Bearer TOKEN

  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'access_token_required',
      message: '액세스 토큰이 필요합니다'
    })
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        error: 'invalid_token',
        message: '유효하지 않은 토큰입니다'
      })
    }
    req.user = user
    next()
  })
}

// 관리자 권한 확인 미들웨어
const requireAdmin = (req, res, next) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      error: 'admin_required',
      message: '관리자 권한이 필요합니다'
    })
  }
  next()
}

// 로그인 API
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'missing_credentials',
        message: '이메일과 비밀번호를 입력해주세요'
      })
    }

    // 사용자 조회 (profiles 테이블에서)
    const userResult = await pool.query(
      'SELECT * FROM profiles WHERE email = $1',
      [email]
    )

    if (userResult.rows.length === 0) {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

    const user = userResult.rows[0]

    // 비밀번호 검증 (실제로는 해시된 비밀번호와 비교)
    // 여기서는 간단히 하드코딩된 비밀번호 사용
    const validPassword = password === 'admin123' // 실제로는 bcrypt.compare 사용

    if (!validPassword) {
      return res.status(401).json({
        success: false,
        error: 'invalid_credentials',
        message: '이메일 또는 비밀번호가 올바르지 않습니다'
      })
    }

    // JWT 토큰 생성
    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
        role: user.user_type || 'user',
        name: user.full_name || user.email
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    )

    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          email: user.email,
          role: user.user_type || 'user',
          name: user.full_name || user.email
        }
      },
      message: '로그인 성공'
    })

  } catch (error) {
    console.error('로그인 에러:', error)
    res.status(500).json({
      success: false,
      error: 'server_error',
      message: '서버 오류가 발생했습니다'
    })
  }
})

// 토큰 검증 API
app.get('/api/auth/verify', authenticateToken, (req, res) => {
  res.json({
    success: true,
    data: {
      user: req.user
    },
    message: '토큰이 유효합니다'
  })
})

// 테스트 API (인증 필요)
app.get('/api/test', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: '보안된 Express 서버가 정상적으로 작동합니다!',
    user: req.user,
    timestamp: new Date().toISOString()
  })
})

// 회사 데이터 API (인증 필요)
app.get('/api/companies', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM companies ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
      user: req.user,
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('회사 데이터 조회 에러:', error)
    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
})

// 제품 데이터 API (인증 필요)
app.get('/api/products', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
      user: req.user,
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('제품 데이터 조회 에러:', error)
    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
})

// 고객 데이터 API (인증 필요)
app.get('/api/clients', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM clients ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
      user: req.user,
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('고객 데이터 조회 에러:', error)
    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
})

// 관리자 전용 API (관리자 권한 필요)
app.get('/api/admin/stats', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const stats = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM companies) as companies_count,
        (SELECT COUNT(*) FROM products) as products_count,
        (SELECT COUNT(*) FROM clients) as clients_count,
        (SELECT COUNT(*) FROM pharmacies) as pharmacies_count,
        (SELECT COUNT(*) FROM wholesale_sales) as wholesale_sales_count
    `)
    
    res.json({
      success: true,
      data: stats.rows[0],
      user: req.user,
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('관리자 통계 조회 에러:', error)
    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
})

// 토큰 갱신 API
app.post('/api/auth/refresh', authenticateToken, (req, res) => {
  try {
    // 새로운 토큰 생성
    const newToken = jwt.sign(
      {
        id: req.user.id,
        email: req.user.email,
        role: req.user.role,
        name: req.user.name
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    )

    res.json({
      success: true,
      data: {
        token: newToken,
        user: req.user
      },
      message: '토큰이 갱신되었습니다'
    })
  } catch (error) {
    console.error('토큰 갱신 에러:', error)
    res.status(500).json({
      success: false,
      error: 'server_error',
      message: '토큰 갱신 중 오류가 발생했습니다'
    })
  }
})

// 로그아웃 API (클라이언트에서 토큰 삭제)
app.post('/api/auth/logout', (req, res) => {
  res.json({
    success: true,
    message: '로그아웃되었습니다'
  })
})

// 서버 시작
app.listen(port, () => {
  console.log(`🔐 보안 Express 서버가 포트 ${port}에서 실행 중입니다`)
  console.log(`🔑 JWT 시크릿: ${JWT_SECRET}`)
  console.log(`⏰ 토큰 만료 시간: ${JWT_EXPIRES_IN}`)
  console.log(`📊 API 엔드포인트:`)
  console.log(`   - POST /api/auth/login - 로그인`)
  console.log(`   - GET  /api/auth/verify - 토큰 검증`)
  console.log(`   - POST /api/auth/refresh - 토큰 갱신`)
  console.log(`   - POST /api/auth/logout - 로그아웃`)
  console.log(`   - GET  /api/test - 서버 상태 확인`)
  console.log(`   - GET  /api/companies - 회사 데이터`)
  console.log(`   - GET  /api/products - 제품 데이터`)
  console.log(`   - GET  /api/clients - 고객 데이터`)
  console.log(`   - GET  /api/admin/stats - 관리자 통계`)
})

export default app 