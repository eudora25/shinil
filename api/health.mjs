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

// IP 제한 함수
function checkIPAccess(req) {
  // 개발 환경에서는 모든 IP 허용
  if (process.env.NODE_ENV === 'development' || !process.env.NODE_ENV) {
    console.log('🔓 개발 환경: 모든 IP 허용')
    return { allowed: true }
  }

  // 환경 변수에서 허용된 IP 목록 로드
  const envIPs = process.env.ALLOWED_IPS
  if (!envIPs) {
    console.log('❌ ALLOWED_IPS 환경 변수가 설정되지 않았습니다')
    return { 
      allowed: false, 
      error: {
        success: false,
        message: 'IP 접근 제한 설정이 올바르지 않습니다.',
        error: 'IP_CONFIG_ERROR',
        timestamp: new Date().toISOString()
      }
    }
  }

  const allowedIPs = envIPs.split(',').map(ip => ip.trim()).filter(ip => ip.length > 0)

  // 클라이언트 IP 확인
  const clientIP = req.headers['x-forwarded-for']?.split(',')[0]?.trim() ||
                   req.headers['x-real-ip'] ||
                   req.connection?.remoteAddress ||
                   req.socket?.remoteAddress ||
                   req.ip ||
                   '127.0.0.1'

  console.log('🔍 클라이언트 IP 확인:', clientIP)
  console.log('🔍 X-Forwarded-For:', req.headers['x-forwarded-for'])
  console.log('🔍 X-Real-IP:', req.headers['x-real-ip'])
  console.log('🔍 Connection Remote Address:', req.connection?.remoteAddress)
  console.log('🔍 Socket Remote Address:', req.socket?.remoteAddress)
  console.log('🔍 Request IP:', req.ip)
  console.log('🔒 허용된 IP 목록:', allowedIPs.join(', '))

  // IP 허용 여부 확인
  const isAllowed = allowedIPs.some(allowedIP => {
    // 정확한 IP 매칭
    if (allowedIP === clientIP) return true
    
    // IPv4-mapped IPv6 주소 처리 (::ffff:192.168.65.1 -> 192.168.65.1)
    if (clientIP.startsWith('::ffff:')) {
      const ipv4Part = clientIP.substring(7) // ::ffff: 제거
      if (allowedIP === ipv4Part) return true
    }
    
    // IPv4 주소를 IPv4-mapped IPv6로 변환해서 매칭
    if (allowedIP.includes('.') && !allowedIP.includes(':')) {
      const mappedIPv6 = `::ffff:${allowedIP}`
      if (clientIP === mappedIPv6) return true
    }
    
    // CIDR 표기법 지원 (예: 192.168.1.0/24)
    if (allowedIP.includes('/')) {
      const [network, bits] = allowedIP.split('/')
      const mask = ~((1 << (32 - parseInt(bits))) - 1)
      const networkLong = ipToLong(network) & mask
      const ipLong = ipToLong(clientIP) & mask
      return networkLong === ipLong
    }
    
    return false
  })

  if (!isAllowed) {
    console.log('🚫 IP 접근 차단:', clientIP)
    return { 
      allowed: false, 
      error: {
        success: false,
        message: '접근이 허용되지 않은 IP입니다.',
        error: 'IP_ACCESS_DENIED',
        clientIP: clientIP,
        timestamp: new Date().toISOString()
      }
    }
  }

  console.log('✅ IP 접근 허용:', clientIP)
  return { allowed: true }
}

// IP 주소를 long으로 변환
function ipToLong(ip) {
  return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0) >>> 0
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
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      return res.status(403).json({
        status: 'access_denied',
        timestamp: new Date().toISOString(),
        uptime: Math.floor((Date.now() - serverStartTime) / 1000),
        environment: process.env.NODE_ENV || 'development'
      })
    }

    // 환경 변수 확인
    if (!getEnvironmentVariables()) {
      return res.status(500).json({
        status: 'config_error',
        timestamp: new Date().toISOString(),
        uptime: Math.floor((Date.now() - serverStartTime) / 1000),
        environment: process.env.NODE_ENV || 'development'
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
      console.error('Supabase 연결 테스트 실패:', error)
      return res.status(500).json({
        status: 'unhealthy',
        timestamp: new Date().toISOString(),
        uptime: Math.floor((Date.now() - serverStartTime) / 1000),
        environment: process.env.NODE_ENV || 'development'
      })
    }

    // 서버 상태 정보
    const uptime = Math.floor((Date.now() - serverStartTime) / 1000)
    const memoryUsage = process.memoryUsage()

    // 02_시스템_헬스체크.xlsx 스펙에 맞춘 응답
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: uptime,
      environment: process.env.NODE_ENV || 'development'
    })

  } catch (error) {
    console.error('Health check error:', error)
    return res.status(500).json({
      status: 'error',
      timestamp: new Date().toISOString(),
      uptime: Math.floor((Date.now() - serverStartTime) / 1000),
      environment: process.env.NODE_ENV || 'development'
    })
  }
}