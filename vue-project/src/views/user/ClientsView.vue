<template>
  <div class="admin-clients-view page-container">
    <div class="page-header">
      <div class="header-title">병의원 목록</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <span class="filter-item p-input-icon-left">
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
          전체 {{ clients.length }} 건
        </div>
        <div class="data-card-buttons">
        <button class="btn-excell-download" @click="downloadExcel" :disabled="clients.length === 0">
          엑셀 다운로드
        </button>
      </div>
      </div>
      <DataTable
        :value="clients"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['client_code', 'name', 'business_registration_number']"
        class="custom-table clients-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>등록된 병의원이 없습니다.</template>
        <template #loading>병의원 목록을 불러오는 중입니다...</template>
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
        </Column>
        <Column field="client_code" header="병의원코드" :headerStyle="{ width: columnWidths.client_code }" :sortable="true" />
        <Column field="name" header="병의원명" :headerStyle="{ width: columnWidths.name }" :sortable="true">
          <template #body="slotProps">
            <a href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">{{ slotProps.data.name }}</a>
          </template>
        </Column>
        <Column field="business_registration_number" header="사업자등록번호" :headerStyle="{ width: columnWidths.business_registration_number }" :sortable="true" />
        <Column field="owner_name" header="원장명" :headerStyle="{ width: columnWidths.owner_name }" :sortable="true" />
        <Column field="address" header="주소" :headerStyle="{ width: columnWidths.address }" :sortable="true" />
        <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true" />
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import InputText from 'primevue/inputtext';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

const clients = ref([]);
const filters = ref({ 'global': { value: null, matchMode: 'contains' } });
const router = useRouter();
const currentPageFirstIndex = ref(0);

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  client_code: '7%',
  name: '18%',
  business_registration_number: '9%',
  owner_name: '7%',
  address: '39%',
  remarks: '16%'
};

function goToDetail(id) {
  router.push(`/clients/${id}`);
}

const fetchClients = async () => {
  // 1. 로그인한 사용자의 UID
  const { data: { session } } = await supabase.auth.getSession();
  const userUid = session?.user?.id;

  // 2. companies 테이블에서 내 업체 id(uuid) 찾기
  const { data: myCompany, error: companyError } = await supabase
    .from('companies')
    .select('id')
    .eq('user_id', userUid)
    .single();

  if (companyError || !myCompany) {
    clients.value = [];
    return;
  }
  const companyId = myCompany.id;

  // 3. 매핑 테이블에서 내 거래처 id 목록 추출
  const { data: assignments, error: assignError } = await supabase
    .from('client_company_assignments')
    .select('client_id')
    .eq('company_id', companyId);

  if (assignError || !assignments || assignments.length === 0) {
    clients.value = [];
    return;
  }

  const clientIds = assignments.map(a => a.client_id);

  // 4. 거래처 테이블에서 해당 id만 조회
  const { data, error } = await supabase
    .from('clients')
    .select('*')
    .in('id', clientIds)
    .eq('status', 'active')
    .order('client_code', { ascending: true });

  if (!error && data) {
    clients.value = data;
  }
};

// 엑셀 다운로드 함수
function downloadExcel() {
  if (!clients.value || clients.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.');
    return;
  }

  // 엑셀 데이터 준비
  const excelData = clients.value.map((client, index) => ({
    'No': index + 1,
    '병의원코드': client.client_code || '',
    '병의원명': client.name || '',
    '사업자등록번호': client.business_registration_number || '',
    '원장명': client.owner_name || '',
    '주소': client.address || '',
    '비고': client.remarks || ''
  }));

  // 워크북 생성
  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(excelData);

  // 컬럼 너비 설정
  ws['!cols'] = [
    { wpx: 50 },  // No
    { wpx: 100 }, // 병의원코드
    { wpx: 180 }, // 병의원명
    { wpx: 120 }, // 사업자등록번호
    { wpx: 100 }, // 원장명
    { wpx: 300 }, // 주소
    { wpx: 120 }  // 비고
  ];

  // 워크시트를 워크북에 추가
  XLSX.utils.book_append_sheet(wb, ws, '병의원 목록');

  // 파일명 생성
  const today = new Date();
  const dateStr = today.toISOString().slice(0, 10).replace(/-/g, '');
  const fileName = `병의원목록_${dateStr}.xlsx`;

  // 파일 다운로드
  XLSX.writeFile(wb, fileName);
}

onMounted(() => {
  fetchClients();
});
</script>
