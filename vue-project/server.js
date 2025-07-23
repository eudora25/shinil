import express from 'express'
import pg from 'pg'
import cors from 'cors'

const { Pool } = pg

const app = express()
const port = 3001

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

// 로컬 데이터 조회 API
app.post('/api/local-data', async (req, res) => {
  try {
    const filters = req.body
    console.log('받은 필터:', filters)
    
    // 기본 쿼리 시작
    let query = `
      SELECT 
        c.company_name,
        c.company_type,
        cl.name as client_name,
        cl.hospital_number,
        p.product_name,
        p.insurance_code,
        p.price,
        pr.*
      FROM companies c
      LEFT JOIN products p ON c.id = p.company_id
      LEFT JOIN clients cl ON 1=1
      LEFT JOIN performance_records pr ON p.id = pr.product_id AND cl.id = pr.client_id
      WHERE 1=1
    `
    
    const params = []
    let paramIndex = 1
    
    // 필터 조건 적용
    if (filters.company_id) {
      query += ` AND c.id = $${paramIndex++}`
      params.push(filters.company_id)
    }
    
    if (filters.client_id) {
      query += ` AND cl.id = $${paramIndex++}`
      params.push(filters.client_id)
    }
    
    if (filters.product_id) {
      query += ` AND p.id = $${paramIndex++}`
      params.push(filters.product_id)
    }
    
    if (filters.user_edit_status) {
      query += ` AND pr.user_edit_status = $${paramIndex++}`
      params.push(filters.user_edit_status)
    }
    
    if (filters.record_type) {
      query += ` AND pr.record_type = $${paramIndex++}`
      params.push(filters.record_type)
    }
    
    if (filters.date_from) {
      query += ` AND pr.created_at >= $${paramIndex++}`
      params.push(filters.date_from)
    }
    
    if (filters.date_to) {
      query += ` AND pr.created_at <= $${paramIndex++}`
      params.push(filters.date_to)
    }
    
    // 정렬
    query += ` ORDER BY pr.created_at DESC`
    
    // 제한
    const limit = filters.limit || 50
    query += ` LIMIT $${paramIndex++}`
    params.push(limit)
    
    console.log('실행할 쿼리:', query)
    console.log('파라미터:', params)
    
    const result = await pool.query(query, params)
    
    const response = {
      success: true,
      data: result.rows,
      total_count: result.rows.length,
      filter_applied: filters,
      timestamp: new Date().toISOString()
    }
    
    res.json(response)
    
  } catch (error) {
    console.error('데이터베이스 쿼리 에러:', error)
    res.status(500).json({
      success: false,
      error: 'database_error',
      message: error.message
    })
  }
})

// 회사 데이터 API
app.get('/api/companies', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM companies ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
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

// 제품 데이터 API
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
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

// 고객 데이터 API
app.get('/api/clients', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM clients ORDER BY id LIMIT 50')
    res.json({
      success: true,
      data: result.rows,
      total_count: result.rows.length,
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

// 간단한 테스트 API
app.get('/api/test', (req, res) => {
  res.json({
    success: true,
    message: 'Express 서버가 정상적으로 작동합니다!',
    timestamp: new Date().toISOString()
  })
})

// 서버 시작
app.listen(port, () => {
  console.log(`🚀 Express 서버가 포트 ${port}에서 실행 중입니다`)
  console.log(`📊 로컬 데이터 API: http://localhost:${port}/api/local-data`)
  console.log(`🧪 테스트 API: http://localhost:${port}/api/test`)
})

export default app 