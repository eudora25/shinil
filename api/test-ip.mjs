// IP 테스트 API (디버깅용)
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

export default async function handler(req, res) {
  try {
    // 클라이언트 IP 확인
    const clientIP = req.headers['x-forwarded-for']?.split(',')[0]?.trim() ||
                     req.headers['x-real-ip'] ||
                     req.connection?.remoteAddress ||
                     req.socket?.remoteAddress ||
                     req.ip ||
                     '127.0.0.1'

    // 모든 헤더 정보 수집
    const headers = {
      'x-forwarded-for': req.headers['x-forwarded-for'],
      'x-real-ip': req.headers['x-real-ip'],
      'x-vercel-forwarded-for': req.headers['x-vercel-forwarded-for'],
      'x-vercel-ip-country': req.headers['x-vercel-ip-country'],
      'x-vercel-ip-city': req.headers['x-vercel-ip-city'],
      'user-agent': req.headers['user-agent']
    }

    // 환경 변수 정보
    const envInfo = {
      NODE_ENV: process.env.NODE_ENV,
      VERCEL: process.env.VERCEL,
      VERCEL_ENV: process.env.VERCEL_ENV,
      ALLOWED_IPS: process.env.ALLOWED_IPS
    }

    // IP 차단 테스트
    const isDevelopment = process.env.NODE_ENV === 'development' || !process.env.NODE_ENV
    const shouldBlock = !isDevelopment

    res.json({
      success: true,
      message: 'IP 테스트 정보',
      data: {
        clientIP: clientIP,
        headers: headers,
        environment: envInfo,
        ipBlocking: {
          isDevelopment: isDevelopment,
          shouldBlock: shouldBlock,
          nodeEnv: process.env.NODE_ENV
        },
        timestamp: new Date().toISOString()
      }
    })

  } catch (error) {
    console.error('IP Test API error:', error)
    return res.status(500).json({
      success: false,
      message: 'IP 테스트 중 오류가 발생했습니다.',
      error: error.message
    })
  }
}
