// 토큰 검증 미들웨어
import { createClient } from '@supabase/supabase-js'

/**
 * 토큰 검증 미들웨어
 * JWT 토큰의 유효성을 검증하고, 만료 시 자동 갱신
 */
export const tokenValidationMiddleware = async (req, res, next) => {
  try {
    // Authorization 헤더에서 Bearer 토큰 추출
    const authHeader = req.headers.authorization
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: '인증 토큰이 필요합니다.',
        error: 'TOKEN_MISSING',
        code: 'AUTH_REQUIRED'
      })
    }

    const accessToken = authHeader.substring(7)
    console.log(`🔍 토큰 검증 시작: ${accessToken.substring(0, 20)}...`)

    // Supabase 클라이언트 생성 (RLS 우회를 위해 Service Role Key 사용)
    const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_SERVICE_ROLE_KEY
    const anonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
    
    const supabase = createClient(
      supabaseUrl,
      serviceRoleKey || anonKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // 1단계: 액세스 토큰 유효성 검증
    try {
      const { data: { user }, error: tokenError } = await supabase.auth.getUser(accessToken)
      
      if (user && !tokenError) {
        // 토큰이 유효함 - admin 타입 검증 추가
        const userType = user.user_metadata?.user_type
        if (userType !== 'admin') {
          console.log(`❌ 권한 부족: 사용자 ${user.email} (타입: ${userType})`)
          return res.status(403).json({
            success: false,
            message: '관리자 권한이 필요합니다.',
            error: 'INSUFFICIENT_PERMISSIONS',
            code: 'ADMIN_REQUIRED'
          })
        }
        
        console.log(`✅ 토큰 검증 성공: 사용자 ${user.email} (admin)`)
        req.user = user
        req.accessToken = accessToken
        console.log('🔍 next() 호출 전')
        return next()
      }
      
      // 토큰이 유효하지 않음 - 리프레시 토큰으로 갱신 시도
      console.log(`⚠️ 액세스 토큰 만료 또는 무효: ${tokenError?.message}`)
      
    } catch (tokenError) {
      console.log(`⚠️ 액세스 토큰 검증 실패: ${tokenError.message}`)
    }

    // 2단계: 리프레시 토큰으로 새 액세스 토큰 발급 시도
    const refreshToken = req.headers['x-refresh-token'] || req.cookies?.refreshToken
    
    if (!refreshToken) {
      return res.status(401).json({
        success: false,
        message: '토큰이 만료되었습니다. 다시 로그인해주세요.',
        error: 'TOKEN_EXPIRED',
        code: 'REFRESH_REQUIRED'
      })
    }

    try {
      console.log(`🔄 리프레시 토큰으로 새 액세스 토큰 발급 시도...`)
      
      // 리프레시 토큰용 별도 클라이언트 생성 (Service Role Key 사용)
      const refreshSupabase = createClient(
        supabaseUrl,
        serviceRoleKey || anonKey,
        {
          auth: {
            autoRefreshToken: false,
            persistSession: false
          }
        }
      )
      
      const { data: refreshData, error: refreshError } = await refreshSupabase.auth.refreshSession({
        refresh_token: refreshToken
      })

      if (refreshData.session && !refreshError) {
        // 새 토큰 발급 성공 - admin 타입 검증 추가
        const userType = refreshData.user.user_metadata?.user_type
        if (userType !== 'admin') {
          console.log(`❌ 권한 부족: 사용자 ${refreshData.user.email} (타입: ${userType})`)
          return res.status(403).json({
            success: false,
            message: '관리자 권한이 필요합니다.',
            error: 'INSUFFICIENT_PERMISSIONS',
            code: 'ADMIN_REQUIRED'
          })
        }
        
        const newAccessToken = refreshData.session.access_token
        const newRefreshToken = refreshData.session.refresh_token
        
        console.log(`✅ 토큰 갱신 성공: 사용자 ${refreshData.user.email} (admin)`)
        
        // 새 토큰 정보를 요청 객체에 저장
        req.user = refreshData.user
        req.accessToken = newAccessToken
        req.refreshToken = newRefreshToken
        req.tokenRefreshed = true
        
        // 응답 헤더에 새 토큰 정보 포함
        res.set('X-New-Access-Token', newAccessToken)
        res.set('X-New-Refresh-Token', newRefreshToken)
        res.set('X-Token-Refreshed', 'true')
        
        return next()
        
      } else {
        // 리프레시 토큰도 무효
        console.log(`❌ 리프레시 토큰 무효: ${refreshError?.message}`)
        return res.status(401).json({
          success: false,
          message: '인증이 만료되었습니다. 다시 로그인해주세요.',
          error: 'REFRESH_TOKEN_INVALID',
          code: 'REAUTH_REQUIRED'
        })
      }
      
    } catch (refreshError) {
      console.error('토큰 갱신 중 오류:', refreshError)
      return res.status(401).json({
        success: false,
        message: '토큰 갱신에 실패했습니다. 다시 로그인해주세요.',
        error: 'TOKEN_REFRESH_FAILED',
        code: 'REAUTH_REQUIRED'
      })
    }

  } catch (error) {
    console.error('토큰 검증 미들웨어 오류:', error)
    return res.status(500).json({
      success: false,
      message: '인증 확인 중 오류가 발생했습니다.',
      error: 'AUTH_CHECK_ERROR',
      code: 'INTERNAL_ERROR'
    })
  }
}

/**
 * 선택적 토큰 검증 미들웨어
 * 토큰이 있으면 검증하고, 없으면 다음으로 진행
 */
export const optionalTokenValidationMiddleware = async (req, res, next) => {
  const authHeader = req.headers.authorization
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // 토큰이 없으면 다음으로 진행
    return next()
  }
  
  // 토큰이 있으면 검증
  return tokenValidationMiddleware(req, res, next)
}

export default tokenValidationMiddleware
