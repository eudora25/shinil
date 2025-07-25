<template>
  <TopNavigationBar :breadcrumbMenu="'업체 관리'" :breadcrumbSubMenu="'미승인 업체'" />
  <div class="admin-companies-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">미승인 업체</div>
    </div>

    <div class="filter-card">
      <div class="filter-row">
        <span class="filter-item p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="업체명, 사업자등록번호, 대표자명 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>

    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ pendingCompanies.length }} 건
        </div>
        <div class="action-buttons-group">
          <button class="btn-excell-download" @click="downloadExcel" :disabled="pendingCompanies.length === 0">엑셀 다운로드</button>
          <button class="btn-save" @click="goCreate">업체 등록</button>
        </div>
      </div>

      <DataTable
        :value="pendingCompanies"
        :loading="loading"
        paginator :rows="50" :rowsPerPageOptions="[20, 50, 100]"
        editMode="cell" @cell-edit-complete="onCellEditComplete"
        scrollable scrollHeight="calc(100vh - 250px)" 
        v-model:filters="filters"
        :globalFilterFields="['company_name', 'business_registration_number', 'representative_name']"
        class="admin-companies-pending-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>
          <div v-if="!loading">승인 대기 중인 업체가 없습니다.</div>
        </template>
        <template #loading> 승인 대기 업체 목록을 불러오는 중입니다... </template>
        
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
        </Column>
        <Column field="company_group" header="구분" :headerStyle="{ width: columnWidths.company_group }" :sortable="true" :editor="getTextEditor"></Column>
        <Column field="company_name" header="업체명" :headerStyle="{ width: columnWidths.company_name }" :sortable="true">
          <template #body="slotProps">
            <a href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">{{ slotProps.data.company_name }}</a>
          </template>
        </Column>
        <Column field="business_registration_number" header="사업자등록번호" :headerStyle="{ width: columnWidths.business_registration_number }" :sortable="true" :editor="getTextEditor"></Column>
        <Column field="representative_name" header="대표자" :headerStyle="{ width: columnWidths.representative_name }" :sortable="true" :editor="getTextEditor"></Column>
        <Column field="business_address" header="사업장소재지" :headerStyle="{ width: columnWidths.business_address }" :sortable="true" :editor="getTextEditor">
          <template #body="slotProps">
            <span class="ellipsis-cell" :title="slotProps.data.business_address" @mouseenter="checkOverflow" @mouseleave="removeOverflowClass">{{ slotProps.data.business_address }}</span>
          </template>
        </Column>
        <Column field="default_commission_grade" header="수수료 등급" :headerStyle="{ width: columnWidths.default_commission_grade }" :sortable="true" :editor="getDropdownEditor">
          <template #editor="{ data, field }">
            <Dropdown v-model="data[field]" :options="commissionGrades" optionLabel="name" optionValue="value" style="width: 100%" />
          </template>
        </Column>
        <Column field="assigned_pharmacist_contact" header="관리자" :headerStyle="{ width: columnWidths.assigned_pharmacist_contact }" :sortable="true" :editor="getTextEditor"></Column>
        <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }">
          <template #body="slotProps">
            {{ slotProps.data.remarks || '-' }}
          </template>
        </Column>
        <Column field="approval_status" header="승인 처리" :headerStyle="{ width: columnWidths.approval_status }" :exportable="false">
          <template #body="slotProps">
            <button class="btn-approve-sm" @click="confirmApprovalChange(slotProps.data, 'approved')">승인</button>
          </template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, watch } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import { h } from 'vue'
import { supabase } from '@/supabase'
import Textarea from 'primevue/textarea'
import Password from 'primevue/password'
import { useRouter } from 'vue-router'
import * as XLSX from 'xlsx'
import TopNavigationBar from '@/components/TopNavigationBar.vue'

// 컬럼 너비 관리
const columnWidths = {
  no: '4%',
  company_group: '7%',
  company_name: '16%',
  business_registration_number: '9%',
  representative_name: '7%',
  business_address: '25%',
  default_commission_grade: '7%',
  assigned_pharmacist_contact: '7%',
  remarks: '12%',
  approval_status: '6%',
}

const pendingCompanies = ref([])
const loading = ref(false)
const currentPageFirstIndex = ref(0)
const filters = ref({
  global: { value: null, matchMode: 'contains' },
})
const commissionGrades = [
  { name: 'A', value: 'A' },
  { name: 'B', value: 'B' },
  { name: 'C', value: 'C' },
]
const router = useRouter()

const fetchCompanies = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase.from('companies').select('*')
    if (error) {
      console.error('업체 정보를 불러오는데 실패했습니다.', error)
      throw error
    }
    pendingCompanies.value = (data || []).filter(
      (company) => company.user_type === 'user' && company.approval_status === 'pending',
    )
  } catch (err) {
    console.error('업체 정보를 불러오는데 실패했습니다.', err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchCompanies()
})

function getDropdownEditor() {
  return {}
}

const goCreate = () => {
  router.push('/admin/companies/create?from=pending')
}

const companyDetailDialog = ref(false)
const selectedCompany = reactive({})
const isEditing = ref(false)
const hasChanges = ref(false)
const originalCompanyDetail = ref({})

const openCompanyDetailDialog = (company) => {
  Object.assign(selectedCompany, company)
  originalCompanyDetail.value = JSON.parse(JSON.stringify(company))
  companyDetailDialog.value = true
  isEditing.value = false
  hasChanges.value = false
  router.push(`/admin/companies/${company.id}?from=pending`)
}

const closeCompanyDetailDialog = () => {
  companyDetailDialog.value = false
}

const startEditCompanyDetail = () => {
  isEditing.value = true
  hasChanges.value = false
}

const cancelEditCompanyDetail = () => {
  Object.assign(selectedCompany, JSON.parse(JSON.stringify(originalCompanyDetail.value)))
  isEditing.value = false
  hasChanges.value = false
}

const saveCompanyDetail = async () => {
  try {
    loading.value = true
    const currentUser = await supabase.auth.getUser()
    if (!currentUser.data.user) {
      alert('로그인 정보가 없습니다. 다시 로그인해주세요.')
      loading.value = false
      return
    }
    const adminUserId = currentUser.data.user.id

    const { error } = await supabase
      .from('companies')
      .update({
        company_name: selectedCompany.company_name,
        representative_name: selectedCompany.representative_name,
        business_address: selectedCompany.business_address,
        landline_phone: selectedCompany.landline_phone,
        contact_person_name: selectedCompany.contact_person_name,
        mobile_phone: selectedCompany.mobile_phone,
        mobile_phone_2: selectedCompany.mobile_phone_2,
        receive_email: selectedCompany.receive_email,
        company_group: selectedCompany.company_group,
        default_commission_grade: selectedCompany.default_commission_grade,
        assigned_pharmacist_contact: selectedCompany.assigned_pharmacist_contact,
        remarks: selectedCompany.remarks,
        updated_at: new Date().toISOString(),
        updated_by: adminUserId,
      })
      .eq('id', selectedCompany.id)
    if (error) throw error
    alert('업체 정보가 성공적으로 수정되었습니다.')
    isEditing.value = false
    hasChanges.value = false
    originalCompanyDetail.value = JSON.parse(JSON.stringify(selectedCompany))
    await fetchCompanies()
  } catch (err) {
    console.error('업체 정보 수정 중 오류가 발생했습니다.', err)
  } finally {
    loading.value = false
  }
}

watch(
  selectedCompany,
  (newVal) => {
    hasChanges.value = JSON.stringify(newVal) !== JSON.stringify(originalCompanyDetail.value)
  },
  { deep: true },
)

const confirmApprovalChange = async (company, newStatus) => {
  const actionText = newStatus === 'approved' ? '승인' : '승인 취소'
  if (!confirm(`${company.company_name} 업체를 ${actionText} 처리하시겠습니까?`)) return
  try {
    loading.value = true
    const currentUser = await supabase.auth.getUser()
    if (!currentUser.data.user) {
      alert('로그인 정보가 없습니다. 다시 로그인해주세요.')
      loading.value = false
      return
    }
    const adminUserId = currentUser.data.user.id

    const updatePayload = {
      approval_status: newStatus,
      updated_at: new Date().toISOString(),
      updated_by: adminUserId,
      approved_at: newStatus === 'approved' ? new Date().toISOString() : null,
    }

    const { error } = await supabase.from('companies').update(updatePayload).eq('id', company.id)
    if (error) throw error
    alert('업체 상태가 성공적으로 변경되었습니다.')
    await fetchCompanies()
    router.push('/admin/companies/pending')
  } catch (err) {
    alert(err.message || '상태 변경 실패')
  } finally {
    loading.value = false
  }
}

function getTextEditor(slotProps) {
  return h(InputText, {
    modelValue: slotProps.data[slotProps.field],
    'onUpdate:modelValue': (value) => (slotProps.data[slotProps.field] = value),
  })
}

function onCellEditComplete(event) {
  // event.data, event.field, event.newValue 등 활용
  // 예: 서버에 저장 등
}

function goToDetail(id) {
  router.push(`/admin/companies/${id}?from=pending`)
}

const downloadExcel = () => {
  if (pendingCompanies.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.')
    return
  }

  const dataToExport = pendingCompanies.value.map((company, index) => ({
    ID: company.id,
    No: index + 1 + currentPageFirstIndex.value,
    '아이디(이메일)': company.email,
    구분: company.company_group,
    업체명: company.company_name,
    사업자등록번호: company.business_registration_number,
    대표자: company.representative_name,
    사업장소재지: company.business_address,
    유선전화: company.landline_phone,
    담당자: company.contact_person_name,
    '휴대폰 번호': company.mobile_phone,
    '휴대폰 번호 2': company.mobile_phone_2,
    '수신용 이메일': company.receive_email,
    승인여부:
      company.approval_status === 'approved'
        ? '승인'
        : company.approval_status === 'pending'
          ? '미승인'
          : company.approval_status,
    '수수료 등급': company.default_commission_grade,
    관리자: company.assigned_pharmacist_contact,
    비고: company.remarks,
    등록일자: company.created_at ? new Date(company.created_at).toLocaleString('ko-KR') : '',
    승인일자: company.approved_at ? new Date(company.approved_at).toLocaleString('ko-KR') : '',
    수정일자: company.updated_at ? new Date(company.updated_at).toLocaleString('ko-KR') : '',
  }))

  const worksheet = XLSX.utils.json_to_sheet(dataToExport)
  const workbook = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(workbook, worksheet, '미승인업체목록')

  const today = new Date().toISOString().split('T')[0]
  const fileName = `미승인업체목록_${today}.xlsx`
  XLSX.writeFile(workbook, fileName)
}

// 오버플로우 감지 및 툴팁 제어 함수들
const checkOverflow = (event) => {
  const element = event.target;
  
  // 실제 오버플로우 감지
  const rect = element.getBoundingClientRect();
  const computedStyle = window.getComputedStyle(element);
  const fontSize = parseFloat(computedStyle.fontSize);
  const fontFamily = computedStyle.fontFamily;
  
  // 임시 캔버스를 만들어서 텍스트의 실제 너비 측정
  const canvas = document.createElement('canvas');
  const context = canvas.getContext('2d');
  context.font = `${fontSize}px ${fontFamily}`;
  const textWidth = context.measureText(element.textContent).width;
  
  // 패딩과 보더 고려
  const paddingLeft = parseFloat(computedStyle.paddingLeft) || 0;
  const paddingRight = parseFloat(computedStyle.paddingRight) || 0;
  const borderLeft = parseFloat(computedStyle.borderLeftWidth) || 0;
  const borderRight = parseFloat(computedStyle.borderRightWidth) || 0;
  
  const availableWidth = rect.width - paddingLeft - paddingRight - borderLeft - borderRight;
  const isOverflowed = textWidth > availableWidth;
  
  console.log('업체 오버플로우 체크:', {
    text: element.textContent,
    textWidth,
    availableWidth,
    isOverflowed
  });
  
  if (isOverflowed) {
    element.classList.add('overflowed');
    console.log('업체 오버플로우 클래스 추가됨');
  } else {
    element.classList.remove('overflowed'); // Ensure class is removed if not overflowed
    console.log('업체 오버플로우 아님 - 클래스 제거됨');
  }
}

const removeOverflowClass = (event) => {
  const element = event.target;
  element.classList.remove('overflowed');
}

</script>

<style scoped>
.text-link { color: var(--text-link); text-decoration: underline; cursor: pointer; }
.text-link:hover { color: var(--primary-color-dark); }
</style> 