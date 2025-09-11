// Swagger Spec API 엔드포인트 (IP 차단 적용)
import { config } from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'

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

  // 허용된 IP 목록
  const allowedIPs = [
    '127.0.0.1',        // localhost
    '::1',              // localhost IPv6
    '192.168.1.119',    // 예시: 허용할 IP 주소
    '203.241.xxx.xxx',  // 예시: 허용할 IP 주소 (실제 IP로 변경 필요)
    '1.214.163.196',    // 현재 사용자 IP
    '192.168.65.1',     // Docker/개발 환경 IP
    '::ffff:192.168.65.1',  // IPv4-mapped IPv6 형식
    '112.187.169.69',   // 추가 허용 IP
    '58.229.119.165',   // 추가 허용 IP
    '172.19.0.1',       // Docker 컨테이너 네트워크 IP
    '::ffff:172.19.0.1', // Docker 컨테이너 네트워크 IP (IPv6 형식)
    '172.64.149.246',   // 현재 클라이언트 IP
    '::ffff:172.64.149.246', // 현재 클라이언트 IP (IPv6 형식)
    '1.229.109.223',    // 현재 클라이언트 IP
    '::ffff:1.229.109.223', // 현재 클라이언트 IP (IPv6 형식)
    '172.18.0.6',       // Docker 컨테이너 네트워크 IP
    '::ffff:172.18.0.6', // Docker 컨테이너 네트워크 IP (IPv6 형식)
    '172.18.0.1',       // Docker 컨테이너 네트워크 IP
    '::ffff:172.18.0.1', // Docker 컨테이너 네트워크 IP (IPv6 형식)
    '172.18.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.19.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.20.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.21.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.22.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.23.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.24.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.25.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.26.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.27.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.28.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.29.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.30.0.0/16',    // Docker 컨테이너 네트워크 대역
    '172.31.0.0/16',    // Docker 컨테이너 네트워크 대역
  ]

  // 환경 변수에서 IP 목록 로드
  const envIPs = process.env.ALLOWED_IPS
  if (envIPs) {
    allowedIPs.push(...envIPs.split(',').map(ip => ip.trim()))
  }

  // 클라이언트 IP 확인
  const clientIP = req.headers['x-forwarded-for']?.split(',')[0]?.trim() ||
                   req.headers['x-real-ip'] ||
                   req.connection?.remoteAddress ||
                   req.socket?.remoteAddress ||
                   req.ip ||
                   '127.0.0.1'

  console.log('🔍 클라이언트 IP 확인:', clientIP)
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

export default async function handler(req, res) {
  try {
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      return res.status(403).json(ipCheck.error)
    }

    // swagger-spec.json 파일 읽기
    const specPath = path.join(__dirname, '..', 'swagger-spec.json')
    
    if (!fs.existsSync(specPath)) {
      return res.status(404).json({
        success: false,
        message: 'Swagger spec 파일을 찾을 수 없습니다.',
        error: 'FILE_NOT_FOUND'
      })
    }

    const specContent = fs.readFileSync(specPath, 'utf8')
    const spec = JSON.parse(specContent)

    // JSON 응답
    res.setHeader('Content-Type', 'application/json; charset=utf-8')
    res.status(200).json(spec)

  } catch (error) {
    console.error('Swagger Spec API error:', error)
    return res.status(500).json({
      success: false,
      message: 'Swagger spec을 불러오는 중 오류가 발생했습니다.',
      error: error.message
    })
  }
}
