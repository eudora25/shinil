<template>
  <div class="api-container">
    <div class="api-response">
      <h2>Notices API</h2>
      <div class="api-info">
        <p><strong>Endpoint:</strong> /api/notices</p>
        <p><strong>Method:</strong> GET</p>
        <p><strong>Description:</strong> 공지사항 목록을 조회합니다.</p>
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

      <div class="actual-data" v-if="notices.length > 0">
        <h3>Current Data</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="notice in notices" :key="notice.id">
                <td>{{ notice.id }}</td>
                <td>{{ notice.title }}</td>
                <td>{{ notice.created_by_name || '-' }}</td>
                <td>{{ formatDate(notice.created_at) }}</td>
                <td>{{ notice.view_count || 0 }}</td>
                <td>
                  <span :class="getStatusClass(notice.status)">
                    {{ getStatusText(notice.status) }}
                  </span>
                </td>
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

const notices = ref([])
const error = ref('')
const queryParams = ref([
  { name: 'limit', description: '조회할 공지사항 수 (기본값: 100)' },
  { name: 'offset', description: '건너뛸 공지사항 수 (페이지네이션용)' },
  { name: 'search', description: '제목 검색' },
  { name: 'status', description: '상태 필터 (active, inactive)' }
])

const responseExample = ref(`{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "공지사항 제목",
      "content": "공지사항 내용",
      "created_by_name": "작성자명",
      "created_at": "2025-01-01T00:00:00Z",
      "view_count": 0,
      "status": "active"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0
}`)

const formatDate = (dateString) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleDateString('ko-KR')
}

const getStatusText = (status) => {
  switch (status) {
    case 'active': return '활성'
    case 'inactive': return '비활성'
    default: return '알 수 없음'
  }
}

const getStatusClass = (status) => {
  switch (status) {
    case 'active': return 'status-active'
    case 'inactive': return 'status-inactive'
    default: return 'status-unknown'
  }
}

onMounted(async () => {
  try {
    // 공지사항 정보와 작성자 정보를 함께 조회
    const { data, error: fetchError } = await supabase
      .from('notices')
      .select(`
        *,
        companies!notices_created_by_fkey (
          company_name
        )
      `)
      .order('created_at', { ascending: false })
      .limit(100)

    if (fetchError) {
      error.value = fetchError.message
    } else {
      // 데이터 가공
      notices.value = (data || []).map(notice => ({
        ...notice,
        created_by_name: notice.companies?.company_name || '관리자'
      }))
    }
  } catch (err) {
    error.value = '데이터를 불러오는 중 오류가 발생했습니다.'
    console.error('API Notices Error:', err)
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

.status-active {
  color: #28a745;
  font-weight: bold;
}

.status-inactive {
  color: #dc3545;
  font-weight: bold;
}

.status-unknown {
  color: #6c757d;
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