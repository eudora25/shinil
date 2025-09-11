import { verifyToken, refreshAccessToken } from '../lib/tokenRefresh.js';

/**
 * HTTP 요청에서 토큰 추출
 * @param {Object} req - Express 요청 객체
 * @returns {string|null} 추출된 토큰 또는 null
 */
function extractToken(req) {
  // Authorization 헤더에서 Bearer 토큰 추출
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith('Bearer ')) {
    return authHeader.substring(7);
  }
  
  // 쿼리 파라미터에서 토큰 추출 (fallback)
  if (req.query.token) {
    return req.query.token;
  }
  
  // 쿠키에서 토큰 추출 (fallback)
  if (req.cookies && req.cookies.access_token) {
    return req.cookies.access_token;
  }
  
  return null;
}

/**
 * HTTP 요청에서 Refresh Token 추출
 * @param {Object} req - Express 요청 객체
 * @returns {string|null} 추출된 Refresh Token 또는 null
 */
function extractRefreshToken(req) {
  // Authorization 헤더에서 Refresh 토큰 추출
  const refreshHeader = req.headers['x-refresh-token'];
  if (refreshHeader) {
    return refreshHeader;
  }
  
  // 쿼리 파라미터에서 Refresh 토큰 추출
  if (req.query.refresh_token) {
    return req.query.refresh_token;
  }
  
  // 쿠키에서 Refresh 토큰 추출
  if (req.cookies && req.cookies.refresh_token) {
    return req.cookies.refresh_token;
  }
  
  return null;
}

/**
 * 토큰 갱신 처리
 * @param {Object} req - Express 요청 객체
 * @param {Object} res - Express 응답 객체
 * @returns {Promise<Object|null>} 갱신된 토큰 정보 또는 null
 */
async function handleTokenRefresh(req, res) {
  try {
    const refreshToken = extractRefreshToken(req);
    
    if (!refreshToken) {
      console.log('Refresh Token이 없습니다.');
      return null;
    }
    
    console.log('Refresh Token으로 토큰 갱신 시도...');
    
    // Refresh Token으로 새 Access Token 발급
    const newTokens = await refreshAccessToken(refreshToken);
    
    if (!newTokens) {
      console.log('토큰 갱신 실패');
      return null;
    }
    
    console.log('토큰 갱신 성공');
    
    // 응답 헤더에 새 토큰 포함
    res.set('X-New-Access-Token', newTokens.accessToken);
    res.set('X-New-Refresh-Token', newTokens.refreshToken);
    res.set('X-Token-Refreshed', 'true');
    
    return {
      user: newTokens.user,
      accessToken: newTokens.accessToken,
      refreshToken: newTokens.refreshToken
    };
  } catch (error) {
    console.error('토큰 갱신 처리 중 오류:', error);
    return null;
  }
}

/**
 * 인증 미들웨어
 * @param {Object} req - Express 요청 객체
 * @param {Object} res - Express 응답 객체
 * @param {Function} next - 다음 미들웨어 함수
 */
export async function authMiddleware(req, res, next) {
  try {
    console.log('인증 미들웨어 실행 중...');
    
    const token = extractToken(req);
    
    if (!token) {
      console.log('토큰이 없습니다.');
      return res.status(401).json({ 
        error: '토큰이 필요합니다.',
        code: 'TOKEN_MISSING'
      });
    }
    
    console.log('토큰 검증 중...');
    
    // 토큰 검증
    const { valid, user, error } = await verifyToken(token);
    
    if (!valid) {
      console.log('토큰 검증 실패:', error);
      
      // 토큰 만료 또는 유효하지 않음
      if (error.includes('expired') || error.includes('invalid') || error.includes('401')) {
        console.log('토큰 만료 감지, 갱신 시도...');
        
        // Refresh Token으로 갱신 시도
        const newTokens = await handleTokenRefresh(req, res);
        
        if (newTokens) {
          console.log('토큰 갱신 성공, 요청 계속 진행');
          req.user = newTokens.user;
          req.newAccessToken = newTokens.accessToken;
          req.newRefreshToken = newTokens.refreshToken;
          req.tokenRefreshed = true;
          return next();
        } else {
          console.log('토큰 갱신 실패');
          return res.status(401).json({ 
            error: '토큰이 만료되었습니다. 다시 로그인해주세요.',
            code: 'TOKEN_EXPIRED_REFRESH_FAILED'
          });
        }
      }
      
      return res.status(401).json({ 
        error: '유효하지 않은 토큰입니다.',
        code: 'TOKEN_INVALID'
      });
    }
    
    console.log('토큰 검증 성공');
    req.user = user;
    next();
    
  } catch (error) {
    console.error('인증 미들웨어 오류:', error);
    return res.status(500).json({ 
      error: '인증 처리 중 오류가 발생했습니다.',
      code: 'AUTH_ERROR'
    });
  }
}

/**
 * 선택적 인증 미들웨어 (토큰이 있으면 검증, 없으면 통과)
 * @param {Object} req - Express 요청 객체
 * @param {Object} res - Express 응답 객체
 * @param {Function} next - 다음 미들웨어 함수
 */
export async function optionalAuthMiddleware(req, res, next) {
  try {
    const token = extractToken(req);
    
    if (!token) {
      // 토큰이 없으면 인증 없이 통과
      req.user = null;
      return next();
    }
    
    // 토큰이 있으면 검증
    const { valid, user, error } = await verifyToken(token);
    
    if (valid) {
      req.user = user;
    } else {
      // 토큰이 유효하지 않아도 통과 (선택적 인증)
      req.user = null;
    }
    
    next();
  } catch (error) {
    console.error('선택적 인증 미들웨어 오류:', error);
    req.user = null;
    next();
  }
}

/**
 * 관리자 권한 확인 미들웨어
 * @param {Object} req - Express 요청 객체
 * @param {Object} res - Express 응답 객체
 * @param {Function} next - 다음 미들웨어 함수
 */
export function adminAuthMiddleware(req, res, next) {
  if (!req.user) {
    return res.status(401).json({ 
      error: '인증이 필요합니다.',
      code: 'AUTH_REQUIRED'
    });
  }
  
  const userType = req.user.user_metadata?.user_type;
  
  if (userType !== 'admin') {
    return res.status(403).json({ 
      error: '관리자 권한이 필요합니다.',
      code: 'ADMIN_REQUIRED'
    });
  }
  
  next();
}

/**
 * 토큰 정보 로깅 미들웨어 (디버깅용)
 * @param {Object} req - Express 요청 객체
 * @param {Object} res - Express 응답 객체
 * @param {Function} next - 다음 미들웨어 함수
 */
export function tokenLoggingMiddleware(req, res, next) {
  const token = extractToken(req);
  const refreshToken = extractRefreshToken(req);
  
  console.log('=== 토큰 정보 로깅 ===');
  console.log('Access Token 존재:', !!token);
  console.log('Refresh Token 존재:', !!refreshToken);
  
  if (token) {
    try {
      const decoded = JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
      console.log('토큰 만료 시간:', new Date(decoded.exp * 1000).toISOString());
      console.log('현재 시간:', new Date().toISOString());
      console.log('만료까지 남은 시간:', Math.max(0, decoded.exp - Math.floor(Date.now() / 1000)), '초');
    } catch (e) {
      console.log('토큰 디코딩 실패');
    }
  }
  
  next();
}

export default {
  authMiddleware,
  optionalAuthMiddleware,
  adminAuthMiddleware,
  tokenLoggingMiddleware,
  extractToken,
  extractRefreshToken,
  handleTokenRefresh
};
