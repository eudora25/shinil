<template>
  <div class="performance-review-view page-container" style="display: flex; flex-direction: column; height: 100vh;">
    <div class="page-header-title-area" style="flex-shrink: 0;">
      <div class="header-title">실적 검수</div>
    </div>

    <!-- 필터 카드 -->
    <div class="filter-card" style="flex-shrink: 0;" :class="{ 'disabled-area': isAnyEditing }">
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
            <option v-for="company in companyOptions" :key="company.id" :value="company.id">{{ company.company_name }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>병의원</label>
          <select v-model="selectedHospitalId" class="select_240px">
            <option v-for="hospital in hospitalOptions" :key="hospital.id" :value="hospital.id">{{ hospital.name }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <label>상태</label>
          <select v-model="selectedStatus" class="select_100px">
            <option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
          </select>
        </div>
        <div style="display: flex; align-items: center; gap: 8px; margin-left: 16px;">
          <button 
            class="btn-primary" 
            @click="loadPerformanceData" 
            :disabled="loading || isAnyEditing"
          >
            불러오기
          </button>
        </div>
      </div>
    </div>

    <!-- 데이터 카드 -->
    <div class="data-card" style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden;">
      <div class="data-card-header" style="flex-shrink: 0;">
        <div class="total-count-display">전체 {{ displayRows.length }} 건</div>
        <div v-if="!loading && displayRows.length === 0" class="header-center-message">
          필터 조건을 선택하고 '불러오기'를 클릭하세요.
        </div>
        <div class="data-card-buttons" style="margin-left: auto;">
           <button class="btn-secondary" @click="selectAll" :disabled="isAnyEditing">전체 선택</button>
           <button class="btn-secondary" @click="unselectAll" :disabled="isAnyEditing">전체 해제</button>
           <button class="btn-primary" @click="changeReviewStatus" :disabled="!selectedRows || selectedRows.length === 0 || isAnyEditing">
             검수 상태 변경 ({{ selectedRows.length }}건)
           </button>
           <button class="btn-primary" @click="openPrescriptionTypeModal" :disabled="!selectedRows || selectedRows.length === 0 || isAnyEditing">
             처방구분변경 ({{ selectedRows.length }}건)
           </button>
           <button class="btn-warning" @click="excludeFromReview" :disabled="!selectedRows || selectedRows.length === 0 || isAnyEditing">
             검수 대상 제외 ({{ selectedRows.length }}건)
           </button>
        </div>
      </div>
      
      <div style="flex-grow: 1; overflow: hidden;">
        <DataTable 
          :value="displayRows" 
          :loading="loading"
          v-model:editingRows="editingRows"
          editMode="row"
          @row-edit-save="onRowEditSave"
          :rowClass="getRowClass"
          paginator
          :rows="100"
          :rowsPerPageOptions="[100, 200, 500, 1000]"
          scrollable 
          scrollHeight="calc(100vh - 240px)"
          class="admin-performance-review-table"
          dataKey="id"
          v-model:first="currentPageFirstIndex"

          :pt="{
            wrapper: { style: 'min-width: 2400px;' },
            table: { style: 'min-width: 2400px;' }
          }"
        >
          <template #empty>
            <div v-if="loading">데이터를 불러오는 중입니다.</div>
            <div v-else>필터 조건을 선택하고 '불러오기'를 클릭하세요.</div>
          </template>
          
          <Column header="No" :headerStyle="{ width: columnWidths.no }" :frozen="true">
            <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
          </Column>
          
          <Column header="상태" field="display_status" :headerStyle="{ width: columnWidths.review_status }" :frozen="true">
            <template #body="slotProps">
              <Tag :value="slotProps.data.display_status" :severity="getStatusSeverity(slotProps.data.display_status)"/>
            </template>
          </Column>

          <Column header="작업" field="review_action" :headerStyle="{ width: columnWidths.review_action }" :frozen="true">
            <template #body="slotProps">
              <Tag v-if="slotProps.data.review_action" :value="slotProps.data.review_action" :severity="getActionSeverity(slotProps.data.review_action)"/>
            </template>
          </Column>
          
          <Column header="액션" :headerStyle="{ width: columnWidths.actions }" :frozen="true">
             <template #body="slotProps">
              <div style="display: flex; gap: 4px; justify-content: center;">
                <template v-if="slotProps.data.isEditing">
                  <button class="btn-save-sm" @click="saveEdit(slotProps.data)" title="저장">✓</button>
                  <button class="btn-cancel-sm" @click="cancelEdit(slotProps.data)" title="취소">✕</button>
                </template>
                <template v-else-if="slotProps.data.review_action === '삭제'">
                  <button class="btn-restore-sm" @click="restoreRow(slotProps.data)" title="되돌리기" :disabled="isAnyEditing">↶</button>
                </template>
                <template v-else>
                  <button class="btn-edit-sm" @click="startEdit(slotProps.data)" title="수정" :disabled="slotProps.data.display_status === '완료' || isAnyEditing">✎</button>
                  <button class="btn-delete-sm" @click="confirmDeleteRow(slotProps.data)" title="삭제" :disabled="slotProps.data.display_status === '완료' || isAnyEditing">－</button>
                  <button class="btn-add-sm" @click="addRowBelow(slotProps.data)" title="추가" :disabled="isAnyEditing">＋</button>
                </template>
              </div>
            </template>
          </Column>

          <Column field="company_name" header="업체명" :headerStyle="{ width: columnWidths.company_name }" :sortable="true" />
          <Column field="client_name" header="병의원명" :headerStyle="{ width: columnWidths.client_name }" :sortable="true" />
          
          <Column field="prescription_month" header="처방월" :headerStyle="{ width: columnWidths.prescription_month }" :sortable="true">
            <template #body="slotProps">
              <select v-if="slotProps.data.isEditing"
                      v-model="slotProps.data.prescription_month_modify"
                      class="edit-mode-input"
              >
                <option v-for="month in prescriptionMonthOptionsForEdit" :key="month" :value="month">{{ month }}</option>
              </select>
              <span v-else>{{ slotProps.data.prescription_month }}</span>
            </template>
          </Column>
          <Column field="product_name_display" header="제품명" :headerStyle="{ width: columnWidths.product_name_display }" :sortable="true"  :frozen="true">
            <template #body="slotProps">
              <template v-if="slotProps.data.isEditing">
                <div class="product-input-container">
                  <input
                    v-model="slotProps.data.product_name_search"
                    @input="handleProductNameInput(slotProps.data, $event)"
                    @focus="handleProductNameFocus(slotProps.data)"
                    @blur="delayedHideProductSearchList(slotProps.data)"
                    :ref="el => setProductInputRef(slotProps.data.id, el)"
                    autocomplete="off"
                    class="edit-mode-input"
                  />
                  <teleport to="body">
                    <div v-if="slotProps.data.showProductSearchList"
                      class="product-search-list"
                      :style="slotProps.data.productDropdownStyle"
                    >
                      <div
                        v-for="(product, idx) in slotProps.data.productSearchResults"
                        :key="product.id"
                        :class="['product-search-item', { selected: idx === slotProps.data.productSearchSelectedIndex }]"
                        @mousedown.prevent="applySelectedProduct(product, slotProps.data)"
                      >
                        {{ product.product_name }} ({{ product.insurance_code }})
                      </div>
                    </div>
                  </teleport>
                </div>
              </template>
              <template v-else>
                <span>{{ slotProps.data.product_name_display }}</span>
              </template>
            </template>
          </Column>
          <Column field="insurance_code" header="보험코드" :headerStyle="{ width: columnWidths.insurance_code }" :sortable="true" />
          <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true">
            <template #body="slotProps">
                <span v-if="slotProps.data.isEditing">{{ slotProps.data.price_for_calc?.toLocaleString() }}</span>
                <span v-else>{{ slotProps.data.price }}</span>
            </template>
          </Column>
          <Column field="prescription_qty" header="수량" :headerStyle="{ width: columnWidths.prescription_qty }" :sortable="true">
            <template #body="slotProps">
              <input
                v-if="slotProps.data.isEditing"
                v-model="slotProps.data.prescription_qty_modify"
                type="number"
                class="edit-mode-input"
                @change="handleEditCalculations(slotProps.data, 'qty')"
              />
              <span v-else>{{ Number(slotProps.data.prescription_qty).toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 }) }}</span>
            </template>
          </Column>
          <Column field="prescription_amount" header="처방액" :headerStyle="{ width: columnWidths.prescription_amount }" :sortable="true">
            <template #body="slotProps">
              <span v-if="slotProps.data.isEditing">{{ slotProps.data.prescription_amount_modify?.toLocaleString() }}</span>
              <span v-else>{{ slotProps.data.prescription_amount }}</span>
            </template>
          </Column>

          <Column :headerStyle="{ width: columnWidths.checkbox }" :frozen="false">
            <template #header>
              <span style="font-weight: 500 !important; text-align: center !important; margin-left: 10px !important;">선택</span>
            </template>
            <template #body="slotProps">
              <Checkbox v-model="selectedRows" :value="slotProps.data" :disabled="slotProps.data.review_action === '삭제'" />
            </template>
          </Column>

          <Column field="prescription_type" header="처방구분" :headerStyle="{ width: columnWidths.prescription_type }" :sortable="true">
            <template #body="slotProps">
              <select
                v-if="slotProps.data.isEditing"
                v-model="slotProps.data.prescription_type_modify"
                class="edit-mode-input"
              >
                <option v-for="type in prescriptionTypeOptions" :key="type" :value="type">{{ type }}</option>
              </select>
              <span v-else>{{ slotProps.data.prescription_type }}</span>
            </template>
          </Column>
          <Column field="commission_rate" header="수수료율" :headerStyle="{ width: columnWidths.commission_rate }" :sortable="true">
            <template #body="slotProps">
              <input 
                v-if="slotProps.data.isEditing" 
                v-model="slotProps.data.commission_rate_modify"
                type="number" 
                class="edit-mode-input"
                @change="handleEditCalculations(slotProps.data, 'rate')"
              />
              <span v-else>{{ slotProps.data.commission_rate ? `${(slotProps.data.commission_rate * 100).toFixed(1)}%` : '' }}</span>
            </template>
          </Column>
          <Column field="payment_amount" header="지급액" :headerStyle="{ width: columnWidths.payment_amount }" :sortable="true">
            <template #body="slotProps">
              <span v-if="slotProps.data.isEditing">{{ slotProps.data.payment_amount_modify?.toLocaleString() }}</span>
              <span v-else>{{ slotProps.data.payment_amount }}</span>
            </template>
          </Column>
          <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true">
            <template #body="slotProps">
              <input 
                v-if="slotProps.data.isEditing" 
                v-model="slotProps.data.remarks_modify"
                class="edit-mode-input"
              />
              <span v-else>{{ slotProps.data.remarks }}</span>
            </template>
          </Column>
          <Column field="created_at" header="등록일시" :headerStyle="{ width: columnWidths.created_date }" :sortable="true">
            <template #body="slotProps">
              {{ formatDateTime(slotProps.data.created_at) }}
            </template>
          </Column>
          <Column field="registered_by_name" header="등록자" :headerStyle="{ width: columnWidths.created_by }" :sortable="true" />

          <ColumnGroup type="footer">
            <Row>
              <Column footer="합계" :colspan="4" footerClass="footer-cell" footerStyle="text-align:center;" :frozen="true" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" :frozen="true" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column :footer="totalQuantity" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column :footer="totalPrescriptionAmount" footerClass="footer-cell" footerStyle="text-align:right !important;" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />
              <Column footer="" footerClass="footer-cell" />

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
  <div v-if="showPrescriptionTypeModal" class="modal-mask" style="position: fixed; z-index: 9999; left: 0; top: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.2); display: flex; align-items: center; justify-content: center;">
    <div class="modal-dialog" style="background: #fff; border-radius: 8px; padding: 32px 24px; min-width: 320px; box-shadow: 0 2px 16px rgba(0,0,0,0.15);">
      <div style="font-size: 1.1em; margin-bottom: 16px;">처방구분을 일괄변경하시겠습니까?</div>
      <select v-model="selectedPrescriptionType" style="width: 100%; margin-bottom: 24px; padding: 8px; font-size: 1em;">
        <option v-for="type in prescriptionTypeOptionsForBulk" :key="type" :value="type">{{ type }}</option>
      </select>
      <div style="display: flex; gap: 12px; justify-content: flex-end;">
        <button class="btn-primary" @click="handleBulkPrescriptionTypeUpdate">확인</button>
        <button class="btn-secondary" @click="closePrescriptionTypeModal">취소</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import { supabase } from '@/supabase';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import ColumnGroup from 'primevue/columngroup';
import Row from 'primevue/row';
import Checkbox from 'primevue/checkbox';
import Tag from 'primevue/tag';
import { v4 as uuidv4 } from 'uuid';
import { useToast } from "primevue/usetoast";
import Toast from 'primevue/toast';

// --- 초기화 ---
const toast = useToast();

// --- 고정 변수 ---
const columnWidths = {
  no: '3%',
  review_status: '3%',
  review_action: '3%',
  actions: '6%',
  company_name: '8%',
  client_name: '15%',
  prescription_month: '5%',
  product_name_display: '15%', 
  insurance_code: '5%', 
  price: '5%',
  prescription_qty: '5%', 
  prescription_amount: '6%', 
  checkbox: '4%',
  prescription_type: '6%',
  commission_rate: '5%',
  payment_amount: '6%', 
  remarks: '10%',
  created_date: '7%',
  created_by: '8%'
};
const prescriptionTypeOptions = ['EDI', 'ERP직거래자료', '매출자료', '약국조제', '원내매출', '원외매출', '차감'];

// --- 합계 계산 ---
const totalQuantity = computed(() => {
  const total = displayRows.value
    .filter(row => row.review_action !== '삭제') // 삭제 항목 제외
    .reduce((sum, row) => sum + (Number(row.prescription_qty) || 0), 0);
  return total.toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 });
});

const totalPrescriptionAmount = computed(() => {
  const total = displayRows.value
    .filter(row => row.review_action !== '삭제') // 삭제 항목 제외
    .reduce((sum, row) => sum + (Number(String(row.prescription_amount).replace(/,/g, '')) || 0), 0);
  return total.toLocaleString();
});

const totalPaymentAmount = computed(() => {
  const total = displayRows.value
    .filter(row => row.review_action !== '삭제') // 삭제 항목 제외
    .reduce((sum, row) => sum + (Number(String(row.payment_amount).replace(/,/g, '')) || 0), 0);
  return total.toLocaleString();
});

// --- 기존 데이터 및 필터 변수들 ---
const availableMonths = ref([]);
const selectedSettlementMonth = ref('');
const prescriptionOffset = ref(null);
const selectedCompanyId = ref(null);
const selectedHospitalId = ref(null);

const statusOptions = ref([
  { value: null, label: '전체' },
  { value: '완료', label: '완료' },
  { value: '검수중', label: '검수중' },
  { value: '대기', label: '신규' },
]);
const selectedStatus = ref('대기');

const monthlyPerformanceLinks = ref([]);
const monthlyCompanies = ref([]);
const monthlyHospitals = ref([]);

// --- 상태 관리: 데이터 테이블 ---
const loading = ref(false);
const rows = ref([]);
const originalRows = ref([]);
const selectedRows = ref([]);
const activeEditingRowId = ref(null);
const products = ref([]);
const productsByMonth = ref({}); // { '2025-06': [...], '2025-05': [...], ... }
const productInputRefs = ref({});
const currentPageFirstIndex = ref(0);

// --- Computed 속성 ---
const isAnyEditing = computed(() => activeEditingRowId.value !== null);

const displayRows = computed(() => {
  let filteredRows = rows.value;
  
  // 처방월 필터 적용
  if (prescriptionOffset.value !== null) {
    const targetPrescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
    filteredRows = filteredRows.filter(row => row.prescription_month === targetPrescriptionMonth);
  }
  
  return filteredRows.map(row => ({
    ...row,
    isEditing: row.id === activeEditingRowId.value,
    display_status: row.review_status === '대기' ? '신규' : row.review_status
  }));
});

const prescriptionOptions = computed(() => {
  if (!selectedSettlementMonth.value) return [{ value: null, month: '전체' }];
  return [
    { value: null, month: '전체' },
    ...[1, 2, 3].map(offset => ({
      value: offset,
      month: getPrescriptionMonth(selectedSettlementMonth.value, offset)
    }))
  ];
});

const prescriptionMonthOptionsForEdit = computed(() => {
    if (!selectedSettlementMonth.value) return [];
    // 처방월 옵션을 3개월로 제한
    return [1, 2, 3].map(offset => getPrescriptionMonth(selectedSettlementMonth.value, offset));
});

const companyOptions = computed(() => {
    return [{ id: null, company_name: '전체' }, ...monthlyCompanies.value];
});

const hospitalOptions = computed(() => {
    if (!selectedCompanyId.value) {
        return [{ id: null, name: '전체' }, ...monthlyHospitals.value];
    }
    const relevantClientIds = monthlyPerformanceLinks.value
        .filter(link => link.company_id === selectedCompanyId.value)
        .map(link => link.client_id);
    const filteredHospitals = monthlyHospitals.value.filter(hospital => relevantClientIds.includes(hospital.id));
    return [{ id: null, name: '전체' }, ...filteredHospitals.sort((a, b) => a.name.localeCompare(b.name, 'ko'))];
});

// --- Watchers ---
watch(selectedSettlementMonth, async (newMonth) => {
    if (newMonth) {
        await fetchFilterOptions(newMonth);
        selectedCompanyId.value = null;
        selectedHospitalId.value = null;
    }
});

watch(selectedCompanyId, () => {
    selectedHospitalId.value = null;
});

watch(prescriptionOffset, async () => {
    if (selectedSettlementMonth.value) {
        if (prescriptionOffset.value !== null) {
            const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
            await fetchProducts(prescriptionMonth);
        } else {
            // 처방월이 "전체"인 경우 제품 목록을 불러올 필요 없음
            products.value = [];
        }
    }
});

// --- 라이프사이클 훅 ---
onMounted(async () => {
  console.log("1. onMounted 시작");
  await fetchAvailableMonths();
  if (availableMonths.value.length > 0) {
    selectedSettlementMonth.value = availableMonths.value[0].settlement_month;
    console.log(`2. 기본 정산월 선택됨: ${selectedSettlementMonth.value}`);
    await fetchFilterOptions(selectedSettlementMonth.value);
  }
  // 실제 선택된 처방월 값으로 fetchProducts 호출
  if (prescriptionOffset.value !== null) {
    const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
    await fetchProducts(prescriptionMonth);
  } else {
    // 처방월이 "전체"인 경우 제품 목록을 불러올 필요 없음
    products.value = [];
  }
  console.log("7. onMounted 종료");
});

// --- 데이터 로딩 함수 ---
async function fetchAvailableMonths() {
  const { data, error } = await supabase.from('settlement_months').select('settlement_month').order('settlement_month', { ascending: false });
  if (error) console.error('정산월 로딩 실패:', error);
  else availableMonths.value = data;
}

async function fetchFilterOptions(settlementMonth) {
    console.log(`3. fetchFilterOptions 시작: ${settlementMonth}월`);
    loading.value = true;
    
    // === 1,000행 제한 해결: 전체 데이터 가져오기 ===
    let allPerformanceData = [];
    let from = 0;
    const batchSize = 1000;
    
    while (true) {
    const { data: performanceData, error: perfError } = await supabase
        .from('performance_records')
        .select('company_id, client_id')
            .eq('settlement_month', settlementMonth)
            .range(from, from + batchSize - 1);

    if (perfError) {
        console.error('실적 기반 필터 데이터 로딩 실패:', perfError);
        loading.value = false;
        return;
    }

        if (!performanceData || performanceData.length === 0) {
            break;
        }

        allPerformanceData = allPerformanceData.concat(performanceData);

        // 가져온 데이터가 batchSize보다 적으면 마지막 배치
        if (performanceData.length < batchSize) {
            break;
        }

        from += batchSize;
    }

    console.log(`4. ${settlementMonth}월의 performance_records 데이터 ${allPerformanceData.length}건 확인`);
    
    monthlyPerformanceLinks.value = allPerformanceData;
    const companyIds = [...new Set(allPerformanceData.map(p => p.company_id).filter(id => id))];
    const clientIds = [...new Set(allPerformanceData.map(p => p.client_id).filter(id => id))];
    console.log(`5. 고유 업체 ${companyIds.length}개, 고유 병원 ${clientIds.length}개 발견`);

    if (companyIds.length > 0) {
        const { data: companies, error: compError } = await supabase.from('companies').select('id, company_name').in('id', companyIds);
        if (compError) console.error('업체 필터 로딩 실패:', compError);
        else monthlyCompanies.value = companies.sort((a, b) => a.company_name.localeCompare(b.company_name, 'ko'));
    } else {
        monthlyCompanies.value = [];
    }

    if (clientIds.length > 0) {
        const { data: clients, error: clientError } = await supabase.from('clients').select('id, name').in('id', clientIds);
        if (clientError) console.error('병원 필터 로딩 실패:', clientError);
        else monthlyHospitals.value = clients.sort((a, b) => a.name.localeCompare(b.name, 'ko'));
    } else {
        monthlyHospitals.value = [];
    }
    console.log(`6. 필터 옵션 로딩 완료: 업체 ${monthlyCompanies.value.length}개, 병원 ${monthlyHospitals.value.length}개`);
    loading.value = false;
}

async function fetchProductsForMonth(month) {
    // 이미 불러온 월이면 캐시 사용
    if (productsByMonth.value[month]) return;

    const { data, error } = await supabase
        .from('products')
        .select('*')
        .eq('status', 'active')
        .eq('base_month', month)
        .range(0, 2999);

    if (!error && data) {
        // 보험코드 기준으로 유니크하게 처리
        const uniqByMonthAndInsurance = {};
        const noInsurance = [];
        data.forEach(p => {
            const key = `${p.base_month}_${p.insurance_code || ''}`;
            if (p.insurance_code) {
                if (!uniqByMonthAndInsurance[key]) uniqByMonthAndInsurance[key] = p;
            } else {
                noInsurance.push(p);
            }
        });
        productsByMonth.value[month] = [...Object.values(uniqByMonthAndInsurance), ...noInsurance];
        console.log(`처방월 ${month} 제품 로드 완료:`, data.length, '개 → 유니크', productsByMonth.value[month].length, '개');
    } else {
        console.error('제품 목록 로딩 실패:', error);
        productsByMonth.value[month] = [];
    }
}

// 기존 fetchProducts 함수는 호환성을 위해 유지
async function fetchProducts(prescriptionMonth) {
    if (!prescriptionMonth) {
        products.value = [];
        return;
    }
    await fetchProductsForMonth(prescriptionMonth);
    products.value = productsByMonth.value[prescriptionMonth] || [];
}

async function loadPerformanceData() {
  console.log("8. loadPerformanceData 시작");
  if (!selectedSettlementMonth.value) {
    toast.add({ severity: 'warn', summary: '알림', detail: '정산월을 선택해주세요.', life: 3000 });
    return;
  }
  
  // 제품 목록 로드 - 처방월이 특정된 경우에만 제품 목록 불러오기
  if (prescriptionOffset.value !== null) {
    const prescriptionMonth = getPrescriptionMonth(selectedSettlementMonth.value, prescriptionOffset.value);
    await fetchProducts(prescriptionMonth);
  } else {
    // 처방월이 "전체"인 경우 제품 목록을 불러올 필요 없음
    products.value = [];
  }
  
  loading.value = true;
  rows.value = [];
  originalRows.value = [];
  selectedRows.value = [];

  try {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error("로그인이 필요합니다.");
    const adminUserId = user.id;
    const currentTimestamp = new Date().toISOString();
    
    let idsToFetch = [];
    let shouldFetchByIds = false;

    // --- 데이터 처리 로직 ---
    // 1. '신규' 선택 시: '대기' 상태인 데이터를 찾아 '검수중'으로 업데이트하고, 해당 데이터만 불러옵니다.
    if (selectedStatus.value === '대기') {
      console.log("처리 방식: 신규");
      let findQuery = supabase.from('performance_records').select('id').eq('review_status', '대기');
      if (selectedSettlementMonth.value) findQuery = findQuery.eq('settlement_month', selectedSettlementMonth.value);
      if (selectedCompanyId.value) findQuery = findQuery.eq('company_id', selectedCompanyId.value);
      if (selectedHospitalId.value) findQuery = findQuery.eq('client_id', selectedHospitalId.value);

      const { data: pendingRecords, error: findError } = await findQuery;
      if (findError) throw findError;

      if (pendingRecords && pendingRecords.length > 0) {
        idsToFetch = pendingRecords.map(r => r.id);
        shouldFetchByIds = true;

        console.log(`${idsToFetch.length}건의 신규 데이터를 '검수중'으로 변경합니다.`);
        const { error: updateError } = await supabase
          .from('performance_records')
          .update({ review_status: '검수중', updated_at: currentTimestamp, updated_by: adminUserId })
          .in('id', idsToFetch);
        if (updateError) throw updateError;
      }
    } 
    // 2. '전체' 선택 시: 필터에 맞는 모든 데이터를 대상으로 '대기' 상태인 것을 '검수중'으로 업데이트하고, 전체를 불러옵니다.
    else if (!selectedStatus.value) { 
      console.log("처리 방식: 전체");
      let findQuery = supabase.from('performance_records').select('id').eq('review_status', '대기');
      if (selectedSettlementMonth.value) findQuery = findQuery.eq('settlement_month', selectedSettlementMonth.value);
      if (selectedCompanyId.value) findQuery = findQuery.eq('company_id', selectedCompanyId.value);
      if (selectedHospitalId.value) findQuery = findQuery.eq('client_id', selectedHospitalId.value);

      const { data: pendingRecords, error: findError } = await findQuery;
      if (findError) throw findError;
      
      if (pendingRecords && pendingRecords.length > 0) {
          const idsToUpdate = pendingRecords.map(r => r.id);
          console.log(`전체 데이터 중 ${idsToUpdate.length}건의 신규 데이터를 '검수중'으로 변경합니다.`);
          const { error: updateError } = await supabase
              .from('performance_records')
              .update({ review_status: '검수중', updated_at: currentTimestamp, updated_by: adminUserId })
              .in('id', idsToUpdate);
          if (updateError) throw updateError;
      }
    }
    // 3. '검수중' 또는 '완료' 선택 시: 상태 변경 없이 데이터만 불러옵니다.

    // --- 데이터 조회 로직 ---
    console.log("데이터 조회 시작");
    let query = supabase.from('performance_records').select(`
      *,
      companies ( company_name ),
      clients ( name ),
      products ( product_name, insurance_code, price )
    `);

    if (shouldFetchByIds) {
      if (idsToFetch.length === 0) {
          rows.value = [];
          originalRows.value = [];
          loading.value = false;
          return;
      }
      query = query.in('id', idsToFetch);
    } else {
      query = query.eq('settlement_month', selectedSettlementMonth.value);
      if (selectedCompanyId.value) query = query.eq('company_id', selectedCompanyId.value);
      if (selectedHospitalId.value) query = query.eq('client_id', selectedHospitalId.value);
      if (selectedStatus.value) query = query.eq('review_status', selectedStatus.value);
    }

    // === 1,000행 제한 해결: 전체 데이터 가져오기 ===
    let allData = [];
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
      
      // 가져온 데이터가 batchSize보다 적으면 마지막 배치
      if (data.length < batchSize) {
        break;
      }
      
      from += batchSize;
    }
    
    if (!allData || allData.length === 0) {
      rows.value = [];
      originalRows.value = [];
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

    console.log(`10. 최종 데이터 ${allData.length}건 불러옴`);

    // 데이터 가공: Join된 객체를 펼치고, 화면 표시에 필요한 값을 설정
    rows.value = allData.map(item => {
      const prescriptionAmount = Math.round(item.prescription_qty * (item.products?.price || 0));
      const paymentAmount = Math.round(prescriptionAmount * (item.commission_rate || 0));
      
      return {
        ...item,
        id: item.id,
        company_name: item.companies?.company_name || 'N/A',
        client_name: item.clients?.name || 'N/A',
        product_name_display: item.products?.product_name || 'N/A',
        insurance_code: item.products?.insurance_code || '',
        price: item.products?.price ? Math.round(item.products.price).toLocaleString() : '0',
        prescription_amount: prescriptionAmount.toLocaleString(),
        payment_amount: paymentAmount.toLocaleString(),
        registered_by_name: registrarMap.get(item.registered_by) || '관리자',
        display_status: item.review_status === '대기' ? '신규' : item.review_status,
      };
    });
    
    originalRows.value = JSON.parse(JSON.stringify(rows.value));

  } catch (err) {
    console.error('데이터 처리 중 오류 발생:', err);
    alert(`데이터를 처리하는 중 오류가 발생했습니다: ${err.message}`);
    rows.value = [];
  } finally {
    loading.value = false;
    selectedRows.value = [];
    console.log("11. loadPerformanceData 종료");
  }
}

// --- 행 편집 관련 함수 ---
function setProductInputRef(id, el) {
  if (el) {
    productInputRefs.value[id] = el;
  }
}

function startEdit(rowData) {
  if (isAnyEditing.value) return;

  const originalRow = originalRows.value.find(r => r.id === rowData.id);
  if (!originalRow) {
    console.error("Original row not found for editing:", rowData.id);
    return;
  }

  const index = rows.value.findIndex(r => r.id === rowData.id);
  if (index !== -1) {
    const editRow = {
      ...JSON.parse(JSON.stringify(originalRow)),
      isEditing: true,
      product_id_modify: originalRow.product_id,
      product_name_search: originalRow.product_name_display,
      prescription_month_modify: originalRow.prescription_month,
      prescription_qty_modify: originalRow.prescription_qty,
      prescription_type_modify: originalRow.prescription_type,
      commission_rate_modify: originalRow.commission_rate,
      remarks_modify: originalRow.remarks,
      price_for_calc: parseFloat(String(originalRow.price || '0').replace(/,/g, '')) || 0,
      showProductSearchList: false,
      productSearchResults: [],
      productSearchSelectedIndex: -1,
      productDropdownStyle: {},
    };
    rows.value[index] = editRow;
    activeEditingRowId.value = rowData.id;

    nextTick(() => {
       handleProductNameFocus(editRow);
    });
  }
}

function cancelEdit(rowData) {
  const originalRow = originalRows.value.find(r => r.id === rowData.id);
  const index = rows.value.findIndex(r => r.id === rowData.id);
  // 새로 추가 중이던 행(원본이 없는 행)을 취소하면 목록에서 제거
  if (!originalRows.value.some(r => r.id === rowData.id)) {
    rows.value.splice(index, 1);
  } else if (index !== -1 && originalRow) {
    rows.value[index] = JSON.parse(JSON.stringify(originalRow));
  }
  activeEditingRowId.value = null;
}

async function saveEdit(rowData) {
  // 필수 값 검증
  if (!rowData.product_id_modify || rowData.prescription_qty_modify === null || rowData.prescription_qty_modify === '') {
    alert('제품명과 수량은 필수 입력 항목입니다.');
    return;
  }
  
  loading.value = true;
  activeEditingRowId.value = null;

  try {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('로그인 정보가 유효하지 않습니다.');
    const adminUserId = user.id;

    const isNewRecord = !originalRows.value.some(r => r.id === rowData.id);
    
    let saveData = {
      settlement_month: rowData.settlement_month,
      company_id: rowData.company_id,
      client_id: rowData.client_id,
      product_id: rowData.product_id_modify,
      prescription_month: rowData.prescription_month_modify,
      prescription_qty: Number(rowData.prescription_qty_modify) || 0,
      prescription_type: rowData.prescription_type_modify,
      commission_rate: Number(rowData.commission_rate_modify) || 0,
      remarks: rowData.remarks_modify,
      review_status: '검수중', 
      updated_at: new Date().toISOString(),
      updated_by: adminUserId,
    };

    let error;

    if (isNewRecord) {
      // 추가 (INSERT)
      saveData = {
        ...saveData,
        created_at: new Date().toISOString(),
        registered_by: adminUserId,
        review_action: '추가',
      };
      const { error: insertError } = await supabase.from('performance_records').insert(saveData);
      error = insertError;
    } else {
      // 수정 (UPDATE)
      saveData = {
        ...saveData,
        review_action: '수정',
      };
      const { error: updateError } = await supabase.from('performance_records').update(saveData).eq('id', rowData.id);
      error = updateError;
    }

    if (error) throw error;

    alert(`성공적으로 저장되었습니다.`);
    await loadPerformanceData();
  } catch (err) {
    console.error('저장 실패:', err);
    alert(`저장 중 오류가 발생했습니다: ${err.message}`);
    // 실패 시, 편집모드로 되돌리거나 원본으로 복구하는 로직 추가 가능
  } finally {
    loading.value = false;
  }
}

function addRowBelow(referenceRow) {
  if (isAnyEditing.value) return;

  const refIndex = rows.value.findIndex(r => r.id === referenceRow.id);
  const newRow = {
    id: uuidv4(),
    isEditing: true,
    review_action: '추가',
    review_status: '검수중',
    
    // --- 복사되는 데이터 ---
    settlement_month: referenceRow.settlement_month,
    company_id: referenceRow.company_id,
    company_name: referenceRow.company_name, // 화면 표시용
    client_id: referenceRow.client_id,
    client_name: referenceRow.client_name, // 화면 표시용

    // --- 수정 가능한 데이터 (복사 후 수정) ---
    prescription_month_modify: referenceRow.prescription_month || getPrescriptionMonth(selectedSettlementMonth.value, 1),
    prescription_type_modify: referenceRow.prescription_type,
    
    // --- 초기화되는 데이터 ---
    product_id_modify: null,
    product_name_display: '',
    product_name_search: '',
    insurance_code: '',
    prescription_qty_modify: null,
    commission_rate_modify: null,
    remarks_modify: '',

    // --- 계산을 위한 초기값 ---
    price_for_calc: 0,
    prescription_amount_modify: 0,
    payment_amount_modify: 0,
    
    // --- UI 상태 ---
    showProductSearchList: false,
    productSearchResults: [],
    productSearchSelectedIndex: -1,
    productDropdownStyle: {}, // 드롭다운 위치 스타일
  };

  rows.value.splice(refIndex + 1, 0, newRow);
  activeEditingRowId.value = newRow.id;
  productInputRefs.value[newRow.id]?.focus();
}

// --- 처방월 변경 이벤트 핸들러 ---
async function handlePrescriptionMonthChange(rowData) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow) return;
  
  // 처방월이 변경되었고 제품이 선택되어 있으면 정보 업데이트
  if (reactiveRow.product_id_modify) {
    await updateProductInfoForMonthChange(rowData);
  }
  
  // 해당 월의 제품 목록이 로드되어 있지 않으면 로드
  if (reactiveRow.prescription_month_modify && !products.value.some(p => p.base_month === reactiveRow.prescription_month_modify)) {
    await fetchProducts(reactiveRow.prescription_month_modify);
  }
}

const confirmDeleteRow = async (row) => {
  if (isAnyEditing.value) return;

  const confirmMessage = "선택한 행을 삭제하시겠습니까?\n실제 데이터는 삭제되지 않고, 합계, 흡수율 분석, 정산 대상에서만 제외됩니다.";
  if (confirm(confirmMessage)) {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      const userUid = session?.user?.id;

      const { error } = await supabase
        .from('performance_records')
        .update({ review_action: '삭제', updated_by: userUid, updated_at: new Date().toISOString() })
        .eq('id', row.id);
      
      if (error) throw error;
      
      // 로컬 데이터 업데이트
      const index = rows.value.findIndex(r => r.id === row.id);
      if (index !== -1) {
        rows.value[index].review_action = '삭제';
      }
      
      alert("해당 항목이 삭제 처리되었습니다. 되돌리기를 하시면 다시 검수 완료가 가능합니다.");

    } catch (error) {
      console.error('삭제 처리 중 오류:', error);
      alert(`오류가 발생했습니다: ${error.message}`);
    }
  }
};

const restoreRow = async (row) => {
  if (isAnyEditing.value) return;
  try {
    const { data: { session } } = await supabase.auth.getSession();
    const userUid = session?.user?.id;

    const { error } = await supabase
      .from('performance_records')
      .update({ review_action: null, updated_by: userUid, updated_at: new Date().toISOString() })
      .eq('id', row.id);
    
    if (error) throw error;

    const index = rows.value.findIndex(r => r.id === row.id);
    if (index !== -1) {
      rows.value[index].review_action = null;
    }
    alert('항목이 복원되었습니다.');
  } catch(error) {
    console.error('복원 중 오류:', error);
    alert(`복원 중 오류가 발생했습니다: ${error.message}`);
  }
};

// --- 상단 버튼 액션 함수 ---
function selectAll() {
  selectedRows.value = displayRows.value.filter(record => record.review_action !== '삭제');
}

function unselectAll() {
  selectedRows.value = [];
}

async function changeReviewStatus() {
  if (!selectedRows.value || selectedRows.value.length === 0) return;

  if (window.confirm(`선택된 ${selectedRows.value.length}개 항목의 검수 상태를 변경하시겠습니까? ('검수중' ↔ '완료')`)) {
    loading.value = true;
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error("로그인이 필요합니다.");

      const updates = selectedRows.value.map(record => {
        const newStatus = record.review_status === '검수중' ? '완료' : '검수중';
        return supabase
          .from('performance_records')
          .update({ 
            review_status: newStatus, 
            updated_by: user.id,
            updated_at: new Date().toISOString() 
          })
          .eq('id', record.id);
      });

      const results = await Promise.all(updates);
      const errors = results.filter(res => res.error);

      if (errors.length > 0) {
        throw new Error(`다음 항목들의 상태 변경에 실패했습니다: ${errors.map(e=>e.error.message).join(', ')}`);
      }
      
      alert(`${selectedRows.value.length}개 항목의 상태를 성공적으로 변경했습니다.`);
      await loadPerformanceData(); // 데이터 새로고침
    } catch (error) {
      console.error('상태 변경 오류:', error);
      alert(error.message);
    } finally {
      loading.value = false;
    }
  }
}

const excludeFromReview = async () => {
  if (!selectedRows.value || selectedRows.value.length === 0) {
    alert("제외할 항목을 선택해주세요.");
    return;
  }

  const confirmMessage = `선택된 ${selectedRows.value.length}개 항목을 검수 대상에서 제외하시겠습니까? 해당 항목은 '대기' 상태로 돌아가며, 목록에서 사라집니다.`;
  if (!confirm(confirmMessage)) {
    return;
  }

  try {
    const { data: { session } } = await supabase.auth.getSession();
    const userUid = session?.user?.id;

    const updates = selectedRows.value.map(row => 
      supabase
        .from('performance_records')
        .update({ review_status: '대기', review_action: null, updated_by: userUid, updated_at: new Date().toISOString() })
        .eq('id', row.id)
    );
    const results = await Promise.all(updates);
    const errorResult = results.find(res => res.error);
    if (errorResult) throw errorResult.error;

    // 로컬 데이터 업데이트: 목록에서 제거
    const idsToRemove = new Set(selectedRows.value.map(r => r.id));
    rows.value = rows.value.filter(row => !idsToRemove.has(row.id));

    selectedRows.value = [];
    alert('선택한 항목들이 검수 대상에서 제외되었습니다.');

  } catch (error) {
    console.error('검수 제외 처리 중 오류:', error);
    alert(`오류가 발생했습니다: ${error.message}`);
  }
};

// --- 유틸리티 함수 ---
// 회사-거래처 매핑에서 수수료율 등급 조회 함수
async function getCommissionGradeForClientCompany(companyId, clientId) {
  const { data, error } = await supabase
    .from('client_company_assignments')
    .select('modified_commission_grade, company_default_commission_grade')
    .eq('company_id', companyId)
    .eq('client_id', clientId)
    .single();
  
  if (error || !data) {
    // 매핑 정보가 없으면 회사의 기본 등급 사용
    const { data: company } = await supabase
      .from('companies')
      .select('default_commission_grade')
      .eq('id', companyId)
      .single();
    return company?.default_commission_grade || 'A';
  }
  
  // modified_commission_grade가 있으면 우선 사용, 없으면 company_default_commission_grade 사용
  return data.modified_commission_grade || data.company_default_commission_grade || 'A';
}

async function handleEditCalculations(rowData, field) {
  // 간단한 제품 검색 및 가격/수수료율 업데이트
  if (field === 'product') {
      const product = products.value.find(p => p.id === rowData.product_id_modify);
      if (product) {
          rowData.price_for_calc = product.price;
          // 회사-거래처 매핑에서 수수료율 등급 조회
          const grade = await getCommissionGradeForClientCompany(rowData.company_id, rowData.client_id);
          let commissionRate = 0;
          if (grade === 'A') {
            commissionRate = product.commission_rate_a;
          } else if (grade === 'B') {
            commissionRate = product.commission_rate_b;
          }
          rowData.commission_rate_modify = commissionRate;
      }
  }
  // 처방액, 지급액 계산
  const qty = Number(rowData.prescription_qty_modify) || 0;
  const price = Number(rowData.price_for_calc) || 0;
  const rate = Number(rowData.commission_rate_modify) || 0;
  const prescriptionAmount = Math.round(qty * price);
  rowData.prescription_amount_modify = prescriptionAmount;
  rowData.payment_amount_modify = Math.round(prescriptionAmount * rate);
}

function handleProductNameInput(rowData, event) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow) return;

  reactiveRow.product_name_search = event.target.value;
  const searchTerm = event.target.value.toLowerCase();
  reactiveRow.showProductSearchList = true;

  const sourceList = reactiveRow.availableProducts || [];

  if (!searchTerm) {
    reactiveRow.productSearchResults = sourceList;
  } else {
    reactiveRow.productSearchResults = sourceList.filter(p =>
      p.product_name.toLowerCase().includes(searchTerm) ||
      (p.insurance_code && p.insurance_code.toLowerCase().includes(searchTerm))
    );
  }
  updateProductDropdownPosition(reactiveRow);
}

async function applySelectedProduct(product, rowData) {
    const reactiveRow = rows.value.find(r => r.id === rowData.id);
    if (!reactiveRow) return;

    reactiveRow.product_id_modify = product.id;
    reactiveRow.product_name_search = product.product_name;
    reactiveRow.product_name_display = product.product_name;
    reactiveRow.insurance_code = product.insurance_code;
    reactiveRow.price_for_calc = product.price;

    // 회사-거래처 매핑에서 수수료율 등급 조회
    const grade = await getCommissionGradeForClientCompany(reactiveRow.company_id, reactiveRow.client_id);
    let commissionRate = 0;
    if (grade === 'A') {
      commissionRate = product.commission_rate_a;
    } else if (grade === 'B') {
      commissionRate = product.commission_rate_b;
    }
    reactiveRow.commission_rate_modify = commissionRate;
    
    reactiveRow.showProductSearchList = false;
    handleEditCalculations(reactiveRow, 'product');
}

function getRowClass(data) {
  return [
    { 'editing-row': data.isEditing },
    { 'added-row': data.review_action === '추가' },
    { 'modified-row': data.review_action === '수정' },
    { 'deleted-row': data.review_action === '삭제' }
  ];
}

function getActionSeverity(action) {
    if (action === '수정') return 'info';
    if (action === '추가') return 'success';
    if (action === '삭제') return 'danger';
    return 'secondary';
}

function getStatusSeverity(status) {
    if (status === '완료') return 'success';
    if (status === '검수중') return 'warning';
    if (status === '신규') return 'info';
    return 'secondary';
}

function getPrescriptionMonth(settlementMonth, offset) {
  if (!settlementMonth) return '';
  const [y, m] = settlementMonth.split('-');
  let mm = parseInt(m, 10) - offset;
  let yy = parseInt(y, 10);
  while (mm <= 0) { mm += 12; yy -= 1; }
  return `${yy}-${String(mm).padStart(2, '0')}`;
}

function formatDateTime(dateTimeString) {
    if (!dateTimeString) return '';
    const date = new Date(dateTimeString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
}

// --- 제품 검색 관련 함수 ---
function handleProductNameFocus(rowData) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow) return;

  const prescriptionMonth = reactiveRow.prescription_month_modify || reactiveRow.prescription_month;
  
  if (!prescriptionMonth) {
    console.log('[제품 검색] 처방월이 지정되지 않음');
    return;
  }
  
  // 해당 처방월의 제품 목록이 없으면 먼저 불러오기
  if (!productsByMonth.value[prescriptionMonth]) {
    console.log(`[제품 검색] 처방월 ${prescriptionMonth} 제품 목록을 불러옵니다.`);
    fetchProductsForMonth(prescriptionMonth).then(() => {
      const filteredList = getFilteredProductList(prescriptionMonth);
      reactiveRow.availableProducts = filteredList;
      reactiveRow.productSearchResults = filteredList;
      reactiveRow.showProductSearchList = true;
      updateProductDropdownPosition(reactiveRow);
    });
  } else {
    const filteredList = getFilteredProductList(prescriptionMonth);
    reactiveRow.availableProducts = filteredList;
    reactiveRow.productSearchResults = filteredList;
    reactiveRow.showProductSearchList = true;
    updateProductDropdownPosition(reactiveRow);
  }
}

function delayedHideProductSearchList(rowData) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow) return;
  
  setTimeout(() => {
    reactiveRow.showProductSearchList = false;
  }, 200);
}

function updateProductDropdownPosition(rowData) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow) return;

  nextTick(() => {
    const inputEl = productInputRefs.value[reactiveRow.id];
    if (inputEl) {
      const rect = inputEl.getBoundingClientRect();
      reactiveRow.productDropdownStyle = {
        position: 'fixed',
        top: `${rect.bottom}px`,
        left: `${rect.left}px`,
        width: `${rect.width}px`,
        zIndex: 1000
      };
    }
  });
}

// --- 제품 검색 헬퍼 ---
function getFilteredProductList(prescriptionMonth) {
  if (!prescriptionMonth) {
    console.log('[제품 검색] 처방월이 지정되지 않음');
    return [];
  }

  // 해당 처방월의 제품 목록 가져오기 (없으면 자동으로 불러옴)
  if (!productsByMonth.value[prescriptionMonth]) {
    console.log(`[제품 검색] 처방월 ${prescriptionMonth} 제품 목록이 없어서 불러옵니다.`);
    fetchProductsForMonth(prescriptionMonth);
    return [];
  }

  const productList = productsByMonth.value[prescriptionMonth] || [];
  console.log(`[제품 검색] 처방월 ${prescriptionMonth} 기준 전체 제품 수:`, productList.length);
  
  return productList;
}

// --- 처방월 변경 시 제품 정보 업데이트 ---
async function updateProductInfoForMonthChange(rowData) {
  const reactiveRow = rows.value.find(r => r.id === rowData.id);
  if (!reactiveRow || !reactiveRow.insurance_code || !reactiveRow.prescription_month_modify) return;

  try {
    // 보험코드로 새 처방월에서 해당 제품 정보 조회
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('insurance_code', reactiveRow.insurance_code)
      .eq('base_month', reactiveRow.prescription_month_modify)
      .eq('status', 'active')
      .limit(1);

    if (error) {
      console.error('제품 조회 오류:', error);
      return;
    }

    if (!data || data.length === 0) {
      // 새 처방월에 해당 제품이 없으면 제품 선택 해제
      console.log(`보험코드 ${reactiveRow.insurance_code} 제품이 ${reactiveRow.prescription_month_modify}에 존재하지 않습니다. 제품 선택을 해제합니다.`);
      reactiveRow.product_id_modify = null;
      reactiveRow.product_name_search = '';
      reactiveRow.product_name_display = '';
      reactiveRow.insurance_code = '';
      reactiveRow.price_for_calc = 0;
      reactiveRow.commission_rate_modify = null;
      reactiveRow.prescription_amount_modify = 0;
      reactiveRow.payment_amount_modify = 0;
      return;
    }

    const productData = data[0]; // 첫 번째 결과 사용

    // 새 처방월에 해당 제품이 있으면 정보 업데이트
    console.log(`보험코드 ${reactiveRow.insurance_code} 제품의 ${reactiveRow.prescription_month_modify} 정보로 업데이트:`, {
      product_id: productData.id,
      product_name: productData.product_name,
      price: productData.price
    });

    reactiveRow.product_id_modify = productData.id;
    reactiveRow.product_name_search = productData.product_name;
    reactiveRow.product_name_display = productData.product_name;
    reactiveRow.insurance_code = productData.insurance_code;
    reactiveRow.price_for_calc = productData.price || 0;

    // 회사-거래처 매핑에서 수수료율 등급 조회
    const grade = await getCommissionGradeForClientCompany(reactiveRow.company_id, reactiveRow.client_id);
    let commissionRate = 0;
    if (grade === 'A') {
      commissionRate = productData.commission_rate_a;
    } else if (grade === 'B') {
      commissionRate = productData.commission_rate_b;
    }
    reactiveRow.commission_rate_modify = commissionRate;
    
    // 처방수량이 있으면 처방액 재계산
    if (reactiveRow.prescription_qty_modify) {
      const qty = Number(reactiveRow.prescription_qty_modify);
      const price = Number(productData.price) || 0;
      if (!isNaN(qty) && !isNaN(price) && price > 0) {
        reactiveRow.prescription_amount_modify = qty * price;
        reactiveRow.payment_amount_modify = reactiveRow.prescription_amount_modify * (commissionRate / 100);
      }
    }
  } catch (err) {
    console.error('제품 정보 업데이트 오류:', err);
  }
}

const showPrescriptionTypeModal = ref(false);
const selectedPrescriptionType = ref('EDI');
const prescriptionTypeOptionsForBulk = [
  'EDI',
  'ERP직거래자료',
  '매출자료',
  '약국조제',
  '원내매출',
  '원외매출',
  '차감'
];
function openPrescriptionTypeModal() {
  selectedPrescriptionType.value = 'EDI';
  showPrescriptionTypeModal.value = true;
}
function closePrescriptionTypeModal() {
  showPrescriptionTypeModal.value = false;
}

async function handleBulkPrescriptionTypeUpdate() {
  if (!selectedRows.value || selectedRows.value.length === 0) return;
  const ids = selectedRows.value.map(row => row.id);
  const newType = selectedPrescriptionType.value;
  try {
    const { error } = await supabase
      .from('performance_records')
      .update({ prescription_type: newType, review_action: '수정' })
      .in('id', ids);
    if (error) {
      alert('처방구분 변경 실패: ' + error.message);
    } else {
      alert('처방구분이 성공적으로 변경되었습니다.');
      await loadPerformanceData();
    }
  } catch (e) {
    alert('처방구분 변경 중 오류 발생: ' + e.message);
  } finally {
    showPrescriptionTypeModal.value = false;
  }
}
</script>

<style scoped>
/* ... 다른 스타일들 ... */

.product-search-list {
  position: absolute;
  background-color: white;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  max-height: 200px;
  overflow-y: auto;
  z-index: 1000;
}

.product-search-item {
  padding: 8px 12px;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
}

.product-search-item:hover {
  background-color: #f0f0f0;
}

.product-search-item.selected {
  background-color: #e0e0e0;
}

.product-search-item .product-name {
  font-weight: 500;
}

.product-search-item .insurance-code {
  color: #666;
  font-size: 0.9em;
}

:deep(.row-added .p-frozen-column),
:deep(.row-added td) {
  background-color: #e3f2fd !important; /* 아주 연한 파란색 */
}

:deep(.row-modified .p-frozen-column),
:deep(.row-modified td) {
  background-color: #fffde7 !important; /* 아주 연한 노란색 */
}

:deep(.deleted-row .p-frozen-column),
:deep(.deleted-row td) {
  background-color: #ffebee !important; /* 아주 연한 붉은색 */
}

/* No와 액션 열에서는 취소선 제거 */
:deep(.deleted-row td:first-child),
:deep(.deleted-row td:nth-child(4)) {
  text-decoration: none !important;
}

:deep(.p-datatable-tfoot > tr > td) {
    background: #f8f9fa !important;
}

:deep(.p-datatable .p-datatable-tbody > tr.p-highlight) {
    background-color: #eff6ff;
    color: #1d4ed8;
}

/* 기존 배경색 규칙을 삭제하고 아래의 더 구체적인 규칙으로 대체합니다. */
:deep(.p-datatable .p-datatable-tbody > tr.added-row > td) {
  background-color: #e3f2fd !important; /* 아주 연한 파란색 */
}

:deep(.p-datatable .p-datatable-tbody > tr.modified-row > td) {
  background-color: #fffde7 !important; /* 아주 연한 노란색 */
}

:deep(.p-datatable .p-datatable-tbody > tr.deleted-row > td) {
  background-color: #ffebee !important; /* 아주 연한 붉은색 */
  color: #999 !important;
  text-decoration: line-through !important;
}

:deep(.p-datatable-tfoot > tr > td) {
    background: #f8f9fa !important;
    font-weight: bold;
}
</style>
