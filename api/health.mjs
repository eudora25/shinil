import { createClient } from '@supabase/supabase-js'
import { config } from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// 환경 변수 로드
const nodeEnv = process.env.NODE_ENV || 'development'
const envFile = nodeEnv === 'production' ? '.env.production' : '.env.local'

try {
  config({ 
    path: path.join(__dirname, '..', envFile),
    override: true
  })
  console.log(`✅ 환경 파일 로드 성공: ${envFile}`)
} catch (error) {
  console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
}

// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const requiredEnvVars = [
    'VITE_SUPABASE_URL',
    'VITE_SUPABASE_ANON_KEY'
  ]

  const missingEnvVars = requiredEnvVars.filter(envVar => !process.env[envVar])

  if (missingEnvVars.length > 0) {
    console.error('❌ 필수 환경 변수가 설정되지 않았습니다:', missingEnvVars)
    return false
  }

  return true
}

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL
  const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Supabase 환경 변수가 설정되지 않았습니다')
  }

  return createClient(supabaseUrl, supabaseKey)
}

const serverStartTime = Date.now()

export default async function handler(req, res) {
  try {
    // 환경 변수 확인
    if (!getEnvironmentVariables()) {
      return res.status(500).json({
        error: 'Environment variables not configured',
        message: '필수 환경 변수가 설정되지 않았습니다'
      })
    }

    // Supabase 연결 테스트
    const supabase = createSupabaseClient()
    
    // 간단한 쿼리로 연결 테스트 (인증이 필요하지 않은 테이블 사용)
    const { data, error } = await supabase
      .from('companies')
      .select('id')
      .limit(1)

    if (error) {
      console.error('Supabase 연결 오류:', error)
      return res.status(500).json({
        error: 'Database connection failed',
        message: '데이터베이스 연결에 실패했습니다',
        details: error.message
      })
    }

    // 서버 상태 정보
    const uptime = Date.now() - serverStartTime
    const memoryUsage = process.memoryUsage()

    return res.status(200).json({
      success: true,
      message: 'API 서버가 정상적으로 작동 중입니다',
      data: {
        status: 'healthy',
        uptime: `${Math.floor(uptime / 1000)}초`,
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development',
        memory: {
          used: `${Math.round(memoryUsage.heapUsed / 1024 / 1024)}MB`,
          total: `${Math.round(memoryUsage.heapTotal / 1024 / 1024)}MB`
        },
        database: {
          connected: true,
          message: 'Supabase 연결 성공'
        }
      }
    })

  } catch (error) {
    console.error('Health check 오류:', error)
    return res.status(500).json({
      error: 'Internal server error',
      message: '서버 내부 오류가 발생했습니다',
      details: error.message
    })
  }
}
