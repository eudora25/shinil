<template>
  <div class="performance-register-view">
    <div class="header-title">등록 현황</div>
    
    <!-- 고정될 상단 영역 -->
    <div class="fixed-header-area" style="position: sticky; top: 0; background: white; z-index: 10; border-bottom: 1px solid #ddd;">
      <!-- 정산월과 엑셀 다운로드를 테이블 너비에 맞춰 배치 -->
      <div style="display: flex; justify-content: space-between; align-items: center; padding: 16px 16px 20px 16px; max-width: 100%;">
        <div style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
          <!-- 정산월 선택 드롭다운 -->
          <div class="info-box info-box-settlement">
            <span class="info-box-label">정산월</span>
            <select v-model="selectedSettlementMonth" class="prescription-select" @change="onSettlementMonthChange">
              <option value="">- 선택하세요 -</option>
              <option v-for="month in availableMonths" :key="month.settlement_month" :value="month.settlement_month">
                {{ month.settlement_month }}
              </option>
            </select>
          </div>
          
          <div class="info-box info-box-period">
            <span class="info-box-label">제출기간</span>
            <span class="info-box-content">{{ selectedMonthInfo ? (selectedMonthInfo.start_date + ' ~ ' + selectedMonthInfo.end_date) : '' }}</span>
          </div>
          
          <!-- 처방월 표시 -->
          <div class="info-box info-box-prescription">
            <span class="info-box-label">처방월</span>
            <select v-model="prescriptionOffset" class="prescription-select" @change="onPrescriptionOffsetChange">
              <option v-for="opt in prescriptionOptions" :key="opt.value" :value="opt.value">
                {{ opt.month }}
              </option>
            </select>
          </div>
          
          <!-- 업체 선택 -->
          <div class="info-box">
            <span class="info-box-label">업체 선택</span>
            <select 
              v-model="selectedCompanyId" 
              class="prescription-select"
              style="width: 200px;"
              @change="onCompanyChange"
            >
              <option value="">- 전체 -</option>
              <option v-for="company in companies" :key="company.id" :value="company.id">
                {{ company.company_name }}
              </option>
            </select>
          </div>
          
          <!-- 거래처 선택 -->
          <div class="info-box">
            <span class="info-box-label">거래처 선택</span>
            <select 
              v-model="selectedHospitalId" 
              class="prescription-select"
              style="width: 200px;"
              @change="onHospitalChange"
            >
              <option value="">- 전체 -</option>
              <option v-for="hospital in hospitals" :key="hospital.id" :value="hospital.id">
                {{ hospital.name }}
              </option>
            </select>
          </div>
        </div>
      </div>        
        <!-- 엑셀 다운로드 버튼을 오른쪽 끝에 -->
      <div class="top-btns">
        <button class="btn-excell-download" @click="downloadExcel" :disabled="displayRows.length === 0">
          엑셀 다운로드
        </button>
      </div>
      
      <!-- 테이블 헤더를 고정 영역에 포함 -->
      <table class="input-table" style="width: 97%; table-layout: fixed; margin: 0px 0px 0px 16px; border-bottom: none;">
        <colgroup>
          <col style="width:40px;">
          <col style="width:10%;">
          <col style="width:16%;">
          <col style="width:6%;">
          <col style="width:14%;">
          <col style="width:8%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:8%;">
          <col style="width:8%;">
          <col style="width:8%;">
        </colgroup>
        <thead>
          <tr>
            <th style="width:40px;">No</th>
            <th style="width:10%;">업체명</th>
            <th style="width:16%;">거래처</th>
            <th style="width:6%;">처방월</th>
            <th style="width:12%;">제품명</th>
            <th style="width:8%;">보험코드</th>
            <th style="width:6%;">약가</th>
            <th style="width:6%;">처방수량</th>
            <th style="width:6%;">처방액</th>
            <th style="width:6%;">처방구분</th>
            <th style="width:8%;">비고</th>
            <th style="width:8%;">등록일자</th>
            <th style="width:8%;">등록자</th>
          </tr>
        </thead>
      </table>
    </div>
    
    <!-- 스크롤 가능한 테이블 바디 영역 -->
    <div class="table-container" style="position: relative; max-height: calc(100vh - 350px); overflow-y: auto; margin-top: 0; border-top: none;">
      <table class="input-table" style="width: 100%; table-layout: fixed; margin: -16px 0px 0px 0px; border-top: none; padding: 0px 0px 0px 0px;">
        <colgroup>
          <col style="width:40px;">
          <col style="width:10%;">
          <col style="width:16%;">
          <col style="width:6%;">
          <col style="width:12%;">
          <col style="width:8%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:8%;">
          <col style="width:8%;">
          <col style="width:8%;">
        </colgroup>
        <tbody>
          <tr v-if="displayRows.length === 0">
            <td colspan="13" style="text-align:center;padding:2rem;color:#666;">
              {{ selectedSettlementMonth ? '등록된 실적이 없습니다.' : '정산월을 선택하세요.' }}
            </td>
          </tr>
          <tr v-for="(row, rowIdx) in displayRows" :key="rowIdx" v-else>
            <td style="text-align:center;">{{ rowIdx + 1 }}</td>
            <td style="text-align:left;">
              <input 
                v-model="row.company_name" 
                readonly 
                tabindex="-1" 
                style="text-align:left; background: #fff !important;"
              />
            </td>
            <td style="text-align:left;">
              <input 
                v-model="row.client_name" 
                readonly 
                tabindex="-1" 
                style="text-align:left; background: #fff !important;"
              />
            </td>
            <td style="text-align:center;">
              <input 
                v-model="row.prescription_month" 
                readonly 
                tabindex="-1" 
                style="text-align:center; background: #fff !important;"
              />
            </td>
            <td style="text-align:left;">
              <input
                v-model="row.product_name_display"
                readonly
                tabindex="-1"
                style="text-align:left; background: #fff !important;"
              />
            </td>
            <td style="text-align:center;">
              <input 
                v-model="row.insurance_code" 
                readonly 
                tabindex="-1" 
                style="text-align:center; background: #fff !important;"
              />
            </td>
            <td style="text-align:right;">
              <input 
                v-model="row.price" 
                readonly 
                tabindex="-1" 
                style="text-align:right; background: #fff !important;"
              />
            </td>
            <td style="text-align:right;">
              <input
                :value="row.prescription_qty ? Number(row.prescription_qty).toLocaleString() : ''"
                readonly
                tabindex="-1"
                style="text-align:right; background: #fff !important;"
              />
            </td>
            <td style="text-align:right;">
              <input 
                v-model="row.prescription_amount" 
                readonly 
                tabindex="-1" 
                style="text-align:right; background: #fff !important;"
              />
            </td>
            <td style="text-align:center;">
              <input
                v-model="row.prescription_type"
                readonly
                tabindex="-1"
                style="text-align:center; background: #fff !important;"
              />
            </td>
            <td style="text-align:left;">
              <input
                v-model="row.remarks"
                readonly
                tabindex="-1"
                style="text-align:left; background: #fff !important;"
              />
            </td>
            <td style="text-align:center;">
              <input
                v-model="row.created_date"
                readonly
                tabindex="-1"
                style="text-align:center; background: #fff !important;"
              />
            </td>
            <td style="text-align:left;">
              <input
                v-model="row.created_by"
                readonly
                tabindex="-1"
                style="text-align:left; background: #fff !important;"
              />
            </td>
          </tr>
        </tbody>
      </table>
      
      <div v-if="!selectedSettlementMonth" style="position:absolute;top:0;left:0;width:100%;height:100%;display:flex;align-items:center;justify-content:center;z-index:10;background:rgba(255,255,255,0.85);">
        <div style="font-size:1.3rem;color:#666;text-align:center;">정산월을 선택하세요.</div>
      </div>
    </div>
    
    <!-- 합계 고정 영역 -->
    <div style="position: sticky; bottom: 0; background: white; z-index: 10; border-top: 1px solid #ddd;">
      <table class="input-table" style="width: 100%; table-layout: fixed; margin: 0; border-top: none;">
        <colgroup>
          <col style="width:40px;">
          <col style="width:10%;">
          <col style="width:14%;">
          <col style="width:6%;">
          <col style="width:14%;">
          <col style="width:8%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:6%;">
          <col style="width:8%;">
          <col style="width:8%;">
          <col style="width:8%;">
        </colgroup>
        <tfoot>
          <tr>
            <td colspan="7" style="text-align:center;font-weight:bold;">합계</td>
            <td style="text-align:right;font-weight:bold;">{{ totalQty }}</td>
            <td style="text-align:right;font-weight:bold;">{{ totalAmount }}</td>
            <td colspan="4"></td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

// 반응형 데이터
const availableMonths = ref([]); // 선택 가능한 정산월 목록
const selectedSettlementMonth = ref(''); // 선택된 정산월
const selectedMonthInfo = ref(null); // 선택된 정산월 정보
const prescriptionMonth = ref('');
const prescriptionOffset = ref(0); // 0: 전체, 1: -1M, 2: -2M, 3: -3M
const prescriptionOptions = ref([]);

// 업체 관련
const selectedCompanyId = ref(''); // 선택된 업체 ID
const selectedCompanyInfo = ref(null); // 선택된 업체 정보
const companies = ref([]); // 업체 목록

// 병원 관련
const selectedHospitalName = ref('');
const selectedHospitalInfo = ref(null);
const selectedHospitalId = ref(''); // 빈 문자열로 초기화 (전체)
const hospitals = ref([]);

// 실적 데이터
const performanceRecords = ref([]); // DB에서 가져온 실적 데이터
const displayRows = ref([]); // 화면에 표시할 행들

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
  selectedCompanyInfo.value = null;
  
  // 거래처 선택 초기화
  selectedHospitalId.value = '';
  selectedHospitalInfo.value = null;
  
  if (selectedSettlementMonth.value) {
    fetchCompanies();
    fetchHospitals();
    fetchPerformanceRecords();
  } else {
    companies.value = [];
    hospitals.value = [];
    displayRows.value = [];
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
  selectedCompanyInfo.value = null;
  
  // 거래처 선택 초기화
  selectedHospitalId.value = '';
  selectedHospitalInfo.value = null;
  
  if (selectedSettlementMonth.value) {
    fetchCompanies();
    fetchHospitals();
    fetchPerformanceRecords();
  }
});

watch(selectedCompanyId, () => {
  // 거래처 선택 초기화
  selectedHospitalId.value = '';
  selectedHospitalInfo.value = null;
  
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
async function fetchCompanies() {
  console.log('fetchCompanies called with:', selectedSettlementMonth.value, prescriptionMonth.value, prescriptionOffset.value);
  
  if (!selectedSettlementMonth.value) {
    console.log('fetchCompanies: missing settlement month');
    companies.value = [];
    return;
  }
  
  try {
    console.log('fetchCompanies: querying database...');
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
    
    console.log('fetchCompanies: raw data from database:', data);
    if (data && data.length > 0) {
      console.log('First company record:', data[0].companies);
      console.log('Company fields:', Object.keys(data[0].companies));
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
          business_registration_number: record.companies.business_registration_number,
          representative_name: record.companies.representative_name
        });
      }
    });
    
    // 업체명으로 정렬
    companies.value = uniqueCompanies.sort((a, b) => a.company_name.localeCompare(b.company_name));
    console.log('fetchCompanies result:', companies.value);
  } catch (err) {
    console.error('업체 조회 예외:', err);
  }
}

async function fetchHospitals() {
  console.log('fetchHospitals called with:', selectedSettlementMonth.value, prescriptionMonth.value, prescriptionOffset.value, selectedCompanyId.value);
  
  if (!selectedSettlementMonth.value) {
    console.log('fetchHospitals: missing settlement month');
    hospitals.value = [];
    return;
  }
  
  try {
    console.log('fetchHospitals: querying database...');
    
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
      console.error('거래처 조회 오류:', error);
      return;
    }
    
    console.log('fetchHospitals: raw data from database:', data);
    if (data && data.length > 0) {
      console.log('First hospital record:', data[0].clients);
      console.log('Hospital fields:', Object.keys(data[0].clients));
    }
    
    // 중복 제거하여 고유한 거래처들만 추출
    const uniqueHospitals = [];
    const hospitalIds = new Set();
    
    data?.forEach(record => {
      if (!hospitalIds.has(record.client_id)) {
        hospitalIds.add(record.client_id);
        uniqueHospitals.push({
          id: record.clients.id,
          name: record.clients.name,
          business_registration_number: record.clients.business_registration_number,
          owner_name: record.clients.owner_name,
          address: record.clients.address
        });
      }
    });
    
    // 거래처명으로 정렬
    hospitals.value = uniqueHospitals.sort((a, b) => a.name.localeCompare(b.name));
    console.log('fetchHospitals result:', hospitals.value);
  } catch (err) {
    console.error('거래처 조회 예외:', err);
  }
}

// 기본 정산월 설정 함수
async function setDefaultSettlementMonth() {
  if (availableMonths.value.length === 0) return;
  
  try {
    // 가장 최근 사용 가능한 월 선택
    if (availableMonths.value.length > 0) {
      selectedSettlementMonth.value = availableMonths.value[0].settlement_month;
    }
  } catch (err) {
    console.error('기본 정산월 설정 오류:', err);
    // 오류 시 첫 번째 사용 가능한 월로 설정
    if (availableMonths.value.length > 0) {
      selectedSettlementMonth.value = availableMonths.value[0].settlement_month;
    }
  }
}

// 라이프사이클
onMounted(async () => {
  await fetchAvailableMonths();
  
  // 기본 정산월 설정 (이후 watch에서 업체, 거래처 조회됨)
  await setDefaultSettlementMonth();
});

// 이벤트 핸들러들
function onSettlementMonthChange() {
  // watch에서 처리됨
}

function onPrescriptionOffsetChange() {
  // watch에서 처리됨
}

function onCompanyChange() {
  const company = companies.value.find(c => c.id === selectedCompanyId.value);
  selectedCompanyInfo.value = company || null;
}

function onHospitalChange() {
  const hospital = hospitals.value.find(h => h.id === selectedHospitalId.value);
  selectedHospitalInfo.value = hospital || null;
  selectedHospitalName.value = hospital ? hospital.name : '';
}

// 데이터 fetch 함수들
async function fetchAvailableMonths() {
  try {
    const { data, error } = await supabase
      .from('settlement_months')
      .select('*')
      .eq('status', 'active')
      .order('settlement_month', { ascending: false });
      
    if (error) {
      console.error('정산월 조회 오류:', error);
      return;
    }
    
    availableMonths.value = data || [];
  } catch (err) {
    console.error('정산월 조회 예외:', err);
  }
}

async function fetchPerformanceRecords() {
  if (!selectedSettlementMonth.value) {
    displayRows.value = [];
    performanceRecords.value = [];
    return;
  }
  
  try {
    let query = supabase
      .from('performance_records')
      .select(`
        *,
        products!inner(product_name, insurance_code, price),
        clients!inner(name, business_registration_number, owner_name, address),
        companies!inner(company_name, business_registration_number, representative_name)
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
    
    // 병원 필터링
    if (selectedHospitalId.value) {
      query = query.eq('client_id', selectedHospitalId.value);
    }
    
    const { data, error } = await query.order('prescription_month', { ascending: false }).order('created_at', { ascending: true });
    
    if (error) {
      console.error('실적 조회 오류:', error);
      return;
    }
    
    performanceRecords.value = data || [];
    
    // 화면 표시용 데이터 변환
    const transformedData = performanceRecords.value.map(record => ({
      id: record.id,
      company_name: record.companies.company_name,
      product_name_display: record.products.product_name,
      product_id: record.product_id,
      insurance_code: record.products.insurance_code,
      price: record.products.price ? Number(record.products.price).toLocaleString() : '',
      prescription_qty: record.prescription_qty,
      prescription_amount: (record.prescription_qty * record.products.price).toLocaleString(),
      prescription_type: record.prescription_type,
      client_name: record.clients.name,
      prescription_month: record.prescription_month,
      remarks: record.remarks || '',
      created_date: record.created_at ? record.created_at.split('T')[0] : '',
      created_by: record.companies.company_name
    }));
    
    displayRows.value = transformedData;
    
  } catch (err) {
    console.error('실적 조회 예외:', err);
  }
}

// 합계 계산
const totalQty = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (Number(row.prescription_qty) || 0), 0);
  return total.toLocaleString();
});
const totalAmount = computed(() => {
  return displayRows.value.reduce((sum, row) => sum + (Number(row.prescription_amount.toString().replace(/,/g, '')) || 0), 0).toLocaleString();
});

// 엑셀 다운로드 기능
const downloadExcel = () => {
  if (displayRows.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.');
    return;
  }
  
  // 데이터 변환
  const excelData = displayRows.value.map((row, index) => ({
    'No': index + 1,
    '업체명': row.company_name || '',
    '거래처': row.client_name || '',
    '처방월': row.prescription_month || '',
    '제품명': row.product_name_display || '',
    '보험코드': row.insurance_code || '',
    '약가': Number(row.price?.toString().replace(/,/g, '')) || 0,
    '처방수량': Number(row.prescription_qty) || 0,
    '처방액': Number(row.prescription_amount?.toString().replace(/,/g, '')) || 0,
    '처방구분': row.prescription_type || '',
    '비고': row.remarks || '',
    '등록일자': row.created_date || '',
    '등록자': row.created_by || ''
  }));
  
  // 합계 행 추가
  excelData.push({
    'No': '',
    '업체명': '',
    '거래처': '',
    '처방월': '',
    '제품명': '',
    '보험코드': '',
    '약가': '합계',
    '처방수량': Number(totalQty.value.replace(/,/g, '')),
    '처방액': Number(totalAmount.value.replace(/,/g, '')),
    '처방구분': '',
    '비고': '',
    '등록일자': '',
    '등록자': ''
  });
  
  const ws = XLSX.utils.json_to_sheet(excelData);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, '실적등록현황');
  
  // 컬럼 너비 설정
  ws['!cols'] = [
    { width: 5 },  // No
    { width: 15 }, // 업체명
    { width: 20 }, // 거래처
    { width: 10 }, // 처방월
    { width: 20 }, // 제품명
    { width: 12 }, // 보험코드
    { width: 10 }, // 약가
    { width: 12 }, // 처방수량
    { width: 12 }, // 처방액
    { width: 10 }, // 처방구분
    { width: 15 }, // 비고
    { width: 15 }, // 등록일자
    { width: 15 }  // 등록자
  ];
  
  // 약가, 처방수량, 처방액 컬럼에 숫자 형식 적용 (천단위 콤마)
  const range = XLSX.utils.decode_range(ws['!ref']);
  for (let row = 1; row <= range.e.r; row++) { // 헤더 제외하고 시작
    // 약가 (7번째 컬럼, 인덱스 6)
    const priceCell = XLSX.utils.encode_cell({ r: row, c: 6 });
    if (ws[priceCell] && typeof ws[priceCell].v === 'number') {
      ws[priceCell].z = '#,##0';
    }
    
    // 처방수량 (8번째 컬럼, 인덱스 7)
    const qtyCell = XLSX.utils.encode_cell({ r: row, c: 7 });
    if (ws[qtyCell] && typeof ws[qtyCell].v === 'number') {
      ws[qtyCell].z = '#,##0';
    }
    
    // 처방액 (9번째 컬럼, 인덱스 8)
    const amountCell = XLSX.utils.encode_cell({ r: row, c: 8 });
    if (ws[amountCell] && typeof ws[amountCell].v === 'number') {
      ws[amountCell].z = '#,##0';
    }
  }
  
  // 파일명 생성
  let fileName = '실적등록현황';
  if (selectedSettlementMonth.value) {
    fileName += `_${selectedSettlementMonth.value}`;
  }
  if (prescriptionOffset.value !== 0) {
    fileName += `_${prescriptionMonth.value}`;
  }
  if (selectedCompanyInfo.value) {
    fileName += `_${selectedCompanyInfo.value.company_name}`;
  }
  if (selectedHospitalInfo.value) {
    fileName += `_${selectedHospitalInfo.value.name}`;
  }
  
  const today = new Date().toISOString().split('T')[0];
  fileName += `_${today}.xlsx`;
  
  XLSX.writeFile(wb, fileName);
};
</script> 