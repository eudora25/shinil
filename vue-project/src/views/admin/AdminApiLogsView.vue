<template>
  <div class="admin-api-logs">
    <div class="header">
      <h1>API 로그 관리</h1>
      <p>API 호출 로그를 확인하고 관리할 수 있습니다.</p>
    </div>

    <!-- 필터 섹션 -->
    <div class="filters">
      <div class="filter-row">
        <div class="filter-group">
          <label>엔드포인트:</label>
          <input 
            v-model="filters.endpoint" 
            placeholder="엔드포인트 검색"
            @input="applyFilters"
          />
        </div>
        <div class="filter-group">
          <label>사용자 이메일:</label>
          <input 
            v-model="filters.userEmail" 
            placeholder="사용자 이메일 검색"
            @input="applyFilters"
          />
        </div>
        <div class="filter-group">
          <label>HTTP 메서드:</label>
          <select v-model="filters.method" @change="applyFilters">
            <option value="">전체</option>
            <option value="GET">GET</option>
            <option value="POST">POST</option>
            <option value="PUT">PUT</option>
            <option value="DELETE">DELETE</option>
          </select>
        </div>
        <div class="filter-group">
          <label>상태 코드:</label>
          <select v-model="filters.statusCode" @change="applyFilters">
            <option value="">전체</option>
            <option value="200">200 (성공)</option>
            <option value="400">400 (잘못된 요청)</option>
            <option value="401">401 (인증 실패)</option>
            <option value="403">403 (접근 거부)</option>
            <option value="500">500 (서버 오류)</option>
          </select>
        </div>
      </div>
      <div class="filter-row">
        <div class="filter-group">
          <label>날짜 범위:</label>
          <input 
            type="date" 
            v-model="filters.startDate" 
            @change="applyFilters"
          />
          <span>~</span>
          <input 
            type="date" 
            v-model="filters.endDate" 
            @change="applyFilters"
          />
        </div>
        <div class="filter-group">
          <button @click="clearFilters" class="clear-btn">필터 초기화</button>
          <button @click="refreshLogs" class="refresh-btn">새로고침</button>
        </div>
      </div>
    </div>

    <!-- 통계 섹션 -->
    <div class="stats" v-if="stats">
      <div class="stat-card">
        <h3>총 API 호출</h3>
        <p>{{ stats.totalCalls }}</p>
      </div>
      <div class="stat-card">
        <h3>성공률</h3>
        <p>{{ stats.successRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>평균 응답 시간</h3>
        <p>{{ stats.avgResponseTime }}ms</p>
      </div>
      <div class="stat-card">
        <h3>오늘 호출 수</h3>
        <p>{{ stats.todayCalls }}</p>
      </div>
    </div>

    <!-- 로그 테이블 -->
    <div class="logs-table">
      <table>
        <thead>
          <tr>
            <th>시간</th>
            <th>엔드포인트</th>
            <th>메서드</th>
            <th>사용자</th>
            <th>IP 주소</th>
            <th>상태 코드</th>
            <th>응답 시간</th>
            <th>상세보기</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="log in logs" :key="log.id" :class="getStatusClass(log.response_status)">
            <td>{{ formatDate(log.created_at) }}</td>
            <td>{{ log.endpoint }}</td>
            <td>
              <span :class="`method-badge method-${log.method.toLowerCase()}`">
                {{ log.method }}
              </span>
            </td>
            <td>{{ log.user_email || '익명' }}</td>
            <td>{{ log.request_ip }}</td>
            <td>
              <span :class="`status-badge status-${log.response_status}`">
                {{ log.response_status }}
              </span>
            </td>
            <td>{{ log.execution_time_ms }}ms</td>
            <td>
              <button @click="showLogDetail(log)" class="detail-btn">
                상세보기
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination" v-if="totalPages > 1">
      <button 
        @click="changePage(currentPage - 1)" 
        :disabled="currentPage <= 1"
        class="page-btn"
      >
        이전
      </button>
      <span class="page-info">
        {{ currentPage }} / {{ totalPages }}
      </span>
      <button 
        @click="changePage(currentPage + 1)" 
        :disabled="currentPage >= totalPages"
        class="page-btn"
      >
        다음
      </button>
    </div>

    <!-- 로그 상세 모달 -->
    <div v-if="selectedLog" class="modal-overlay" @click="closeLogDetail">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>API 로그 상세</h2>
          <button @click="closeLogDetail" class="close-btn">&times;</button>
        </div>
        <div class="modal-body">
          <div class="log-detail">
            <div class="detail-section">
              <h3>기본 정보</h3>
              <table>
                <tr>
                  <td>ID:</td>
                  <td>{{ selectedLog.id }}</td>
                </tr>
                <tr>
                  <td>시간:</td>
                  <td>{{ formatDate(selectedLog.created_at) }}</td>
                </tr>
                <tr>
                  <td>엔드포인트:</td>
                  <td>{{ selectedLog.endpoint }}</td>
                </tr>
                <tr>
                  <td>메서드:</td>
                  <td>{{ selectedLog.method }}</td>
                </tr>
                <tr>
                  <td>사용자:</td>
                  <td>{{ selectedLog.user_email || '익명' }}</td>
                </tr>
                <tr>
                  <td>IP 주소:</td>
                  <td>{{ selectedLog.request_ip }}</td>
                </tr>
                <tr>
                  <td>상태 코드:</td>
                  <td>{{ selectedLog.response_status }}</td>
                </tr>
                <tr>
                  <td>응답 시간:</td>
                  <td>{{ selectedLog.execution_time_ms }}ms</td>
                </tr>
              </table>
            </div>
            
            <div class="detail-section">
              <h3>요청 헤더</h3>
              <pre>{{ JSON.stringify(selectedLog.request_headers, null, 2) }}</pre>
            </div>
            
            <div class="detail-section" v-if="selectedLog.request_body">
              <h3>요청 본문</h3>
              <pre>{{ JSON.stringify(selectedLog.request_body, null, 2) }}</pre>
            </div>
            
            <div class="detail-section">
              <h3>응답 본문</h3>
              <pre>{{ JSON.stringify(selectedLog.response_body, null, 2) }}</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/supabase'

// 반응형 데이터
const logs = ref([])
const stats = ref(null)
const selectedLog = ref(null)
const loading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)
const itemsPerPage = 20

// 필터
const filters = ref({
  endpoint: '',
  userEmail: '',
  method: '',
  statusCode: '',
  startDate: '',
  endDate: ''
})

// 필터 적용
const applyFilters = () => {
  currentPage.value = 1
  fetchLogs()
}

// 필터 초기화
const clearFilters = () => {
  filters.value = {
    endpoint: '',
    userEmail: '',
    method: '',
    statusCode: '',
    startDate: '',
    endDate: ''
  }
  applyFilters()
}

// 로그 가져오기
const fetchLogs = async () => {
  loading.value = true
  try {
    let query = supabase
      .from('api_logs')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    // 필터 적용
    if (filters.value.endpoint) {
      query = query.ilike('endpoint', `%${filters.value.endpoint}%`)
    }
    if (filters.value.userEmail) {
      query = query.ilike('user_email', `%${filters.value.userEmail}%`)
    }
    if (filters.value.method) {
      query = query.eq('method', filters.value.method)
    }
    if (filters.value.statusCode) {
      query = query.eq('response_status', parseInt(filters.value.statusCode))
    }
    if (filters.value.startDate) {
      query = query.gte('created_at', filters.value.startDate)
    }
    if (filters.value.endDate) {
      query = query.lte('created_at', filters.value.endDate + 'T23:59:59')
    }

    // 페이지네이션
    const from = (currentPage.value - 1) * itemsPerPage
    const to = from + itemsPerPage - 1
    query = query.range(from, to)

    const { data, error, count } = await query

    if (error) {
      console.error('Error fetching logs:', error)
      return
    }

    logs.value = data || []
    totalPages.value = Math.ceil((count || 0) / itemsPerPage)
    
    // 통계 가져오기
    fetchStats()
  } catch (error) {
    console.error('Error:', error)
  } finally {
    loading.value = false
  }
}

// 통계 가져오기
const fetchStats = async () => {
  try {
    const { data, error } = await supabase
      .rpc('get_api_logs_stats')

    if (error) {
      console.error('Error fetching stats:', error)
      return
    }

    stats.value = data
  } catch (error) {
    console.error('Error:', error)
  }
}

// 페이지 변경
const changePage = (page) => {
  currentPage.value = page
  fetchLogs()
}

// 로그 새로고침
const refreshLogs = () => {
  fetchLogs()
}

// 로그 상세보기
const showLogDetail = (log) => {
  selectedLog.value = log
}

// 로그 상세 닫기
const closeLogDetail = () => {
  selectedLog.value = null
}

// 상태별 클래스
const getStatusClass = (status) => {
  if (status >= 200 && status < 300) return 'success'
  if (status >= 400 && status < 500) return 'client-error'
  if (status >= 500) return 'server-error'
  return ''
}

// 날짜 포맷
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleString('ko-KR')
}

// 컴포넌트 마운트 시 로그 가져오기
onMounted(() => {
  fetchLogs()
})
</script>

<style scoped>
.admin-api-logs {
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
}

.header {
  margin-bottom: 30px;
}

.header h1 {
  color: #333;
  margin-bottom: 10px;
}

.header p {
  color: #666;
  margin: 0;
}

.filters {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.filter-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
}

.filter-row:last-child {
  margin-bottom: 0;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.filter-group label {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.filter-group input,
.filter-group select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.clear-btn,
.refresh-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  margin-top: 20px;
}

.clear-btn {
  background: #6c757d;
  color: white;
  margin-right: 10px;
}

.refresh-btn {
  background: #007bff;
  color: white;
}

.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  text-align: center;
}

.stat-card h3 {
  margin: 0 0 10px 0;
  color: #666;
  font-size: 14px;
}

.stat-card p {
  margin: 0;
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.logs-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background: #f8f9fa;
  font-weight: 600;
  color: #333;
}

.method-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
}

.method-get {
  background: #d4edda;
  color: #155724;
}

.method-post {
  background: #d1ecf1;
  color: #0c5460;
}

.method-put {
  background: #fff3cd;
  color: #856404;
}

.method-delete {
  background: #f8d7da;
  color: #721c24;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.status-200 {
  background: #d4edda;
  color: #155724;
}

.status-400,
.status-401,
.status-403 {
  background: #f8d7da;
  color: #721c24;
}

.status-500 {
  background: #f8d7da;
  color: #721c24;
}

.detail-btn {
  padding: 4px 8px;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.success {
  background: #f8fff8;
}

.client-error {
  background: #fff8f8;
}

.server-error {
  background: #fff0f0;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  margin-top: 20px;
}

.page-btn {
  padding: 8px 16px;
  border: 1px solid #ddd;
  background: white;
  cursor: pointer;
  border-radius: 4px;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-weight: 600;
  color: #333;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h2 {
  margin: 0;
  color: #333;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #666;
}

.modal-body {
  padding: 20px;
}

.log-detail {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-section {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 15px;
}

.detail-section h3 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
}

.detail-section table {
  width: 100%;
}

.detail-section table td {
  padding: 8px 0;
  border-bottom: none;
}

.detail-section table td:first-child {
  font-weight: 600;
  width: 120px;
  color: #666;
}

.detail-section pre {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 4px;
  overflow-x: auto;
  font-size: 12px;
  margin: 0;
}
</style> 