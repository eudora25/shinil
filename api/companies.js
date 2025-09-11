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
} catch (error) {
  console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
}

export default async function handler(req, res) {
  try {
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      return res.status(403).json(ipCheck.error)
    }

    // 환경 변수 확인 (개행 문자 제거)
    const supabaseUrl = (process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL)?.trim()
    const supabaseAnonKey = (process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY)?.trim()
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()

    // 환경 변수 디버깅
    console.log('Companies API - Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
    })
    
    // Service Role Key 디버깅
    console.log('🔍 Service Role Key status:', serviceRoleKey ? 'Available' : 'Not available')
    if (serviceRoleKey) {
      console.log('🔍 Service Role Key length:', serviceRoleKey.length)
      console.log('🔍 Service Role Key starts with:', serviceRoleKey.substring(0, 20) + '...')
    }

    // 환경 변수가 없으면 기본값 사용 (개발용)
    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase environment variables not configured',
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing'
        }
      })
    }

    // 환경 변수 값 확인 (디버깅용)
    console.log('Supabase URL:', supabaseUrl)
    console.log('Supabase Anon Key (first 20 chars):', supabaseAnonKey?.substring(0, 20))

    console.log('Environment variables updated:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing',
      allEnvKeys: Object.keys(process.env).filter(key => key.includes('SUPABASE')),
      actualValues: {
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey ? supabaseAnonKey.substring(0, 20) + '...' : 'Missing',
        serviceRoleKey: serviceRoleKey ? serviceRoleKey.substring(0, 20) + '...' : 'Missing'
      }
    })

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing'
        }
      })
    }

    // 토큰 검증
    const authHeader = req.headers.authorization
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    const token = authHeader.substring(7)
    const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey)
    const { data: { user }, error: authError } = await supabaseAuth.auth.getUser(token)

    if (authError || !user || user.user_metadata?.user_type !== 'admin') {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      })
    }

    // Supabase 클라이언트 생성 (RLS 정책 무시를 위해 Service Role Key 사용)
    let supabase
    
    if (serviceRoleKey) {
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      supabase = createClient(supabaseUrl, supabaseAnonKey)
    }
    
    // 연결 테스트 (간단한 쿼리)
    const { data: testData, error: testError } = await supabase
      .from('companies')
      .select('id')
      .limit(1)
    
    if (testError) {
      console.error('Supabase connection test failed:', testError)
      return res.status(500).json({
        success: false,
        message: 'Supabase connection failed',
        error: testError.message,
        debug: {
          supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
          supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
          testError: testError
        }
      })
    }

    const { page = 1, limit = 100 } = req.query
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    const { data: companies, error: getError, count } = await supabase
      .from('companies')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })
      .range(offset, offset + limitNum - 1)

    if (getError) {
      console.error('Database error:', getError)
      return res.status(500).json({
        success: false,
        message: 'Database error',
        error: getError.message
      })
    }

    res.json({
      success: true,
      message: '회사 정보 조회 성공',
      data: companies || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum
    })

  } catch (error) {
    console.error('Error:', error)
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
}