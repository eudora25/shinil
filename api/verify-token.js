import { createClient } from '@supabase/supabase-js'

export default async function handler(req, res) {
  // CORS 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end()
  }

  // POST 요청만 처리
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, message: 'Method not allowed' })
  }

  try {
    // 환경 변수에서 Supabase 설정 가져오기
    const supabaseUrl = process.env.VITE_SUPABASE_URL
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

    if (!supabaseUrl || !supabaseAnonKey) {
      return res.status(500).json({ 
        success: false, 
        message: 'Supabase configuration missing' 
      })
    }

    // Supabase 클라이언트 생성
    const supabase = createClient(supabaseUrl, supabaseAnonKey)

    // Authorization 헤더 또는 요청 본문에서 토큰 가져오기
    let token = req.headers.authorization
    if (token && token.startsWith('Bearer ')) {
      token = token.substring(7)
    } else {
      // 헤더에 없으면 본문에서 가져오기
      const { token: bodyToken } = req.body
      if (bodyToken) {
        token = bodyToken
      }
    }

    if (!token) {
      return res.status(400).json({ 
        success: false, 
        message: 'Token is required' 
      })
    }

    // 토큰 검증
    const { data: { user }, error } = await supabase.auth.getUser(token)

    if (error || !user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid or expired token' 
      })
    }

    // 성공 응답
    res.status(200).json({
      success: true,
      message: 'Token is valid',
      data: {
        user: {
          id: user.id,
          email: user.email,
          user_metadata: user.user_metadata
        }
      }
    })

  } catch (error) {
    console.error('Verify token API error:', error)
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error',
      error: error.message 
    })
  }
}
