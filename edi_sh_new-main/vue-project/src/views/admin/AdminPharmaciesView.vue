<template>
  <div class="admin-clients-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">문전약국 목록</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <span class="p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="약국코드, 약국명, 사업자등록번호 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>
    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ pharmacies.length }} 건
        </div>
        <div class="action-buttons-group">
          <button class="btn-excell-template" @click="downloadTemplate">엑셀 템플릿</button>
          <button class="btn-excell-upload" @click="triggerFileUpload">엑셀 등록</button>
          <button class="btn-excell-download" @click="downloadExcel">엑셀 다운로드</button>
          <button class="btn-delete" @click="deleteAllPharmacies">모두 삭제</button>
          <input
            ref="fileInput"
            type="file"
            accept=".xlsx,.xls"
            @change="handleFileUpload"
            style="display: none"
          />
          <button class="btn-save" @click="goCreate">개별 등록</button>
        </div>
      </div>
      <DataTable
        :value="pharmacies"
        :loading="loading"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['pharmacy_code', 'name', 'business_registration_number']"
        class="admin-pharmacies-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>
          <div v-if="!loading">등록된 약국이 없습니다.</div>
        </template>
        <template #loading>약국 목록을 불러오는 중입니다...</template>
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">
            {{ slotProps.index + currentPageFirstIndex + 1 }}
          </template>
        </Column>
        <Column
          field="pharmacy_code"
          header="약국코드"
          :headerStyle="{ width: columnWidths.pharmacy_code }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.pharmacy_code"
              class="inline-edit-input"
            />
            <span v-else>{{ slotProps.data.pharmacy_code }}</span>
          </template>
        </Column>
        <Column field="name" header="약국명" :headerStyle="{ width: columnWidths.name }" :sortable="true">
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.name"
              class="inline-edit-input"
            />
            <a v-else href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">
              {{ slotProps.data.name }}
            </a>
          </template>
        </Column>
        <Column
          field="business_registration_number"
          header="사업자등록번호"
          :headerStyle="{ width: columnWidths.business_registration_number }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.business_registration_number"
              class="inline-edit-input"
            />
            <span v-else>{{ slotProps.data.business_registration_number }}</span>
          </template>
        </Column>
        <Column
          field="address"
          header="주소"
          :headerStyle="{ width: columnWidths.address }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.address"
              class="inline-edit-input"
            />
            <span v-else>{{ slotProps.data.address }}</span>
          </template>
        </Column>
        <Column
          field="remarks"
          header="비고"
          :headerStyle="{ width: columnWidths.remarks }"
          :sortable="true"
        >
          <template #body="slotProps">
            <input
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.remarks"
              class="inline-edit-input"
            />
            <span v-else>{{ slotProps.data.remarks }}</span>
          </template>
        </Column>
        <Column
          field="created_at"
          header="등록일자"
          :headerStyle="{ width: columnWidths.created_at }"
          :sortable="true"
        >
          <template #body="slotProps">
            <span>{{
              slotProps.data.created_at
                ? new Date(slotProps.data.created_at).toISOString().split('T')[0]
                : ''
            }}</span>
          </template>
        </Column>
        <Column
          field="status"
          header="상태"
          :headerStyle="{ width: columnWidths.status }"
          :sortable="true"
        >
          <template #body="slotProps">
            <select
              v-if="slotProps.data.isEditing"
              v-model="slotProps.data.status"
              class="inline-edit-input"
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
        <Column
          header="작업"
          :headerStyle="{ width: columnWidths.actions }"
        >
          <template #body="slotProps">
            <div style="display: flex; gap: 4px; justify-content: center">
              <template v-if="slotProps.data.isEditing">
                <button @click="saveEdit(slotProps.data)" class="btn-save-sm" title="저장">
                  저장
                </button>
                <button @click="cancelEdit(slotProps.data)" class="btn-cancel-sm" title="취소">
                  취소
                </button>
              </template>
              <template v-else>
                <button @click="startEdit(slotProps.data)" class="btn-edit-sm" title="수정">
                  수정
                </button>
                <button @click="deletePharmacy(slotProps.data)" class="btn-delete-sm" title="삭제">
                  삭제
                </button>
              </template>
            </div>
          </template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import { useRouter } from 'vue-router'
import { supabase } from '@/supabase'
import * as XLSX from 'xlsx'

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  pharmacy_code: '7%',
  name: '18%',
  business_registration_number: '8%',
  address: '31%',
  remarks: '10%',
  created_at: '8%',
  status: '6%',
  actions: '8%'
};

const pharmacies = ref([])
const loading = ref(false)
const filters = ref({ global: { value: null, matchMode: 'contains' } })
const router = useRouter()
const fileInput = ref(null)
const currentPageFirstIndex = ref(0)

function goCreate() {
  router.push('/admin/pharmacies/create')
}
function goToDetail(id) {
  router.push(`/admin/pharmacies/${id}`)
}

const fetchPharmacies = async () => {
  loading.value = true;
  try {
    const { data, error } = await supabase
      .from('pharmacies')
      .select('*')
      .order('pharmacy_code', { ascending: true })
    if (!error && data) {
      // 각 행에 편집 상태와 원본 데이터 백업 추가
      pharmacies.value = data.map((item) => ({
        ...item,
        isEditing: false,
        originalData: { ...item },
      }))
    }
  } finally {
    loading.value = false;
  }
}

// 수정 시작
const startEdit = (row) => {
  // 다른 행이 편집 중이면 취소
  pharmacies.value.forEach((item) => {
    if (item.isEditing && item.id !== row.id) {
      cancelEdit(item)
    }
  })

  // 원본 데이터 백업
  row.originalData = { ...row }
  row.isEditing = true
}

// 수정 취소
const cancelEdit = (row) => {
  // 원본 데이터로 복원
  Object.keys(row.originalData).forEach((key) => {
    if (key !== 'isEditing' && key !== 'originalData') {
      row[key] = row.originalData[key]
    }
  })
  row.isEditing = false
}

// 수정 저장
const saveEdit = async (row) => {
  try {
    // 필수 필드 검증
    if (!row.name || !row.business_registration_number) {
      alert('필수 항목을 모두 입력하세요. (약국명, 사업자등록번호)')
      return
    }

    // 상태 값 검증
    if (!['active', 'inactive'].includes(row.status)) {
      alert('상태는 active 또는 inactive여야 합니다.')
      return
    }

    const updateData = {
      pharmacy_code: row.pharmacy_code || '',
      name: row.name,
      business_registration_number: row.business_registration_number,
      address: row.address || '',
      remarks: row.remarks || '',
      status: row.status,
    }

    const { error } = await supabase.from('pharmacies').update(updateData).eq('id', row.id)

    if (error) {
      alert('수정 실패: ' + error.message)
      return
    }

    // 편집 모드 종료
    row.isEditing = false
    row.originalData = { ...row }

    alert('수정되었습니다.')
  } catch (error) {
    console.error('수정 오류:', error)
    alert('수정 중 오류가 발생했습니다.')
  }
}

// 삭제
const deletePharmacy = async (row) => {
  if (!confirm('정말 삭제하시겠습니까?')) {
    return
  }

  try {
    const { error } = await supabase.from('pharmacies').delete().eq('id', row.id)

    if (error) {
      alert('삭제 실패: ' + error.message)
      return
    }

    // 목록에서 제거
    const index = pharmacies.value.findIndex((item) => item.id === row.id)
    if (index > -1) {
      pharmacies.value.splice(index, 1)
    }

    alert('삭제되었습니다.')
  } catch (error) {
    console.error('삭제 오류:', error)
    alert('삭제 중 오류가 발생했습니다.')
  }
}

// 엑셀 템플릿 다운로드
const downloadTemplate = () => {
  const templateData = [
    {
      약국코드: 'PH001',
      약국명: '예시약국',
      사업자등록번호: '123-45-67890',
      주소: '서울시 강남구 테헤란로 123',
      비고: '예시 비고',
      상태: '활성',
    },
    {
      약국코드: 'PH002',
      약국명: '테스트약국',
      사업자등록번호: '012-34-56789', // 앞자리 0이 있는 예시
      주소: '서울시 서초구 서초대로 456',
      비고: '예시',
      상태: '활성',
    },
  ]

  const ws = XLSX.utils.json_to_sheet(templateData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '문전약국템플릿')

  // 컬럼 너비 설정
  ws['!cols'] = [
    { width: 12 }, // 약국코드
    { width: 25 }, // 약국명
    { width: 15 }, // 사업자등록번호
    { width: 40 }, // 주소
    { width: 20 }, // 비고
    { width: 10 }, // 상태
  ]

  // 사업자등록번호(C열) 전체를 텍스트 형식으로 설정 (1000행까지)
  const maxRows = 1000;
  
  for (let row = 0; row < maxRows; row++) {
    // C열 (사업자등록번호) - 빈 셀이라도 텍스트 형식으로 설정
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
    e: { c: 5, r: maxRows - 1 }
  })

  XLSX.writeFile(wb, '문전약국_엑셀등록_템플릿.xlsx')
}

// 파일 업로드 트리거
const triggerFileUpload = () => {
  fileInput.value.click()
}

// 엑셀 파일 업로드 처리
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

    // 기존 데이터 확인
    const hasExistingData = pharmacies.value.length > 0

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
        // 대체 모드: 기존 데이터 삭제
        const { error: deleteError } = await supabase.from('pharmacies').delete().neq('id', 0)
        
        if (deleteError) {
          alert('기존 데이터 삭제 실패: ' + deleteError.message)
          event.target.value = ''
          return
        }
        // 로컬 데이터도 초기화
        pharmacies.value = []
      }
    }

    // 데이터 변환 및 검증
    let uploadData = []
    const errors = []

    jsonData.forEach((row, index) => {
      const rowNum = index + 2 // 엑셀 행 번호 (헤더 제외)

      // 필수 필드 검증
      if (!row['약국명']) {
        errors.push(`${rowNum}행: 약국명이 필요합니다.`)
        return
      }
      if (!row['사업자등록번호']) {
        errors.push(`${rowNum}행: 사업자등록번호가 필요합니다.`)
        return
      }

      // 상태 값 검증 및 변환
      let statusValue = 'active' // 기본값
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
        pharmacy_code: row['약국코드'] || '',
        name: row['약국명'],
        business_registration_number: row['사업자등록번호'],
        address: row['주소'] || '',
        remarks: row['비고'] || '',
        status: statusValue,
        rowNum: rowNum // 에러 표시용
      })
    })

    if (errors.length > 0) {
      alert('데이터 오류:\n' + errors.join('\n'))
      return
    }

    // 3단계: 추가 모드일 때만 사업자등록번호 중복 체크
    if (hasExistingData && isAppendMode) {
      const duplicateErrors = []
      const duplicatePharmacies = []
      
      for (const newPharmacy of uploadData) {
        if (newPharmacy.business_registration_number) {
          // 기존 데이터에서 동일한 사업자등록번호 중복 확인
          const existingPharmacy = pharmacies.value.find(p => 
            p.business_registration_number === newPharmacy.business_registration_number
          )
          
          if (existingPharmacy) {
            duplicateErrors.push(`${newPharmacy.rowNum}행: 이미 동일한 사업자등록번호의 약국이 등록되어 있습니다.`)
            duplicatePharmacies.push(newPharmacy)
          }
        }
      }

      if (duplicateErrors.length > 0) {
        // 4단계: 중복 발견 시 계속 진행 여부 확인
        if (!confirm('중복 오류:\n' + duplicateErrors.join('\n') + '\n\n계속 등록 작업을 진행하시겠습니까?')) {
          return
        }

        // 5단계: 중복 해결 방법 선택
        const shouldReplace = confirm('이미 동일한 사업자등록번호 약국을 어떻게 처리하시겠습니까?\n\n확인: 기존 약국 정보를 신규 약국 정보로 교체하기\n취소: 기존 약국 정보는 그대로 두고 신규 약국만 등록하기')
        
        if (shouldReplace) {
          // 교체 모드: 중복되는 기존 약국들 삭제
          for (const duplicatePharmacy of duplicatePharmacies) {
            const { error: deleteError } = await supabase
              .from('pharmacies')
              .delete()
              .eq('business_registration_number', duplicatePharmacy.business_registration_number)
            
            if (deleteError) {
              alert('기존 약국 삭제 실패: ' + deleteError.message)
              return
            }
          }
          // 로컬 데이터에서도 삭제
          for (const duplicatePharmacy of duplicatePharmacies) {
            const index = pharmacies.value.findIndex(p => 
              p.business_registration_number === duplicatePharmacy.business_registration_number
            )
            if (index > -1) {
              pharmacies.value.splice(index, 1)
            }
          }
        } else {
          // 기존 유지 모드: 중복되는 신규 약국들 제외
          const duplicateBusinessNumbers = duplicatePharmacies.map(p => p.business_registration_number)
          uploadData = uploadData.filter(item => !duplicateBusinessNumbers.includes(item.business_registration_number))
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

    // 데이터베이스에 일괄 삽입
    const { error } = await supabase.from('pharmacies').insert(insertData)

    if (error) {
      alert('업로드 실패: ' + error.message)
    } else {
      alert(`${insertData.length}건의 문전약국 데이터가 업로드되었습니다.`)
      await fetchPharmacies() // 목록 새로고침
    }
  } catch (error) {
    console.error('파일 처리 오류:', error)
    alert('파일 처리 중 오류가 발생했습니다.')
  } finally {
    // 파일 입력 초기화
    event.target.value = ''
  }
}

// 엑셀 다운로드 (현재 목록)
const downloadExcel = () => {
  if (pharmacies.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.')
    return
  }

  // 데이터 변환
  const excelData = pharmacies.value.map((pharmacy) => ({
    ID: pharmacy.id,
    약국코드: pharmacy.pharmacy_code || '',
    약국명: pharmacy.name || '',
    사업자등록번호: pharmacy.business_registration_number || '',
    주소: pharmacy.address || '',
    비고: pharmacy.remarks || '',
    상태: pharmacy.status === 'active' ? '활성' : '비활성',
    등록일: pharmacy.created_at ? new Date(pharmacy.created_at).toISOString().split('T')[0] : '',
    수정일: pharmacy.updated_at ? new Date(pharmacy.updated_at).toISOString().split('T')[0] : '',
  }))

  const ws = XLSX.utils.json_to_sheet(excelData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '문전약국목록')

  // 컬럼 너비 설정
  ws['!cols'] = [
    { width: 10 }, // ID
    { width: 12 }, // 약국코드
    { width: 20 }, // 약국명
    { width: 15 }, // 사업자등록번호
    { width: 30 }, // 주소
    { width: 20 }, // 비고
    { width: 10 }, // 상태
    { width: 12 }, // 등록일
    { width: 12 }, // 수정일
  ]

  const range = XLSX.utils.decode_range(ws['!ref'])
  
  // 모든 행에 대해 형식 설정
  for (let row = 0; row <= range.e.r; row++) {
    // D열 (사업자등록번호) - 텍스트 형식으로 설정
    const cellD = XLSX.utils.encode_cell({ r: row, c: 3 })
    if (ws[cellD]) {
      ws[cellD].t = 's' // 문자열 타입
      ws[cellD].z = '@' // 텍스트 형식
    }
  }

  // 파일명에 현재 날짜 포함
  const today = new Date().toISOString().split('T')[0]
  const fileName = `문전약국목록_${today}.xlsx`

  XLSX.writeFile(wb, fileName)
}

async function deleteAllPharmacies() {
  if (!confirm('정말 모든 약국을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
  const { error } = await supabase.from('pharmacies').delete().neq('id', 0);
  if (error) {
    alert('삭제 중 오류가 발생했습니다: ' + error.message);
    return;
  }
  pharmacies.value = [];
  alert('모든 약국이 삭제되었습니다.');
}

onMounted(() => {
  fetchPharmacies()
})
</script>
