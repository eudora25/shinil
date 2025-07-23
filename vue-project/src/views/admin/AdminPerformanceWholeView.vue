<template>
  <div class="performance-register-view page-container" style="display: flex; flex-direction: column; height: 100vh;">
    <div class="page-header-title-area" style="flex-shrink: 0;">
      <div class="header-title">전체 등록 현황</div>
    </div>

    <!-- 필터 카드: 정산월, 처방월, 업체, 병의원 드롭다운 -->
    <div class="filter-card" style="flex-shrink: 0;">
      <div class="filter-row" style="justify-content: flex-start; align-items: flex-end;">
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>정산월</label>
          <select v-model="selectedSettlementMonth" class="select_month">
            <option v-for="month in availableMonths" :key="month.settlement_month" :value="month.settlement_month">{{ month.settlement_month }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>처방월</label>
          <select v-model="prescriptionOffset" class="select_month">
            <option v-for="opt in prescriptionOptions" :key="opt.value" :value="opt.value">{{ opt.month }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>업체</label>
          <select v-model="selectedCompanyId" class="select_200px">
            <option value="">- 전체 -</option>
            <option v-for="company in companies" :key="company.id" :value="company.id">{{ company.company_name }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>병의원</label>
          <select v-model="selectedHospitalId" class="select_200px">
            <option value="">- 전체 -</option>
            <option v-for="hospital in hospitals" :key="hospital.id" :value="hospital.id">{{ hospital.name }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label style="font-weight:400;">검수</label>
          <select v-model="selectedReviewStatus" class="select_100px">
            <option value="">- 전체 -</option>
            <option value="완료">완료</option>
            <option value="검수중">검수중</option>
            <option value="대기">신규</option>
          </select>
        </div>
      </div>
    </div>

    <!-- 데이터 카드: 전체 n건 + 테이블 + 합계 행 -->
    <div class="data-card" style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden;">
      <div class="data-card-header" style="flex-shrink: 0;">
        <div class="total-count-display">전체 {{ displayRows.length }} 건</div>
        <div class="data-card-buttons">
          <button class="btn-excell-download" @click="downloadExcel" :disabled="displayRows.length === 0">
            엑셀 다운로드
          </button>
        </div>
      </div>
      <div style="flex-grow: 1; overflow: hidden;">
        <DataTable 
          :value="displayRows" 
          :loading="loading"
          scrollable 
          scrollHeight="calc(100vh - 220px)"
          scrollDirection="both"
          class="admin-performance-whole-table"
          :paginator="true"
          :rows="100"
          :rowsPerPageOptions="[100, 200, 500, 1000]"
          :pt="{
            wrapper: { style: 'min-width: 2200px;' },
            table: { style: 'min-width: 2200px;' }
          }"
          @page="onPageChange"
        >
          <template #empty>
            <div v-if="!loading">등록된 실적이 없습니다.</div>
          </template>
          <template #loading>전체 실적을 불러오는 중입니다...</template>
          
          <Column header="No" :headerStyle="{ width: columnWidths.no }" :frozen="true">
            <template #body="slotProps">
              {{ slotProps.index + currentPageFirstIndex + 1 }}
            </template>
          </Column>
          <Column header="검수" :headerStyle="{ width: columnWidths.review_status }" :frozen="true">
            <template #body="slotProps">
              <span v-if="slotProps.data.review_status === '완료'" class="status-completed">완료</span>
              <span v-else-if="slotProps.data.review_status === '검수중'" class="status-reviewing">검수중</span>
              <span v-else-if="slotProps.data.review_status === '대기'" class="status-pending">신규</span>
              <span v-else>-</span>
            </template>
          </Column>
          <Column field="company_group" header="구분" :headerStyle="{ width: columnWidths.company_group }" :sortable="true">
            <template #body="slotProps">
              <span style="font-weight: 400;">{{ slotProps.data.company_group }}</span>
            </template>
          </Column>
          <Column field="company_name" header="업체명" :headerStyle="{ width: columnWidths.company_name }" :sortable="true" :frozen="true">
            <template #body="slotProps">
              <span style="font-weight: 400;">{{ slotProps.data.company_name }}</span>
            </template>
          </Column>
          <Column field="client_name" header="병의원명" :headerStyle="{ width: columnWidths.client_name }" :sortable="true" :frozen="true">
            <template #body="slotProps">
              <span style="font-weight: 400;">{{ slotProps.data.client_name }}</span>
            </template>
          </Column>
          <Column field="prescription_month" header="처방월" :headerStyle="{ width: columnWidths.prescription_month }" :sortable="true"/>
          <Column field="product_name_display" header="제품명" :headerStyle="{ width: columnWidths.product_name_display }" :sortable="true"  :frozen="true"/>
          <Column field="insurance_code" header="보험코드" :headerStyle="{ width: columnWidths.insurance_code }" :sortable="true"/>
          <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true"/>
          <Column field="prescription_qty" header="처방수량" :headerStyle="{ width: columnWidths.prescription_qty }" :sortable="true"/>
          <Column field="prescription_amount" header="처방액" :headerStyle="{ width: columnWidths.prescription_amount }" :sortable="true"/>
          <Column field="prescription_type" header="처방구분" :headerStyle="{ width: columnWidths.prescription_type }" :sortable="true"/>
          <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true"/>
          <Column field="created_date" header="등록일시" :headerStyle="{ width: columnWidths.created_date }" :sortable="true"/>
          <Column field="created_by" header="등록자" :headerStyle="{ width: columnWidths.created_by }" :sortable="true"/>
          <Column field="assigned_pharmacist_contact" header="관리자" :headerStyle="{ width: columnWidths.assigned_pharmacist_contact }" :sortable="true">
            <template #body="slotProps">
              <span style="font-weight: 400;">{{ slotProps.data.assigned_pharmacist_contact }}</span>
            </template>
          </Column>
          <ColumnGroup type="footer">
            <Row>
              <Column :colspan="2" footerClass="footer-cell" :frozen="true" />
              <Column :colspan="1" footerClass="footer-cell" />
              <Column footer="합계" :colspan="2" footerClass="footer-cell" footerStyle="text-align:center !important;" :frozen="true" />
              <Column :colspan="1" footerClass="footer-cell" />
              <Column :colspan="1" footerClass="footer-cell" :frozen="true" />
              <Column :colspan="2" footerClass="footer-cell" />
              <Column :footer="totalQty" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :colspan="5" footerClass="footer-cell" />
            </Row>
          </ColumnGroup>
        </DataTable>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import ColumnGroup from 'primevue/columngroup';
import Row from 'primevue/row';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

const columnWidths = {
  no: '3%',
  review_status: '4%',
  company_group: '7%',
  company_name: '9%',
  client_name: '13%',
  prescription_month: '6%',
  product_name_display: '13%',
  insurance_code: '6%',
  price: '5%',
  prescription_qty: '6%',
  prescription_amount: '6%',
  prescription_type: '7%',
  remarks: '11%',
  created_date: '9%',
  created_by: '8%',
  assigned_pharmacist_contact: '5%'
};

// 반응형 데이터
const availableMonths = ref([]); // 선택 가능한 정산월 목록
const selectedSettlementMonth = ref(''); // 선택된 정산월
const selectedMonthInfo = ref(null); // 선택된 정산월 정보
const prescriptionMonth = ref('');
const prescriptionOffset = ref(0); // 0: 전체, 1: -1M, 2: -2M, 3: -3M
const prescriptionOptions = ref([]);
const loading = ref(false);
const selectedReviewStatus = ref('');

// 페이지네이션 관련
const currentPageFirstIndex = ref(0);

// 업체 관련
const selectedCompanyId = ref(''); // 선택된 업체 ID
const companies = ref([]); // 업체 목록

// 병의원 관련
const selectedHospitalId = ref(''); // 빈 문자열로 초기화 (전체)
const hospitals = ref([]);

// 실적 데이터
const performanceRecords = ref([]); // DB에서 가져온 실적 데이터
const rawRows = ref([]);
const displayRows = computed(() => {
  let rows = rawRows.value;
  if (selectedReviewStatus.value) {
    rows = rows.filter(row => row.review_status === selectedReviewStatus.value);
  }
  return rows;
});

// 유틸리티 함수들
function getPrescriptionMonth(settlementMonth, offset) {
  if (!settlementMonth) return '';
  const [y, m] = settlementMonth.split('-');
  let mm = parseInt(m, 10) - offset;
  let yy = parseInt(y, 10);
  while (mm <= 0) { mm += 12; yy -= 1; }
  return `${yy}-${String(mm).padStart(2, '0')}`;
}

function updatePrescriptionOptions() {
  if (!selectedMonthInfo.value) {
    prescriptionOptions.value = [];
    return;
  }
  
  // "- 전체 -" 옵션을 첫 번째로 추가
  prescriptionOptions.value = [
    { value: 0, month: '- 전체 -' },
    ...([1, 2, 3].map(offset => ({
      value: offset,
      month: getPrescriptionMonth(selectedMonthInfo.value.settlement_month, offset)
    })))
  ];
}

// 워치어
watch(selectedSettlementMonth, () => {
  const monthInfo = availableMonths.value.find(m => m.settlement_month === selectedSettlementMonth.value);
  selectedMonthInfo.value = monthInfo || null;
  updatePrescriptionOptions();
  prescriptionOffset.value = 0; // 기본값을 "- 전체 -"로 설정
  prescriptionMonth.value = ''; // 전체 선택 시 빈 값
  
  // 업체 선택 초기화
  selectedCompanyId.value = '';
  
  // 병의원 선택 초기화
  selectedHospitalId.value = '';
  
  if (selectedSettlementMonth.value) {
    fetchCompanies();
    fetchHospitals();
    fetchPerformanceRecords();
  } else {
    companies.value = [];
    hospitals.value = [];
    rawRows.value = [];
    performanceRecords.value = [];
  }
});

watch(prescriptionOffset, (val) => {
  if (val === 0) {
    prescriptionMonth.value = ''; // 전체 선택 시 빈 값
  } else {
    prescriptionMonth.value = getPrescriptionMonth(selectedSettlementMonth.value, val);
  }
  
  // 업체 선택 초기화
  selectedCompanyId.value = '';
  
  // 병의원 선택 초기화
  selectedHospitalId.value = '';
  
  if (selectedSettlementMonth.value) {
    fetchCompanies();
    fetchHospitals();
    fetchPerformanceRecords();
  }
});

watch(selectedCompanyId, () => {
  // 병의원 선택 초기화
  selectedHospitalId.value = '';
  
  if (selectedSettlementMonth.value) {
    fetchHospitals();
    fetchPerformanceRecords();
  }
});

watch(selectedHospitalId, () => {
  if (selectedSettlementMonth.value) {
    fetchPerformanceRecords();
  }
});

// 데이터 fetch 함수들
async function fetchAvailableMonths() {
  try {
    const { data, error } = await supabase
      .from('settlement_months')
      .select('settlement_month, start_date, end_date')
      .order('settlement_month', { ascending: false });
    if (!error && data) {
      availableMonths.value = data;
      // 첫 번째(최신) 정산월을 디폴트로 설정
      if (data.length > 0 && !selectedSettlementMonth.value) {
        selectedSettlementMonth.value = data[0].settlement_month;
      }
    }
  } catch (err) {
    console.error('정산월 조회 오류:', err);
  }
}

async function fetchCompanies() {
  if (!selectedSettlementMonth.value) {
    companies.value = [];
    return;
  }
  
  try {
    // 선택된 정산월에 실적을 제출한 업체들만 조회
    let query = supabase
      .from('performance_records')
      .select(`
        company_id,
        companies!inner(*)
      `)
      .eq('settlement_month', selectedSettlementMonth.value);
    
    // 처방월 필터링 (0이 아닐 때만)
    if (prescriptionOffset.value !== 0) {
      query = query.eq('prescription_month', prescriptionMonth.value);
    }
      
    const { data, error } = await query;
      
    if (error) {
      console.error('업체 조회 오류:', error);
      return;
    }
    
    // 중복 제거하여 고유한 업체들만 추출
    const uniqueCompanies = [];
    const companyIds = new Set();
    
    data?.forEach(record => {
      if (!companyIds.has(record.company_id)) {
        companyIds.add(record.company_id);
        uniqueCompanies.push({
          id: record.companies.id,
          company_name: record.companies.company_name,
          company_group: record.companies.company_group,
          assigned_pharmacist_contact: record.companies.assigned_pharmacist_contact
        });
      }
    });
    
    // 업체명으로 정렬
    companies.value = uniqueCompanies.sort((a, b) => a.company_name.localeCompare(b.company_name));
  } catch (err) {
    console.error('업체 조회 예외:', err);
  }
}

async function fetchHospitals() {
  if (!selectedSettlementMonth.value) {
    hospitals.value = [];
    return;
  }
  
  try {
    let query = supabase
      .from('performance_records')
      .select(`
        client_id,
        clients!inner(*)
      `)
      .eq('settlement_month', selectedSettlementMonth.value);
    
    // 처방월 필터링 (0이 아닐 때만)
    if (prescriptionOffset.value !== 0) {
      query = query.eq('prescription_month', prescriptionMonth.value);
    }
    
    // 업체가 선택된 경우 해당 업체의 실적만 조회
    if (selectedCompanyId.value) {
      query = query.eq('company_id', selectedCompanyId.value);
    }
    
    const { data, error } = await query;
      
    if (error) {
      console.error('병의원 조회 오류:', error);
      return;
    }
    
    // 중복 제거 후 병의원 정보만 추출
    const uniqueHospitals = [];
    const seenIds = new Set();
    
    data?.forEach(record => {
      if (record.clients && !seenIds.has(record.clients.id)) {
        seenIds.add(record.clients.id);
        uniqueHospitals.push({
          id: record.clients.id,
          name: record.clients.name
        });
      }
    });

    // 이름순으로 정렬
    hospitals.value = uniqueHospitals.sort((a, b) => a.name.localeCompare(b.name));
    
  } catch (err) {
    console.error('병의원 조회 예외:', err);
    hospitals.value = [];
  }
}

async function fetchPerformanceRecords() {
  if (!selectedSettlementMonth.value) {
    rawRows.value = [];
    performanceRecords.value = [];
    return;
  }

  // prescriptionOffset이 0이면 전체 처방월 조회
  if (prescriptionOffset.value !== 0 && !prescriptionMonth.value) {
    rawRows.value = [];
    performanceRecords.value = [];
    return;
  }
  
  loading.value = true;
  
  try {
    let query = supabase
      .from('performance_records')
      .select(`
        *,
        companies!inner(company_name, company_group, representative_name, assigned_pharmacist_contact),
        products!inner(product_name, insurance_code, price),
        clients!inner(name)
      `)
      .eq('settlement_month', selectedSettlementMonth.value);
      
    // 처방월 필터링 (0이 아닐 때만)
    if (prescriptionOffset.value !== 0) {
      query = query.eq('prescription_month', prescriptionMonth.value);
    }
    
    // 업체 필터링
    if (selectedCompanyId.value) {
      query = query.eq('company_id', selectedCompanyId.value);
    }
    
    // 병의원 필터링
    if (selectedHospitalId.value) {
      query = query.eq('client_id', selectedHospitalId.value);
    }
    
    // 검수 상태 필터링
    if (selectedReviewStatus.value) {
      query = query.eq('review_status', selectedReviewStatus.value);
    }

    // === 1,000행 제한 해결: 전체 데이터 가져오기 ===
    let allData = [];
    let from = 0;
    const batchSize = 1000;
    
    while (true) {
      const { data, error } = await query
        .range(from, from + batchSize - 1)
        .order('created_at', { ascending: false });
    
    if (error) {
      console.error('실적 데이터 조회 오류:', error);
      rawRows.value = [];
        loading.value = false;
      return;
    }
    
    if (!data || data.length === 0) {
        break;
      }
      
      allData = allData.concat(data);
      
      // 가져온 데이터가 batchSize보다 적으면 마지막 배치
      if (data.length < batchSize) {
        break;
      }
      
      from += batchSize;
    }
    
    if (allData.length === 0) {
      rawRows.value = [];
      loading.value = false;
      return;
    }

    const registrarIds = [...new Set(allData.map(item => item.registered_by).filter(id => id))];
    let registrarMap = new Map();

    if (registrarIds.length > 0) {
      const { data: registrars, error: registrarError } = await supabase
        .from('companies')
        .select('user_id, company_name')
        .in('user_id', registrarIds);
      
      if (registrarError) {
        console.error("등록자 정보 조회 실패:", registrarError);
      } else {
        registrars.forEach(r => registrarMap.set(r.user_id, r.company_name));
      }
    }
    
    // 데이터 변환
    let mappedData = allData.map(record => {
      const prescriptionAmount = (record.prescription_qty || 0) * (record.products?.price || 0);
      return {
        id: record.id,
        review_status: record.review_status || '대기',
        company_group: record.companies?.company_group || '',
        company_name: record.companies?.company_name || '',
        client_name: record.clients?.name || '',
        prescription_month: record.prescription_month || '',
        product_name_display: record.products?.product_name || '',
        insurance_code: record.products?.insurance_code || '',
        price: record.products?.price ? Number(record.products.price).toLocaleString() : '0',
        prescription_qty: record.prescription_qty ? Number(record.prescription_qty).toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 }) : '0.0',
        prescription_amount: Math.round(prescriptionAmount).toLocaleString(),
        prescription_type: record.prescription_type || '',
        remarks: record.remarks || '',
        created_date: new Date(record.created_at).toISOString().slice(0, 16).replace('T', ' '),
        created_by: registrarMap.get(record.registered_by) || '관리자',
        assigned_pharmacist_contact: record.companies?.assigned_pharmacist_contact || '',
      };
    });

    // 데이터 정렬
    const statusOrder = { '대기': 1, '검수중': 2, '완료': 3 };
    mappedData.sort((a, b) => {
      const orderA = statusOrder[a.review_status] || 99;
      const orderB = statusOrder[b.review_status] || 99;
      if (orderA !== orderB) return orderA - orderB;
      if (a.company_name !== b.company_name) return a.company_name.localeCompare(b.company_name, 'ko');
      if (a.client_name !== b.client_name) return a.client_name.localeCompare(b.client_name, 'ko');
      if (a.product_name_display !== b.product_name_display) return a.product_name_display.localeCompare(b.product_name_display, 'ko');
      return (b.prescription_qty || 0) - (a.prescription_qty || 0);
    });

    rawRows.value = mappedData;
    
  } catch (err) {
    console.error('실적 데이터 조회 예외:', err);
    rawRows.value = [];
  } finally {
    loading.value = false;
  }
}

// 합계 계산
const totalQty = computed(() => {
  const sum = displayRows.value.reduce((sum, row) => sum + (Number(row.prescription_qty.toString().replace(/,/g, '')) || 0), 0);
  return sum.toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 });
});

const totalAmount = computed(() => {
  const sum = displayRows.value.reduce((sum, row) => {
    const amount = Number(row.prescription_amount.toString().replace(/,/g, '')) || 0;
    return sum + amount;
  }, 0);
  return sum.toLocaleString();
});

// 페이지네이션 이벤트 핸들러
function onPageChange(event) {
  currentPageFirstIndex.value = event.first;
}

// 엑셀 다운로드
const downloadExcel = () => {
  if (displayRows.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.');
    return;
  }

  // 엑셀용 데이터 준비
  const excelData = displayRows.value.map((row, index) => ({
    'No': index + 1,
    '검수상태': row.review_status,
    '구분': row.company_group || '',
    '업체명': row.company_name || '',
    '병의원명': row.client_name || '',
    '처방월': row.prescription_month || '',
    '제품명': row.product_name_display || '',
    '보험코드': row.insurance_code || '',
    '약가': Number(String(row.price).replace(/,/g, '')) || 0,
    '처방수량': Number(String(row.prescription_qty).replace(/,/g, '')) || 0,
    '처방액': Number(String(row.prescription_amount).replace(/,/g, '')) || 0,
    '처방구분': row.prescription_type || '',
    '비고': row.remarks || '',
    '확인(검수)': row.review_status || '대기',
    '등록일시': new Date(row.created_date),
    '등록자': row.created_by,
    '관리자': row.assigned_pharmacist_contact
  }));

  // 합계 행 추가
  excelData.push({
    'No': '합계',
    '처방수량': Number(totalQty.value.replace(/,/g, '')),
    '처방액': Number(totalAmount.value.replace(/,/g, ''))
  });

  // 워크북 생성
  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(excelData);

  // 숫자 형식 지정 (천 단위 구분)
  const numberFormat = '#,##0';
  const numberFormatDecimal = '#,##0.0'; // 소수점 한 자리
  const range = XLSX.utils.decode_range(ws['!ref']);
  for (let row = 1; row <= range.e.r; row++) {
    // 약가 컬럼 (I열)
    const priceCell = ws[XLSX.utils.encode_cell({ r: row, c: 8 })];
    if (priceCell && typeof priceCell.v === 'number') {
      priceCell.z = numberFormat;
    }
    // 처방수량 컬럼 (J열) - 소수점 한 자리 표시
    const qtyCell = ws[XLSX.utils.encode_cell({ r: row, c: 9 })];
    if (qtyCell && typeof qtyCell.v === 'number') {
      qtyCell.z = numberFormatDecimal;
    }
    // 처방액 컬럼 (K열)
    const amountCell = ws[XLSX.utils.encode_cell({ r: row, c: 10 })];
    if (amountCell && typeof amountCell.v === 'number') {
      amountCell.z = numberFormat;
    }
     // 등록일시 컬럼 (O열)
    const dateCell = ws[XLSX.utils.encode_cell({ r: row, c: 14 })];
    if (dateCell && dateCell.t === 'd') {
      dateCell.z = 'yyyy-mm-dd hh:mm';
    }
  }

  XLSX.utils.book_append_sheet(wb, ws, '전체 등록 현황');

  // 파일명 생성
  const today = new Date();
  const dateStr = today.toISOString().slice(0, 10);
  const fileName = `전체_등록현황_${selectedSettlementMonth.value || dateStr}.xlsx`;

  // 다운로드
  XLSX.writeFile(wb, fileName);
};

// 마운트
onMounted(() => {
  fetchAvailableMonths();
});
</script>

<style scoped>
/* 기존 스타일 유지 */
.performance-register-view { padding: 0px; }
.data-card-buttons { display: flex; gap: 8px; }

/* 셀 배경색을 흰색으로 지정 */
:deep(.p-datatable-tbody > tr > td) {
  background: #ffffff !important;
}

/* 푸터 셀 스타일 */
:deep(.p-datatable-tfoot > tr > td) {
    background: #f8f9fa !important;
    font-weight: bold;
}
</style>
