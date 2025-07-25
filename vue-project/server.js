const express = require('express')
const { createServer: createViteServer } = require('vite')
const path = require('path')

async function createServer() {
  const app = express()

  // API 엔드포인트들
  app.get('/api/health', (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      test: "001",
      status: "OK",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
      environment: "development"
    })
  })

  app.get('/api/products', (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      test: "002",
      message: "Products API endpoint",
      timestamp: new Date().toISOString()
    })
  })

  app.get('/api/clients', (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      test: "003",
      message: "Clients API endpoint",
      timestamp: new Date().toISOString()
    })
  })

  app.get('/api/notices', (req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.json({
      test: "004",
      message: "Notices API endpoint",
      timestamp: new Date().toISOString()
    })
  })

  // Vite 개발 서버 생성
  const vite = await createViteServer({
    server: { middlewareMode: true },
    appType: 'spa'
  })

  // Vite 미들웨어 사용
  app.use(vite.middlewares)

  app.listen(3000, () => {
    console.log('🚀 Server running at http://localhost:3000')
    console.log('📡 API endpoints:')
    console.log('   - GET /api/health')
    console.log('   - GET /api/products')
    console.log('   - GET /api/clients')
    console.log('   - GET /api/notices')
  })
}

createServer() 