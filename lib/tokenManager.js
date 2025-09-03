/**
 * 토큰 관리 클래스
 * Access Token과 Refresh Token의 생명주기를 관리합니다.
 */
class TokenManager {
  constructor() {
    this.accessToken = null;
    this.refreshToken = null;
    this.tokenExpiry = null;
    this.user = null;
  }
  
  /**
   * 토큰 정보 설정
   * @param {string} accessToken - 액세스 토큰
   * @param {string} refreshToken - 리프레시 토큰
   * @param {number} expiresIn - 만료 시간 (초)
   * @param {Object} user - 사용자 정보
   */
  setTokens(accessToken, refreshToken, expiresIn, user = null) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.tokenExpiry = Date.now() + (expiresIn * 1000);
    this.user = user;
    
    // 로컬 스토리지에 저장 (브라우저 환경)
    if (typeof window !== 'undefined') {
      try {
        localStorage.setItem('shinil_access_token', accessToken);
        localStorage.setItem('shinil_refresh_token', refreshToken);
        localStorage.setItem('shinil_token_expiry', this.tokenExpiry.toString());
        if (user) {
          localStorage.setItem('shinil_user', JSON.stringify(user));
        }
      } catch (error) {
        console.warn('로컬 스토리지 저장 실패:', error);
      }
    }
  }
  
  /**
   * 저장된 토큰 정보 복원
   */
  restoreTokens() {
    if (typeof window !== 'undefined') {
      try {
        const accessToken = localStorage.getItem('shinil_access_token');
        const refreshToken = localStorage.getItem('shinil_refresh_token');
        const tokenExpiry = localStorage.getItem('shinil_token_expiry');
        const userStr = localStorage.getItem('shinil_user');
        
        if (accessToken && refreshToken && tokenExpiry) {
          this.accessToken = accessToken;
          this.refreshToken = refreshToken;
          this.tokenExpiry = parseInt(tokenExpiry);
          if (userStr) {
            this.user = JSON.parse(userStr);
          }
          return true;
        }
      } catch (error) {
        console.warn('로컬 스토리지 복원 실패:', error);
      }
    }
    return false;
  }
  
  /**
   * 토큰 만료 확인
   * @returns {boolean} 토큰 만료 여부
   */
  isTokenExpired() {
    if (!this.tokenExpiry) return true;
    return Date.now() >= this.tokenExpiry;
  }
  
  /**
   * 토큰 갱신 필요 여부 확인 (만료 5분 전)
   * @returns {boolean} 갱신 필요 여부
   */
  needsRefresh() {
    if (!this.tokenExpiry) return true;
    return Date.now() >= (this.tokenExpiry - 300000); // 5분 전
  }
  
  /**
   * 유효한 액세스 토큰 반환
   * @returns {string|null} 유효한 액세스 토큰 또는 null
   */
  getValidAccessToken() {
    if (this.accessToken && !this.isTokenExpired()) {
      return this.accessToken;
    }
    return null;
  }
  
  /**
   * 리프레시 토큰 반환
   * @returns {string|null} 리프레시 토큰 또는 null
   */
  getRefreshToken() {
    return this.refreshToken;
  }
  
  /**
   * 사용자 정보 반환
   * @returns {Object|null} 사용자 정보 또는 null
   */
  getUser() {
    return this.user;
  }
  
  /**
   * 토큰 정보 초기화
   */
  clearTokens() {
    this.accessToken = null;
    this.refreshToken = null;
    this.tokenExpiry = null;
    this.user = null;
    
    // 로컬 스토리지에서도 제거
    if (typeof window !== 'undefined') {
      try {
        localStorage.removeItem('shinil_access_token');
        localStorage.removeItem('shinil_refresh_token');
        localStorage.removeItem('shinil_token_expiry');
        localStorage.removeItem('shinil_user');
      } catch (error) {
        console.warn('로컬 스토리지 정리 실패:', error);
      }
    }
  }
  
  /**
   * 토큰 상태 정보 반환
   * @returns {Object} 토큰 상태 정보
   */
  getTokenStatus() {
    return {
      hasAccessToken: !!this.accessToken,
      hasRefreshToken: !!this.refreshToken,
      isExpired: this.isTokenExpired(),
      needsRefresh: this.needsRefresh(),
      expiresIn: this.tokenExpiry ? Math.max(0, this.tokenExpiry - Date.now()) : 0,
      user: this.user
    };
  }
}

// Node.js 환경에서는 module.exports, 브라우저 환경에서는 window에 할당
if (typeof module !== 'undefined' && module.exports) {
  module.exports = TokenManager;
} else if (typeof window !== 'undefined') {
  window.TokenManager = TokenManager;
}

export default TokenManager;
