<template>
  <div class="user-settlement-detail-view page-container" style="display: flex; flex-direction: column; height: 100vh;">
    <!-- 상단 필터카드 -->
    <div class="filter-card" style="flex-shrink: 0;">
      <div class="filter-row">
        <div style="display: flex; align-items: center; gap: 8px">
          <label>정산월</label>
          <select v-model="selectedMonth" class="select_month">
            <option v-for="month in availableMonths" :key="month" :value="month">{{ month }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px">
          <label>처방월</label>
          <select v-model="selectedPrescriptionMonth" class="select_month">
            <option value="">- 전체 -</option>
            <option v-for="m in availablePrescriptionMonths" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label style="white-space: nowrap; font-weight: 400">병의원</label>
          <select v-model="selectedClient" class="select_240px">
            <option value="">- 전체 -</option>
            <option v-for="c in availableClients" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
      </div>
    </div>

    <!-- 데이터 카드 -->
    <div class="data-card" style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden;">
      <div class="data-card-header" style="flex-shrink: 0; justify-content: space-between;">
        <div class="total-count-display">전체 {{ detailRows.length }} 건</div>
        <div class="settlement-summary">
          <span style="font-weight: 600;">공급가 : {{ settlementSummary.supply_price?.toLocaleString() }}원</span>
          <span style="font-weight: 600;">부가세 : {{ settlementSummary.vat_price?.toLocaleString() }}원</span>
          <span style="font-weight: 600;">합계액 : {{ settlementSummary.total_price?.toLocaleString() }}원</span>
        </div>
        <div class="action-buttons-group">
          <button class="btn-excell-download" @click="downloadExcel">엑셀 다운로드</button>
        </div>
      </div>
      <div style="flex-grow: 1; overflow: hidden;">
        <DataTable
          :value="detailRows" 
          scrollable 
          scrollHeight="calc(100vh - 220px)"
          class="user-settlement-detail-table"
          >
          <template #empty>공유된 정산 내역이 없습니다.</template>
          <Column header="No" :headerStyle="{ width: columnWidths.no }">
            <template #body="slotProps">{{ slotProps.index + 1 }}</template>
          </Column>
          <Column field="client_name" header="병의원명" :headerStyle="{ width: columnWidths.client_name }" :sortable="true">
            <template #body="slotProps">
              <span class="ellipsis-cell" :title="slotProps.data.client_name" @mouseenter="checkOverflow" @mouseleave="removeOverflowClass">{{ slotProps.data.client_name }}</span>
            </template>
          </Column>
          <Column field="prescription_month" header="처방월" :headerStyle="{ width: columnWidths.prescription_month }" :sortable="true" />
          <Column field="product_name_display" header="제품명" :headerStyle="{ width: columnWidths.product_name }" :sortable="true">
            <template #body="slotProps">
              <span class="ellipsis-cell" :title="slotProps.data.product_name_display" @mouseenter="checkOverflow" @mouseleave="removeOverflowClass">{{ slotProps.data.product_name_display }}</span>
            </template>
          </Column>
          <Column field="insurance_code" header="보험코드" :headerStyle="{ width: columnWidths.insurance_code }" :sortable="true" />
          <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true">
            <template #body="slotProps">{{ Math.round(slotProps.data._raw_price || 0).toLocaleString() }}</template>
          </Column>
          <Column field="prescription_qty" header="처방수량" :headerStyle="{ width: columnWidths.prescription_qty }" :sortable="true">
            <template #body="slotProps">{{ (slotProps.data._raw_qty || 0).toLocaleString('ko-KR', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) }}</template>
          </Column>
          <Column field="prescription_amount" header="처방액" :headerStyle="{ width: columnWidths.prescription_amount }" :sortable="true" />
          <Column field="commission_rate" header="수수료율" :headerStyle="{ width: columnWidths.commission_rate }" :sortable="true" />
          <Column field="payment_amount" header="지급액" :headerStyle="{ width: columnWidths.payment_amount }" :sortable="true" />
          <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true">
            <template #body="slotProps">
              <span class="ellipsis-cell" :title="slotProps.data.remarks" @mouseenter="checkOverflow" @mouseleave="removeOverflowClass">{{ slotProps.data.remarks }}</span>
            </template>
          </Column>
          <ColumnGroup type="footer">
            <Row>
              <Column footer="합계" :colspan="6" footerClass="footer-cell" footerStyle="text-align:center !important;" />
              <Column :footer="totalQty" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalPrescriptionAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column footerClass="footer-cell" />
              <Column :footer="totalPaymentAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column footerClass="footer-cell" />
            </Row>
          </ColumnGroup>
        </DataTable>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import ColumnGroup from 'primevue/columngroup';
import Row from 'primevue/row';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

const companyId = ref('');
const availableMonths = ref([]);
const selectedMonth = ref('');
const availablePrescriptionMonths = ref([]);
const selectedPrescriptionMonth = ref('');
const availableClients = ref([]);
const selectedClient = ref('');
const detailRows = ref([]);
const allDataForMonth = ref([]);

const totalQty = computed(() => detailRows.value.reduce((sum, row) => sum + (row._raw_qty || 0), 0).toLocaleString('ko-KR', { minimumFractionDigits: 1, maximumFractionDigits: 1 }));
const totalPrescriptionAmount = computed(() => detailRows.value.reduce((sum, row) => sum + (row._raw_prescription_amount || 0), 0).toLocaleString());
const totalPaymentAmount = computed(() => detailRows.value.reduce((sum, row) => sum + (row._raw_payment_amount || 0), 0).toLocaleString());

const settlementSummary = computed(() => {
  const totalPrice = detailRows.value.reduce((sum, row) => {
    return sum + (row._raw_payment_amount || 0);
  }, 0);

  const supplyPrice = Math.round(totalPrice / 1.1);
  const vatPrice = Math.round(totalPrice - supplyPrice);
  
  return {
    total_price: totalPrice,
    supply_price: supplyPrice,
    vat_price: vatPrice,
  };
});

const columnWidths = {
   no: '4%',
   client_name: '18%',
   prescription_month: '6%',
   product_name: '16%',
   insurance_code: '7%',
   price: '7%',
   prescription_qty: '7%',
   prescription_amount: '7%',
   commission_rate: '7%',
   payment_amount: '7%',
   remarks: '14%' };

async function fetchCompanyId() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session?.user?.id) return;
  const { data, error } = await supabase.from('companies').select('id').eq('user_id', session.user.id).single();
  if (!error && data) companyId.value = data.id;
}

async function fetchAvailableMonths() {
  if (!companyId.value) return;
  const { data, error } = await supabase
    .from('settlement_share')
    .select('settlement_month')
    .eq('company_id', companyId.value)
    .eq('share_enabled', true);
  if (!error && data) {
    availableMonths.value = Array.from(new Set(data.map(d => d.settlement_month))).sort((a, b) => b.localeCompare(a));
    if (availableMonths.value.length > 0) selectedMonth.value = availableMonths.value[0];
  }
}

async function fetchAllDataForMonth() {
  if (!companyId.value || !selectedMonth.value) {
    allDataForMonth.value = [];
    return;
  }
  
  // 1. settlement_share 테이블에서 공유 여부 확인
  const { data: shareData, error: shareError } = await supabase
    .from('settlement_share')
    .select('share_enabled')
    .eq('settlement_month', selectedMonth.value)
    .eq('company_id', companyId.value)
    .single();

  // 공유되지 않았거나 오류 발생 시, 빈 화면 처리
  if (shareError || !shareData || !shareData.share_enabled) {
    allDataForMonth.value = [];
    updateFilterOptions();
    filterDetailRows();
    return;
  }

  // 2. 공유된 경우에만 performance_records_absorption 데이터 조회
  const { data, error } = await supabase
    .from('performance_records_absorption')
    .select(`
      *,
      clients ( name ),
      products ( product_name, insurance_code, price )
    `)
    .eq('settlement_month', selectedMonth.value)
    .eq('company_id', companyId.value);
  
  if (error) {
    allDataForMonth.value = [];
    return;
  }
  
  allDataForMonth.value = data.map(row => {
    const price = row.products?.price || 0;
    const qty = row.prescription_qty || 0;
    const prescriptionAmount = Math.round(qty * price);
    const paymentAmount = Math.round(prescriptionAmount * (row.commission_rate || 0));
    
    return {
      ...row,
      client_name: row.clients?.name || 'N/A',
      product_name_display: row.products?.product_name || 'N/A',
      insurance_code: row.products?.insurance_code || 'N/A',
      price: price,
      prescription_qty: qty,
      prescription_amount: prescriptionAmount,
      payment_amount: paymentAmount,
      commission_rate: `${((row.commission_rate || 0) * 100).toFixed(1)}%`,
      // 원본 숫자 데이터 보존
      _raw_price: price,
      _raw_qty: qty,
      _raw_prescription_amount: prescriptionAmount,
      _raw_payment_amount: paymentAmount,
    };
  });
  
  updateFilterOptions();
  filterDetailRows();
}

function updateFilterOptions() {
  if (allDataForMonth.value.length > 0) {
    availablePrescriptionMonths.value = [...new Set(allDataForMonth.value.map(r => r.prescription_month))].sort((a, b) => b.localeCompare(a));
    availableClients.value = [...new Set(allDataForMonth.value.map(r => r.client_name))].sort();
  } else {
    availablePrescriptionMonths.value = [];
    availableClients.value = [];
  }
}

function filterDetailRows() {
  let filtered = [...allDataForMonth.value];
  if (selectedPrescriptionMonth.value) {
    filtered = filtered.filter(row => row.prescription_month === selectedPrescriptionMonth.value);
  }
  if (selectedClient.value) {
    filtered = filtered.filter(row => row.client_name === selectedClient.value);
  }

  filtered.sort((a, b) => {
    // 1. 병의원명 가나다순
    const clientNameCompare = a.client_name.localeCompare(b.client_name, 'ko');
    if (clientNameCompare !== 0) return clientNameCompare;

    // 2. 제품명 가나다순
    const productNameCompare = a.product_name_display.localeCompare(b.product_name_display, 'ko');
    if (productNameCompare !== 0) return productNameCompare;

    // 3. 처방수량 높은 순
    const qtyA = a._raw_qty || 0;
    const qtyB = b._raw_qty || 0;
    return qtyB - qtyA;
  });

  detailRows.value = filtered.map(row => ({
    ...row,
    price: (row.price || 0).toLocaleString(),
    prescription_qty: (row.prescription_qty || 0).toLocaleString('ko-KR', { minimumFractionDigits: 1, maximumFractionDigits: 1 }),
    prescription_amount: Math.round(row.prescription_amount || 0).toLocaleString(),
    payment_amount: Math.round(row.payment_amount || 0).toLocaleString()
  }));
}

watch(selectedMonth, async () => {
  selectedPrescriptionMonth.value = '';
  selectedClient.value = '';
  await fetchAllDataForMonth();
});
watch([selectedPrescriptionMonth, selectedClient], filterDetailRows);

onMounted(async () => {
  await fetchCompanyId();
  await fetchAvailableMonths();
});

function downloadExcel() {
  if (!detailRows.value.length) return;
  
  // No 컬럼과 함께 데이터 생성
  const excelData = detailRows.value.map((row, index) => ({
    'No': index + 1,
    '병의원명': row.client_name,
    '처방월': row.prescription_month,
    '제품명': row.product_name_display,
    '보험코드': row.insurance_code,
    '약가': row._raw_price || 0,
    '처방수량': row._raw_qty || 0,
    '처방액': row._raw_prescription_amount || 0,
    '수수료율': Number(String(row.commission_rate).replace('%', '')) / 100,
    '지급액': row._raw_payment_amount || 0,
    '비고': row.remarks || '',
  }));

  // 합계 행 추가 (반올림된 개별 값들의 합계)
  const totalQtySum = detailRows.value.reduce((sum, row) => sum + (row._raw_qty || 0), 0);
  const totalPrescriptionAmountSum = detailRows.value.reduce((sum, row) => sum + (row._raw_prescription_amount || 0), 0);
  const totalPaymentAmountSum = detailRows.value.reduce((sum, row) => sum + (row._raw_payment_amount || 0), 0);
  
  excelData.push({
    'No': '합계',
    '병의원명': '',
    '처방월': '',
    '제품명': '',
    '보험코드': '',
    '약가': '',
    '처방수량': totalQtySum,
    '처방액': totalPrescriptionAmountSum,
    '수수료율': '',
    '지급액': totalPaymentAmountSum,
    '비고': '',
  });

  const ws = XLSX.utils.json_to_sheet(excelData);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, '정산내역서상세');

  // 컬럼 너비 설정 (No 컬럼 추가로 인해 컬럼 수 증가)
  ws['!cols'] = [ 
    { wch: 5 },   // No
    { wch: 18 },  // 병의원명
    { wch: 10 },  // 처방월
    { wch: 20 },  // 제품명
    { wch: 12 },  // 보험코드
    { wch: 12 },  // 약가
    { wch: 12 },  // 처방수량
    { wch: 12 },  // 처방액
    { wch: 10 },  // 수수료율
    { wch: 12 },  // 지급액
    { wch: 18 }   // 비고
  ];
  
  // 셀 서식 지정
  const range = XLSX.utils.decode_range(ws['!ref']);
  for (let R = range.s.r + 1; R <= range.e.r; ++R) {
    // 숫자 컬럼들 (천 단위 콤마, 소수점 없음)
    const numberCols = [5, 7, 9]; // 약가, 처방액, 지급액
    numberCols.forEach(col => {
      const cell = ws[XLSX.utils.encode_cell({c: col, r: R})];
      if (cell && typeof cell.v === 'number') {
        cell.z = '#,##0';
      }
    });

    // 처방수량 컬럼 (소수점 1자리)
    const qtyCell = ws[XLSX.utils.encode_cell({c: 6, r: R})];
    if (qtyCell && typeof qtyCell.v === 'number') {
      qtyCell.z = '#,##0.0';
    }

    // 수수료율 컬럼 (백분율)
    const rateCell = ws[XLSX.utils.encode_cell({c: 8, r: R})];
    if (rateCell && typeof rateCell.v === 'number') {
      rateCell.z = '0.0%';
    }
  }

  const today = new Date().toISOString().split('T')[0];
  const fileName = `정산내역서상세_${selectedMonth.value || ''}_${today}.xlsx`;
  XLSX.writeFile(wb, fileName);
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
  
  console.log('이용자 정산내역서 오버플로우 체크:', {
    text: element.textContent,
    textWidth,
    availableWidth,
    isOverflowed
  });
  
  if (isOverflowed) {
    element.classList.add('overflowed');
    console.log('이용자 정산내역서 오버플로우 클래스 추가됨');
  } else {
    element.classList.remove('overflowed'); // Ensure class is removed if not overflowed
    console.log('이용자 정산내역서 오버플로우 아님 - 클래스 제거됨');
  }
}

const removeOverflowClass = (event) => {
  const element = event.target;
  element.classList.remove('overflowed');
  console.log('이용자 정산내역서 오버플로우 클래스 제거됨');
}
</script>

<style scoped>
.action-buttons-group {
    display: flex;
    gap: 8px;
}

</style>
