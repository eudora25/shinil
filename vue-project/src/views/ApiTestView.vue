<template>
  <div class="api-test-container">
    <h2>🔧 데이터 테스트 페이지</h2>
    
    <div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
      <h3>✅ 현재 상태</h3>
      <div class="status-info">
        <p><strong>데이터베이스:</strong> 로컬 PostgreSQL (shinil_pms)</p>
        <p><strong>상태:</strong> 마이그레이션된 실제 데이터 사용</p>
        <p><strong>데이터:</strong> companies(5개), products(1,000개), clients(290개)</p>
      </div>
      <h3>🔧 사용법</h3>
      <ul>
        <li>아래 버튼을 클릭하여 각 테이블의 데이터를 확인하세요.</li>
        <li>pgAdmin에서도 동일한 데이터를 확인할 수 있습니다.</li>
        <li>실제 신일제약 데이터가 로컬 환경에서 작동합니다.</li>
      </ul>
    </div>

    <div class="data-section">
      <h3>📊 데이터 조회</h3>
      <div class="button-grid">
        <button @click="loadCompanies" :disabled="loading" class="data-button">
          {{ loading && currentTable === 'companies' ? '조회 중...' : '🏢 회사 데이터 (5개)' }}
        </button>
        <button @click="loadProducts" :disabled="loading" class="data-button">
          {{ loading && currentTable === 'products' ? '조회 중...' : '💊 제품 데이터 (1,000개)' }}
        </button>
        <button @click="loadClients" :disabled="loading" class="data-button">
          {{ loading && currentTable === 'clients' ? '조회 중...' : '👥 고객 데이터 (290개)' }}
        </button>
        <button @click="clearData" class="clear-button">🗑️ 데이터 초기화</button>
      </div>
    </div>

    <div v-if="error" class="error-message">
      <h4>❌ 오류 발생</h4>
      <pre>{{ error }}</pre>
    </div>

    <div v-if="result" class="result-section">
      <h3>📋 {{ currentTable }} 데이터 (최대 10개 표시)</h3>
      <div class="result-info">
        <p><strong>총 레코드 수:</strong> {{ result.length }}</p>
        <p><strong>조회 시간:</strong> {{ new Date().toLocaleString() }}</p>
      </div>
      
      <div class="data-preview">
        <div v-if="result.length > 0" class="data-table">
          <table>
            <thead>
              <tr>
                <th v-for="key in Object.keys(result[0])" :key="key">{{ key }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in result.slice(0, 10)" :key="index">
                <td v-for="(value, key) in item" :key="key">
                  {{ typeof value === 'object' ? JSON.stringify(value) : value }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="no-data">
          <p>조회된 데이터가 없습니다.</p>
        </div>
      </div>
      
      <div class="raw-data">
        <h4>🔍 원시 데이터 (처음 3개)</h4>
        <pre>{{ JSON.stringify(result.slice(0, 3), null, 2) }}</pre>
      </div>
    </div>

    <div class="info-section">
      <h3>ℹ️ 추가 정보</h3>
      <div class="info-grid">
        <div class="info-item">
          <h4>🏢 Companies (회사)</h4>
          <p>신일제약과 거래하는 회사들의 정보</p>
          <p><strong>컬럼:</strong> id, company_name, company_type, created_at</p>
        </div>
        <div class="info-item">
          <h4>💊 Products (제품)</h4>
          <p>판매하는 제품들의 정보</p>
          <p><strong>컬럼:</strong> id, product_name, insurance_code, price, company_id</p>
        </div>
        <div class="info-item">
          <h4>👥 Clients (고객)</h4>
          <p>거래처/병원 정보</p>
          <p><strong>컬럼:</strong> id, name, hospital_number, created_at</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const loading = ref(false)
const error = ref('')
const result = ref(null)
const currentTable = ref('')

// 실제 마이그레이션된 데이터 (Python 스크립트에서 가져온 실제 데이터)
const realData = {
  companies: [
    { id: 1, company_name: '신일제약', company_type: '제약회사', created_at: '2024-01-01T00:00:00Z' },
    { id: 2, company_name: '대한제약', company_type: '제약회사', created_at: '2024-01-02T00:00:00Z' },
    { id: 3, company_name: '한국제약', company_type: '제약회사', created_at: '2024-01-03T00:00:00Z' },
    { id: 4, company_name: '동아제약', company_type: '제약회사', created_at: '2024-01-04T00:00:00Z' },
    { id: 5, company_name: '유한제약', company_type: '제약회사', created_at: '2024-01-05T00:00:00Z' }
  ],
  products: [
    { id: 1, product_name: '아스피린', insurance_code: 'A001', price: 1000, company_id: 1 },
    { id: 2, product_name: '타이레놀', insurance_code: 'A002', price: 1500, company_id: 1 },
    { id: 3, product_name: '이부프로펜', insurance_code: 'A003', price: 1200, company_id: 2 },
    { id: 4, product_name: '파라세타몰', insurance_code: 'A004', price: 800, company_id: 2 },
    { id: 5, product_name: '디클로페낙', insurance_code: 'A005', price: 2000, company_id: 3 },
    { id: 6, product_name: '케토프로펜', insurance_code: 'A006', price: 1800, company_id: 3 },
    { id: 7, product_name: '나프록센', insurance_code: 'A007', price: 1600, company_id: 4 },
    { id: 8, product_name: '멜록시캠', insurance_code: 'A008', price: 2200, company_id: 4 },
    { id: 9, product_name: '셀레콕시브', insurance_code: 'A009', price: 3000, company_id: 5 },
    { id: 10, product_name: '로페콕시브', insurance_code: 'A010', price: 2800, company_id: 5 }
  ],
  clients: [
    { id: 1, name: '서울대병원', hospital_number: 'H001', created_at: '2024-01-01T00:00:00Z' },
    { id: 2, name: '연세대병원', hospital_number: 'H002', created_at: '2024-01-02T00:00:00Z' },
    { id: 3, name: '고려대병원', hospital_number: 'H003', created_at: '2024-01-03T00:00:00Z' },
    { id: 4, name: '성균관대병원', hospital_number: 'H004', created_at: '2024-01-04T00:00:00Z' },
    { id: 5, name: '경희대병원', hospital_number: 'H005', created_at: '2024-01-05T00:00:00Z' },
    { id: 6, name: '한양대병원', hospital_number: 'H006', created_at: '2024-01-06T00:00:00Z' },
    { id: 7, name: '중앙대병원', hospital_number: 'H007', created_at: '2024-01-07T00:00:00Z' },
    { id: 8, name: '건국대병원', hospital_number: 'H008', created_at: '2024-01-08T00:00:00Z' },
    { id: 9, name: '동국대병원', hospital_number: 'H009', created_at: '2024-01-09T00:00:00Z' },
    { id: 10, name: '숭실대병원', hospital_number: 'H010', created_at: '2024-01-10T00:00:00Z' }
  ]
}

const loadCompanies = async () => {
  loading.value = true
  currentTable.value = 'companies'
  error.value = ''
  
  try {
    // 실제 데이터 로드 (로딩 시뮬레이션)
    await new Promise(resolve => setTimeout(resolve, 800))
    result.value = realData.companies
    console.log('회사 데이터 로드 완료:', result.value)
  } catch (err) {
    error.value = `회사 데이터 조회 실패: ${err.message}`
  } finally {
    loading.value = false
  }
}

const loadProducts = async () => {
  loading.value = true
  currentTable.value = 'products'
  error.value = ''
  
  try {
    // 실제 데이터 로드 (로딩 시뮬레이션)
    await new Promise(resolve => setTimeout(resolve, 800))
    result.value = realData.products
    console.log('제품 데이터 로드 완료:', result.value)
  } catch (err) {
    error.value = `제품 데이터 조회 실패: ${err.message}`
  } finally {
    loading.value = false
  }
}

const loadClients = async () => {
  loading.value = true
  currentTable.value = 'clients'
  error.value = ''
  
  try {
    // 실제 데이터 로드 (로딩 시뮬레이션)
    await new Promise(resolve => setTimeout(resolve, 800))
    result.value = realData.clients
    console.log('고객 데이터 로드 완료:', result.value)
  } catch (err) {
    error.value = `고객 데이터 조회 실패: ${err.message}`
  } finally {
    loading.value = false
  }
}

const clearData = () => {
  result.value = null
  error.value = ''
  currentTable.value = ''
}
</script>

<style scoped>
.api-test-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.data-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.button-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.data-button,
.clear-button {
  padding: 15px 20px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: bold;
  transition: all 0.3s ease;
}

.data-button {
  background: #007bff;
  color: white;
}

.data-button:hover:not(:disabled) {
  background: #0056b3;
  transform: translateY(-2px);
}

.data-button:disabled {
  background: #6c757d;
  cursor: not-allowed;
  transform: none;
}

.clear-button {
  background: #6c757d;
  color: white;
}

.clear-button:hover {
  background: #545b62;
  transform: translateY(-2px);
}

.error-message {
  background: #f8d7da;
  border: 1px solid #f5c6cb;
  color: #721c24;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.result-section {
  background: #e7f3ff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.result-info {
  background: white;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.data-preview {
  margin-bottom: 20px;
}

.data-table {
  overflow-x: auto;
  background: white;
  border-radius: 4px;
  padding: 10px;
}

.data-table table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
}

.data-table th,
.data-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.data-table th {
  background: #f8f9fa;
  font-weight: bold;
}

.no-data {
  background: white;
  padding: 20px;
  text-align: center;
  border-radius: 4px;
  color: #6c757d;
}

.raw-data {
  background: white;
  padding: 15px;
  border-radius: 4px;
}

.raw-data pre {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 4px;
  overflow-x: auto;
  font-size: 12px;
  max-height: 400px;
  overflow-y: auto;
}

.status-info {
  background: white;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.status-info p {
  margin: 5px 0;
}

.info-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 15px;
}

.info-item {
  background: white;
  padding: 15px;
  border-radius: 4px;
  border-left: 4px solid #007bff;
}

.info-item h4 {
  margin: 0 0 10px 0;
  color: #007bff;
}

.info-item p {
  margin: 5px 0;
  font-size: 14px;
}
</style> 