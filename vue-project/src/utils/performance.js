import { captureMessage, setTag } from './sentry'

/**
 * 페이지 로딩 성능 측정
 */
export function measurePageLoad() {
  if (typeof window === 'undefined') return

  window.addEventListener('load', () => {
    const navigation = performance.getEntriesByType('navigation')[0]
    const paint = performance.getEntriesByType('paint')
    
    const metrics = {
      // 네트워크 성능
      dnsLookup: navigation.domainLookupEnd - navigation.domainLookupStart,
      tcpConnect: navigation.connectEnd - navigation.connectStart,
      serverResponse: navigation.responseEnd - navigation.requestStart,
      domLoad: navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart,
      windowLoad: navigation.loadEventEnd - navigation.loadEventStart,
      
      // 페인트 성능
      firstPaint: paint.find(entry => entry.name === 'first-paint')?.startTime,
      firstContentfulPaint: paint.find(entry => entry.name === 'first-contentful-paint')?.startTime,
      
      // 전체 로딩 시간
      totalLoadTime: navigation.loadEventEnd - navigation.fetchStart
    }

    // 성능 메트릭을 Sentry에 전송
    captureMessage('Page Load Performance', 'info', metrics)
    
    // 성능 태그 설정
    setTag('load_time', Math.round(metrics.totalLoadTime))
    setTag('fcp', Math.round(metrics.firstContentfulPaint || 0))
  })
}

/**
 * API 호출 성능 측정
 */
export function measureApiCall(apiName, startTime) {
  const endTime = performance.now()
  const duration = endTime - startTime
  
  const metrics = {
    apiName,
    duration: Math.round(duration),
    timestamp: new Date().toISOString()
  }
  
  // 느린 API 호출 경고 (1초 이상)
  if (duration > 1000) {
    captureMessage(`Slow API Call: ${apiName}`, 'warning', metrics)
  }
  
  // 성능 태그 설정
  setTag(`api_${apiName}`, Math.round(duration))
  
  return duration
}

/**
 * 컴포넌트 렌더링 성능 측정
 */
export function measureComponentRender(componentName, startTime) {
  const endTime = performance.now()
  const duration = endTime - startTime
  
  const metrics = {
    componentName,
    duration: Math.round(duration),
    timestamp: new Date().toISOString()
  }
  
  // 느린 렌더링 경고 (100ms 이상)
  if (duration > 100) {
    captureMessage(`Slow Component Render: ${componentName}`, 'warning', metrics)
  }
  
  return duration
}

/**
 * 메모리 사용량 모니터링
 */
export function monitorMemoryUsage() {
  if (typeof window === 'undefined' || !performance.memory) return
  
  const memory = performance.memory
  const metrics = {
    usedJSHeapSize: Math.round(memory.usedJSHeapSize / 1024 / 1024), // MB
    totalJSHeapSize: Math.round(memory.totalJSHeapSize / 1024 / 1024), // MB
    jsHeapSizeLimit: Math.round(memory.jsHeapSizeLimit / 1024 / 1024), // MB
    usagePercentage: Math.round((memory.usedJSHeapSize / memory.jsHeapSizeLimit) * 100)
  }
  
  // 메모리 사용량이 80% 이상이면 경고
  if (metrics.usagePercentage > 80) {
    captureMessage('High Memory Usage', 'warning', metrics)
  }
  
  // 메모리 태그 설정
  setTag('memory_usage_mb', metrics.usedJSHeapSize)
  setTag('memory_usage_percent', metrics.usagePercentage)
  
  return metrics
}

/**
 * 네트워크 상태 모니터링
 */
export function monitorNetworkStatus() {
  if (typeof navigator === 'undefined' || !navigator.connection) return
  
  const connection = navigator.connection
  const metrics = {
    effectiveType: connection.effectiveType,
    downlink: connection.downlink,
    rtt: connection.rtt,
    saveData: connection.saveData
  }
  
  // 느린 네트워크 경고
  if (connection.effectiveType === 'slow-2g' || connection.effectiveType === '2g') {
    captureMessage('Slow Network Detected', 'warning', metrics)
  }
  
  // 네트워크 태그 설정
  setTag('network_type', connection.effectiveType)
  setTag('network_downlink', connection.downlink)
  setTag('network_rtt', connection.rtt)
  
  return metrics
}

/**
 * 사용자 인터랙션 성능 측정
 */
export function measureUserInteraction(action, startTime) {
  const endTime = performance.now()
  const duration = endTime - startTime
  
  const metrics = {
    action,
    duration: Math.round(duration),
    timestamp: new Date().toISOString()
  }
  
  // 느린 인터랙션 경고 (300ms 이상)
  if (duration > 300) {
    captureMessage(`Slow User Interaction: ${action}`, 'warning', metrics)
  }
  
  return duration
}

/**
 * 성능 모니터링 시작
 */
export function startPerformanceMonitoring() {
  // 페이지 로딩 성능 측정
  measurePageLoad()
  
  // 주기적 메모리 사용량 모니터링
  setInterval(monitorMemoryUsage, 30000) // 30초마다
  
  // 네트워크 상태 모니터링
  if (navigator.connection) {
    navigator.connection.addEventListener('change', monitorNetworkStatus)
  }
  
  // 전역 에러 핸들러
  window.addEventListener('error', (event) => {
    captureMessage('JavaScript Error', 'error', {
      message: event.message,
      filename: event.filename,
      lineno: event.lineno,
      colno: event.colno,
      error: event.error?.stack
    })
  })
  
  // Promise 에러 핸들러
  window.addEventListener('unhandledrejection', (event) => {
    captureMessage('Unhandled Promise Rejection', 'error', {
      reason: event.reason,
      promise: event.promise
    })
  })
} 