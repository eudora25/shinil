import { config } from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'
import { productionEnv } from './production-env.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// 환경에 따라 적절한 .env 파일 로드
const nodeEnv = process.env.NODE_ENV || 'development'

let envFile = '.env.local' // 기본값

if (nodeEnv === 'production') {
  envFile = '.env.production'
  // 프로덕션 환경에서는 JavaScript 파일에서 환경 변수 로드
  console.log('🚀 Production 환경: JavaScript 환경 변수 파일 사용')
  Object.assign(process.env, productionEnv)
} else if (nodeEnv === 'development') {
  envFile = '.env.local'
  // .env 파일 로드 (개발 환경에서만)
  try {
    config({ 
      path: path.join(__dirname, '..', envFile),
      override: true // 기존 환경 변수보다 .env 파일 우선
    })
    console.log(`✅ 환경 파일 로드 성공: ${envFile}`)
  } catch (error) {
    console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
  }
}

// 환경 변수 검증
const requiredEnvVars = [
  'VITE_SUPABASE_URL',
  'VITE_SUPABASE_ANON_KEY'
]

// 선택적 환경 변수 (Service Role Key)
const optionalEnvVars = [
  'SUPABASE_SERVICE_ROLE_KEY'
]

const missingEnvVars = requiredEnvVars.filter(envVar => !process.env[envVar])

if (missingEnvVars.length > 0) {
  console.error('❌ 필수 환경 변수가 설정되지 않았습니다:', missingEnvVars)
  console.error(`📁 현재 로드된 환경 파일: ${envFile}`)
  process.exit(1)
}

// 환경 정보 출력
console.log(`🌍 환경: ${nodeEnv}`)
console.log(`📁 환경 파일: ${envFile}`)
console.log(`🔗 Supabase URL: ${process.env.VITE_SUPABASE_URL}`)
console.log(`🔑 Supabase Key: ${process.env.VITE_SUPABASE_ANON_KEY?.substring(0, 20)}...`)

export default {
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: process.env.PORT || 3001,
  SUPABASE_URL: process.env.VITE_SUPABASE_URL,
  SUPABASE_ANON_KEY: process.env.VITE_SUPABASE_ANON_KEY,
  SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY,
  API_BASE_URL: process.env.API_BASE_URL || 'http://localhost:3001',
  CORS_ORIGIN: process.env.CORS_ORIGIN || 'http://localhost:3000',
  LOG_LEVEL: process.env.LOG_LEVEL || 'info',
  JWT_SECRET: process.env.JWT_SECRET || 'default-jwt-secret',
  SESSION_SECRET: process.env.SESSION_SECRET || 'default-session-secret'
}
