<template>
  <div class="api-container">
    <div class="api-response">
      <h2>API Health Check</h2>
      <div class="status-info">
        <p><strong>Status:</strong> <span class="status-ok">OK</span></p>
        <p><strong>Timestamp:</strong> {{ timestamp }}</p>
        <p><strong>Version:</strong> 1.0.0</p>
        <p><strong>Environment:</strong> {{ environment }}</p>
      </div>
      <div class="json-response">
        <h3>JSON Response:</h3>
        <pre>{{ jsonResponse }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const timestamp = ref('')
const environment = ref('production')
const jsonResponse = ref('')

onMounted(() => {
  timestamp.value = new Date().toISOString()
  environment.value = import.meta.env.MODE || 'development'
  
  // JSON 응답 생성
  const response = {
    test: "001",
    status: "OK",
    timestamp: timestamp.value,
    version: "1.0.0",
    environment: environment.value
  }
  
  jsonResponse.value = JSON.stringify(response, null, 2)
  
  // API 엔드포인트로 직접 접근한 경우 JSON 응답 반환
  if (typeof window !== 'undefined' && window.location.pathname === '/api/health') {
    // Content-Type을 JSON으로 설정
    const meta = document.createElement('meta')
    meta.setAttribute('http-equiv', 'Content-Type')
    meta.setAttribute('content', 'application/json')
    document.head.appendChild(meta)
    
    // 페이지 내용을 JSON으로 교체
    document.body.innerHTML = JSON.stringify(response)
    document.title = 'API Health'
  }
})
</script>

<style scoped>
.api-container {
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
  font-family: 'Courier New', monospace;
}

.api-response {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 2rem;
}

.status-info {
  margin-top: 1rem;
}

.status-info p {
  margin: 0.5rem 0;
  font-size: 1rem;
}

.status-ok {
  color: #28a745;
  font-weight: bold;
}

.json-response {
  margin-top: 2rem;
  padding: 1rem;
  background: #f1f3f4;
  border-radius: 4px;
}

.json-response pre {
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
}

h2, h3 {
  color: #333;
  margin-bottom: 1rem;
}
</style> 