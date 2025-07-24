import * as Sentry from '@sentry/vue'
import { browserTracingIntegration } from '@sentry/vue'

export function initSentry(app, router) {
  // 개발 환경에서는 Sentry 비활성화
  if (import.meta.env.DEV) {
    console.log('Sentry is disabled in development mode')
    return
  }

  try {
    Sentry.init({
      app,
      dsn: import.meta.env.VITE_SENTRY_DSN || 'https://your-sentry-dsn@your-project.ingest.sentry.io/your-project-id',
      integrations: [
        browserTracingIntegration({
          router,
          tracingOrigins: ['localhost', 'shinil.vercel.app', /^\//],
        }),
      ],
    // 성능 모니터링 설정
    tracesSampleRate: 0.1, // 10%의 요청만 추적
    // 에러 샘플링 설정
    replaysSessionSampleRate: 0.1,
    replaysOnErrorSampleRate: 1.0,
    
    // 환경 설정
    environment: import.meta.env.VITE_ENVIRONMENT || 'production',
    
    // 릴리즈 정보
    release: import.meta.env.VITE_APP_VERSION || '1.0.0',
    
    // 에러 필터링
    beforeSend(event) {
      // 개발 환경 에러 무시
      if (import.meta.env.DEV) {
        return null
      }
      
      // 특정 에러 타입 필터링
      if (event.exception) {
        const exception = event.exception.values[0]
        // 네트워크 에러나 일반적인 브라우저 에러는 무시
        if (exception.type === 'NetworkError' || 
            exception.type === 'TypeError' && exception.value.includes('fetch')) {
          return null
        }
      }
      
      return event
    },
    
    // 사용자 정보 설정
    beforeBreadcrumb(breadcrumb) {
      // 민감한 정보 제거
      if (breadcrumb.category === 'navigation') {
        const url = new URL(breadcrumb.data?.url || '')
        // 쿼리 파라미터에서 민감한 정보 제거
        url.searchParams.delete('token')
        url.searchParams.delete('password')
        breadcrumb.data.url = url.toString()
      }
      return breadcrumb
    }
  })
  } catch (error) {
    console.error('Sentry initialization failed:', error)
  }
}

// 커스텀 에러 핸들러
export function captureError(error, context = {}) {
  if (import.meta.env.DEV) {
    console.error('Error captured in development:', error, context)
    return
  }
  
  Sentry.captureException(error, {
    extra: context
  })
}

// 커스텀 메시지 캡처
export function captureMessage(message, level = 'info', context = {}) {
  if (import.meta.env.DEV) {
    console.log(`Message captured in development: ${message}`, context)
    return
  }
  
  Sentry.captureMessage(message, {
    level,
    extra: context
  })
}

// 사용자 정보 설정
export function setUser(user) {
  if (user) {
    Sentry.setUser({
      id: user.id,
      email: user.email,
      user_type: user.user_type,
      company_name: user.company_name
    })
  } else {
    Sentry.setUser(null)
  }
}

// 태그 설정
export function setTag(key, value) {
  Sentry.setTag(key, value)
}

// 컨텍스트 설정
export function setContext(name, context) {
  Sentry.setContext(name, context)
} 