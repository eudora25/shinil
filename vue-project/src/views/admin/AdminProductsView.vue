<template>
  <div class="admin-products-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">제품 목록</div>
    </div>

    <div class="filter-card">
      <div class="filter-row">
        <div style="display: flex; align-items: center; gap: 8px; margin-right: 24px;">
          <label style="white-space: nowrap; font-weight: 400">기준월</label>
          <select
            v-model="selectedMonth"
            @change="filterByMonth"
            class="select_month"
          >
            <option v-for="month in availableMonths" :key="month" :value="month">
              {{ month }}
            </option>
          </select>
        </div>
        <span class="filter-item p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="제품명, 보험코드 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>

    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ filteredProducts.length }} 건
        </div>
        <div class="action-buttons-group">
          <button class="btn-excell-template" @click="downloadTemplate">엑셀 템플릿</button>
          <button class="btn-excell-upload" @click="triggerFileUpload">엑셀 등록</button>
          <input
            ref="fileInput"
            type="file"
            accept=".xlsx,.xls"
            @change="handleFileUpload"
            style="display: none"
          />
          <button class="btn-excell-download" @click="downloadExcel">엑셀 다운로드</button>
          <button class="btn-delete" @click="deleteAllProducts">모두 삭제</button>
          <button class="btn-save" @click="goCreate">개별 등록</button>
        </div>
      </div>

      <DataTable
        :value="filteredProducts"
        :loading="loading"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['base_month', 'product_name', 'insurance_code']"
        class="admin-products-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>
          <div v-if="!loading">등록된 제품이 없습니다.</div>
        </template>
        <template #loading> 제품 목록을 불러오는 중입니다... </template>
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">
            {{ slotProps.index + currentPageFirstIndex + 1 }}
          </template>
        </Column>
        <Column
          field="product_name" header="제품명" :headerStyle="{ width: columnWidths.product_name }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.product_name"
              class="p-inputtext p-component p-inputtext-sm inline-edit-input"
            />
            <a v-else href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">
              {{ slotProps.data.product_name }}
            </a>
          </template>
        </Column>
        <Column
          field="insurance_code"
          header="보험코드"
          :headerStyle="{ width: columnWidths.insurance_code }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.insurance_code"
              class="p-inputtext p-component p-inputtext-sm inline-edit-input"
            />
            <span v-else>{{ slotProps.data.insurance_code }}</span>
          </template>
        </Column>
        <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.price"
              type="number"
              class="p-inputtext p-component p-inputtext-sm text-right inline-edit-input"
            />
            <span v-else>{{ slotProps.data.price?.toLocaleString() }}</span>
          </template>
        </Column>
        <Column header="수수료율 A" :headerStyle="{ width: columnWidths.commission_rate_a }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.commission_rate_a"
              type="number"
              step="0.001"
              class="p-inputtext p-component p-inputtext-sm text-right inline-edit-input"
            />
            <span v-else>{{ slotProps.data.commission_rate_a !== undefined && slotProps.data.commission_rate_a !== null ? (slotProps.data.commission_rate_a * 100).toFixed(1) + '%' : '-' }}</span>
          </template>
        </Column>
        <Column header="수수료율 B" :headerStyle="{ width: columnWidths.commission_rate_b }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.commission_rate_b"
              type="number"
              step="0.001"
              class="p-inputtext p-component p-inputtext-sm text-right inline-edit-input"
            />
            <span v-else>{{ slotProps.data.commission_rate_b !== undefined && slotProps.data.commission_rate_b !== null ? (slotProps.data.commission_rate_b * 100).toFixed(1) + '%' : '-' }}</span>
          </template>
        </Column>
        <Column header="수수료율 C" :headerStyle="{ width: columnWidths.commission_rate_c }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.commission_rate_c"
              type="number"
              step="0.001"
              class="p-inputtext p-component p-inputtext-sm text-right inline-edit-input"
            />
            <span v-else>{{ slotProps.data.commission_rate_c !== undefined && slotProps.data.commission_rate_c !== null ? (slotProps.data.commission_rate_c * 100).toFixed(1) + '%' : '-' }}</span>
          </template>
        </Column>
        <Column
          field="standard_code"
          header="표준코드"
          :headerStyle="{ width: columnWidths.standard_code }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.standard_code"
              class="p-inputtext p-component p-inputtext-sm inline-edit-input"
            />
            <span v-else>{{ slotProps.data.standard_code }}</span>
          </template>
        </Column>
        <Column
          field="unit_packaging_desc"
          header="단위 / 포장형태"
          :headerStyle="{ width: columnWidths.unit_packaging_desc }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.unit_packaging_desc"
              class="p-inputtext p-component p-inputtext-sm inline-edit-input"
            />
            <span v-else>{{ slotProps.data.unit_packaging_desc }}</span>
          </template>
        </Column>
        <Column
          field="unit_quantity"
          header="단위수량"
          :headerStyle="{ width: columnWidths.unit_quantity }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.unit_quantity"
              type="number"
              class="p-inputtext p-component p-inputtext-sm text-right inline-edit-input"
            />
            <span v-else>{{ slotProps.data.unit_quantity !== undefined && slotProps.data.unit_quantity !== null ? slotProps.data.unit_quantity.toLocaleString() : '' }}</span>
          </template>
        </Column>
        <Column
          field="created_at"
          header="등록일자"
          :headerStyle="{ width: columnWidths.created_at }"
          :sortable="true"
        >
          <template #body="slotProps">
            <span>{{ slotProps.data.created_at ? new Date(slotProps.data.created_at).toISOString().split('T')[0] : '' }}</span>
          </template>
        </Column>
        <Column field="status" header="상태" :headerStyle="{ width: columnWidths.status }" :sortable="true">
          <template #body="slotProps">
            <select
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.status"
              class="p-inputtext p-component p-inputtext-sm inline-edit-input"
            >
              <option value="active">활성</option>
              <option value="inactive">비활성</option>
            </select>
            <span
              v-else
              :class="slotProps.data.status === 'active' ? 'active-badge' : 'inactive-badge'"
            >
              {{ slotProps.data.status === 'active' ? '활성' : '비활성' }}
            </span>
          </template>
        </Column>
        <Column header="작업" :headerStyle="{ width: columnWidths.actions }">
          <template #body="slotProps">
            <div style="display: flex; gap: 0.25rem; justify-content: center;">
              <template v-if="slotProps.data.isEditing">
                <button @click="saveEdit(slotProps.data)" class="btn-save-sm" title="저장">저장</button>
                <button @click="cancelEdit(slotProps.data)" class="btn-cancel-sm" title="취소">취소</button>
              </template>
              <template v-else>
                <button @click="startEdit(slotProps.data)" class="btn-edit-sm" title="수정">수정</button>
                <button @click="deleteProduct(slotProps.data)" class="btn-delete-sm" title="삭제">삭제</button>
              </template>
            </div>
          </template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import { useRouter } from 'vue-router'
import { supabase } from '@/supabase'
import * as XLSX from 'xlsx'

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  product_name: '18%',
  insurance_code: '8%',
  price: '6%',
  commission_rate_a: '8%',
  commission_rate_b: '8%',
  commission_rate_c: '8%',
  standard_code: '8%',
  unit_packaging_desc: '10%',
  unit_quantity: '8%',
  created_at: '8%',
  status: '6%',
  actions: '8%'
};

const products = ref([])
const loading = ref(false)
const filters = ref({ global: { value: null, matchMode: 'contains' } })
const selectedMonth = ref('')
const availableMonths = ref([])
const router = useRouter()
const fileInput = ref(null)
const currentPageFirstIndex = ref(0)

const koLocale = {
  firstDayOfWeek: 0,
  dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
  monthNames: [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ],
  monthNamesShort: [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ],
  today: '오늘',
  clear: '초기화',
}

const filteredProducts = computed(() => {
  if (!selectedMonth.value) return products.value
  return products.value.filter((p) => p.base_month === selectedMonth.value)
})

const filterByMonth = () => {
  // computed에서 자동 처리
}

function goCreate() {
  router.push('/admin/products/create')
}
function goToDetail(id) {
  router.push(`/admin/products/${id}`)
}

const fetchProducts = async () => {
  loading.value = true;
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*', { count: 'exact' })
      .range(0, 2999)
      .order('base_month', { ascending: false });
    if (!error && data) {
      products.value = data;
      // 중복 없이 기준월만 추출
      const monthSet = new Set();
      data.forEach((item) => {
        if (item.base_month) monthSet.add(item.base_month);
      });
      availableMonths.value = Array.from(monthSet).sort((a, b) => b.localeCompare(a));
      // 최신 연월을 기본값으로
      if (availableMonths.value.length > 0) {
        selectedMonth.value = availableMonths.value[0];
      }
    }
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  fetchProducts()
})

const downloadTemplate = () => {
  // 기준월과 보험코드에 예시 데이터 추가 (보험코드 앞에 0이 있는 예시)
  const templateData = [
    {
      기준월: '2025-01',
      제품명: '팜플정',
      보험코드: '0601234567', // 앞자리 0이 있는 예시
      약가: 1000,
      수수료A: 0.45,
      수수료B: 0.44,
      표준코드: '8800123456789',
      단위포장형태: '정 10개',
      단위수량: 10,
      비고: '',
      상태: '활성',
    },
    {
      기준월: '2025-02',
      제품명: '테스트약',
      보험코드: '601234567',
      약가: 2000,
      수수료A: 0.40,
      수수료B: 0.39,
      표준코드: '8800987654321',
      단위포장형태: '캡슐 20개',
      단위수량: 20,
      비고: '예시',
      상태: '활성',
    },
  ]

  const ws = XLSX.utils.json_to_sheet(templateData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '제품템플릿')

  // 컬럼 너비 설정
  ws['!cols'] = [
    { width: 12 }, // 기준월
    { width: 20 }, // 제품명
    { width: 15 }, // 보험코드
    { width: 10 }, // 약가
    { width: 10 }, // 수수료A
    { width: 10 }, // 수수료B
    { width: 16 }, // 표준코드
    { width: 16 }, // 단위포장형태
    { width: 10 }, // 단위수량
    { width: 20 }, // 비고
    { width: 10 }, // 상태
  ]

  // A열과 C열 전체를 텍스트 형식으로 설정 (1000행까지 미리 설정)
  const maxRows = 1000; // 충분한 행 수 설정
  
  for (let row = 0; row < maxRows; row++) {
    // A열 (기준월) - 빈 셀이라도 텍스트 형식으로 설정
    const cellA = XLSX.utils.encode_cell({ r: row, c: 0 })
    if (!ws[cellA]) {
      ws[cellA] = { t: 's', v: '', z: '@' } // 빈 텍스트 셀 생성
    } else {
      ws[cellA].t = 's' // 문자열 타입
      ws[cellA].z = '@' // 텍스트 형식
    }
    
    // C열 (보험코드) - 빈 셀이라도 텍스트 형식으로 설정
    const cellC = XLSX.utils.encode_cell({ r: row, c: 2 })
    if (!ws[cellC]) {
      ws[cellC] = { t: 's', v: '', z: '@' } // 빈 텍스트 셀 생성
    } else {
      ws[cellC].t = 's' // 문자열 타입
      ws[cellC].z = '@' // 텍스트 형식
    }
  }
  
  // 워크시트 범위 업데이트 (1000행까지 확장)
  ws['!ref'] = XLSX.utils.encode_range({
    s: { c: 0, r: 0 },
    e: { c: 10, r: maxRows - 1 }
  })

  XLSX.writeFile(wb, '제품_엑셀등록_템플릿.xlsx')
}

const triggerFileUpload = () => {
  fileInput.value.click()
}

const handleFileUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  try {
    const data = await file.arrayBuffer()
    const workbook = XLSX.read(data)
    const worksheet = workbook.Sheets[workbook.SheetNames[0]]
    const jsonData = XLSX.utils.sheet_to_json(worksheet)

    if (jsonData.length === 0) {
      alert('엑셀 파일에 데이터가 없습니다.')
      return
    }

    // 업로드 데이터의 기준월들 추출
    const uploadMonths = [...new Set(jsonData.map(row => row['기준월']).filter(month => month))]
    
    // 기존 데이터 확인
    let hasExistingData = false
    for (const month of uploadMonths) {
      const existingProducts = products.value.filter(p => p.base_month === month)
      if (existingProducts.length > 0) {
        hasExistingData = true
        break
      }
    }

    // 1단계: 기존 데이터 존재 시 확인
    let isAppendMode = false
    if (hasExistingData) {
      if (!confirm('기존 데이터가 있습니다.\n계속 등록하시겠습니까?')) {
        event.target.value = ''
        return
      }

      // 2단계: 추가 vs 대체 선택
      isAppendMode = confirm('기존 데이터에 추가하시겠습니까? 대체하시겠습니까?\n\n확인: 기존 데이터는 그대로 추가 등록\n취소: 기존 데이터를 모두 지우고 등록')
      
      if (!isAppendMode) {
        // 대체 모드: 해당 기준월의 기존 데이터 삭제
        for (const month of uploadMonths) {
          const { error: deleteError } = await supabase
            .from('products')
            .delete()
            .eq('base_month', month)
          
          if (deleteError) {
            alert('기존 데이터 삭제 실패: ' + deleteError.message)
            event.target.value = ''
            return
          }
        }
        // 대체 모드에서는 로컬 데이터도 업데이트
        products.value = products.value.filter(p => !uploadMonths.includes(p.base_month))
      }
    }

    let uploadData = []
    const errors = []

    jsonData.forEach((row, index) => {
      const rowNum = index + 2

      if (!row['기준월']) {
        errors.push(`${rowNum}행: 기준월이 필요합니다.`)
        return
      }
      if (!row['제품명']) {
        errors.push(`${rowNum}행: 제품명이 필요합니다.`)
        return
      }
      if (!row['보험코드']) {
        errors.push(`${rowNum}행: 보험코드가 필요합니다.`)
        return
      }

      const monthRegex = /^\d{4}-\d{2}$/
      if (!monthRegex.test(row['기준월'])) {
        errors.push(`${rowNum}행: 기준월은 YYYY-MM 형식이어야 합니다.`)
        return
      }

      let statusValue = 'active'
      if (row['상태']) {
        if (row['상태'] === '활성') {
          statusValue = 'active'
        } else if (row['상태'] === '비활성') {
          statusValue = 'inactive'
        } else {
          errors.push(`${rowNum}행: 상태는 '활성' 또는 '비활성'이어야 합니다.`)
          return
        }
      } else {
        statusValue = 'active'
      }

      uploadData.push({
        base_month: row['기준월'],
        product_name: row['제품명'],
        insurance_code: row['보험코드'],
        price: Number(row['약가']) || 0,
        commission_rate_a: Number(row['수수료A']) || 0,
        commission_rate_b: Number(row['수수료B']) || 0,
        commission_rate_c: Number(row['수수료C']) || 0,
        standard_code: row['표준코드'] || '',
        unit_packaging_desc: row['단위포장형태'] || '',
        unit_quantity: Number(row['단위수량']) || 0,
        remarks: row['비고'] || '',
        status: statusValue,
        rowNum: rowNum // 에러 표시용
      })
    })

    if (errors.length > 0) {
      alert('데이터 오류:\n' + errors.join('\n'))
      return
    }

    // 3단계: 추가 모드일 때만 표준코드 중복 체크
    if (hasExistingData && isAppendMode) {
      const duplicateErrors = []
      const duplicateProducts = []
      
      for (const newProduct of uploadData) {
        if (newProduct.standard_code) {
          // 기존 데이터에서 동일한 기준월의 표준코드 중복 확인
          const existingProduct = products.value.find(p => 
            p.base_month === newProduct.base_month && 
            p.standard_code === newProduct.standard_code
          )
          
          if (existingProduct) {
            duplicateErrors.push(`${newProduct.rowNum}행: 이미 동일한 표준코드 제품이 등록되어 있습니다.`)
            duplicateProducts.push(newProduct)
          }
        }
      }

      if (duplicateErrors.length > 0) {
        // 4단계: 중복 발견 시 계속 진행 여부 확인
        if (!confirm('중복 오류:\n' + duplicateErrors.join('\n') + '\n\n계속 등록 작업을 진행하시겠습니까?')) {
          return
        }

        // 5단계: 중복 해결 방법 선택
        const shouldReplace = confirm('이미 동일한 표준코드 제품을 어떻게 처리하시겠습니까?\n\n확인: 기존 제품 정보를 신규 제품 정보로 교체하기\n취소: 기존 제품 정보는 그대로 두고 신규 제품 정보만 등록하기')
        
        if (shouldReplace) {
          // 교체 모드: 중복되는 기존 제품들 삭제
          for (const duplicateProduct of duplicateProducts) {
            const { error: deleteError } = await supabase
              .from('products')
              .delete()
              .eq('base_month', duplicateProduct.base_month)
              .eq('standard_code', duplicateProduct.standard_code)
            
            if (deleteError) {
              alert('기존 제품 삭제 실패: ' + deleteError.message)
              return
            }
          }
          // 로컬 데이터에서도 삭제
          for (const duplicateProduct of duplicateProducts) {
            const index = products.value.findIndex(p => 
              p.base_month === duplicateProduct.base_month && 
              p.standard_code === duplicateProduct.standard_code
            )
            if (index > -1) {
              products.value.splice(index, 1)
            }
          }
        } else {
          // 기존 유지 모드: 중복되는 신규 제품들 제외
          const duplicateStandardCodes = duplicateProducts.map(p => p.standard_code)
          uploadData = uploadData.filter(item => !duplicateStandardCodes.includes(item.standard_code))
        }
      }
    }

    // 최종 등록
    const insertData = uploadData.map(item => {
      const { rowNum, ...data } = item
      return data
    })

    if (insertData.length === 0) {
      alert('등록할 데이터가 없습니다.')
      return
    }

    const { error } = await supabase.from('products').insert(insertData)

    if (error) {
      alert('업로드 실패: ' + error.message)
    } else {
      alert(`${insertData.length}건의 제품 데이터가 업로드되었습니다.`)
      await fetchProducts()
    }
  } catch (error) {
    console.error('파일 처리 오류:', error)
    alert('파일 처리 중 오류가 발생했습니다.')
  } finally {
    event.target.value = ''
  }
}

const downloadExcel = () => {
  if (filteredProducts.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.')
    return
  }

  const excelData = filteredProducts.value.map((product) => ({
    기준월: product.base_month || '',
    제품명: product.product_name || '',
    보험코드: product.insurance_code || '',
    약가: product.price || 0,
    수수료A: product.commission_rate_a || 0,
    수수료B: product.commission_rate_b || 0,
    수수료C: product.commission_rate_c || 0,
    표준코드: product.standard_code || '',
    단위포장형태: product.unit_packaging_desc || '',
    단위수량: product.unit_quantity || 0,
    비고: product.remarks || '',
    상태: product.status === 'active' ? '활성' : '비활성',
    등록일: product.created_at ? new Date(product.created_at).toISOString().split('T')[0] : '',
    수정일: product.updated_at ? new Date(product.updated_at).toISOString().split('T')[0] : '',
  }))

  const ws = XLSX.utils.json_to_sheet(excelData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '제품목록')

  // 컬럼 너비 설정
  ws['!cols'] = [
    { width: 12 }, // 기준월
    { width: 20 }, // 제품명
    { width: 15 }, // 보험코드
    { width: 10 }, // 약가
    { width: 10 }, // 수수료A
    { width: 10 }, // 수수료B
    { width: 10 }, // 수수료C
    { width: 12 }, // 표준코드
    { width: 15 }, // 단위포장형태
    { width: 10 }, // 단위수량
    { width: 20 }, // 비고
    { width: 12 }, // 상태
    { width: 12 }, // 등록일
    { width: 12 }, // 수정일
  ]

  const range = XLSX.utils.decode_range(ws['!ref'])
  
  // 모든 행에 대해 형식 설정
  for (let row = 0; row <= range.e.r; row++) {
    // A열 (기준월) - 텍스트 형식으로 설정
    const cellA = XLSX.utils.encode_cell({ r: row, c: 0 })
    if (ws[cellA]) {
      ws[cellA].t = 's' // 문자열 타입
      ws[cellA].z = '@' // 텍스트 형식
    }
    
    // C열 (보험코드) - 텍스트 형식으로 설정
    const cellC = XLSX.utils.encode_cell({ r: row, c: 2 })
    if (ws[cellC]) {
      ws[cellC].t = 's' // 문자열 타입
      ws[cellC].z = '@' // 텍스트 형식
    }
    
    // D열 (약가) - 숫자 천 단위 구분자 형식
    const cellD = XLSX.utils.encode_cell({ r: row, c: 3 })
    if (ws[cellD] && row > 0) { // 헤더 제외
      ws[cellD].z = '#,##0'
    }
  }

  const today = new Date().toISOString().split('T')[0]
  const fileName = `제품목록_${today}.xlsx`

  XLSX.writeFile(wb, fileName)
}

const startEdit = (row) => {
  products.value.forEach((item) => {
    if (item.isEditing && item.id !== row.id) {
      cancelEdit(item)
    }
  })

  row.originalData = { ...row }
  row.isEditing = true
}

const cancelEdit = (row) => {
  Object.keys(row.originalData).forEach((key) => {
    if (key !== 'isEditing' && key !== 'originalData') {
      row[key] = row.originalData[key]
    }
  })
  row.isEditing = false
}

const saveEdit = async (row) => {
  try {
    if (!row.base_month || !row.product_name || !row.insurance_code) {
      alert('필수 항목을 모두 입력하세요.')
      return
    }

    const monthRegex = /^\d{4}-\d{2}$/
    if (!monthRegex.test(row.base_month)) {
      alert('기준월은 YYYY-MM 형식이어야 합니다.')
      return
    }

    if (!['active', 'inactive'].includes(row.status)) {
      alert('상태는 active 또는 inactive여야 합니다.')
      return
    }

    const updateData = {
      base_month: row.base_month,
      product_name: row.product_name,
      insurance_code: row.insurance_code,
      price: Number(row.price) || 0,
      commission_rate_a: Number(row.commission_rate_a) || 0,
      commission_rate_b: Number(row.commission_rate_b) || 0,
      commission_rate_c: Number(row.commission_rate_c) || 0,
      standard_code: row.standard_code || '',
      unit_packaging_desc: row.unit_packaging_desc || '',
      unit_quantity: Number(row.unit_quantity) || 0,
      remarks: row.remarks || '',
      status: row.status,
    }

    const { error } = await supabase.from('products').update(updateData).eq('id', row.id)

    if (error) {
      alert('수정 실패: ' + error.message)
      return
    }

    row.isEditing = false
    row.originalData = { ...row }

    alert('수정되었습니다.')
  } catch (error) {
    console.error('수정 오류:', error)
    alert('수정 중 오류가 발생했습니다.')
  }
}

const deleteProduct = async (row) => {
  if (!confirm('정말 삭제하시겠습니까?')) {
    return
  }

  try {
    const { error } = await supabase.from('products').delete().eq('id', row.id)

    if (error) {
      alert('삭제 실패: ' + error.message)
      return
    }

    const index = products.value.findIndex((item) => item.id === row.id)
    if (index > -1) {
      products.value.splice(index, 1)
    }

    alert('삭제되었습니다.')
  } catch (error) {
    console.error('삭제 오류:', error)
    alert('삭제 중 오류가 발생했습니다.')
  }
}

async function deleteAllProducts() {
  if (!selectedMonth.value) {
    alert('기준월을 선택해주세요.');
    return;
  }
  
  const confirmMessage = `정말 ${selectedMonth.value} 기준월의 모든 제품을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.`;
  if (!confirm(confirmMessage)) return;
  
  // 선택된 기준월에 해당하는 제품만 삭제
  const { error } = await supabase.from('products').delete().eq('base_month', selectedMonth.value);
  if (error) {
    alert('삭제 중 오류가 발생했습니다: ' + error.message);
    return;
  }
  
  // 로컬 데이터에서도 해당 기준월 제품 제거
  products.value = products.value.filter(p => p.base_month !== selectedMonth.value);
  
  alert(`${selectedMonth.value} 기준월의 모든 제품이 삭제되었습니다.`);
}
</script>
