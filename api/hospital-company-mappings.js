// Vercel 서버리스 함수 형식으로 변경 (10_병원업체_관계정보.xlsx 형식에 맞춤)
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
    // 환경 변수 확인 (개행 문자 제거)
    const supabaseUrl = (process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL)?.trim()
    const supabaseAnonKey = (process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY)?.trim()
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()

    // 환경 변수 디버깅
    console.log('Hospital Company Mappings API - Environment variables:', {
      supabaseUrl: supabaseUrl ? 'Set' : 'Missing',
      supabaseAnonKey: supabaseAnonKey ? 'Set' : 'Missing',
      serviceRoleKey: serviceRoleKey ? 'Set' : 'Missing'
    })

    // 환경 변수가 없으면 기본값 사용 (개발용)
    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase configuration missing'
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
      console.log('🔍 Using Service Role Key for RLS bypass')
      supabase = createClient(supabaseUrl, serviceRoleKey)
    } else {
      console.log('🔍 Service Role Key not available, using Anon Key')
      supabase = createClient(supabaseUrl, supabaseAnonKey)
    }

    // 연결 테스트 (간단한 쿼리)
    const { data: testData, error: testError } = await supabase
      .from('client_company_assignments')
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

    // 쿼리 파라미터 파싱 (10_병원업체_관계정보.xlsx 형식에 맞춤)
    const {
      page = 1,
      limit = 100,
      startDate,
      endDate
    } = req.query

    // 페이지네이션 계산
    const pageNum = parseInt(page, 10)
    const limitNum = parseInt(limit, 10)
    const offset = (pageNum - 1) * limitNum

    // 입력값 검증
    if (pageNum < 1 || limitNum < 1 || limitNum > 1000) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pagination parameters. Page must be >= 1, limit must be between 1 and 1000.'
      })
    }

    // 기본 쿼리 설정
    let query = supabase
      .from('client_company_assignments')
      .select(`
        *,
        clients:client_id(id, name, address, business_registration_number, client_code, owner_name),
        companies:company_id(id, company_name, business_registration_number, representative_name)
      `, { count: 'exact' })
      .order('created_at', { ascending: false })

    // 날짜 필터링 (startDate, endDate 파라미터 지원)
    if (startDate) {
      query = query.gte('created_at', startDate)
    }
    if (endDate) {
      query = query.lte('created_at', endDate)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limitNum - 1)

    // 데이터 조회
    const { data: mappings, error: getError, count } = await query

    console.log('🔍 Hospital Company Mappings query result:', { data: mappings?.length, error: getError, count })

    if (getError) {
      console.error('Hospital Company Mappings fetch error:', getError)
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch hospital company mappings',
        error: getError.message
      })
    }

    // 페이지네이션 정보 계산
    const totalPages = Math.ceil(count / limitNum)
    const hasNextPage = pageNum < totalPages
    const hasPrevPage = pageNum > 1

    // 10_병원업체_관계정보.xlsx 형식에 맞춘 응답
    const response = {
      success: true,
      message: '병원-회사 매핑 목록 조회 성공',
      data: mappings || [],
      count: count || 0,
      page: pageNum,
      limit: limitNum,
      totalPages,
      hasNextPage,
      hasPrevPage
    }

    res.json(response)

  } catch (error) {
    console.error('Hospital Company Mappings API error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })

    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}

