/**
 * API 클라이언트 클래스
 * 토큰 자동 갱신 및 API 요청 관리를 담당합니다.
 */
import TokenManager from './tokenManager.js';

class ApiClient {
  constructor(baseURL = '') {
    this.baseURL = baseURL;
    this.tokenManager = new TokenManager();
    this.isRefreshing = false;
    this.failedQueue = [];
    
    // 저장된 토큰 복원
    this.tokenManager.restoreTokens();
    
    this.setupInterceptors();
  }
  
  /**
   * HTTP 인터셉터 설정
   */
  setupInterceptors() {
    // 요청 인터셉터: 토큰 자동 추가
    this.addRequestInterceptor();
    
    // 응답 인터셉터: 토큰 갱신 처리
    this.addResponseInterceptor();
  }
  
  /**
   * 요청 인터셉터 추가
   */
  addRequestInterceptor() {
    // fetch를 사용하는 경우를 위한 래퍼
    const originalFetch = window.fetch;
    
    window.fetch = async (url, options = {}) => {
      // 토큰이 필요하고 만료되었으면 갱신
      if (this.shouldAddToken(url) && this.tokenManager.needsRefresh()) {
        await this.refreshTokensIfNeeded();
      }
      
      // 유효한 토큰이 있으면 헤더에 추가
      const validToken = this.tokenManager.getValidAccessToken();
      if (validToken) {
        options.headers = {
          ...options.headers,
          'Authorization': `Bearer ${validToken}`
        };
      }
      
      return originalFetch(url, options);
    };
  }
  
  /**
   * 응답 인터셉터 추가
   */
  addResponseInterceptor() {
    // fetch를 사용하는 경우를 위한 래퍼
    const originalFetch = window.fetch;
    
    window.fetch = async (url, options = {}) => {
      try {
        const response = await originalFetch(url, options);
        
        // 새 토큰이 헤더에 있으면 저장
        const newAccessToken = response.headers.get('x-new-access-token');
        const newRefreshToken = response.headers.get('x-new-refresh-token');
        
        if (newAccessToken && newRefreshToken) {
          console.log('새 토큰을 받았습니다. 저장 중...');
          this.tokenManager.setTokens(newAccessToken, newRefreshToken, 3600);
        }
        
        return response;
      } catch (error) {
        // 401 에러 시 토큰 갱신 시도
        if (error.status === 401 || (error.response && error.response.status === 401)) {
          console.log('401 에러 감지, 토큰 갱신 시도...');
          
          const refreshed = await this.refreshTokensIfNeeded();
          if (refreshed) {
            // 원래 요청 재시도
            return this.retryRequest(url, options);
          }
        }
        
        throw error;
      }
    };
  }
  
  /**
   * URL이 토큰을 필요로 하는지 확인
   */
  shouldAddToken(url) {
    const tokenRequiredPaths = ['/api/products', '/api/clients', '/api/notices'];
    return tokenRequiredPaths.some(path => url.includes(path));
  }
  
  /**
   * 토큰 갱신이 필요한지 확인하고 갱신
   */
  async refreshTokensIfNeeded() {
    if (this.isRefreshing) {
      // 이미 갱신 중이면 대기
      return new Promise((resolve) => {
        this.failedQueue.push(resolve);
      });
    }
    
    if (!this.tokenManager.needsRefresh()) {
      return true;
    }
    
    this.isRefreshing = true;
    
    try {
      const refreshToken = this.tokenManager.getRefreshToken();
      if (!refreshToken) {
        throw new Error('Refresh token이 없습니다.');
      }
      
      console.log('토큰 갱신 요청 중...');
      
      const response = await fetch(`${this.baseURL}/api/auth`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          action: 'refresh',
          refreshToken: refreshToken
        })
      });
      
      if (!response.ok) {
        throw new Error('토큰 갱신 실패');
      }
      
      const data = await response.json();
      
      if (data.success) {
        // 새 토큰 저장
        this.tokenManager.setTokens(
          data.data.token,
          data.data.refreshToken,
          data.data.expiresIn,
          data.data.user
        );
        
        console.log('토큰 갱신 성공');
        
        // 대기 중인 요청들 처리
        this.processQueue();
        
        return true;
      } else {
        throw new Error(data.message || '토큰 갱신 실패');
      }
      
    } catch (error) {
      console.error('토큰 갱신 중 오류:', error);
      
      // Refresh Token도 만료된 경우 로그아웃
      this.logout();
      
      return false;
    } finally {
      this.isRefreshing = false;
    }
  }
  
  /**
   * 대기 중인 요청들 처리
   */
  processQueue() {
    this.failedQueue.forEach((resolve) => {
      resolve();
    });
    this.failedQueue = [];
  }
  
  /**
   * 원래 요청 재시도
   */
  async retryRequest(url, options) {
    const validToken = this.tokenManager.getValidAccessToken();
    if (validToken) {
      options.headers = {
        ...options.headers,
        'Authorization': `Bearer ${validToken}`
      };
    }
    
    return fetch(url, options);
  }
  
  /**
   * API 요청 실행
   */
  async request(url, options = {}) {
    try {
      // 토큰 갱신이 필요하면 먼저 처리
      if (this.tokenManager.needsRefresh()) {
        await this.refreshTokensIfNeeded();
      }
      
      // 유효한 토큰이 있으면 헤더에 추가
      const validToken = this.tokenManager.getValidAccessToken();
      if (validToken) {
        options.headers = {
          ...options.headers,
          'Authorization': `Bearer ${validToken}`
        };
      }
      
      const response = await fetch(`${this.baseURL}${url}`, options);
      
      // 새 토큰이 헤더에 있으면 저장
      const newAccessToken = response.headers.get('x-new-access-token');
      const newRefreshToken = response.headers.get('x-new-refresh-token');
      
      if (newAccessToken && newRefreshToken) {
        console.log('새 토큰을 받았습니다. 저장 중...');
        this.tokenManager.setTokens(newAccessToken, newRefreshToken, 3600);
      }
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      return await response.json();
      
    } catch (error) {
      console.error('API 요청 오류:', error);
      throw error;
    }
  }
  
  /**
   * GET 요청
   */
  async get(url, options = {}) {
    return this.request(url, { ...options, method: 'GET' });
  }
  
  /**
   * POST 요청
   */
  async post(url, data, options = {}) {
    return this.request(url, {
      ...options,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      body: JSON.stringify(data)
    });
  }
  
  /**
   * PUT 요청
   */
  async put(url, data, options = {}) {
    return this.request(url, {
      ...options,
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      body: JSON.stringify(data)
    });
  }
  
  /**
   * DELETE 요청
   */
  async delete(url, options = {}) {
    return this.request(url, { ...options, method: 'DELETE' });
  }
  
  /**
   * 로그인
   */
  async login(email, password) {
    try {
      const response = await this.post('/api/auth', {
        action: 'login',
        email,
        password
      });
      
      if (response.success) {
        // 토큰 저장
        this.tokenManager.setTokens(
          response.data.token,
          response.data.refreshToken,
          response.data.expiresIn,
          response.data.user
        );
        
        console.log('로그인 성공');
        return response;
      } else {
        throw new Error(response.message);
      }
      
    } catch (error) {
      console.error('로그인 오류:', error);
      throw error;
    }
  }
  
  /**
   * 로그아웃
   */
  logout() {
    this.tokenManager.clearTokens();
    console.log('로그아웃 완료');
    
    // 로그인 페이지로 리다이렉트
    if (typeof window !== 'undefined') {
      window.location.href = '/login';
    }
  }
  
  /**
   * 토큰 상태 확인
   */
  getTokenStatus() {
    return this.tokenManager.getTokenStatus();
  }
  
  /**
   * 사용자 정보 가져오기
   */
  getUser() {
    return this.tokenManager.getUser();
  }
  
  /**
   * 인증 상태 확인
   */
  isAuthenticated() {
    const status = this.tokenManager.getTokenStatus();
    return status.hasValidAccessToken;
  }
}

// Node.js 환경에서는 module.exports, 브라우저 환경에서는 window에 할당
if (typeof module !== 'undefined' && module.exports) {
  module.exports = ApiClient;
} else if (typeof window !== 'undefined') {
  window.ApiClient = ApiClient;
}

export default ApiClient;
