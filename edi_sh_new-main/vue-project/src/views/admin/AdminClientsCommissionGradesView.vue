<template>
  <div class="admin-clients-commission-grades page-container">
    <div class="page-header-title-area">
      <div class="header-title">수수료 등급 설정</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <span class="p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="병의원명, 병의원 사업자등록번호, 업체명, 업체 사업자등록번호 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>
    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">전체 {{ filteredAssignments.length }} 건</div>
        <div class="action-buttons-group">
          <button class="btn-excell-template" @click="downloadTemplate">엑셀 템플릿</button>
          <button class="btn-excell-upload" @click="triggerFileUpload">엑셀 등록</button>
          <button class="btn-excell-download" @click="downloadExcel">엑셀 다운로드</button>
          <button class="btn-delete" @click="deleteAllGrades">모두 삭제</button>
          <input
            ref="fileInput"
            type="file"
            accept=".xlsx,.xls"
            @change="handleFileUpload"
            style="display: none"
          />
        </div>
      </div>

      <DataTable
        :value="filteredAssignments"
        :loading="loading"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['client_name', 'client_business_registration_number', 'owner_name', 'address', 'company_name', 'company_business_registration_number']"
        class="admin-commission-grades-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>
          <div v-if="!loading">등록된 병의원이 없습니다.</div>
        </template>
        <template #loading>병의원 목록을 불러오는 중입니다...</template>

        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">
            {{ slotProps.index + currentPageFirstIndex + 1 }}
          </template>
        </Column>
        <Column
          field="client_code"
          header="병의원코드"
          :headerStyle="{ width: columnWidths.client_code }"
          :sortable="true"
        >
          <template #body="slotProps">
            {{ slotProps.data.client_code || '' }}
          </template>
        </Column>
        <Column
          field="client_name"
          header="병의원명"
          :headerStyle="{ width: columnWidths.client_name }"
          :style="{ fontWeight: '500 !important' }"  
          :sortable="true"
        />
        <Column
          field="client_business_registration_number"
          header="사업자등록번호"
          :headerStyle="{ width: columnWidths.client_business_registration_number }"
          :sortable="true"
        />
        <Column
          field="owner_name"
          header="원장명"
          :headerStyle="{ width: columnWidths.owner_name }"
          :sortable="true"
        />
        <Column
          field="address"
          header="주소"
          :headerStyle="{ width: columnWidths.address }"
          :sortable="true"
        />
        <Column
          field="company_name"
          header="업체명"
          :headerStyle="{ width: columnWidths.company_name }"
          :style="{ fontWeight: '500 !important' }"
          :sortable="true"
        />
        <Column
          field="company_business_registration_number"
          header="사업자등록번호"
          :headerStyle="{ width: columnWidths.company_business_registration_number }"
          :sortable="true"
        />
        <Column
          field="company_default_commission_grade"
          header="기본 수수료 등급"
          :headerStyle="{ width: columnWidths.default_grade, textAlign: 'center' }"
          :bodyStyle="{ textAlign: 'center' }"
          :sortable="true"
        />
        <Column header="변경 수수료 등급" :headerStyle="{ width: columnWidths.modified_grade, textAlign: 'center' }" :bodyStyle="{ textAlign: 'center' }">
          <template #body="slotProps">
            <select
              v-model="slotProps.data.modified_commission_grade"
              @change="onGradeChange(slotProps.data, $event.target.value)"
              class="commission-grade-select"
            >
              <option value="">-</option>
              <option value="A">A</option>
              <option value="B">B</option>
            </select>
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
import { supabase } from '@/supabase'
import * as XLSX from 'xlsx'

const assignments = ref([])
const loading = ref(false)
const filters = ref({ global: { value: null, matchMode: 'contains' } })
const currentPageFirstIndex = ref(0)
const fileInput = ref(null)

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  client_code: '6%',
  client_name: '16%',
  client_business_registration_number: '8%',
  owner_name: '6%',
  address: '24%',
  company_name: '12%',
  company_business_registration_number: '8%',
  default_grade: '8%',
  modified_grade: '8%',
}

const fetchAssignments = async () => {
  loading.value = true;
  try {
    const { data: assignmentsData, error } = await supabase
      .from('client_company_assignments')
      .select(`
        id,
        company_default_commission_grade,
        modified_commission_grade,
        client:clients(id, client_code, name, business_registration_number, owner_name, address),
        company:companies(id, company_name, business_registration_number)
      `)
    
    if (!error && assignmentsData) {
      assignments.value = assignmentsData.map((assignment) => ({
        id: assignment.id,
        client_code: assignment.client?.client_code || '',
        client_name: assignment.client?.name || '',
        client_business_registration_number: assignment.client?.business_registration_number || '',
        owner_name: assignment.client?.owner_name || '',
        address: assignment.client?.address || '',
        company_name: assignment.company?.company_name || '',
        company_business_registration_number: assignment.company?.business_registration_number || '',
        company_default_commission_grade: assignment.company_default_commission_grade,
        modified_commission_grade: assignment.modified_commission_grade,
      }))
    }
  } catch (err) {
    console.error('데이터 조회 오류:', err)
  } finally {
    loading.value = false;
  }
}
const filteredAssignments = computed(() => {
  if (!filters.value['global'].value) return assignments.value
  const search = filters.value['global'].value.toLowerCase()
  return assignments.value.filter(
    (a) =>
      a.client_name.toLowerCase().includes(search) ||
      a.client_business_registration_number.includes(search) ||
      a.owner_name.toLowerCase().includes(search) ||
      a.address.toLowerCase().includes(search) ||
      a.company_name.toLowerCase().includes(search) ||
      a.company_business_registration_number.includes(search),
  )
})
// 수수료 등급 변경 관련 함수들
async function onGradeChange(assignment, newValue) {
  const oldValue = assignment.modified_commission_grade
  
  if (confirm('해당 병의원의 수수료 등급을 변경하시겠습니까?')) {
    try {
      const { error } = await supabase
        .from('client_company_assignments')
        .update({ modified_commission_grade: newValue })
        .eq('id', assignment.id)
      
      if (error) {
        console.error('수수료 등급 변경 오류:', error)
        alert('수수료 등급 변경 중 오류가 발생했습니다.')
        // 드롭다운을 이전 값으로 되돌리기
        assignment.modified_commission_grade = oldValue
      } else {
        // 성공적으로 변경됨
        assignment.modified_commission_grade = newValue
      }
    } catch (err) {
      console.error('수수료 등급 변경 오류:', err)
      alert('수수료 등급 변경 중 오류가 발생했습니다.')
      // 드롭다운을 이전 값으로 되돌리기
      assignment.modified_commission_grade = oldValue
    }
  } else {
    // 취소한 경우 드롭다운을 이전 값으로 되돌리기
    assignment.modified_commission_grade = oldValue
  }
}

const downloadTemplate = () => {
  const templateData = [
    { '병의원 사업자등록번호': '123-45-67890', '업체 사업자등록번호': '111-22-33333', '변경 수수료 등급': 'A' },
    { '병의원 사업자등록번호': '987-65-43210', '업체 사업자등록번호': '444-55-66666', '변경 수수료 등급': 'B' },
  ]
  const ws = XLSX.utils.json_to_sheet(templateData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '수수료등급설정템플릿')
  ws['!cols'] = [{ width: 20 }, { width: 20 }, { width: 15 }] // 컬럼 너비 조정
  XLSX.writeFile(wb, '수수료등급설정_엑셀등록_템플릿.xlsx') // 파일명 변경
}

const triggerFileUpload = () => {
  if (fileInput.value) {
    fileInput.value.click()
  }
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

    const gradesToUpdate = []
    const errors = []

    // 모든 매핑 정보를 미리 로드
    const { data: allAssignmentsData, error: assignmentError } = await supabase
      .from('client_company_assignments')
      .select(`
        id,
        client:clients(business_registration_number),
        company:companies(business_registration_number)
      `)

    if (assignmentError) {
      alert('매핑 정보 조회 중 오류가 발생했습니다.')
      console.error(assignmentError)
      return
    }

    // 매핑 정보를 키-값 형태로 변환 (성능 최적화)
    const assignmentMap = new Map()
    allAssignmentsData.forEach(assignment => {
      if (assignment.client && assignment.company) {
        const key = `${assignment.client.business_registration_number}-${assignment.company.business_registration_number}`
        assignmentMap.set(key, assignment.id)
      }
    })

    for (const [index, row] of jsonData.entries()) {
      const rowNum = index + 2
      const clientBrn = row['병의원 사업자등록번호']
      const companyBrn = row['업체 사업자등록번호']
      const newGrade = row['변경 수수료 등급']

      if (!clientBrn || !companyBrn) {
        errors.push(`${rowNum}행: 병의원 또는 업체의 사업자등록번호가 비어있습니다.`)
        continue
      }

      if (newGrade && !['A', 'B'].includes(newGrade)) {
        errors.push(`${rowNum}행: 변경 수수료 등급은 'A' 또는 'B'만 가능합니다.`)
        continue
      }

      const key = `${clientBrn}-${companyBrn}`
      const assignmentId = assignmentMap.get(key)

      if (!assignmentId) {
        errors.push(
          `${rowNum}행: 병의원-업체 매핑을 찾을 수 없습니다. (병의원: ${clientBrn}, 업체: ${companyBrn})`,
        )
        continue
      }

      gradesToUpdate.push({
        id: assignmentId,
        modified_commission_grade: newGrade || null
      })
    }

    if (errors.length > 0) {
      alert('데이터 오류:\n' + errors.join('\n'))
      return
    }

    if (gradesToUpdate.length > 0) {
      // 각 항목을 개별적으로 업데이트
      let successCount = 0
      let errorCount = 0

      for (const gradeUpdate of gradesToUpdate) {
        const { error } = await supabase
          .from('client_company_assignments')
          .update({ modified_commission_grade: gradeUpdate.modified_commission_grade })
          .eq('id', gradeUpdate.id)
        
        if (error) {
          errorCount++
          console.error('수수료 등급 업데이트 오류:', error)
        } else {
          successCount++
        }
      }

      if (errorCount > 0) {
        alert(`업로드 완료: 성공 ${successCount}건, 실패 ${errorCount}건`)
      } else {
        alert(`${successCount}건의 수수료 등급이 업데이트되었습니다.`)
      }
      
      await fetchAssignments() // 목록 새로고침
    }
  } catch (error) {
    console.error('파일 처리 오류:', error)
    alert('파일 처리 중 오류가 발생했습니다.')
  } finally {
    if (event.target) {
      event.target.value = ''
    }
  }
}

const downloadExcel = () => {
  if (filteredAssignments.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.')
    return
  }
  
  const excelData = filteredAssignments.value.map((assignment) => ({
    병의원코드: assignment.client_code,
    병의원명: assignment.client_name,
    '병의원 사업자등록번호': assignment.client_business_registration_number,
    원장명: assignment.owner_name,
    주소: assignment.address,
    업체명: assignment.company_name,
    '업체 사업자등록번호': assignment.company_business_registration_number,
    '기본 수수료 등급': assignment.company_default_commission_grade,
    '변경 수수료 등급': assignment.modified_commission_grade || '-',
  }))

  const ws = XLSX.utils.json_to_sheet(excelData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '수수료등급설정현황')
  const today = new Date().toISOString().split('T')[0]
  XLSX.writeFile(wb, `수수료등급설정현황_${today}.xlsx`)
}

async function deleteAllGrades() {
  if (!confirm('정말 모든 변경 수수료 등급을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'))
    return
  
  const { error } = await supabase
    .from('client_company_assignments')
    .update({ modified_commission_grade: null })
    .neq('id', 0)
  
  if (error) {
    alert('삭제 중 오류가 발생했습니다: ' + error.message)
    return
  }
  
  // 로컬 데이터도 업데이트
  assignments.value.forEach((assignment) => {
    assignment.modified_commission_grade = null
  })
  
  alert('모든 변경 수수료 등급이 삭제되었습니다.')
}

onMounted(() => {
  fetchAssignments()
})
</script>

<style scoped>
.commission-grade-select {
  width: 100%;
  min-width: 80px;
  padding: 4px 8px;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  background-color: white;
  font-size: 13px;
  color: #374151;
  cursor: pointer;
  text-align: center;
}

.commission-grade-select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.1);
}

.commission-grade-select option {
  padding: 4px 8px;
}

.commission-grade-select option:checked {
  background-color: #3b82f6;
  color: white;
}

.admin-commission-grades-table .p-datatable-tbody > tr > td {
  padding: 4px 12px;
}
</style>
