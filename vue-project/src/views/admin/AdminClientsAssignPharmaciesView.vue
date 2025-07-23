<template>
  <div class="admin-clients-assign-pharmacies page-container">
    <div class="page-header-title-area">
      <div class="header-title">문전약국 지정</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <span class="p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="병의원코드, 병의원명, 사업자등록번호 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>
    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ filteredClients.length }} 건
        </div>
        <div class="action-buttons-group">
          <button class="btn-excell-template" @click="downloadTemplate">엑셀 템플릿</button>
          <button class="btn-excell-upload" @click="triggerFileUpload">엑셀 등록</button>
          <button class="btn-excell-download" @click="downloadExcel">엑셀 다운로드</button>
          <button class="btn-delete" @click="deleteAllAssignments">모두 삭제</button>
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
        :value="filteredClients"
        :loading="loading"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['client_code', 'name', 'business_registration_number']"
        class="admin-assign-pharmacies-table"
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
        />
        <Column 
          field="name" 
          header="병의원명" 
          :headerStyle="{ width: columnWidths.name }" 
          :style="{ fontWeight: '500 !important' }"  
          :sortable="true" 
        />
        <Column
          field="business_registration_number"
          header="사업자등록번호"
          :headerStyle="{ width: columnWidths.business_registration_number }"
          :sortable="true"
        />
        <Column
          field="owner_name"
          header="원장명"
          :headerStyle="{ width: columnWidths.owner_name }"
          :sortable="true"
        />
        <Column field="address" header="주소" :headerStyle="{ width: columnWidths.address }" :sortable="true" />
        <Column header="약국명" :headerStyle="{ width: columnWidths.pharmacy_name }">
          <template #body="slotProps">
            <div v-if="slotProps.data.pharmacies && slotProps.data.pharmacies.length > 0">
              <div
                v-for="(pharmacy, idx) in slotProps.data.pharmacies"
                :key="pharmacy.id"
                style="min-height: 32px; display: flex; align-items: center !important; font-weight: 500 !important;"
              >
                {{ pharmacy.name }}
              </div>
            </div>
            <div v-else style="min-height: 32px">-</div>
          </template>
        </Column>
        <Column header="사업자등록번호" :headerStyle="{ width: columnWidths.pharmacy_brn }">
          <template #body="slotProps">
            <div v-if="slotProps.data.pharmacies && slotProps.data.pharmacies.length > 0">
              <div
                v-for="(pharmacy, idx) in slotProps.data.pharmacies"
                :key="pharmacy.id"
                style="min-height: 32px; display: flex; align-items: center"
              >
                {{ pharmacy.business_registration_number }}
              </div>
            </div>
            <div v-else style="min-height: 32px">-</div>
          </template>
        </Column>
        <Column header="작업" :headerStyle="{ width: columnWidths.actions }">
          <template #body="slotProps">
            <div v-if="slotProps.data.pharmacies && slotProps.data.pharmacies.length > 0">
              <div
                v-for="(pharmacy, idx) in slotProps.data.pharmacies"
                :key="pharmacy.id"
                style="min-height: 32px; display: flex; align-items: center; gap: 4px"
              >
                <button class="btn-delete-sm" @click="deleteAssignment(slotProps.data, pharmacy)">
                  삭제
                </button>
                <button
                  v-if="idx === slotProps.data.pharmacies.length - 1"
                  class="btn-add-sm"
                  @click="openAssignModal(slotProps.data)"
                >
                  추가
                </button>
              </div>
            </div>
            <div v-else style="min-height: 32px; display: flex; align-items: center">
              <button class="btn-add-sm" @click="openAssignModal(slotProps.data)">추가</button>
            </div>
          </template>
        </Column>
      </DataTable>
    </div>

    <!-- 담당약국 지정 모달 -->
    <Dialog v-model:visible="assignModalVisible" header="약국 지정" :modal="true" :style="{ width: '60vw' }">
      <div>
        <InputText
          v-model="pharmacySearch"
          placeholder="약국명, 사업자등록번호 검색"
          style="width: 100%; margin-bottom: 12px; margin-top: 0px"
          class="modal-search-input"
          />
        <DataTable
          :value="filteredPharmacies"
          v-model:selection="selectedPharmacies"
          selectionMode="multiple"
          class="custom-table modal-assign-pharmacies-table"
          scrollable
          scrollHeight="440px"
        >
          <Column selectionMode="multiple" :headerStyle="{ width: '6%' }" />
          <Column field="name" header="약국명" :headerStyle="{ width: '28%' }" :sortable="true" />
          <Column
            field="business_registration_number"
            header="사업자등록번호"
            :headerStyle="{ width: '16%' }"
            :sortable="true"
          />
          <Column field="address" header="주소" :headerStyle="{ width: '50%' }" :sortable="true" />
        </DataTable>
        <div class="btn-row" style="margin-top: 16px">
          <button class="btn-cancel" @click="closeAssignModal">취소</button>
          <button
            class="btn-save"
            :disabled="selectedPharmacies.length === 0"
            @click="assignPharmacies"
          >
            지정
          </button>
        </div>
      </div>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Dialog from 'primevue/dialog'
import { supabase } from '@/supabase'
import * as XLSX from 'xlsx'

const clients = ref([])
const loading = ref(false)
const pharmacies = ref([])
const filters = ref({ global: { value: null, matchMode: 'contains' } })
const assignModalVisible = ref(false)
const selectedClient = ref(null)
const selectedPharmacies = ref([])
const pharmacySearch = ref('')
const currentPageFirstIndex = ref(0)
const fileInput = ref(null)

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  client_code: '7%',
  name: '18%',
  business_registration_number: '8%',
  owner_name: '7%',
  address: '24%',
  pharmacy_name: '16%',
  pharmacy_brn: '8%',
  actions: '8%'
};

const fetchClients = async () => {
  loading.value = true;
  try {
    const { data: clientsData, error } = await supabase
      .from('clients')
      .select(
        `*, pharmacies:client_pharmacy_assignments(pharmacy:pharmacies(id, name, business_registration_number))`,
      )
      .eq('status', 'active')
    if (!error && clientsData) {
      clients.value = clientsData.map((client) => {
        const pharmaciesArr = client.pharmacies.map((p) => p.pharmacy)
        return {
          ...client,
          pharmacies: pharmaciesArr,
        }
      })
    }
  } finally {
    loading.value = false;
  }
}
const fetchPharmacies = async () => {
  const { data, error } = await supabase.from('pharmacies').select('*').eq('status', 'active')
  if (!error && data) pharmacies.value = data
}
const filteredClients = computed(() => {
  if (!filters.value['global'].value) return clients.value
  const search = filters.value['global'].value.toLowerCase()
  return clients.value.filter(
    (c) =>
      c.client_code.toLowerCase().includes(search) ||
      c.name.toLowerCase().includes(search) ||
      c.business_registration_number.includes(search),
  )
})
const filteredPharmacies = computed(() => {
  if (!pharmacySearch.value) return pharmacies.value
  const search = pharmacySearch.value.toLowerCase()
  return pharmacies.value.filter(
    (p) => p.name.toLowerCase().includes(search) || p.business_registration_number.includes(search),
  )
})
function openAssignModal(client) {
  selectedClient.value = client
  selectedPharmacies.value = []
  assignModalVisible.value = true
}
function closeAssignModal() {
  assignModalVisible.value = false
  selectedClient.value = null
  selectedPharmacies.value = []
}
async function assignPharmacies() {
  if (!selectedClient.value || selectedPharmacies.value.length === 0) return
  const assignments = selectedPharmacies.value.map((pharmacy) => ({
    client_id: selectedClient.value.id,
    pharmacy_id: pharmacy.id,
  }))
  await supabase
    .from('client_pharmacy_assignments')
    .upsert(assignments, { onConflict: 'client_id,pharmacy_id' })
  closeAssignModal()
  await fetchClients()
}
async function deleteAssignment(client, pharmacy = null) {
  let query = supabase.from('client_pharmacy_assignments').delete().eq('client_id', client.id)
  if (pharmacy) query = query.eq('pharmacy_id', pharmacy.id)
  await query
  await fetchClients()
}

const downloadTemplate = () => {
  const templateData = [
    { '병의원 사업자등록번호': '123-45-67890', '약국 사업자등록번호': '222-11-33333' },
    { '병의원 사업자등록번호': '987-65-43210', '약국 사업자등록번호': '555-44-66666' },
  ]
  const ws = XLSX.utils.json_to_sheet(templateData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '문전약국지정템플릿')
  ws['!cols'] = [{ width: 20 }, { width: 20 }]
  XLSX.writeFile(wb, '병의원-약국매핑_엑셀등록_템플릿.xlsx')
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

    const assignmentsToUpload = []
    const errors = []

    const { data: allClientsData, error: clientError } = await supabase
      .from('clients')
      .select('id, business_registration_number')
    const { data: allPharmaciesData, error: pharmacyError } = await supabase
      .from('pharmacies')
      .select('id, business_registration_number')

    if (clientError || pharmacyError) {
      alert('병의원 또는 약국 정보 조회 중 오류가 발생했습니다.')
      console.error(clientError || pharmacyError)
      return
    }

    const clientMap = new Map(allClientsData.map((c) => [c.business_registration_number, c.id]))
    const pharmacyMap = new Map(
      allPharmaciesData.map((p) => [p.business_registration_number, p.id]),
    )

    for (const [index, row] of jsonData.entries()) {
      const rowNum = index + 2
      const clientBrn = row['병의원 사업자등록번호']
      const pharmacyBrn = row['약국 사업자등록번호']

      if (!clientBrn || !pharmacyBrn) {
        errors.push(`${rowNum}행: 병의원 또는 약국의 사업자등록번호가 비어있습니다.`)
        continue
      }

      const clientId = clientMap.get(String(clientBrn))
      const pharmacyId = pharmacyMap.get(String(pharmacyBrn))

      if (!clientId) {
        errors.push(
          `${rowNum}행: 병의원 사업자등록번호 '${clientBrn}'에 해당하는 병의원을 찾을 수 없습니다.`,
        )
      }
      if (!pharmacyId) {
        errors.push(
          `${rowNum}행: 약국 사업자등록번호 '${pharmacyBrn}'에 해당하는 약국을 찾을 수 없습니다.`,
        )
      }

      if (clientId && pharmacyId) {
        assignmentsToUpload.push({ client_id: clientId, pharmacy_id: pharmacyId })
      }
    }

    if (errors.length > 0) {
      alert('데이터 오류:\n' + errors.join('\n'))
      return
    }

    if (assignmentsToUpload.length > 0) {
      const { error } = await supabase
        .from('client_pharmacy_assignments')
        .upsert(assignmentsToUpload, { onConflict: 'client_id,pharmacy_id' })
      if (error) {
        alert('업로드 실패: ' + error.message)
      } else {
        alert(`${assignmentsToUpload.length}건의 문전약국 지정 정보가 업로드/갱신되었습니다.`)
        await fetchClients()
      }
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
  if (filteredClients.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.')
    return
  }
  const excelData = []
  filteredClients.value.forEach((client) => {
    if (client.pharmacies && client.pharmacies.length > 0) {
      client.pharmacies.forEach((pharmacy) => {
        excelData.push({
          병의원ID: client.id,
          병의원코드: client.client_code,
          병의원명: client.name,
          사업자등록번호: client.business_registration_number,
          원장명: client.owner_name,
          주소: client.address,
          약국ID: pharmacy.id,
          '지정된 약국명': pharmacy.name,
          '지정된 약국 사업자번호': pharmacy.business_registration_number,
        })
      })
    } else {
      excelData.push({
        병의원ID: client.id,
        병의원코드: client.client_code,
        병의원명: client.name,
        사업자등록번호: client.business_registration_number,
        원장명: client.owner_name,
        주소: client.address,
        약국ID: '-',
        '지정된 약국명': '-',
        '지정된 약국 사업자번호': '-',
      })
    }
  })

  const ws = XLSX.utils.json_to_sheet(excelData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '문전약국지정현황')
  const today = new Date().toISOString().split('T')[0]
  XLSX.writeFile(wb, `문전약국지정현황_${today}.xlsx`)
}

async function deleteAllAssignments() {
  if (!confirm('정말 모든 문전약국 지정 데이터를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
  const { error } = await supabase.from('client_pharmacy_assignments').delete().neq('id', 0);
  if (error) {
    alert('삭제 중 오류가 발생했습니다: ' + error.message);
    return;
  }
  clients.value.forEach(c => c.pharmacies = []);
  alert('모든 문전약국 지정 데이터가 삭제되었습니다.');
}

onMounted(() => {
  fetchClients()
  fetchPharmacies()
})
</script>
