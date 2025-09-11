// Vercel 서버리스 함수 형식 (04_토큰_검증.xlsx 형식에 맞춤)
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

// 환경 변수 확인 함수
function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  
  return { supabaseUrl, supabaseAnonKey }
}

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  
  try {
    return createClient(supabaseUrl, supabaseAnonKey)
  } catch (error) {
    console.error('Failed to create Supabase client:', error)
    throw error
  }
}

// POST /api/verify-token - JWT 토큰 유효성 검증 (04_토큰_검증.xlsx 형식에 맞춤)
export default async (req, res) => {
  // POST 메서드만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      valid: false,
      message: 'Method not allowed'
    })
  }
  try {
    const { token } = req.body
    
    // 필수 파라미터 검증
    if (!token) {
      return res.status(400).json({
        success: false,
        valid: false,
        message: '토큰이 필요합니다.',
        error: 'TOKEN_MISSING'
      })
    }

    // Supabase 클라이언트 생성
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        valid: false,
        message: '서버 설정 오류',
        error: 'Supabase client initialization failed'
      })
    }

    // JWT 토큰 유효성 검증
    try {
      const { data: { user }, error: tokenError } = await supabase.auth.getUser(token)
      
      if (user && !tokenError) {
        // 토큰이 유효함
        console.log(`✅ 토큰 검증 성공: 사용자 ${user.email}`)
        
        // 04_토큰_검증.xlsx 형식에 맞춘 응답
        const response = {
          success: true,
          valid: true,
          user: {
            id: user.id,
            email: user.email,
            created_at: user.created_at,
            last_sign_in_at: user.last_sign_in_at,
            user_metadata: user.user_metadata || {}
          },
          message: '토큰이 유효합니다.'
        }
        
        res.json(response)
        
      } else {
        // 토큰이 유효하지 않음
        console.log(`❌ 토큰 검증 실패: ${tokenError?.message}`)
        
        const response = {
          success: false,
          valid: false,
          message: '토큰이 유효하지 않습니다.',
          error: tokenError?.message || 'Invalid token'
        }
        
        res.status(401).json(response)
      }
      
    } catch (verificationError) {
      console.error('Token verification error:', verificationError)
      
      const response = {
        success: false,
        valid: false,
        message: '토큰 검증 중 오류가 발생했습니다.',
        error: verificationError.message
      }
      
      res.status(500).json(response)
    }

  } catch (error) {
    console.error('Verify token API error:', error)
    res.status(500).json({
      success: false,
      valid: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
}
