import express from 'express'
import cors from 'cors'
import path from 'path'
import { fileURLToPath } from 'url'
import envConfig from '../config/env.js'
import ipRestrictionPkg from '../middleware/ipRestriction.js'
import tokenValidationPkg from '../middleware/tokenValidation.js'

const { ipRestrictionMiddleware } = ipRestrictionPkg
const { tokenValidationMiddleware } = tokenValidationPkg

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const PORT = envConfig.PORT

// CORS 설정
app.use(cors({
  origin: envConfig.CORS_ORIGIN,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Refresh-Token']
}))

// JSON 파싱 미들웨어
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// IP 제한 미들웨어 (모든 요청에 적용)
app.use(ipRestrictionMiddleware)

// 정적 파일 서빙 (Swagger UI)
app.use(express.static(path.join(__dirname, '..')))

// API 라우트들
import authRoutes from './auth.mjs'
import verifyTokenRoutes from './verify-token.mjs'
import productsRoutes from './products.js'
import clientsRoutes from './clients.js'
import companiesRoutes from './companies.js'
import healthRoutes from './health.mjs'
import noticesRoutes from './notices.js'
import pharmaciesRoutes from './pharmacies.js'
import hospitalCompanyMappingsRoutes from './hospital-company-mappings.js'
import hospitalPharmacyMappingsRoutes from './hospital-pharmacy-mappings.js'
import clientCompanyAssignmentsRoutes from './client-company-assignments.js'
import clientPharmacyAssignmentsRoutes from './client-pharmacy-assignments.js'
import productCompanyNotAssignmentsRoutes from './product-company-not-assignments.js'
import wholesaleSalesRoutes from './wholesale-sales.js'
import directSalesRoutes from './direct-sales.js'
import performanceRoutes from './performance-records.js'
import performanceAbsorptionRoutes from './performance-records-absorption.js'
import performanceEvidenceRoutes from './performance-evidence-files.js'
import settlementMonthsRoutes from './settlement-months.js'
import settlementRoutes from './settlement-share.js'

// API 엔드포인트 등록
app.use('/api/auth', authRoutes)
app.use('/api/verify-token', verifyTokenRoutes)
app.use('/api/products', productsRoutes)
app.use('/api/clients', clientsRoutes)
app.use('/api/companies', companiesRoutes)
app.use('/api/health', healthRoutes)
app.use('/api/notices', noticesRoutes)
app.use('/api/pharmacies', pharmaciesRoutes)
app.use('/api/hospital-company-mappings', hospitalCompanyMappingsRoutes)
app.use('/api/hospital-pharmacy-mappings', hospitalPharmacyMappingsRoutes)
app.use('/api/client-company-assignments', clientCompanyAssignmentsRoutes)
app.use('/api/client-pharmacy-assignments', clientPharmacyAssignmentsRoutes)
app.use('/api/product-company-not-assignments', productCompanyNotAssignmentsRoutes)
app.use('/api/wholesale-sales', wholesaleSalesRoutes)
app.use('/api/direct-sales', directSalesRoutes)
app.use('/api/performance-records', performanceRoutes)
app.use('/api/performance-records-absorption', performanceAbsorptionRoutes)
app.use('/api/performance-evidence-files', performanceEvidenceRoutes)
app.use('/api/settlement-months', settlementMonthsRoutes)
app.use('/api/settlement-share', settlementRoutes)

// API 루트 엔드포인트 추가 (01_API_상태확인.xlsx 형식에 맞춤)
app.get('/api/', (req, res) => {
  res.json({
    name: 'Shinil PMS API Server',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString(),
    environment: 'production'
  })
})

// Swagger UI 라우트
app.get('/swagger-ui.html', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'swagger-ui.html'))
})

// 루트 경로
app.get('/', (req, res) => {
  res.json({
    message: 'Shinil API Server',
    version: '1.0.0',
    environment: envConfig.NODE_ENV,
    endpoints: {
      swagger: '/swagger-ui.html',
      health: '/api/health',
      auth: '/api/auth',
      'verify-token': '/api/verify-token',
      products: '/api/products',
      clients: '/api/clients',
      companies: '/api/companies'
    }
  })
})

// 404 핸들러
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.originalUrl} not found`,
    availableRoutes: [
      '/',
      '/swagger-ui.html',
      '/api/health',
      '/api/auth',
      '/api/verify-token',
      '/api/products',
      '/api/clients',
      '/api/companies'
    ]
  })
})

// 에러 핸들러
app.use((err, req, res, next) => {
  console.error('API Error:', err)
  res.status(500).json({
    error: 'Internal Server Error',
    message: envConfig.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  })
})

// Vercel 서버리스 함수 형식
export default app