<template>
  <div class="home">
    <h1>신일 프로젝트 API 서버</h1>
    <p>API 엔드포인트를 사용하여 데이터에 접근하세요.</p>
    
    <div class="api-links">
      <h3>사용 가능한 API:</h3>
      <ul>
        <li><strong>제품 목록:</strong> <code>/api/products</code></li>
        <li><strong>병의원 목록:</strong> <code>/api/clients</code></li>
        <li><strong>공지사항:</strong> <code>/api/notices</code></li>
        <li><strong>헬스체크:</strong> <code>/api/health</code></li>
      </ul>
    </div>
    
    <div class="swagger-link">
      <h3>API 문서:</h3>
      <p><a href="/swagger-ui.html" target="_blank">Swagger UI 문서 보기</a></p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeComponent'
}
</script>

<style scoped>
.home {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}

h1 {
  color: #2c3e50;
  margin-bottom: 1rem;
}

.api-links {
  margin: 2rem 0;
  text-align: left;
}

.api-links ul {
  list-style: none;
  padding: 0;
}

.api-links li {
  padding: 0.5rem 0;
  border-bottom: 1px solid #eee;
}

code {
  background: #f8f9fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  font-family: monospace;
}

.swagger-link {
  margin-top: 2rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 5px;
}

.swagger-link a {
  color: #007bff;
  text-decoration: none;
}

.swagger-link a:hover {
  text-decoration: underline;
}
</style>
