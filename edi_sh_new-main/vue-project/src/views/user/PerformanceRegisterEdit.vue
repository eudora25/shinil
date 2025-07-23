<template>
  <div class="performance-register-view">
    <div class="header-title">실적 등록</div>
    <div class="filter-card" style="display: flex; align-items: center; gap: 0.5rem; margin-bottom:0rem; padding:0.15rem 1.5rem 0.15rem 1rem !important;">
      <div style="display:flex; align-items:center; flex:1;">
        <Button icon="pi pi-arrow-left" severity="secondary" text rounded @click="goBackToList" style="margin-right:12px;" />
        <div>
          <div style="font-size:1.1rem; font-weight:700;">{{ route.query.clientName }}</div>
          <div style="font-size:0.88rem; color:#444;">
            {{ route.query.businessRegistrationNumber }} / {{ route.query.address }}
          </div>
        </div>
      </div>
      <div v-if="hasNonEditableRow" class="status-message status-warning">
        검수 상태가 완료, 또는 검수중인 실적은 수정이 불가능합니다.
      </div>
    </div>

    <div class="data-card">
      <div class="input-table-wrapper performance-edit-table">
        <div class="top-bar-row" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
          <div class="total-count-display">실적: {{ validRowCount }} 건</div>
          <button class="btn-save" @click="onSave" :disabled="!canSave || !isInputEnabled" style="min-width:90px; margin-bottom:0rem !important;">저장</button>
        </div>
        <div class="table-header-fixed">
          <table>
            <thead>
              <tr>

                <th style="width:10%;">처방월</th>
                <th style="width:5%;">No</th>
                <th style="width:22%;">제품명</th>
                <th style="width:9%;">보험코드</th>
                <th style="width:9%;">단가</th>
                <th style="width:9%;">처방수량</th>
                <th style="width:10%;">처방액</th>
                <th style="width:10%;">처방구분</th>
                <th style="width:14%;">비고</th>
                <th style="width:6%;">삭제</th>
                <th style="width:6%;">추가</th>
                <th style="width:8%;">검수상태</th>
              </tr>
            </thead>
          </table>
        </div>
        
        <div class="table-body-scroll">
          <table class="input-table prime-like-table">
            <tbody>
              <tr v-for="(row, rowIdx) in inputRows" :key="rowIdx">
                <td style="width:10%;text-align:center;">
                  <select
                    v-model="row.prescription_month"
                    :tabindex="isRowEditable(row) ? 0 : -1"
                    :disabled="!isRowEditable(row)"
                    @keydown="onArrowKey($event, rowIdx, 'prescription_month')"
                    :class="['select_month', { 'disabled-area': !isRowEditable(row) }]"
                  >
                    <option v-for="opt in prescriptionOptions" :key="opt.value" :value="opt.month">{{ opt.month }}</option>
                  </select>
                </td>
                <td style="text-align:center;width:5%;" :class="{ 'disabled-area': !isRowEditable(row) }">{{ rowIdx + 1 }}</td>
                <td style="position:relative;text-align:left;width:22%;">
                  <div class="product-input-container">
                    <input
                      v-model="row.product_name_display"
                      :tabindex="isRowEditable(row) ? 0 : -1"
                      :readonly="!isRowEditable(row)"
                      @input="handleProductNameInput(rowIdx, $event)"
                      @keydown.enter.prevent="applySelectedProductFromSearch(rowIdx)"
                      @keydown.down.prevent="navigateProductSearchList('down')"
                      @keydown.up.prevent="navigateProductSearchList('up')"
                      @keydown="onArrowKey($event, rowIdx, 'product_name')"
                      @focus="handleProductNameFocus(rowIdx)"
                      @blur="delayedHideProductSearchList(rowIdx)" 
                      :disabled="!isRowEditable(row)"
                      :class="[
                        cellClass(rowIdx, 'product_name'),
                        { 'disabled-area': !isRowEditable(row) }
                      ]"
                      autocomplete="off"
                      :ref="el => setProductInputRef(rowIdx, el)"
                    />
                    <button 
                      type="button"
                      @click="toggleProductDropdown(rowIdx)"
                      @mousedown.prevent
                      class="dropdown-arrow-btn"
                      tabindex="-1"
                      :disabled="!isRowEditable(row)"
                    >
                      <span class="dropdown-arrow">▼</span>
                    </button>
                  </div>
                  <teleport to="body">
                    <div v-if="productSearchForRow.show && productSearchForRow.activeRowIndex === rowIdx && productSearchForRow.results.length > 0"
                      class="search-dropdown product-search-dropdown"
                      :style="productDropdownStyle[rowIdx]"
                    >
                      <ul>
                        <li
                          v-for="(product, index) in productSearchForRow.results"
                          :key="product.id"
                          @click="clickProductFromSearchList(product, rowIdx)"
                          :class="{ 'selected': productSearchForRow.selectedIndex === index }"
                        >
                          <span class="product-name">{{ truncateText(product.product_name, 25) }}</span>
                          <span class="insurance-code">{{ product.insurance_code }}</span>
                        </li>
                      </ul>
                    </div>
                  </teleport>
                </td>
                <td style="text-align:center;width:9%;">
                  <span :class="['readonly-span', !isRowEditable(row) ? 'disabled-area' : '']">{{ row.insurance_code }}</span>
                </td>
                <td style="text-align:right;width:9%;">
                  <span :class="['readonly-span', !isRowEditable(row) ? 'disabled-area' : '']">{{ row.price }}</span>
                </td>
                <td style="text-align:right;position:relative; width:9%;">
                  <input
                    v-model="row.prescription_qty"
                    :tabindex="isRowEditable(row) ? 0 : -1"
                    :readonly="!isRowEditable(row)"
                    @keydown.enter.prevent="addOrFocusNextRow(rowIdx)"
                    @keydown="onArrowKey($event, rowIdx, 'prescription_qty')"
                    @input="onQtyInput(rowIdx)"
                    @focus="handlePrescriptionQtyFocus(rowIdx)"
                    @blur="row.prescription_qty = row.prescription_qty ? Number(row.prescription_qty.toString().replace(/,/g, '')).toLocaleString() : ''"
                    :disabled="!isRowEditable(row)"
                    :class="[
                      cellClass(rowIdx, 'prescription_qty'),
                      { 'disabled-area': !isRowEditable(row) }
                    ]"
                    style="text-align:right;"
                  />
                </td>
                <td style="text-align:right;width:10%;">
                  <span :class="['readonly-span', !isRowEditable(row) ? 'disabled-area' : '']">{{ row.prescription_amount }}</span>
                </td>
                <td style="text-align:center;width:10%;">
                  <select
                    v-model="row.prescription_type"
                    :tabindex="isRowEditable(row) ? 0 : -1"
                    :readonly="!isRowEditable(row)"
                    @change="onPrescriptionTypeInput(rowIdx)"
                    @keydown="onArrowKey($event, rowIdx, 'prescription_type')"
                    @focus="handleFieldFocus(rowIdx, 'prescription_type')"
                    :disabled="!isRowEditable(row)"
                    :class="[
                      cellClass(rowIdx, 'prescription_type'),
                      { 'disabled-area': !isRowEditable(row) }
                    ]"
                    style="text-align:center;"
                  >
                    <option v-for="type in prescriptionTypeOptions" :key="type" :value="type">{{ type }}</option>
                  </select>
                </td>
                <td style="text-align:left; width:14%;">
                  <input
                    v-model="row.remarks"
                    :tabindex="isRowEditable(row) ? 0 : -1"
                    :readonly="!isRowEditable(row)"
                    @keydown.enter.prevent="addOrFocusNextRow(rowIdx)"
                    @keydown="onArrowKey($event, rowIdx, 'remarks')"
                    @focus="handleFieldFocus(rowIdx, 'remarks')"
                    :disabled="!isRowEditable(row)"
                    :class="[
                      cellClass(rowIdx, 'remarks'),
                      { 'disabled-area': !isRowEditable(row) }
                    ]"
                    style="text-align:left;"
                  />
                </td>
                <td class="action-cell" style="width:6%;">
                  <button 
                    class="btn-delete-sm" 
                    @click="confirmDeleteRow(rowIdx)" 
                    :disabled="inputRows.length === 1 || !isRowEditable(row)" 
                    title="삭제"
                    :class="{ 'disabled-area': !isRowEditable(row) }"
                  >삭제</button>
                </td>
                <td class="action-cell" style="width:6%;">
                  <button 
                    class="btn-add-sm" 
                    @click="confirmAddRowBelow(rowIdx)" 
                    title="추가"
                    :disabled="!isRowEditable(row)"
                    :class="{ 'disabled-area': !isRowEditable(row) }"
                  >추가</button>
                </td>
                <td style="width:8%;text-align:center;">
                  <span :class="getStatusClass(row.review_status || '대기')">
                    {{ getStatusLabel(row.review_status) }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="table-footer-wrapper"
      style="width:100%; background:#f8f9fa;
        height: 38px;
        border:1px solid #dee2e6;
        border-bottom:2px solid #aaa;
        position:sticky;
        bottom:0;z-index:2;">
        <table style="width:100%;table-layout:fixed;">
          <tr>
            <td style="width:43%;text-align:center;font-weight:bold;">합계</td>
            <td style="width:10%;text-align:right;font-weight:bold;">{{ totalQty }}</td>
            <td style="width:8.5%;text-align:right;font-weight:bold;">{{ totalAmount }}</td>
            <td style="width:38.5%;"></td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { supabase } from '@/supabase';
import Button from 'primevue/button';

const route = useRoute();
const router = useRouter();

// 정산월 정보를 이전 화면에서 전달받음
const selectedSettlementMonth = ref(route.params.settlementMonth || route.query.settlementMonth || '');

// 처방월 옵션을 설정
const prescriptionOffset = ref(1); // 1: -1M, 2: -2M, 3: -3M
const prescriptionMonth = ref('');
const prescriptionOptions = ref([]);

// 실적 입력행들 (최소 1행은 유지)
const inputRows = ref([{ 
  prescription_month: getDefaultPrescriptionMonth(),
  product_name_display: '', 
  product_id: null, 
  insurance_code: '', 
  price: '', 
  prescription_qty: '', 
  prescription_amount: '', 
  prescription_type: 'EDI', 
  remarks: '',
  commission_rate_a: null,
  commission_rate_b: null,
  review_status: '대기',
}]);

// 편집 가능 여부 (review_status에 따라 결정)
const isInputEnabled = ref(true);
const reviewStatus = ref('대기');
const statusMessage = ref('');
const canSave = computed(() => {
  const currentValidRows = getValidRows(inputRows.value);
  const originalValidRows = getValidRows(originalRows.value);
  return isRowsChanged(currentValidRows, originalValidRows);
});
// 입력된 실적(제품+수량)만 추려주는 함수
function getValidRows(rows) {
  return rows
    .filter(row => row.product_id && row.prescription_qty)
    .map(row => ({
      id: row.id,
      prescription_month: row.prescription_month,
      product_id: row.product_id,
      prescription_qty: String(row.prescription_qty || '').replace(/,/g, ''),
      prescription_type: row.prescription_type,
      remarks: row.remarks || '',
      commission_rate_a: row.commission_rate_a,
      commission_rate_b: row.commission_rate_b
    }));
}

// 두 배열의 주요 필드가 모두 같은지 비교
function isRowsChanged(current, original) {
  if (current.length !== original.length) return true;
  for (let i = 0; i < current.length; i++) {
    const a = current[i];
    const b = original[i];
    if (
      a.prescription_month !== b.prescription_month ||
      a.product_id !== b.product_id ||
      String(a.prescription_qty || '').replace(/,/g, '') !== String(b.prescription_qty || '').replace(/,/g, '') ||
      a.prescription_type !== b.prescription_type ||
      (a.remarks || '') !== (b.remarks || '')
    ) {
      return true;
    }
  }
  return false;
}

// 화면 진입 시점의 원본 데이터 저장
const originalRows = ref([]);
const currentCell = ref({ row: 0, col: 'product_name' });

const prescriptionTypeOptions = [
  'EDI',
  'ERP직거래자료',
  '매출자료',
  '약국조제',
  '원내매출',
  '원외매출',
  '차감',
];
const products = ref([]);
const productSearchForRow = ref({
  query: '',
  results: [],
  selectedIndex: -1,
  show: false,
  activeRowIndex: -1,
});
const productInputRefs = ref({});
const productDropdownStyle = ref({});

const productsByMonth = ref({}); // { '2025-06': [...], '2025-05': [...], ... }

function setProductInputRef(rowIdx, el) {
  if (el) productInputRefs.value[rowIdx] = el;
}

function updateProductDropdownPosition(rowIdx) {
  nextTick(() => {
    const el = productInputRefs.value[rowIdx];
    if (!el) return;
    const rect = el.getBoundingClientRect();
    
    // 화면 높이와 드롭다운 높이 계산
    const windowHeight = window.innerHeight;
    const dropdownHeight = 220; // 드롭다운 예상 높이
    const spaceBelow = windowHeight - rect.bottom;
    const spaceAbove = rect.top;
    
    // 아래쪽 공간이 부족하고 위쪽 공간이 충분하면 위로 표시
    const showAbove = spaceBelow < dropdownHeight && spaceAbove > dropdownHeight;
    
    productDropdownStyle.value[rowIdx] = {
      position: 'fixed',
      left: rect.left + 'px',
      top: showAbove ? (rect.top - dropdownHeight) + 'px' : rect.bottom + 'px',
      width: rect.width + 'px',
      zIndex: 9999,
      maxHeight: showAbove ? Math.min(dropdownHeight, spaceAbove - 10) + 'px' : Math.min(dropdownHeight, spaceBelow - 10) + 'px',
      overflowY: 'auto',
    };
  });
}

watch(() => productSearchForRow.value.activeRowIndex, (rowIdx) => {
  if (productSearchForRow.value.show && rowIdx !== -1) {
    updateProductDropdownPosition(rowIdx);
  }
});
watch(() => productSearchForRow.value.show, (show) => {
  if (show && productSearchForRow.value.activeRowIndex !== -1) {
    updateProductDropdownPosition(productSearchForRow.value.activeRowIndex);
  }
});
watch(inputRows, () => {
  if (productSearchForRow.value.show && productSearchForRow.value.activeRowIndex !== -1) {
    updateProductDropdownPosition(productSearchForRow.value.activeRowIndex);
  }
}, { deep: true });
window.addEventListener('scroll', () => {
  const rowIdx = productSearchForRow.value.activeRowIndex;
  if (productSearchForRow.value.show && rowIdx !== -1) {
    updateProductDropdownPosition(rowIdx);
  }
}, true);
function getPrescriptionMonth(settlementMonth, offset) {
  if (!settlementMonth) return '';
  const [y, m] = settlementMonth.split('-');
  let mm = parseInt(m, 10) - offset;
  let yy = parseInt(y, 10);
  while (mm <= 0) { mm += 12; yy -= 1; }
  return `${yy}-${String(mm).padStart(2, '0')}`;
}

function truncateText(text, maxLength) {
  if (!text) return '';
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}

// 상태에 따른 CSS 클래스 반환
function getStatusClass(status) {
  if (status === '완료') return 'status-completed';
  if (status === '검수중') return 'status-reviewing';
  return 'status-pending';
}

function getStatusLabel(status) {
  if (status === '완료') return '완료';
  if (status === '검수중') return '검수중';
  return '대기';
}

// 편집 상태 확인 및 메시지 설정
function checkEditStatus() {
  // 관리자는 항상 편집 가능
  if (isAdminUser.value) {
    isInputEnabled.value = true;
    statusMessage.value = '';
    return;
  }
  
  // 일반 사용자는 상태에 따라 편집 제한
  switch (reviewStatus.value) {
    case '대기':
      isInputEnabled.value = true;
      statusMessage.value = '';
      break;
    case '검수중':
      isInputEnabled.value = false;
      statusMessage.value = '검수 중인 실적으로 수정할 수 없습니다';
      break;
    case '완료':
      isInputEnabled.value = false;
      statusMessage.value = '검수 완료된 실적으로 수정할 수 없습니다';
      break;
    default:
      isInputEnabled.value = true;
      statusMessage.value = '';
  }
}

// 해당 거래처의 실적 상태 확인
async function checkPerformanceEditStatus() {
  try {
    const clientId = route.query.clientId;
    if (!clientId || !selectedSettlementMonth.value || !prescriptionMonth.value) {
      return;
    }

    // 관리자가 companyId로 접근하는 경우 기간 체크 우회
    if (route.query.companyId && isAdminUser.value) {
      reviewStatus.value = '대기';
      checkEditStatus();
      return;
    }

    // 해당 거래처의 실적 중 하나라도 검수중/완료 상태인지 확인
    const { data, error } = await supabase
      .from('performance_records')
      .select('review_status')
      .eq('settlement_month', selectedSettlementMonth.value)
      .eq('prescription_month', prescriptionMonth.value)
      .eq('client_id', clientId)
      .limit(1);
    if (error) {
      console.error('실적 상태 확인 오류:', error);
      return;
    }

    if (data && data.length > 0) {
      reviewStatus.value = data[0].review_status || '대기';
    } else {
      reviewStatus.value = '대기';
    }

    checkEditStatus();
  } catch (err) {
    console.error('실적 상태 확인 예외:', err);
  }
}

function updatePrescriptionOptions() {
  if (!selectedSettlementMonth.value) {
    prescriptionOptions.value = [];
    return;
  }
  prescriptionOptions.value = [1, 2, 3].map(offset => ({
    value: offset,
    month: getPrescriptionMonth(selectedSettlementMonth.value, offset)
  }));
}

watch(selectedSettlementMonth, () => {
  if (selectedSettlementMonth.value) {
    updatePrescriptionOptions();
    prescriptionOffset.value = 1;
    prescriptionMonth.value = getPrescriptionMonth(selectedSettlementMonth.value, 1);
  }
}, { immediate: true });
watch(prescriptionOffset, (val) => {
  prescriptionMonth.value = getPrescriptionMonth(selectedSettlementMonth.value, val);
  // 처방월 변경 시 편집 상태 확인
  checkPerformanceEditStatus();
});
// 처방월이 변경되면 편집 상태 재확인
watch(prescriptionMonth, (val) => {
  console.log('처방월 변경 감지:', val);
  if (val) {
    fetchProducts(val);
    checkPerformanceEditStatus();
  }
});
watch(
  () => inputRows.value[0].prescription_month,
  (val) => {
    if (val) {
      fetchProducts(val);
    }
  }
);
async function fetchProducts(prescriptionMonth) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('status', 'active')
    .eq('base_month', prescriptionMonth)
    .range(0, 2999);

  if (!error && data) {
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
    products.value = [...Object.values(uniqByMonthAndInsurance), ...noInsurance];
    console.log('불러온 제품 개수:', data.length, '처방월:', prescriptionMonth);
  }
}

// 제품 검색 관련 함수들
function handleProductNameInput(rowIndex, event) {
  if (!isInputEnabled.value) return;
  const query = event.target.value.toLowerCase();
  inputRows.value[rowIndex].product_name_display = event.target.value;
  inputRows.value[rowIndex].product_id = null;
  inputRows.value[rowIndex].insurance_code = '';
  inputRows.value[rowIndex].price = '';

  productSearchForRow.value.activeRowIndex = rowIndex;
  if (query.length < 1) {
    productSearchForRow.value.show = false;
    productSearchForRow.value.results = [];
    console.log('show:', productSearchForRow.value.show, 'results:', productSearchForRow.value.results);
    return;
  }
  // 처방월에 맞는 제품만 필터링
  const month = inputRows.value[rowIndex].prescription_month;
  const productList = productsByMonth.value[month] || [];
  productSearchForRow.value.results = productList.filter(
    p =>
      (p.product_name && p.product_name.toLowerCase().includes(query)) ||
      (p.insurance_code && p.insurance_code.toLowerCase().includes(query))
  );
  productSearchForRow.value.selectedIndex = -1;
  productSearchForRow.value.show = productSearchForRow.value.results.length > 0;
  console.log('show:', productSearchForRow.value.show, 'results:', productSearchForRow.value.results);
}

function navigateProductSearchList(direction) {
  if (!productSearchForRow.value.show || productSearchForRow.value.results.length === 0) return;
  if (direction === 'down') {
    productSearchForRow.value.selectedIndex = (productSearchForRow.value.selectedIndex + 1) % productSearchForRow.value.results.length;
  } else if (direction === 'up') {
    productSearchForRow.value.selectedIndex = (productSearchForRow.value.selectedIndex - 1 + productSearchForRow.value.results.length) % productSearchForRow.value.results.length;
  }

  // 선택된 항목이 보이도록 스크롤
  nextTick(() => {
    const listElement = document.querySelector('.product-search-dropdown ul');
    const newIndex = productSearchForRow.value.selectedIndex;
    if (listElement && listElement.children[newIndex]) {
      listElement.children[newIndex].scrollIntoView({
        block: 'nearest',
      });
    }
  });
}

function applySelectedProduct(product, rowIndex) {
  inputRows.value[rowIndex].product_name_display = product.product_name;
  inputRows.value[rowIndex].product_id = product.id;
  inputRows.value[rowIndex].insurance_code = product.insurance_code;
  inputRows.value[rowIndex].price = product.price ? Number(product.price).toLocaleString() : '';
  inputRows.value[rowIndex].commission_rate_a = product.commission_rate_a;
  inputRows.value[rowIndex].commission_rate_b = product.commission_rate_b;
  productSearchForRow.value.show = false;
  productSearchForRow.value.activeRowIndex = -1;
  nextTick(() => {
    focusField(rowIndex, 'prescription_qty');
  });
}

function applySelectedProductFromSearch(rowIndexToApply) {
  const idx = productSearchForRow.value.selectedIndex;
  const currentActionRow = productSearchForRow.value.activeRowIndex;
  if (productSearchForRow.value.show && idx !== -1 && productSearchForRow.value.results[idx] && currentActionRow === rowIndexToApply) {
    const product = productSearchForRow.value.results[idx];
    applySelectedProduct(product, currentActionRow);
  } else if (productSearchForRow.value.show && productSearchForRow.value.results.length > 0 && currentActionRow === rowIndexToApply) {
    const product = productSearchForRow.value.results[0];
    applySelectedProduct(product, currentActionRow);
  } else {
    focusField(rowIndexToApply, 'prescription_qty');
  }
  productSearchForRow.value.show = false;
}

function clickProductFromSearchList(product, rowIndex) {
  applySelectedProduct(product, rowIndex);
}

function delayedHideProductSearchList(rowIdx) {
  setTimeout(() => hideProductSearchList(rowIdx), 200);
}

function hideProductSearchList(rowIndex) {
  if (productSearchForRow.value.activeRowIndex === rowIndex) {
    if (!inputRows.value[rowIndex].product_id) {
      inputRows.value[rowIndex].product_name_display = '';
    }
    productSearchForRow.value.show = false;
    productSearchForRow.value.activeRowIndex = -1;
  }
}

function toggleProductDropdown(rowIndex) {
  if (!isInputEnabled.value) return;
  if (isProductSearchOpen.value && productSearchForRow.value.activeRowIndex !== rowIndex) {
    return;
  }
  if (productSearchForRow.value.show && productSearchForRow.value.activeRowIndex === rowIndex) {
    productSearchForRow.value.show = false;
    productSearchForRow.value.activeRowIndex = -1;
    return;
  }
  // 처방월에 맞는 제품만 필터링
  const month = inputRows.value[rowIndex].prescription_month;
  productSearchForRow.value.activeRowIndex = rowIndex;
  productSearchForRow.value.results = productsByMonth.value[month] || [];
  productSearchForRow.value.selectedIndex = -1;
  productSearchForRow.value.show = productSearchForRow.value.results.length > 0;
  console.log('show:', productSearchForRow.value.show, 'results:', productSearchForRow.value.results);
  nextTick(() => {
    focusField(rowIndex, 'product_name');
  });
}

// 제품 검색 드롭다운이 열려있는지 확인하는 computed
const isProductSearchOpen = computed(() => {
  return productSearchForRow.value.show && productSearchForRow.value.activeRowIndex !== -1;
});
// 제품명 필드 포커스 핸들러
function handleProductNameFocus(rowIdx) {
  if (!isInputEnabled.value) { // Added .value
    event.target.blur();
    return;
  }
  
  // 다른 행의 제품 검색이 열려있으면 차단
  if (isProductSearchOpen.value && productSearchForRow.value.activeRowIndex !== rowIdx) {
    event.target.blur();
    return;
  }
  
  currentCell.value = { row: rowIdx, col: 'product_name' };
  productSearchForRow.value.activeRowIndex = rowIdx;
}

// 일반 필드 포커스 핸들러
function handleFieldFocus(rowIdx, col) {
  if (!isInputEnabled.value) { // Added .value
    event.target.blur();
    return;
  }
  
  // 제품 검색 드롭다운이 열려있으면 포커스 차단
  if (isProductSearchOpen.value) {
    event.target.blur();
    return;
  }
  
  currentCell.value = { row: rowIdx, col: col };
}

// 처방수량 필드 포커스 핸들러
function handlePrescriptionQtyFocus(rowIdx) {
  if (!isInputEnabled.value) { // Added .value
    event.target.blur();
    return;
  }
  
  // 제품 검색 드롭다운이 열려있으면 포커스 차단
  if (isProductSearchOpen.value) {
    event.target.blur();
    return;
  }
  
  // 포커스시 콤마 제거
  inputRows.value[rowIdx].prescription_qty = inputRows.value[rowIdx].prescription_qty ? inputRows.value[rowIdx].prescription_qty.toString().replace(/,/g, '') : '';
  currentCell.value = { row: rowIdx, col: 'prescription_qty' };
}

// 테이블 네비게이션 함수들
function focusField(rowIdx, col) {
  nextTick(() => {
    const table = document.querySelector('.input-table');
    if (!table) return;
    const row = table.querySelectorAll('tbody tr')[rowIdx];
    if (!row) return;

    let el = null;
    if (col === 'prescription_month') el = row.querySelector('td:nth-child(1) select');
    else if (col === 'product_name') el = row.querySelector('td:nth-child(3) input');
    else if (col === 'prescription_qty') el = row.querySelector('td:nth-child(6) input');
    else if (col === 'prescription_type') el = row.querySelector('td:nth-child(8) select');
    else if (col === 'remarks') el = row.querySelector('td:nth-child(9) input');
 
    if (el) {
      el.focus();
      if (el.tagName === 'INPUT') {
        el.select();
      }
    }
  });
}

function addOrFocusNextRow(rowIdx) {
  const currentRow = inputRows.value[rowIdx];
  // 현재 행의 제품명 입력 중일 때
  if (currentCell.value.col === 'product_name') {
    // 제품이 선택되어 있지 않으면 다음으로 진행하지 않음
    if (!currentRow.product_id) {
      return;
    }
    // 제품이 선택되어 있으면 수량 입력으로 이동
    focusField(rowIdx, 'prescription_qty');
    return;
  }
  
  // 현재 행의 수량 입력 중일 때
  if (currentCell.value.col === 'prescription_qty') {
    // 제품명과 수량이 모두 입력되어 있어야만 다음행 생성
    if (!currentRow.product_id || !currentRow.prescription_qty) {
      return;
    }
    
    // 마지막 행이면 새 행 추가
    if (rowIdx === inputRows.value.length - 1) {
      inputRows.value.push({ 
        prescription_month: getDefaultPrescriptionMonth(),
        product_name_display: '', 
        product_id: null, 
        insurance_code: '', 
        price: '', 
        prescription_qty: '', 
        prescription_amount: '', 
        prescription_type: 'EDI',
        remarks: '',
        commission_rate_a: null,
        commission_rate_b: null,
        review_status: '대기',
      });
    }
    // 다음 행의 제품명으로 이동
    focusField(rowIdx + 1, 'product_name');
  }
  
  // 비고 입력 중일 때
  if (currentCell.value.col === 'remarks') {
    // 제품명과 수량이 모두 입력되어 있어야만 다음행 생성
    if (!currentRow.product_id || !currentRow.prescription_qty) {
      return;
    }
    
    // 마지막 행이면 새 행 추가
    if (rowIdx === inputRows.value.length - 1) {
      inputRows.value.push({ 
        prescription_month: getDefaultPrescriptionMonth(),
        product_name_display: '', 
        product_id: null, 
        insurance_code: '', 
        price: '', 
        prescription_qty: '', 
        prescription_amount: '', 
        prescription_type: 'EDI',
        remarks: '',
        commission_rate_a: null,
        commission_rate_b: null,
        review_status: '대기',
      });
    }
    // 다음 행의 제품명으로 이동
    focusField(rowIdx + 1, 'product_name');
  }
}

function onPrescriptionTypeInput(rowIdx) {
  const value = inputRows.value[rowIdx].prescription_type;
  for (let i = rowIdx + 1; i < inputRows.value.length; i++) {
    inputRows.value[i].prescription_type = value;
  }
}

function onQtyInput(rowIdx) {
  const qty = Number(inputRows.value[rowIdx].prescription_qty.toString().replace(/,/g, ''));
  const price = Number(inputRows.value[rowIdx].price.toString().replace(/,/g, ''));
  if (!isNaN(qty) && !isNaN(price) && price > 0) {
    inputRows.value[rowIdx].prescription_amount = (qty * price).toLocaleString();
  } else {
    inputRows.value[rowIdx].prescription_amount = '';
  }
}

function onArrowKey(e, rowIdx, col) {
  // 제품 검색 드롭다운이 열려있을 때는 좌우 화살표만 막고, 상하키는 리스트 탐색을 위해 허용
  if (isProductSearchOpen.value && productSearchForRow.value.activeRowIndex === rowIdx) {
    if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
      e.preventDefault();
    }
    return;
  }
  
  if (!["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(e.key)) return;
  e.preventDefault();

  const cols = ["prescription_month", "product_name", "prescription_qty", "prescription_type", "remarks"];
  const currentColIdx = cols.indexOf(col);

  if (currentColIdx === -1) return;

  let newRow = rowIdx;
  let newColIdx = currentColIdx;

  if (e.key === "ArrowUp") {
    newRow = Math.max(0, rowIdx - 1);
  } else if (e.key === "ArrowDown") {
    newRow = Math.min(inputRows.value.length - 1, rowIdx + 1);
  } else if (e.key === "ArrowLeft") {
    newColIdx = Math.max(0, currentColIdx - 1);
  } else if (e.key === "ArrowRight") {
    newColIdx = Math.min(cols.length - 1, currentColIdx + 1);
  }

  // 이동하려는 행이 편집 가능한 경우에만 포커스 이동
  if (isRowEditable(inputRows.value[newRow])) {
    const newCol = cols[newColIdx];
    currentCell.value = { row: newRow, col: newCol };
    focusField(newRow, newCol);
  }
}

function cellClass(rowIdx, col) {
  return currentCell.value.row === rowIdx && currentCell.value.col === col ? 'cell-focused' : '';
}

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

// 실적 저장로직 - 기존 데이터를 삭제 후 새로 저장
async function savePerformanceData() {
  const clientId = route.query.clientId;
  const settlementMonth = route.query.settlementMonth;
  if (!settlementMonth || !clientId) {
    throw new Error('정산월이나 병원이 선택되지 않았습니다.');
  }

  // 현재 로그인한 사용자 ID 가져오기 (등록자 정보용)
  const { data: { session } } = await supabase.auth.getSession();
  const currentUserUid = session?.user?.id;
  if (!currentUserUid) {
    throw new Error('로그인 정보를 확인할 수 없습니다.');
  }

  // 관리자가 전달한 companyId 확인 (관리자가 대신 등록하는 경우)
  let companyId = route.query.companyId;
  let myCompany;
  
  if (companyId) {
    // 관리자가 특정 업체의 실적을 등록하는 경우
    const { data } = await supabase.from('companies').select('id, default_commission_grade').eq('id', companyId).single();
    myCompany = data;
  } else {
    // 일반 사용자가 자신의 실적을 등록하는 경우
    const { data } = await supabase.from('companies').select('id, default_commission_grade').eq('user_id', currentUserUid).single();
    myCompany = data;
  }
  
  if (!myCompany) {
    throw new Error('회사 정보를 찾을 수 없습니다.');
  }

  const currentValidRows = getValidRows(inputRows.value);
  const originalValidRows = originalRows.value; // 이제 getValidRows를 이미 통과한 상태

  // 변경된 행, 추가된 행, 삭제된 행 식별
  const rowsToUpdate = currentValidRows.filter(currentRow => {
    if (!currentRow.id) return false;
    const originalRow = originalValidRows.find(or => or.id === currentRow.id);
    if (!originalRow) return false;
    return (
      currentRow.prescription_month !== originalRow.prescription_month ||
      currentRow.product_id !== originalRow.product_id ||
      currentRow.prescription_qty !== originalRow.prescription_qty ||
      currentRow.prescription_type !== originalRow.prescription_type ||
      currentRow.remarks !== originalRow.remarks
    );
  });

  const rowsToInsert = currentValidRows.filter(currentRow => !currentRow.id);
  const rowsToDelete = originalValidRows.filter(originalRow => !currentValidRows.some(cr => cr.id === originalRow.id));

  // 1. INSERT
  if (rowsToInsert.length > 0) {
    const grade = await getCommissionGradeForClientCompany(myCompany.id, Number(clientId));
    
    // 관리자가 입력하는 경우 바로 완료 상태로 저장
    const reviewStatus = (route.query.companyId && isAdminUser.value) ? '완료' : '대기';
    
    const       dataToInsert = rowsToInsert.map(row => {
      let commissionRate = 0;
      if (grade === 'A') {
        commissionRate = row.commission_rate_a;
      } else if (grade === 'B') {
        commissionRate = row.commission_rate_b;
      }

      return {
      company_id: myCompany.id,
      settlement_month: settlementMonth,
      prescription_month: row.prescription_month,
      client_id: Number(clientId),
      product_id: row.product_id,
      prescription_qty: Number(row.prescription_qty),
      prescription_type: row.prescription_type,
      remarks: row.remarks,
      registered_by: currentUserUid, // 실제 등록한 사용자 ID (관리자 또는 일반사용자)
        review_status: reviewStatus,
        commission_rate: commissionRate
      };
    });
    const { error } = await supabase.from('performance_records').insert(dataToInsert);
    if (error) throw new Error(`실적 추가 중 오류: ${error.message}`);
  }

  // 2. UPDATE
  if (rowsToUpdate.length > 0) {
    const grade = await getCommissionGradeForClientCompany(myCompany.id, Number(clientId));
    
    // 관리자가 입력하는 경우 바로 완료 상태로 저장
    const reviewStatus = (route.query.companyId && isAdminUser.value) ? '완료' : '대기';
    
    const updatePromises = rowsToUpdate.map(row => {
      let commissionRate = 0;
      if (grade === 'A') {
        commissionRate = row.commission_rate_a;
      } else if (grade === 'B') {
        commissionRate = row.commission_rate_b;
      }
      return supabase
        .from('performance_records')
        .update({
          prescription_month: row.prescription_month,
          product_id: row.product_id,
          prescription_qty: Number(row.prescription_qty),
          prescription_type: row.prescription_type,
          remarks: row.remarks,
          commission_rate: commissionRate,
          review_status: reviewStatus
        })
        .eq('id', row.id)
    });
    const results = await Promise.all(updatePromises);
    const firstError = results.find(res => res.error);
    if (firstError) throw new Error(`실적 수정 중 오류: ${firstError.error.message}`);
  }

  // 3. DELETE
  if (rowsToDelete.length > 0) {
    const deletePromises = rowsToDelete.map(row => 
      supabase.from('performance_records').delete().eq('id', row.id)
    );
    const results = await Promise.all(deletePromises);
    const firstError = results.find(res => res.error);
    if (firstError) throw new Error(`실적 삭제 중 오류: ${firstError.error.message}`);
  }

  return currentValidRows.length;
}

// 저장 버튼 클릭 핸들러 (기존 데이터 삭제 후 새로 저장)
async function onSave() {
  // 제품 검색 드롭다운이 열려있으면 차단
  if (isProductSearchOpen.value) {
    return;
  }
  
  // clientId, settlementMonth를 query에서 찾음
  const clientId = route.query.clientId;
  const settlementMonth = route.query.settlementMonth;
  if (!settlementMonth || !clientId) {
    alert('정산월이나 병원이 선택되지 않았습니다.');
    return;
  }

  // 1. 행 분류 (부족한 정보 확인)
  const partialRows = [];
  inputRows.value.forEach((row, index) => {
    const hasProduct = !!row.product_id;
    const hasQty = !!row.prescription_qty;

    if ((hasProduct || hasQty) && !(hasProduct && hasQty)) {
      partialRows.push({ ...row, rowNumber: index + 1 });
    }
  });
  // 2. 부족한 정보 행이 있는 경우 사용자 확인
  if (partialRows.length > 0) {
    const partialRowNumbers = partialRows.map(row => `No ${row.rowNumber}`).join(', ');
    const message = `${partialRows.length}건의 실적이 필수 정보(제품, 처방수량)가 누락되었습니다.\n${partialRowNumbers}\n제외하고 저장하시겠습니까?`;
    
    if (!confirm(message)) {
      return; // 취소 시 저장 중단
    }
  }

  try {
    // 3. 저장 처리 (기존 데이터 삭제 후 새로 저장)
    const savedCount = await savePerformanceData();
    // 4. 성공 메시지
    alert(`${savedCount}건의 실적이 저장되었습니다.`);
    // 5. 저장 후 실적 목록 화면으로 이동
    if (route.query.companyId) {
      // 관리자가 대신 등록한 경우
      router.push('/admin/performance/register');
    } else {
      // 일반 사용자가 등록한 경우
      router.push('/performance/register');
    }
  } catch (err) {
    console.error('저장 처리 오류:', err);
    alert(err.message || '실적 저장 시 오류가 발생했습니다.');
  }

  // 저장 후에는 originalRows를 inputRows에서 입력된 행만 복사해서 동기화
  originalRows.value = getValidRows(inputRows.value).map(row => ({ ...row }));
  // canSave.value = false; // canSave is a computed property, no need to set it manually
}

// 기존 실적 데이터 불러오기
async function loadExistingData() {
  const clientId = route.query.clientId;
  const settlementMonth = route.query.settlementMonth;
  
  if (!clientId || !settlementMonth) return;
  
  try {
    // 관리자가 전달한 companyId 확인 (관리자가 대신 등록하는 경우)
    let companyId = route.query.companyId;
    let myCompany;
    
    if (companyId) {
      // 관리자가 특정 업체의 실적을 조회하는 경우
      const { data } = await supabase.from('companies').select('id').eq('id', companyId).single();
      myCompany = data;
    } else {
      // 일반 사용자가 자신의 실적을 조회하는 경우
      const { data: { session } } = await supabase.auth.getSession();
      const userUid = session?.user?.id;
      if (!userUid) return;
      const { data } = await supabase.from('companies').select('id').eq('user_id', userUid).single();
      myCompany = data;
    }
    
    if (!myCompany) return;
    // 기존 실적 데이터 조회 (products 테이블과 조인)
    const { data, error } = await supabase
      .from('performance_records')
      .select(`
        *,
        products ( * )
     
      `)
      .eq('company_id', myCompany.id)
      .eq('settlement_month', settlementMonth)
      .eq('client_id', clientId);
    if (error) {
      console.error('기존 실적 조회 오류:', error);
      return;
    }

    if (data && data.length > 0) {
      // 기존 데이터를 inputRows에 설정
      inputRows.value = data.map(record => ({
        id: record.id,
        prescription_month: record.prescription_month,
        product_name_display: record.products?.product_name || '',
        product_id: record.product_id,
        insurance_code: record.products?.insurance_code || '',
        price: record.products?.price ? Number(record.products.price).toLocaleString() : '',
        prescription_qty: record.prescription_qty ? Number(record.prescription_qty).toLocaleString() : '',
        prescription_amount: record.prescription_qty && record.products?.price 
          ? (record.prescription_qty * record.products.price).toLocaleString() 
          : '',
        prescription_type: record.prescription_type || 'EDI',
        remarks: record.remarks || '',
        review_status: record.review_status || '대기',
        commission_rate_a: record.products?.commission_rate_a,
        commission_rate_b: record.products?.commission_rate_b,
      }));
      
      // *** MODIFICATION START ***
      // 1. 원본 동기화 (빈 행 추가 전)
      originalRows.value = getValidRows(inputRows.value).map(row => ({ ...row }));
      // *** MODIFICATION END ***

      // 처방월도 기존 데이터에서 가져오기
      if (data[0].prescription_month) {
        const prescMonth = data[0].prescription_month;
        const settlementDate = new Date(settlementMonth + '-01');
        const prescDate = new Date(prescMonth + '-01');
        const monthDiff = (settlementDate.getFullYear() - prescDate.getFullYear()) * 12 + 
          (settlementDate.getMonth() - prescDate.getMonth());
        if (monthDiff >= 1 && monthDiff <= 3) {
          prescriptionOffset.value = monthDiff;
        }
      }

      // 2. 마지막에 빈 행 추가
      inputRows.value.push({
        prescription_month: getDefaultPrescriptionMonth(),
        product_name_display: '', 
        product_id: null, 
        insurance_code: '', 
        price: '', 
        prescription_qty: '', 
        prescription_amount: '', 
        prescription_type: 'EDI', 
        remarks: '',
        review_status: '대기',
        commission_rate_a: null,
        commission_rate_b: null,
      });
    }
  } catch (err) {
    console.error('기존 실적 로드 오류:', err);
  }
}

// 합계 계산
const totalQty = computed(() => {
  const total = inputRows.value.reduce((sum, row) => {
    const qty = Number(row.prescription_qty.toString().replace(/,/g, '')) || 0;
    return sum + qty;
  }, 0);
  return total.toLocaleString();
});
const totalAmount = computed(() => {
  return inputRows.value.reduce((sum, row) => sum + (Number(row.prescription_amount.toString().replace(/,/g, '')) || 0), 0).toLocaleString();
});
// 행 추가/행 삭제
function addRowBelow(idx) {
  inputRows.value.splice(idx + 1, 0, {
    prescription_month: getDefaultPrescriptionMonth(),
    product_name_display: '', product_id: null, insurance_code: '', price: '', prescription_qty: '', prescription_amount: '', prescription_type: 'EDI', remarks: '', review_status: '대기', commission_rate_a: null, commission_rate_b: null,
  });
  nextTick(() => focusField(idx + 1, 'product_name'));
}

function deleteRow(idx) {
  if (inputRows.value.length === 1) return;
  inputRows.value.splice(idx, 1);
}

// 확인 다이얼로그를 브라우저 confirm으로 변경
function confirmDeleteRow(idx) {
  // 제품 검색 드롭다운이 열려있으면 차단
  if (isProductSearchOpen.value) {
    return;
  }
  
  if (confirm('선택한 행을 삭제하시겠습니까?')) {
    deleteRow(idx);
  }
}

function confirmAddRowBelow(idx) {
  // 제품 검색 드롭다운이 열려있으면 차단
  if (isProductSearchOpen.value) {
    return;
  }
  
  if (confirm('아래에 새 행을 추가하시겠습니까?')) {
    addRowBelow(idx);
  }
}

// 행 초기화 함수
function resetRow(rowIdx) {
  const row = inputRows.value[rowIdx];
  if (!row) return;
  
  // 해당 행을 초기화
  row.prescription_month = getDefaultPrescriptionMonth(); // 정산월 - 1M
  row.product_name_display = '';
  row.product_id = null;
  row.insurance_code = '';
  row.price = '';
  row.prescription_qty = '';
  row.prescription_amount = '';
  row.prescription_type = 'EDI';
  row.remarks = '';
  row.commission_rate_a = null;
  row.commission_rate_b = null;
  
  // 제품 검색 드롭다운 숨기기
  if (productSearchForRow.value.show && productSearchForRow.value.activeRowIndex === rowIdx) {
    productSearchForRow.value.show = false;
    productSearchForRow.value.activeRowIndex = -1;
  }
  
  // 해당 행의 제품명 필드로 포커스 이동
  nextTick(() => {
    focusField(rowIdx, 'product_name');
  });
}

// 단축키 처리
function handleGlobalKeydown(e) {
  // 제품 검색 드롭다운이 열려있으면 Insert/Delete/Escape 키 차단
  if (isProductSearchOpen.value) {
    if (e.key === 'Delete' || e.key === 'Insert' || e.key === 'Escape') {
      e.preventDefault();
      return;
    }
  }
  
  if (e.key === 'Delete') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    if (inputRows.value.length > 1) {
      confirmDeleteRow(currentRowIdx);
    }
  } else if (e.key === 'Insert') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    confirmAddRowBelow(currentRowIdx);
  } else if (e.key === 'Escape') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    // 편집 가능한 행만 초기화
    if (isRowEditable(inputRows.value[currentRowIdx])) {
      resetRow(currentRowIdx);
    }
  }
}

// 전역 클릭 이벤트 처리
function handleGlobalClick(e) {
  // 제품 검색 드롭다운 처리
  if (isProductSearchOpen.value) {
    const productContainer = e.target.closest('.product-input-container');
    const searchDropdown = e.target.closest('.search-dropdown');
    
    if (!productContainer && !searchDropdown) {
      const activeRowIndex = productSearchForRow.value.activeRowIndex;
      if (activeRowIndex !== -1) {
        hideProductSearchList(activeRowIndex);
      }
    }
  }
}

// 사용자 권한 정보를 저장할 ref
const isAdminUser = ref(false);

function isRowEditable(row) {
  const status = row.review_status;
  
  // 관리자는 모든 상태 편집 가능
  if (isAdminUser.value) {
    return true;
  }
  
  // 일반 사용자는 '대기' 상태만 편집 가능
  return status === '대기' || !status;
}



// 검수중/완료 행이 하나라도 있으면 안내문구 표시 (관리자는 제외)
const hasNonEditableRow = computed(() => {
  if (isAdminUser.value) return false; // 관리자는 모든 행 편집 가능하므로 경고 메시지 숨김
  return inputRows.value.some(row => {
    const status = row.review_status || '대기';
    return status === '완료' || status === '검수중';
  });
});
// 항상 마지막에 입력 가능한 빈 행이 1개 남아있도록 유지
watch(inputRows, (rows) => {
  const lastRow = rows[rows.length - 1];
  const isLastRowEmpty = !lastRow.product_id && !lastRow.product_name_display && !lastRow.prescription_qty;
  if (!isLastRowEmpty) {
    inputRows.value.push({
      prescription_month: getDefaultPrescriptionMonth(),
      product_name_display: '',
      product_id: null,
      insurance_code: '',
      price: '',
      prescription_qty: '',
      prescription_amount: '',
      prescription_type: 'EDI',
      remarks: '',
      review_status: '대기',
      commission_rate_a: null,
      commission_rate_b: null,
    });
  }
}, { deep: true });
// 라이프사이클
onMounted(async () => {
  // 사용자 권한 확인
  try {
    const { data: { session } } = await supabase.auth.getSession();
    isAdminUser.value = session?.user?.user_metadata?.user_type === 'admin';
  } catch (error) {
    console.error('사용자 권한 확인 오류:', error);
    isAdminUser.value = false;
  }

  if (selectedSettlementMonth.value) {
    updatePrescriptionOptions();
    prescriptionOffset.value = 1;
    prescriptionMonth.value = getPrescriptionMonth(selectedSettlementMonth.value, 1);
  }
  await fetchProducts(prescriptionMonth.value);
  await loadExistingData(); // 기존 실적 데이터 불러오기
  // 편집 상태 확인
  await checkPerformanceEditStatus();
  // 편집 가능한 경우에만 포커스
  if (isInputEnabled.value) {
    // 편집 가능한 첫 행의 제품명에 포커스
    nextTick(() => {
      const firstEditableRowIndex = inputRows.value.findIndex(row => isRowEditable(row));
      if (firstEditableRowIndex !== -1) {
        focusField(firstEditableRowIndex, 'product_name');
      }
    });
  }
  document.addEventListener('keydown', handleGlobalKeydown);
  document.addEventListener('click', handleGlobalClick);

  // 최초 1행의 처방월 값
  const firstMonth = inputRows.value[0].prescription_month;
  if (firstMonth) {
    await fetchProductsForMonth(firstMonth);
  }
});

onUnmounted(() => {
  document.removeEventListener('keydown', handleGlobalKeydown);
  document.removeEventListener('click', handleGlobalClick);
});

// 새 행 추가 시 prescription_month 기본값 적용
function getDefaultPrescriptionMonth() {
  if (!selectedSettlementMonth.value) return '';
  return getPrescriptionMonth(selectedSettlementMonth.value, 1); // -1M
}

// 유효 실적 건수
const validRowCount = computed(() => getValidRows(inputRows.value).length);

function goBackToList() {
  if (route.query.companyId) {
    // 관리자가 대신 등록한 경우
    router.push('/admin/performance/register');
  } else {
    // 일반 사용자가 등록한 경우
    router.push('/performance/register');
  }
}

if (typeof window !== 'undefined') {
  window.products = products;
}

async function fetchProductsForMonth(month) {
  // 이미 불러온 월이면 캐시 사용
  if (productsByMonth.value[month]) return;

  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('status', 'active')
    .eq('base_month', month)
    .range(0, 2999); // 필요시 더 크게

  if (!error && data) {
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
  } else {
    productsByMonth.value[month] = []; // 에러 시 빈 배열
  }
}

watch(
  () => inputRows.value.map(row => row.prescription_month),
  async (months) => {
    // 중복 없이 월별로 fetch
    const uniqueMonths = [...new Set(months.filter(Boolean))];
    for (const month of uniqueMonths) {
      await fetchProductsForMonth(month);
    }
  },
  { deep: true }
);
</script>

<style scoped>

/* 비활성화된 입력 필드 스타일 */
.disabled-area {
  background-color: #f8f9fa !important;
  color: #6c757d !important;
  cursor: not-allowed !important;
  opacity: 0.7 !important;
}

.disabled-area:focus {
  outline: none !important;
  box-shadow: none !important;
}

.status-warning {
  background: #fff3cd;
  color: #856404;
  border: 1px solid #ffeaa7;
  margin-left: 1rem;
}

.back-btn:hover {
  color: #1976d2;
  text-decoration: underline;
}
</style>