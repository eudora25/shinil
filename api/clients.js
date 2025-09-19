import { createClient } from '@supabase/supabase-js'

import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// 환경 변수 로드
const nodeEnv = process.env.NODE_ENV || 'development'
const envFile = nodeEnv === 'production' ? '.env.production' : '.env.local'

  console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
}

export default async function handler(req, res) {
    console.error('Clients API error details:', {
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