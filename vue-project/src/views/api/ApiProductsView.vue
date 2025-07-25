<template>
  <div class="api-container">
    <div class="api-response">
      <h2>Products API</h2>
      <div class="api-info">
        <p><strong>Endpoint:</strong> /api/products</p>
        <p><strong>Method:</strong> GET</p>
        <p><strong>Description:</strong> 승인된 제품 목록을 조회합니다.</p>
        <p><strong>Authentication:</strong> Not Required</p>
      </div>
      
      <div class="query-params" v-if="queryParams.length > 0">
        <h3>Query Parameters</h3>
        <ul>
          <li v-for="param in queryParams" :key="param.name">
            <strong>{{ param.name }}</strong>: {{ param.description }}
          </li>
        </ul>
      </div>

      <div class="response-example">
        <h3>Response Example</h3>
        <pre><code>{{ responseExample }}</code></pre>
      </div>

      <div class="actual-data" v-if="products.length > 0">
        <h3>Current Data</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>제품명</th>
                <th>제조사</th>
                <th>규격</th>
                <th>단위</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="product in products" :key="product.id">
                <td>{{ product.id }}</td>
                <td>{{ product.product_name }}</td>
                <td>{{ product.manufacturer }}</td>
                <td>{{ product.specification }}</td>
                <td>{{ product.unit }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="error-message" v-if="error">
        <h3>Error</h3>
        <p>{{ error }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/supabase'

const products = ref([])
const error = ref('')
const queryParams = ref([
  { name: 'limit', description: '조회할 제품 수 (기본값: 100)' },
  { name: 'offset', description: '건너뛸 제품 수 (페이지네이션용)' },
  { name: 'search', description: '제품명 검색' }
])

const responseExample = ref(`{
  "success": true,
  "data": [
    {
      "id": 1,
      "product_name": "제품명",
      "manufacturer": "제조사",
      "specification": "규격",
      "unit": "단위",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0
}`)

onMounted(async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('products')
      .select('*')
      .order('product_name')
      .limit(100)

    if (fetchError) {
      error.value = fetchError.message
    } else {
      products.value = data || []
    }
  } catch (err) {
    error.value = '데이터를 불러오는 중 오류가 발생했습니다.'
    console.error('API Products Error:', err)
  }
})
</script>

<style scoped>
.api-container {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  font-family: 'Courier New', monospace;
}

.api-response {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 2rem;
}

.api-info {
  margin: 1rem 0;
  padding: 1rem;
  background: #e9ecef;
  border-radius: 4px;
}

.api-info p {
  margin: 0.5rem 0;
  font-size: 0.9rem;
}

.query-params {
  margin: 1rem 0;
}

.query-params ul {
  list-style: none;
  padding-left: 0;
}

.query-params li {
  margin: 0.5rem 0;
  padding: 0.5rem;
  background: #fff;
  border-radius: 4px;
  border-left: 3px solid #007bff;
}

.response-example {
  margin: 1rem 0;
}

.response-example pre {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  padding: 1rem;
  overflow-x: auto;
  font-size: 0.8rem;
}

.actual-data {
  margin: 1rem 0;
}

.data-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
}

th, td {
  border: 1px solid #dee2e6;
  padding: 0.5rem;
  text-align: left;
  font-size: 0.8rem;
}

th {
  background: #e9ecef;
  font-weight: bold;
}

.error-message {
  margin: 1rem 0;
  padding: 1rem;
  background: #f8d7da;
  border: 1px solid #f5c6cb;
  border-radius: 4px;
  color: #721c24;
}

h2, h3 {
  color: #333;
  margin-bottom: 1rem;
}
</style> 