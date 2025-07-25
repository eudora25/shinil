import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.VITE_SUPABASE_URL || 'https://mctzuqctekhhdfwimxek.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'your-service-role-key'

const supabase = createClient(supabaseUrl, supabaseServiceKey)

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }
  
  // POST 메서드만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      message: 'Method not allowed. Use POST.'
    })
  }
  
  try {
    const { token } = req.body
    
    // 토큰 필드 검증
    if (!token) {
      return res.status(400).json({
        success: false,
        message: 'Token is required'
      })
    }
    
    try {
      // Base64 디코딩
      const decodedToken = JSON.parse(Buffer.from(token, 'base64').toString())
      
      // 토큰 만료 확인
      const currentTime = Math.floor(Date.now() / 1000)
      if (decodedToken.exp && decodedToken.exp < currentTime) {
        return res.status(401).json({
          success: false,
          message: 'Token has expired'
        })
      }
      
      // 토큰 검증 성공
      return res.status(200).json({
        success: true,
        message: 'Token is valid',
        data: {
          user: {
            email: decodedToken.email,
            role: decodedToken.role,
            userId: decodedToken.userId
          },
          valid: true,
          expiresAt: new Date(decodedToken.exp * 1000).toISOString()
        }
      })
      
    } catch (decodeError) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token format'
      })
    }
    
  } catch (error) {
    console.error('Token verification error:', error)
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    })
  }
} 