import { createClient } from '@supabase/supabase-js';

// Supabase 클라이언트 생성
const supabaseUrl = process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Supabase 환경 변수가 설정되지 않았습니다.');
}

const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * Refresh Token을 사용하여 새로운 Access Token 발급
 * @param {string} refreshToken - 리프레시 토큰
 * @returns {Promise<Object>} 새로운 토큰 정보
 */
export async function refreshAccessToken(refreshToken) {
  try {
    if (!refreshToken) {
      throw new Error('리프레시 토큰이 필요합니다.');
    }

    console.log('토큰 갱신 시도 중...');
    
    const { data, error } = await supabase.auth.refreshSession({
      refresh_token: refreshToken
    });
    
    if (error) {
      console.error('토큰 갱신 실패:', error);
      throw error;
    }
    
    if (!data.session) {
      throw new Error('세션 정보를 가져올 수 없습니다.');
    }
    
    console.log('토큰 갱신 성공');
    
    return {
      accessToken: data.session.access_token,
      refreshToken: data.session.refresh_token,
      expiresIn: data.session.expires_in,
      user: data.user
    };
  } catch (error) {
    console.error('토큰 갱신 중 오류 발생:', error);
    throw new Error(`토큰 갱신 실패: ${error.message}`);
  }
}

/**
 * 토큰 유효성 검증
 * @param {string} accessToken - 액세스 토큰
 * @returns {Promise<Object>} 토큰 검증 결과
 */
export async function verifyToken(accessToken) {
  try {
    if (!accessToken) {
      return { valid: false, error: '토큰이 없습니다.' };
    }

    const { data: { user }, error } = await supabase.auth.getUser(accessToken);
    
    if (error) {
      return { valid: false, error: error.message };
    }
    
    if (!user) {
      return { valid: false, error: '사용자 정보를 찾을 수 없습니다.' };
    }
    
    return { valid: true, user };
  } catch (error) {
    return { valid: false, error: error.message };
  }
}

/**
 * 토큰 만료 시간 확인
 * @param {string} accessToken - 액세스 토큰
 * @returns {Promise<Object>} 토큰 만료 정보
 */
export async function checkTokenExpiry(accessToken) {
  try {
    if (!accessToken) {
      return { expired: true, error: '토큰이 없습니다.' };
    }

    const { data: { session }, error } = await supabase.auth.getSession();
    
    if (error) {
      return { expired: true, error: error.message };
    }
    
    if (!session) {
      return { expired: true, error: '세션이 없습니다.' };
    }
    
    const now = Math.floor(Date.now() / 1000);
    const expiresAt = session.expires_at;
    const isExpired = now >= expiresAt;
    const timeUntilExpiry = expiresAt - now;
    
    return {
      expired: isExpired,
      expiresAt,
      timeUntilExpiry,
      needsRefresh: timeUntilExpiry <= 300 // 5분 이내 만료
    };
  } catch (error) {
    return { expired: true, error: error.message };
  }
}

/**
 * 사용자 로그아웃
 * @param {string} accessToken - 액세스 토큰
 * @returns {Promise<boolean>} 로그아웃 성공 여부
 */
export async function logout(accessToken) {
  try {
    if (accessToken) {
      const { error } = await supabase.auth.signOut();
      if (error) {
        console.error('로그아웃 중 오류:', error);
        return false;
      }
    }
    
    console.log('로그아웃 성공');
    return true;
  } catch (error) {
    console.error('로그아웃 중 예외 발생:', error);
    return false;
  }
}

/**
 * 토큰 정보 디코딩 (JWT 페이로드 확인용)
 * @param {string} token - JWT 토큰
 * @returns {Object|null} 디코딩된 토큰 정보
 */
export function decodeToken(token) {
  try {
    if (!token) return null;
    
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
      return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    
    return JSON.parse(jsonPayload);
  } catch (error) {
    console.error('토큰 디코딩 실패:', error);
    return null;
  }
}

/**
 * 토큰 상태 요약 정보 반환
 * @param {string} accessToken - 액세스 토큰
 * @param {string} refreshToken - 리프레시 토큰
 * @returns {Promise<Object>} 토큰 상태 요약
 */
export async function getTokenSummary(accessToken, refreshToken) {
  try {
    const accessTokenInfo = accessToken ? decodeToken(accessToken) : null;
    const refreshTokenInfo = refreshToken ? decodeToken(refreshToken) : null;
    
    const now = Math.floor(Date.now() / 1000);
    
    return {
      accessToken: {
        exists: !!accessToken,
        expired: accessTokenInfo ? now >= accessTokenInfo.exp : true,
        expiresAt: accessTokenInfo ? accessTokenInfo.exp : null,
        timeUntilExpiry: accessTokenInfo ? Math.max(0, accessTokenInfo.exp - now) : 0,
        user: accessTokenInfo ? accessTokenInfo.sub : null
      },
      refreshToken: {
        exists: !!refreshToken,
        expired: refreshTokenInfo ? now >= refreshTokenInfo.exp : true,
        expiresAt: refreshTokenInfo ? refreshTokenInfo.exp : null,
        timeUntilExpiry: refreshTokenInfo ? Math.max(0, refreshTokenInfo.exp - now) : 0
      },
      summary: {
        hasValidAccessToken: accessTokenInfo && now < accessTokenInfo.exp,
        hasValidRefreshToken: refreshTokenInfo && now < refreshTokenInfo.exp,
        needsRefresh: accessTokenInfo && (accessTokenInfo.exp - now) <= 300,
        canRefresh: refreshTokenInfo && now < refreshTokenInfo.exp
      }
    };
  } catch (error) {
    console.error('토큰 요약 정보 생성 실패:', error);
    return {
      accessToken: { exists: false, expired: true },
      refreshToken: { exists: false, expired: true },
      summary: {
        hasValidAccessToken: false,
        hasValidRefreshToken: false,
        needsRefresh: false,
        canRefresh: false
      },
      error: error.message
    };
  }
}

export default {
  refreshAccessToken,
  verifyToken,
  checkTokenExpiry,
  logout,
  decodeToken,
  getTokenSummary
};
