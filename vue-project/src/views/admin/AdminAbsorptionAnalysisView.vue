<template>
  <div class="absorption-analysis-view page-container" style="display: flex; flex-direction: column; height: 100vh;">
    <div class="page-header-title-area" style="flex-shrink: 0;">
      <div class="header-title">흡수율 분석</div>
    </div>

    <!-- 필터 카드 -->
    <div class="filter-card" style="flex-shrink: 0;">
      <div class="filter-row" style="justify-content: flex-start; align-items: flex-end; gap: 16px; flex-wrap: wrap;">
        
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
            <option v-for="company in companyOptions" :key="company.id" :value="company.id">{{ company.company_name }}</option>
          </select>
        </div>
        
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>병의원</label>
          <select v-model="selectedHospitalId" class="select_240px">
            <option v-for="hospital in hospitalOptions" :key="hospital.id" :value="hospital.id">{{ hospital.name }}</option>
          </select>
        </div>
        
      </div>
    </div>

    <!-- 데이터 카드 -->
    <div class="data-card" style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden;">
      <div class="data-card-header" style="flex-shrink: 0;">
        <div class="total-count-display">전체 {{ displayRows.length }} 건</div>
         <div v-if="!loading && displayRows.length === 0" class="header-center-message">
          흡수율 분석을 실행하세요.
        </div>
        <div class="data-card-buttons" style="margin-left: auto;">
          <button 
            class="btn-delete" 
            @click="deleteFilteredAnalysisData" 
            :disabled="displayRows.length === 0 || loading"
            style="margin-right: 1rem;"
          >
            분석 데이터 삭제
          </button>
           <button 
             class="btn-add" 
             @click="calculateAbsorptionRates" 
             :disabled="!hasCompletedData || loading"
           >
             흡수율 분석
           </button>
           <button class="btn-excell-download" @click="downloadExcel" :disabled="displayRows.length === 0">
             엑셀 다운로드
           </button>
        </div>
      </div>
      
      <div style="flex-grow: 1; overflow: hidden;">
        <DataTable 
          :value="displayRows" 
          :loading="loading"
          paginator
          :rows="100"
          :rowsPerPageOptions="[100, 200, 500, 1000]"
          scrollable 
          scrollHeight="calc(100vh - 240px)"
          class="absorption-analysis-table"
          v-model:first="currentPageFirstIndex"

          :pt="{
            wrapper: { style: 'min-width: 2600px;' },
            table: { style: 'min-width: 2600px;' }
          }"
        >
          <template #empty>
            <div v-if="loading">데이터를 불러오는 중입니다.</div>
            <div v-else></div>
          </template>
          
          <Column header="No" :headerStyle="{ width: columnWidths.no }" :frozen="true">
            <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
          </Column>
          
          <Column header="작업" field="review_action" :headerStyle="{ width: columnWidths.review_action }" :frozen="true">
            <template #body="slotProps">
              <Tag v-if="slotProps.data.review_action" :value="slotProps.data.review_action" :severity="getActionSeverity(slotProps.data.review_action)"/>
            </template>
          </Column>

          <Column field="company_type" header="구분" :headerStyle="{ width: columnWidths.company_type }" :sortable="true" :frozen="true" />
          <Column field="company_name" header="업체명" :headerStyle="{ width: columnWidths.company_name }" :sortable="true" :frozen="true" />
          <Column field="client_name" header="병의원명" :headerStyle="{ width: columnWidths.client_name }" :sortable="true" :frozen="true" />
          
          <Column field="prescription_month" header="처방월" :headerStyle="{ width: columnWidths.prescription_month }" :sortable="true" />
          <Column field="product_name_display" header="제품명" :headerStyle="{ width: columnWidths.product_name_display }" :sortable="true" :frozen="true" />
          <Column field="insurance_code" header="보험코드" :headerStyle="{ width: columnWidths.insurance_code }" :sortable="true" />
          <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true" />
          <Column field="prescription_qty" header="수량" :headerStyle="{ width: columnWidths.prescription_qty }" :sortable="true">
            <template #body="slotProps">
              {{ Number(slotProps.data.prescription_qty).toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 }) }}
            </template>
          </Column>
          <Column field="prescription_amount" header="처방액" :headerStyle="{ width: columnWidths.prescription_amount }" :sortable="true" />
          <Column field="prescription_type" header="처방구분" :headerStyle="{ width: columnWidths.prescription_type }" :sortable="true" />
          
          <Column field="wholesale_revenue" header="도매매출" :headerStyle="{ width: columnWidths.wholesale_revenue }" :sortable="true">
            <template #body="slotProps">
              <span :title="Math.floor(slotProps.data.wholesale_revenue || 0).toLocaleString()">
                {{ Math.floor(slotProps.data.wholesale_revenue || 0).toLocaleString() }}
              </span>
            </template>
          </Column>
          <Column field="direct_revenue" header="직거래매출" :headerStyle="{ width: columnWidths.direct_revenue }" :sortable="true">
             <template #body="slotProps">
              <span :title="Math.floor(slotProps.data.direct_revenue || 0).toLocaleString()">
                {{ Math.floor(slotProps.data.direct_revenue || 0).toLocaleString() }}
              </span>
            </template>
          </Column>
          <Column field="total_revenue" header="합산액" :headerStyle="{ width: columnWidths.total_revenue }" :sortable="true">
             <template #body="slotProps">
              <span :title="Math.floor(slotProps.data.total_revenue || 0).toLocaleString()">
                {{ Math.floor(slotProps.data.total_revenue || 0).toLocaleString() }}
              </span>
            </template>
          </Column>
          <Column field="absorption_rate" header="흡수율" :headerStyle="{ width: columnWidths.absorption_rate }" :sortable="true">
             <template #body="slotProps">
              <span :title="slotProps.data.absorption_rate + '%'">
                {{ slotProps.data.absorption_rate }}%
              </span>
            </template>
          </Column>

          <Column field="commission_rate" header="수수료율" :headerStyle="{ width: columnWidths.commission_rate }" :sortable="true">
            <template #body="slotProps">
              <span :title="slotProps.data.commission_rate">{{ slotProps.data.commission_rate }}</span>
            </template>
          </Column>
          <Column field="payment_amount" header="지급액" :headerStyle="{ width: columnWidths.payment_amount }" :sortable="true">
            <template #body="slotProps">
              <span :title="slotProps.data.payment_amount">{{ slotProps.data.payment_amount }}</span>
            </template>
          </Column>
          <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true">
            <template #body="slotProps">
              <span :title="slotProps.data.remarks">{{ slotProps.data.remarks }}</span>
            </template>
          </Column>
          <Column field="created_date" header="등록일시" :headerStyle="{ width: columnWidths.created_date }" :sortable="true">
            <template #body="slotProps">
              <span :title="slotProps.data.created_date">{{ slotProps.data.created_date }}</span>
            </template>
          </Column>
          <Column field="created_by" header="등록자" :headerStyle="{ width: columnWidths.created_by }" :sortable="true">
            <template #body="slotProps">
              <span :title="slotProps.data.created_by">{{ slotProps.data.created_by }}</span>
            </template>
          </Column>

          <ColumnGroup type="footer">
            <Row>
              <Column footer="합계" :colspan="5" footerClass="footer-cell" footerStyle="text-align:center;" :frozen="true" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" :frozen="true" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column :footer="totalQuantity" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalPrescriptionAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column footer="" footerClass="footer-cell" />
              <Column :footer="totalWholesaleRevenue" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalDirectRevenue" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalCombinedRevenue" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="averageAbsorptionRate" footerClass="footer-cell" footerStyle="text-align:center !important;" />
              <Column :footer="averageCommissionRate" footerClass="footer-cell" footerStyle="text-align:center !important;" />
              <Column :footer="totalPaymentAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
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
import Tag from 'primevue/tag';
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

const columnWidths = {
  no: '3.5%',
  review_action: '3.5%',
  company_type: '7%',
  company_name: '9%',
  client_name: '16%',
  prescription_month: '6%',
  product_name_display: '16%',
  insurance_code: '6.5%',
  price: '6%',
  prescription_qty: '7%',
  prescription_amount: '7%',
  prescription_type: '7%',
  wholesale_revenue: '7%',
  direct_revenue: '7%',
  total_revenue: '7%',
  absorption_rate: '5%',
  commission_rate: '5%',
  payment_amount: '7%',
  remarks: '12%',
  created_date: '8%',
  created_by: '9%'
};

// --- 상태 변수 정의 ---
const loading = ref(false);
const displayRows = ref([]);
const availableMonths = ref([]);
const companyOptions = ref([]);
const hospitalOptions = ref([]);
const prescriptionOptions = ref([]);
const currentPageFirstIndex = ref(0);

// 필터 선택값
const selectedSettlementMonth = ref('');
const selectedCompanyId = ref('ALL');
const selectedHospitalId = ref('ALL');
const prescriptionOffset = ref(0);

// 새로운 상태 변수들
const hasCompletedData = ref(false);
const changes = ref({
  added_count: 0,
  modified_count: 0,
  deleted_count: 0,
});
const showChangesModal = ref(false);
const changeInfo = ref({
  updated_reviews: 0,
  updated_mappings: 0,
  updated_sales: 0
});

// --- 합계 계산 ---
const totalPrescriptionAmount = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (Number(String(row.prescription_amount).replace(/,/g, '')) || 0), 0);
  return total.toLocaleString();
});

const totalWholesaleRevenue = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (row.wholesale_revenue || 0), 0);
  return Math.floor(total).toLocaleString();
});

const totalDirectRevenue = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (row.direct_revenue || 0), 0);
  return Math.floor(total).toLocaleString();
});

const totalCombinedRevenue = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (row.total_revenue || 0), 0);
  return Math.floor(total).toLocaleString();
});

const totalPaymentAmount = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (Number(String(row.payment_amount).replace(/,/g, '')) || 0), 0);
  return total.toLocaleString();
});

// --- Computed 속성 (버튼 활성화 로직) ---

// --- Computed 속성 (합계 계산) ---
const totalQuantity = computed(() => {
  const total = displayRows.value.reduce((sum, row) => sum + (Number(row.prescription_qty) || 0), 0);
  return total.toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 });
});

const averageAbsorptionRate = computed(() => {
  if (!displayRows.value || displayRows.value.length === 0) return '- %';

  const rates = displayRows.value
    .map(row => parseFloat(row.absorption_rate))
    .filter(rate => !isNaN(rate));
    
  if (rates.length === 0) return '- %';

  const total = rates.reduce((sum, rate) => sum + rate, 0);
  const average = total / rates.length;
  
  return `${average.toFixed(1)}%`;
});

const averageCommissionRate = computed(() => {
  if (!displayRows.value || displayRows.value.length === 0) return '- %';

  const rates = displayRows.value
    .map(row => parseFloat(row.commission_rate))
    .filter(rate => !isNaN(rate));
    
  if (rates.length === 0) return '- %';

  const total = rates.reduce((sum, rate) => sum + rate, 0);
  const average = total / rates.length;

  return `${average.toFixed(1)}%`;
});

// --- 초기화 및 데이터 로딩 ---
onMounted(async () => {
  await fetchAvailableMonths();
});

async function fetchAvailableMonths() {
  try {
    const { data, error } = await supabase
      .from('settlement_months')
      .select('settlement_month')
      .order('settlement_month', { ascending: false });

    if (error) throw error;
    
    availableMonths.value = data;

    if (data.length > 0) {
      selectedSettlementMonth.value = data[0].settlement_month;
    }
  } catch (err) { console.error('정산월 조회 오류:', err); }
}

async function fetchCompaniesForMonth() {
  if (!selectedSettlementMonth.value) {
    companyOptions.value = [{ id: 'ALL', company_name: '- 전체 -' }];
    return;
  }
  try {
    // === 1,000행 제한 해결: 전체 데이터 가져오기 ===
    let allData = [];
    let from = 0;
    const batchSize = 1000;
    
    while (true) {
    const { data, error } = await supabase
      .from('performance_records')
      .select('company_id, companies ( company_name, company_group )')
      .eq('settlement_month', selectedSettlementMonth.value)
      .eq('review_status', '완료')
        .not('company_id', 'is', null)
        .range(from, from + batchSize - 1);

    if (error) throw error;
    
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
    
    const uniqueCompanies = Array.from(new Map(allData.map(item => [item.company_id, { id: item.company_id, company_name: item.companies.company_name, company_group: item.companies.company_group }])).values());
    const sortedCompanies = uniqueCompanies.sort((a, b) => a.company_name.localeCompare(b.company_name));
    companyOptions.value = [{ id: 'ALL', company_name: '- 전체 -' }, ...sortedCompanies];
    selectedCompanyId.value = 'ALL';
  } catch (err) {
    console.error('해당 월의 업체 조회 오류:', err);
    companyOptions.value = [{ id: 'ALL', company_name: '- 전체 -' }];
  }
}

async function fetchClientsForMonth(companyId = null) {
    if (!selectedSettlementMonth.value) {
        hospitalOptions.value = [{ id: 'ALL', name: '- 전체 -' }];
        return;
    }
    try {
        let query = supabase
          .from('performance_records')
          .select('client_id, clients ( name )')
          .eq('settlement_month', selectedSettlementMonth.value)
          .eq('review_status', '완료')
          .not('client_id', 'is', null);

        const finalCompanyId = companyId || (selectedCompanyId.value === 'ALL' ? null : selectedCompanyId.value);
        if (finalCompanyId) {
            query = query.eq('company_id', finalCompanyId);
        }

        // === 1,000행 제한 해결: 전체 데이터 가져오기 ===
        let allData = [];
        let from = 0;
        const batchSize = 1000;
        
        while (true) {
          const { data, error } = await query
            .range(from, from + batchSize - 1);

        if (error) throw error;

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

        const uniqueClients = Array.from(new Map(allData.map(item => [item.client_id, { id: item.client_id, name: item.clients.name }])).values());
        const sortedClients = uniqueClients.sort((a, b) => a.name.localeCompare(b.name));
        hospitalOptions.value = [{ id: 'ALL', name: '- 전체 -' }, ...sortedClients];
        selectedHospitalId.value = 'ALL';
    } catch (err) {
        console.error('해당 월의 거래처 조회 오류:', err);
        hospitalOptions.value = [{ id: 'ALL', name: '- 전체 -' }];
    }
}

// --- 분석 상태 확인 및 변경 감지 함수 ---
const checkAnalysisStatus = async () => {
  if (!selectedSettlementMonth.value) return;
  loading.value = true;
  try {
    // 분석할 원본 데이터(완료 상태)가 있는지 확인
    const { count: completedCount, error: completedError } = await supabase
      .from('performance_records')
      .select('id', { count: 'exact', head: true })
      .eq('settlement_month', selectedSettlementMonth.value)
      .eq('review_status', '완료');
    if (completedError) throw completedError;
    hasCompletedData.value = (completedCount || 0) > 0;

  } catch (err) {
    console.error('분석 상태 확인 중 오류:', err);
    hasCompletedData.value = false;
  } finally {
    loading.value = false;
  }
};

// 정산월 변경 시 상태 확인 함수 호출
watch(selectedSettlementMonth, checkAnalysisStatus, { immediate: true });

// --- 핵심 데이터 처리 함수 ---
async function loadAbsorptionAnalysisResults() {
  if (!selectedSettlementMonth.value) return;
  
  loading.value = true;
  displayRows.value = [];
  
  try {
    let allData = [];
    
    if (selectedCompanyId.value === 'ALL') {
      // === 전체 조회 시: 각 업체별로 개별 쿼리 실행 ===
      console.log('=== 전체 조회: 업체별 개별 쿼리 시작 ===');
      
      const availableCompanies = companyOptions.value.filter(company => company.id !== 'ALL');
      console.log(`처리할 업체 수: ${availableCompanies.length}개`);
      
      for (const company of availableCompanies) {
        console.log(`업체 처리 중: ${company.company_name} (ID: ${company.id})`);
        
        let companyQuery = supabase
          .from('performance_records_absorption')
          .select(`
            *,
            company:companies(company_name, company_group),
            client:clients(name),
            product:products(product_name, insurance_code, price)
          `)
          .eq('settlement_month', selectedSettlementMonth.value)
          .eq('company_id', company.id);
        
        if (selectedHospitalId.value !== 'ALL') {
          companyQuery = companyQuery.eq('client_id', selectedHospitalId.value);
        }
        
        if (prescriptionOffset.value !== 0) {
          const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
          companyQuery = companyQuery.eq('prescription_month', prescriptionMonth);
        }
        
        // 업체별 배치 처리
        let companyData = [];
        let from = 0;
        const batchSize = 1000;
        
        while (true) {
          const { data, error } = await companyQuery
            .range(from, from + batchSize - 1)
            .order('created_at', { ascending: false });
          
          if (error) throw error;
          
          if (!data || data.length === 0) {
            break;
          }
          
          companyData = companyData.concat(data);
          
          if (data.length < batchSize) {
            break;
          }
          
          from += batchSize;
        }
        
        console.log(`${company.company_name}: ${companyData.length}건`);
        allData = allData.concat(companyData);
      }
      
      console.log(`전체 업체 합계: ${allData.length}건`);
      console.log('=== 업체별 개별 쿼리 완료 ===');
      
    } else {
      // === 개별 업체 조회 시: 기존 로직 ===
      console.log('=== 개별 업체 조회 시작 ===');
      
      let query = supabase
        .from('performance_records_absorption')
        .select(`
          *,
          company:companies(company_name, company_group),
          client:clients(name),
          product:products(product_name, insurance_code, price)
        `)
        .eq('settlement_month', selectedSettlementMonth.value)
        .eq('company_id', selectedCompanyId.value);
      
      if (selectedHospitalId.value !== 'ALL') {
        query = query.eq('client_id', selectedHospitalId.value);
      }
      
      if (prescriptionOffset.value !== 0) {
        const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
        query = query.eq('prescription_month', prescriptionMonth);
      }
      
      // 배치 처리
      let from = 0;
      const batchSize = 1000;
      
      while (true) {
        const { data, error } = await query
          .range(from, from + batchSize - 1)
          .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        if (!data || data.length === 0) {
          break;
        }
        
        allData = allData.concat(data);
        
        if (data.length < batchSize) {
          break;
        }
        
        from += batchSize;
      }
      
      console.log(`개별 업체 조회 완료: ${allData.length}건`);
    }

    console.log('=== 데이터 매핑 전 검증 ===');
    console.log(`매핑 전 원본 데이터: ${allData.length}건`);
    
    // NULL 값 체크
    const companyNullCount = allData.filter(row => !row.company).length;
    const clientNullCount = allData.filter(row => !row.client).length;
    const productNullCount = allData.filter(row => !row.product).length;
    
    console.log(`회사 정보 NULL: ${companyNullCount}건`);
    console.log(`병원 정보 NULL: ${clientNullCount}건`);
    console.log(`제품 정보 NULL: ${productNullCount}건`);

    let mappedData = allData.map(row => {
        const prescriptionAmount = Math.round((row.prescription_qty || 0) * (row.product?.price || 0));
        const paymentAmount = Math.round(prescriptionAmount * (row.commission_rate || 0));

        return {
            ...row,
            company_type: row.company?.company_group || 'N/A',
            company_name: row.company?.company_name || 'N/A',
            client_name: row.client?.name || 'N/A',
            product_name_display: row.product?.product_name || 'N/A',
            insurance_code: row.product?.insurance_code || 'N/A',
            price: row.product?.price ? Math.round(row.product.price).toLocaleString() : '0',
            prescription_amount: prescriptionAmount.toLocaleString(),
            payment_amount: paymentAmount.toLocaleString(),
            commission_rate: `${((row.commission_rate || 0) * 100).toFixed(1)}%`,
            absorption_rate: ((row.absorption_rate || 0) * 100).toFixed(1),
            created_date: formatDateTime(row.created_at),
        };
    });
    
    console.log(`매핑 후 데이터: ${mappedData.length}건`);
    console.log('=== 데이터 매핑 완료 ===');

    const actionOrder = { '추가': 1, '수정': 2, '삭제': 3 };
    mappedData.sort((a, b) => {
      const orderA_action = actionOrder[a.review_action] || 4;
      const orderB_action = actionOrder[b.review_action] || 4;
      if (orderA_action !== orderB_action) return orderA_action - orderB_action;

      if (a.company_type !== b.company_type) return a.company_type.localeCompare(b.company_type, 'ko');
      if (a.company_name !== b.company_name) return a.company_name.localeCompare(b.company_name, 'ko');
      if (a.client_name !== b.client_name) return a.client_name.localeCompare(b.client_name, 'ko');
      if (a.product_name_display !== b.product_name_display) return a.product_name_display.localeCompare(b.product_name_display, 'ko');

      return (b.prescription_qty || 0) - (a.prescription_qty || 0);
    });
    
    displayRows.value = mappedData;

    // === 업체별 개수 콘솔 로그 ===
    console.log('=== 흡수율 분석 결과 업체별 개수 ===');
    console.log(`전체 데이터: ${mappedData.length}건`);
    console.log(`선택된 업체: ${selectedCompanyId.value === 'ALL' ? '전체' : companyOptions.value.find(c => c.id === selectedCompanyId.value)?.company_name || selectedCompanyId.value}`);
    
    // 업체별 집계
    const companyCount = {};
    mappedData.forEach(row => {
      const companyName = row.company_name || 'N/A';
      companyCount[companyName] = (companyCount[companyName] || 0) + 1;
    });
    
    // 업체별 개수 출력 (많은 순으로 정렬)
    const sortedCompanies = Object.entries(companyCount).sort((a, b) => b[1] - a[1]);
    sortedCompanies.forEach(([company, count]) => {
      console.log(`${company}: ${count}건`);
    });
    console.log('=====================================');

  } catch (err) {
    console.error('분석 결과 데이터 로딩 오류:', err);
    alert(`분석 결과 데이터 로딩 중 오류가 발생했습니다: ${err.message}`);
  } finally {
    loading.value = false;
  }
}

// --- Watchers ---
watch(selectedSettlementMonth, async (newMonth) => {
  if (newMonth) { 
    await fetchCompaniesForMonth();
    await fetchClientsForMonth(null);
    updatePrescriptionOptions();
    prescriptionOffset.value = 0;
    await checkAnalysisStatus();
    await loadAbsorptionAnalysisResults();
  }
});

watch(selectedCompanyId, async (newCompanyId) => {
  await fetchClientsForMonth(newCompanyId === 'ALL' ? null : newCompanyId);
  
  // 업체 변경 시, 현재 선택된 병의원이 새 업체 목록에 없으면 병의원 선택을 '전체'로 초기화
  if (selectedHospitalId.value !== 'ALL') {
    const isHospitalInList = hospitalOptions.value.some(h => h.id === selectedHospitalId.value);
    if (!isHospitalInList) {
      selectedHospitalId.value = 'ALL';
    }
  }
  
  // 분석 데이터가 있으면 필터링된 결과 로딩
  if (selectedSettlementMonth.value) {
    await loadAbsorptionAnalysisResults();
  }
});

watch(selectedHospitalId, async () => {
  // 분석 데이터가 있으면 필터링된 결과 로딩
  if (selectedSettlementMonth.value) {
    await loadAbsorptionAnalysisResults();
  }
});

watch(prescriptionOffset, async () => {
  // 분석 데이터가 있으면 필터링된 결과 로딩
  if (selectedSettlementMonth.value) {
    await loadAbsorptionAnalysisResults();
  }
});

// --- 유틸리티 함수 ---
const calculateAbsorptionRates = async () => {
  if (!selectedSettlementMonth.value) {
    alert('정산월을 선택해주세요.');
    return;
  }

  // 필터 조건 확인 메시지
  const companyName = selectedCompanyId.value === 'ALL' ? '전체' : companyOptions.value.find(c => c.id === selectedCompanyId.value)?.company_name;
  const hospitalName = selectedHospitalId.value === 'ALL' ? '전체' : hospitalOptions.value.find(h => h.id === selectedHospitalId.value)?.name;
  const prescriptionMonthText = prescriptionOffset.value === 0 ? '전체' : getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);

  if (!confirm(`'${selectedSettlementMonth.value}'월의 흡수율 분석을 시작합니다.\n\n조건: ${companyName} / ${hospitalName} / ${prescriptionMonthText}\n\n1단계: 필터 조건에 맞는 분석 데이터 생성\n2단계: 흡수율 계산`)) {
    return;
  }

  loading.value = true;
  try {
    // 1단계: 필터 조건에 맞는 원본 데이터 복사
    console.log(`1단계 시작: ${selectedSettlementMonth.value} 필터링된 데이터 복사`);
    
    // 먼저 기존 분석 데이터에서 해당 조건의 데이터 삭제
    let deleteQuery = supabase
      .from('performance_records_absorption')
      .delete()
      .eq('settlement_month', selectedSettlementMonth.value);
    
    if (selectedCompanyId.value !== 'ALL') {
      deleteQuery = deleteQuery.eq('company_id', selectedCompanyId.value);
    }
    if (selectedHospitalId.value !== 'ALL') {
      deleteQuery = deleteQuery.eq('client_id', selectedHospitalId.value);
    }
    if (prescriptionOffset.value !== 0) {
      const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
      deleteQuery = deleteQuery.eq('prescription_month', prescriptionMonth);
    }

    const { error: deleteError } = await deleteQuery;
    if (deleteError) {
      console.warn('기존 분석 데이터 삭제 중 오류 (무시):', deleteError);
    }

    // 필터 조건에 맞는 performance_records 데이터 조회
    let sourceQuery = supabase
      .from('performance_records')
      .select('*')
      .eq('settlement_month', selectedSettlementMonth.value)
      .eq('review_status', '완료');
    
    if (selectedCompanyId.value !== 'ALL') {
      sourceQuery = sourceQuery.eq('company_id', selectedCompanyId.value);
    }
    if (selectedHospitalId.value !== 'ALL') {
      sourceQuery = sourceQuery.eq('client_id', selectedHospitalId.value);
    }
    if (prescriptionOffset.value !== 0) {
      const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
      sourceQuery = sourceQuery.eq('prescription_month', prescriptionMonth);
    }

    // === 전체 데이터 조회 (1,000건 제한 해결) ===
    let allSourceData = [];
    let from = 0;
    const batchSize = 1000;
    
    while (true) {
      const { data, error } = await sourceQuery
        .range(from, from + batchSize - 1);
      
      if (error) throw error;

      if (!data || data.length === 0) {
        break;
      }
      
      allSourceData = allSourceData.concat(data);
      
      if (data.length < batchSize) {
        break;
      }
      
      from += batchSize;
    }

    if (allSourceData.length === 0) {
      alert('필터 조건에 맞는 완료된 실적 데이터가 없습니다.');
      return;
    }

    console.log(`${allSourceData.length}건의 실적 데이터를 분석용 테이블로 복사`);

    // performance_records_absorption에 데이터 복사 (올바른 컬럼만 포함)
    const insertBatchSize = 1000;
    let insertedCount = 0;
    
    for (let i = 0; i < allSourceData.length; i += insertBatchSize) {
      const batchData = allSourceData.slice(i, i + insertBatchSize);
      
      const { error: insertError } = await supabase
        .from('performance_records_absorption')
        .insert(batchData.map(record => ({
          id: record.id, // 원본 performance_records의 id 사용
          settlement_month: record.settlement_month,
          company_id: record.company_id,
          client_id: record.client_id,
          product_id: record.product_id,
          prescription_month: record.prescription_month,
          prescription_qty: record.prescription_qty,
          prescription_type: record.prescription_type,
          commission_rate: record.commission_rate,
          remarks: record.remarks,
          registered_by: record.registered_by,
          review_action: record.review_action, // review_action 필드 추가
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })));

      if (insertError) throw insertError;
      
      insertedCount += batchData.length;
      console.log(`${insertedCount}/${allSourceData.length}건 복사 완료`);
    }

    console.log('1단계 완료.');
    alert('1단계(필터링된 데이터 복사)가 완료되었습니다. 2단계(흡수율 계산)를 시작합니다.');
    
    // 2단계: 흡수율 계산 (복사된 데이터에 대해서만)
    console.log(`2단계 시작: 복사된 ${insertedCount}건 데이터의 흡수율 계산`);
    const { error: step2Error } = await supabase.rpc('calculate_absorption_rates_for_month', {
      p_settlement_month: selectedSettlementMonth.value
    });
     if (step2Error) {
      console.error('2단계 오류:', step2Error);
      throw new Error(`2단계(흡수율 계산) 실패: ${step2Error.message}`);
    }
    console.log('2단계 완료.');

    alert(`흡수율 분석이 완료되었습니다. (${insertedCount}건 처리)`);
    await checkAnalysisStatus();
    await loadAbsorptionAnalysisResults();

  } catch (err) {
    console.error('흡수율 분석 실행 오류:', JSON.stringify(err, null, 2));
    alert(`흡수율 분석 중 오류가 발생했습니다: ${err.message}`);
  } finally {
    loading.value = false;
  }
}

function getPrescriptionMonth(settlementMonth, offset) {
  if (!settlementMonth || offset === null) return '';
  const [y, m] = settlementMonth.split('-');
  let month = parseInt(m, 10) - offset;
  let year = parseInt(y, 10);
  while (month <= 0) { month += 12; year -= 1; }
  return `${year}-${String(month).padStart(2, '0')}`;
}

function updatePrescriptionOptions() {
  prescriptionOptions.value = [
    { value: 0, month: '- 전체 -' },
    ...[1, 2, 3].map(offset => ({
      value: offset,
      month: getPrescriptionMonth(selectedSettlementMonth.value, offset)
    }))
  ];
}

function getActionSeverity(action) {
  if (action === '수정') return 'info';
  if (action === '추가') return 'success';
  if (action === '삭제') return 'danger';
  return 'secondary';
}

function formatDateTime(dateTimeString) {
  if (!dateTimeString) return '-';
  const date = new Date(dateTimeString);
  const kstOffset = 9 * 60 * 60 * 1000;
  const kstDate = new Date(date.getTime() + kstOffset);
  return kstDate.toISOString().slice(0, 16).replace('T', ' ');
}

async function downloadExcel() {
  if (displayRows.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.');
    return;
  }

  try {
    // 1. 등록자 UUID -> company_name 매핑을 위한 companies 조회
    const { data: companies, error } = await supabase
      .from('companies')
      .select('user_id, company_name');
    
    if (error) throw error;
    
    // UUID -> company_name 매핑 객체 생성
    const userCompanyMap = {};
    companies.forEach(company => {
      if (company.user_id) {
        userCompanyMap[company.user_id] = company.company_name;
      }
    });

    // 2. 데이터 변환
    const dataToExport = displayRows.value.map((row, index) => ({
      'No': index + 1,
      '작업': row.review_action || '-',
      '구분': row.company_type,
      '업체명': row.company_name,
      '병의원명': row.client_name,
      '처방월': row.prescription_month,
      '제품명': row.product_name_display,
      '보험코드': row.insurance_code,
      '약가': Math.round(Number(String(row.price).replace(/,/g, '')) || 0),
      '수량': Number(row.prescription_qty) || 0,
      '처방액': Math.round(Number(String(row.prescription_amount).replace(/,/g, '')) || 0),
      '처방구분': row.prescription_type,
      '도매매출': Math.round(row.wholesale_revenue || 0),
      '직거래매출': Math.round(row.direct_revenue || 0),
      '합산액': Math.round(row.total_revenue || 0),
      '흡수율': parseFloat(row.absorption_rate) / 100 || 0,
      '수수료율': parseFloat(String(row.commission_rate).replace('%', '')) / 100 || 0,
      '지급액': Math.round(Number(String(row.payment_amount).replace(/,/g, '')) || 0),
      '비고': row.remarks,
      '등록일시': row.created_date,
      '등록자': userCompanyMap[row.registered_by] || row.registered_by || '-'
    }));

    // 합계 행 추가
    dataToExport.push({
      'No': '합계',
      '작업': '',
      '구분': '',
      '업체명': '',
      '병의원명': '',
      '처방월': '',
      '제품명': '',
      '보험코드': '',
      '약가': '',
      '수량': Number(totalQuantity.value.replace(/,/g, '')),
      '처방액': Number(totalPrescriptionAmount.value.replace(/,/g, '')),
      '처방구분': '',
      '도매매출': Number(totalWholesaleRevenue.value.replace(/,/g, '')),
      '직거래매출': Number(totalDirectRevenue.value.replace(/,/g, '')),
      '합산액': Number(totalCombinedRevenue.value.replace(/,/g, '')),
      '흡수율': '',
      '수수료율': '',
      '지급액': Number(totalPaymentAmount.value.replace(/,/g, '')),
      '비고': '',
      '등록일시': '',
      '등록자': ''
    });

    // 3. 워크시트 생성
    const worksheet = XLSX.utils.json_to_sheet(dataToExport);

    // 4. 셀 서식 지정
    const range = XLSX.utils.decode_range(worksheet['!ref']);
    for (let R = range.s.r + 1; R <= range.e.r; ++R) {
      // 숫자 컬럼들 (천 단위 콤마, 소수점 없음)
      const numberCols = [8, 10, 12, 13, 14, 17]; // 약가, 처방액, 도매매출, 직거래매출, 합산액, 지급액
      numberCols.forEach(col => {
        const cell = worksheet[XLSX.utils.encode_cell({c: col, r: R})];
        if (cell && typeof cell.v === 'number') {
          cell.z = '#,##0';
        }
      });

      // 수량 컬럼 (소수점 1자리)
      const qtyCell = worksheet[XLSX.utils.encode_cell({c: 9, r: R})];
      if (qtyCell && typeof qtyCell.v === 'number') {
        qtyCell.z = '#,##0.0';
      }

      // 백분율 컬럼들 (소수점 1자리)
      const percentCols = [15, 16]; // 흡수율, 수수료율
      percentCols.forEach(col => {
        const cell = worksheet[XLSX.utils.encode_cell({c: col, r: R})];
        if (cell && typeof cell.v === 'number') {
          cell.z = '0.0%';
        }
      });
    }

    // 5. 파일 다운로드
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, '흡수율 분석');
    XLSX.writeFile(workbook, '흡수율_분석_데이터.xlsx');

  } catch (err) {
    console.error('엑셀 다운로드 오류:', err);
    alert('엑셀 다운로드 중 오류가 발생했습니다.');
  }
}

async function deleteFilteredAnalysisData() {
  if (!selectedSettlementMonth.value) {
    alert('정산월을 선택해주세요.');
    return;
  }

  if (!confirm(`'${selectedSettlementMonth.value}'월의 현재 필터 조건(${selectedCompanyId.value === 'ALL' ? '전체' : companyOptions.value.find(c => c.id === selectedCompanyId.value)?.company_name}, ${selectedHospitalId.value === 'ALL' ? '전체' : hospitalOptions.value.find(h => h.id === selectedHospitalId.value)?.name}, ${prescriptionOffset.value === 0 ? '전체' : getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value)})에 해당하는 흡수율 분석 데이터를 삭제하시겠습니까?`)) {
    return;
  }

     loading.value = true;
   try {
     // === 전체 데이터 조회 (1,000건 제한 해결) ===
     let allIds = [];
     let from = 0;
     const batchSize = 1000;
     
     while (true) {
       let query = supabase
         .from('performance_records_absorption')
         .select('id')
         .eq('settlement_month', selectedSettlementMonth.value);
       
       if (selectedCompanyId.value !== 'ALL') {
         query = query.eq('company_id', selectedCompanyId.value);
       }
       if (selectedHospitalId.value !== 'ALL') {
         query = query.eq('client_id', selectedHospitalId.value);
       }
       
       if (prescriptionOffset.value !== 0) {
         const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
         query = query.eq('prescription_month', prescriptionMonth);
       }

       const { data, error } = await query
         .range(from, from + batchSize - 1);
       
       if (error) throw error;

       if (!data || data.length === 0) {
         break;
       }
       
       allIds = allIds.concat(data.map(item => item.id));
       
       // 가져온 데이터가 batchSize보다 적으면 마지막 배치
       if (data.length < batchSize) {
         break;
       }
       
       from += batchSize;
     }

     if (allIds.length === 0) {
       alert('삭제할 흡수율 분석 데이터가 없습니다.');
       return;
     }

     console.log(`총 ${allIds.length}건의 데이터를 삭제합니다.`);

     // === 배치 단위로 삭제 (Supabase 삭제 제한 대응) ===
     const deleteBatchSize = 1000;
     let deletedCount = 0;
     
     for (let i = 0; i < allIds.length; i += deleteBatchSize) {
       const batchIds = allIds.slice(i, i + deleteBatchSize);
       
       const { error: deleteError } = await supabase
         .from('performance_records_absorption')
         .delete()
         .in('id', batchIds);

       if (deleteError) throw deleteError;
       
       deletedCount += batchIds.length;
       console.log(`${deletedCount}/${allIds.length}건 삭제 완료`);
     }

     alert(`흡수율 분석 데이터 ${deletedCount}건이 삭제되었습니다.`);
     await loadAbsorptionAnalysisResults();

  } catch (err) {
    console.error('흡수율 분석 데이터 삭제 오류:', err);
    alert(`흡수율 분석 데이터 삭제 중 오류가 발생했습니다: ${err.message}`);
  } finally {
    loading.value = false;
  }
}

</script>

<style scoped>
.absorption-analysis-view { padding: 0px; }
.data-card-buttons { display: flex; gap: 8px; }

/* 셀 배경색을 흰색으로 지정 */
:deep(.p-datatable-tbody > tr > td) {
  background: #ffffff !important;
}


:deep(.p-datatable-tfoot > tr > td) {
    background: #f8f9fa !important;
    font-weight: bold;
}
</style> 