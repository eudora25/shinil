<template>
  <div class="api-test-container">
    <h1>🔧 API 테스트 페이지</h1>
    <p class="description">Supabase Edge Functions를 사용한 API 테스트</p>

    <!-- 로그인 섹션 -->
    <div class="login-section">
      <h2>🔐 로그인</h2>
      <div class="login-info">
        <p><strong>테스트 계정:</strong> admin@shinil.com / admin123</p>
        <p><strong>현재 상태:</strong> 
          <span v-if="user" class="status-success">✅ 로그인됨 ({{ user.role }})</span>
          <span v-else class="status-error">❌ 로그아웃됨</span>
        </p>
      </div>
      <button @click="login" :disabled="loading || !!user" class="btn btn-primary">
        {{ loading ? '로그인 중...' : '로그인' }}
      </button>
    </div>

    <!-- API 테스트 섹션 -->
    <div class="api-section" v-if="user">
      <h2>📊 데이터 조회 API</h2>
      
      <div class="api-buttons">
        <button @click="fetchCompanies" :disabled="loading" class="btn btn-success">
          🏢 회사 데이터 ({{ companies.length }}개)
        </button>
        <button @click="fetchProducts" :disabled="loading" class="btn btn-info">
          💊 제품 데이터 ({{ products.length }}개)
        </button>
        <button @click="fetchClients" :disabled="loading" class="btn btn-warning">
          🏥 고객 데이터 ({{ clients.length }}개)
        </button>
      </div>

      <!-- 로딩 표시 -->
      <div v-if="loading" class="loading">
        <p>데이터를 불러오는 중...</p>
      </div>

      <!-- 에러 표시 -->
      <div v-if="error" class="error">
        <p><strong>오류:</strong> {{ error }}</p>
      </div>

      <!-- 회사 데이터 표시 -->
      <div v-if="companies.length > 0" class="data-section">
        <h3>🏢 회사 데이터 ({{ companies.length }}개)</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>회사명</th>
                <th>대표자</th>
                <th>이메일</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="company in companies.slice(0, 10)" :key="company.id">
                <td>{{ company.id }}</td>
                <td>{{ company.company_name }}</td>
                <td>{{ company.representative_name }}</td>
                <td>{{ company.email }}</td>
                <td>
                  <span :class="company.approval_status === 'approved' ? 'status-approved' : 'status-pending'">
                    {{ company.approval_status }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 제품 데이터 표시 -->
      <div v-if="products.length > 0" class="data-section">
        <h3>💊 제품 데이터 ({{ products.length }}개)</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>제품명</th>
                <th>보험코드</th>
                <th>가격</th>
                <th>회사</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="product in products.slice(0, 10)" :key="product.id">
                <td>{{ product.id }}</td>
                <td>{{ product.product_name }}</td>
                <td>{{ product.insurance_code }}</td>
                <td>{{ product.price?.toLocaleString() }}원</td>
                <td>{{ product.company_name }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 고객 데이터 표시 -->
      <div v-if="clients.length > 0" class="data-section">
        <h3>🏥 고객 데이터 ({{ clients.length }}개)</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>고객명</th>
                <th>병원번호</th>
                <th>연락처</th>
                <th>주소</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="client in clients.slice(0, 10)" :key="client.id">
                <td>{{ client.id }}</td>
                <td>{{ client.client_name }}</td>
                <td>{{ client.hospital_number }}</td>
                <td>{{ client.contact_person_phone }}</td>
                <td>{{ client.address }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 로그아웃 상태 안내 -->
    <div v-else class="logout-notice">
      <p>API 테스트를 위해 먼저 로그인해주세요.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const companies = ref([])
const products = ref([])
const clients = ref([])
const loading = ref(false)
const error = ref(null)
const token = ref(null)
const user = ref(null)

// Vercel API URL
const API_BASE_URL = 'https://shinil.vercel.app/api'

// 로그인 함수
const login = async () => {
  loading.value = true
  error.value = null
  
  try {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: 'admin@shinil.com',
        password: 'admin123'
      })
    })

    const data = await response.json()
    
    if (data.success) {
      token.value = data.data.token
      user.value = data.data.user
      console.log('로그인 성공:', data)
    } else {
      error.value = data.message
      console.error('로그인 실패:', data)
    }
  } catch (err) {
    error.value = err.message
    console.error('로그인 오류:', err)
  } finally {
    loading.value = false
  }
}

// 회사 데이터 조회
const fetchCompanies = async () => {
  if (!token.value) {
    error.value = '먼저 로그인해주세요'
    return
  }

  loading.value = true
  error.value = null
  
  try {
    const response = await fetch(`${API_BASE_URL}/companies`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    })

    const data = await response.json()
    
    if (data.success) {
      companies.value = data.data
      console.log('회사 데이터 조회 성공:', data)
    } else {
      error.value = data.message
      console.error('회사 데이터 조회 실패:', data)
    }
  } catch (err) {
    error.value = err.message
    console.error('회사 데이터 조회 오류:', err)
  } finally {
    loading.value = false
  }
}

// 제품 데이터 조회
const fetchProducts = async () => {
  if (!token.value) {
    error.value = '먼저 로그인해주세요'
    return
  }

  loading.value = true
  error.value = null
  
  try {
    const response = await fetch(`${API_BASE_URL}/products`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    })

    const data = await response.json()
    
    if (data.success) {
      products.value = data.data
      console.log('제품 데이터 조회 성공:', data)
    } else {
      error.value = data.message
      console.error('제품 데이터 조회 실패:', data)
    }
  } catch (err) {
    error.value = err.message
    console.error('제품 데이터 조회 오류:', err)
  } finally {
    loading.value = false
  }
}

// 고객 데이터 조회
const fetchClients = async () => {
  if (!token.value) {
    error.value = '먼저 로그인해주세요'
    return
  }

  loading.value = true
  error.value = null
  
  try {
    const response = await fetch(`${API_BASE_URL}/clients`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    })

    const data = await response.json()
    
    if (data.success) {
      clients.value = data.data
      console.log('고객 데이터 조회 성공:', data)
    } else {
      error.value = data.message
      console.error('고객 데이터 조회 실패:', data)
    }
  } catch (err) {
    error.value = err.message
    console.error('고객 데이터 조회 오류:', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  console.log('[ApiTestView] Component mounted successfully!')
})
</script>

<style scoped>
.api-test-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  color: #2c3e50;
  text-align: center;
  margin-bottom: 10px;
}

.description {
  text-align: center;
  color: #7f8c8d;
  margin-bottom: 30px;
}

.login-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 30px;
}

.login-info {
  margin-bottom: 15px;
}

.login-info p {
  margin: 5px 0;
}

.api-section {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.api-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.3s ease;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-primary {
  background: #007bff;
  color: white;
}

.btn-success {
  background: #28a745;
  color: white;
}

.btn-info {
  background: #17a2b8;
  color: white;
}

.btn-warning {
  background: #ffc107;
  color: #212529;
}

.loading {
  text-align: center;
  padding: 20px;
  color: #6c757d;
}

.error {
  background: #f8d7da;
  color: #721c24;
  padding: 15px;
  border-radius: 5px;
  margin: 20px 0;
}

.data-section {
  margin-top: 30px;
}

.data-section h3 {
  color: #2c3e50;
  margin-bottom: 15px;
}

.data-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background: #f8f9fa;
  font-weight: bold;
  color: #495057;
}

.status-success {
  color: #28a745;
  font-weight: bold;
}

.status-error {
  color: #dc3545;
  font-weight: bold;
}

.status-approved {
  color: #28a745;
  font-weight: bold;
}

.status-pending {
  color: #ffc107;
  font-weight: bold;
}

.logout-notice {
  text-align: center;
  padding: 40px;
  color: #6c757d;
  background: #f8f9fa;
  border-radius: 8px;
}
</style> 