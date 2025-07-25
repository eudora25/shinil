<template>
  <div class="api-container">
    <div class="api-response">
      <h2>Clients API</h2>
      <div class="api-info">
        <p><strong>Endpoint:</strong> /api/clients</p>
        <p><strong>Method:</strong> GET</p>
        <p><strong>Description:</strong> 병의원 목록을 조회합니다.</p>
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

      <div class="actual-data" v-if="clients.length > 0">
        <h3>Current Data</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>병원명</th>
                <th>대표자</th>
                <th>주소</th>
                <th>연락처</th>
                <th>담당업체</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="client in clients" :key="client.id">
                <td>{{ client.id }}</td>
                <td>{{ client.hospital_name }}</td>
                <td>{{ client.representative_name }}</td>
                <td>{{ client.address }}</td>
                <td>{{ client.phone }}</td>
                <td>{{ client.assigned_company_name || '-' }}</td>
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

const clients = ref([])
const error = ref('')
const queryParams = ref([
  { name: 'limit', description: '조회할 병의원 수 (기본값: 100)' },
  { name: 'offset', description: '건너뛸 병의원 수 (페이지네이션용)' },
  { name: 'search', description: '병원명 검색' },
  { name: 'company_id', description: '특정 업체가 담당하는 병의원만 조회' }
])

const responseExample = ref(`{
  "success": true,
  "data": [
    {
      "id": 1,
      "hospital_name": "병원명",
      "representative_name": "대표자명",
      "address": "주소",
      "phone": "연락처",
      "assigned_company_name": "담당업체명",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0
}`)

onMounted(async () => {
  try {
    // 병의원 정보와 담당업체 정보를 함께 조회
    const { data, error: fetchError } = await supabase
      .from('clients')
      .select(`
        *,
        companies!clients_assigned_company_id_fkey (
          company_name
        )
      `)
      .order('hospital_name')
      .limit(100)

    if (fetchError) {
      error.value = fetchError.message
    } else {
      // 데이터 가공
      clients.value = (data || []).map(client => ({
        ...client,
        assigned_company_name: client.companies?.company_name || null
      }))
    }
  } catch (err) {
    error.value = '데이터를 불러오는 중 오류가 발생했습니다.'
    console.error('API Clients Error:', err)
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