<template>
  <div class="admin-products-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">제품 목록</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <div style="display: flex; align-items: center; gap: 8px; margin-right: 24px;">
          <label style="white-space: nowrap;">기준월</label>
          <select v-model="selectedMonth" @change="filterByMonth" class="select_month">
            <option v-for="month in availableMonths" :key="month" :value="month">
              {{ month }}
            </option>
          </select>
        </div>
        <span class="filter-item p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="제품명, 보험코드 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>
    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ filteredProducts.length }} 건
        </div>
        <div class="data-card-buttons">
          <button class="btn-excell-download" @click="downloadExcel" :disabled="filteredProducts.length === 0">
            엑셀 다운로드
          </button>
        </div>
      </div>
      <DataTable
        :value="filteredProducts"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['base_month', 'product_name', 'insurance_code']"
        class="custom-table products-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>등록된 제품이 없습니다.</template>
        <template #loading>제품 목록을 불러오는 중입니다...</template>
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
        </Column>
        <Column field="product_name" header="제품명" :headerStyle="{ width: columnWidths.product_name }" :sortable="true">
          <template #body="slotProps">
            <a href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">{{ slotProps.data.product_name }}</a>
          </template>
        </Column>
        <Column field="insurance_code" header="보험코드" :headerStyle="{ width: columnWidths.insurance_code }" :sortable="true" />
        <Column field="price" header="약가" :headerStyle="{ width: columnWidths.price }" :sortable="true">
          <template #body="slotProps">
            {{ slotProps.data.price !== undefined && slotProps.data.price !== null ? slotProps.data.price.toLocaleString() : '' }}
          </template>
        </Column>
        <Column header="수수료율(%)" :headerStyle="{ width: columnWidths.commission_rate }" :sortable="true">
          <template #body="slotProps">
            {{ getCommissionRate(slotProps.data) }}
          </template>
        </Column>
        <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" :sortable="true" />
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import InputText from 'primevue/inputtext';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';
import * as XLSX from 'xlsx';

const products = ref([]);
const filters = ref({ 'global': { value: null, matchMode: 'contains' } });
const selectedMonth = ref(''); // 문자열로 관리
const availableMonths = ref([]); // 기준월 목록
const router = useRouter();
const userCommissionGrade = ref('A');
const currentPageFirstIndex = ref(0);
const loading = ref(false); // 로딩 상태 추가

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  product_name: '28%',
  insurance_code: '20%',
  price: '12%',
  commission_rate: '12%',
  remarks: '24%'
};

// 기준월 목록 생성 (최신순)
const generateAvailableMonths = () => {
  const monthSet = new Set();
  products.value.forEach((product) => {
    if (product.base_month) {
      monthSet.add(product.base_month);
    }
  });
  availableMonths.value = Array.from(monthSet).sort((a, b) => b.localeCompare(a));
}

// 기준월 + 보험코드 기준 유니크 필터링
const filteredProducts = computed(() => {
  if (!selectedMonth.value) return [];
  const seen = new Set();
  return products.value.filter((p) => {
    if (p.base_month !== selectedMonth.value) return false;
    if (seen.has(p.insurance_code)) return false;
    seen.add(p.insurance_code);
    return true;
  });
});

function getCommissionRate(product) {
  let rate = 0;
  if (userCommissionGrade.value === 'A') {
    rate = product.commission_rate_a || 0;
  } else if (userCommissionGrade.value === 'B') {
    rate = product.commission_rate_b || 0;
  } else {
    rate = product.commission_rate_a || 0;
  }
  return rate ? (rate * 100).toFixed(1) + '%' : '-';
}

function goToDetail(id) {
  router.push(`/products/${id}`);
}

const fetchProducts = async () => {
  loading.value = true;
  try {
    // 페이지네이션을 사용하여 모든 기준월 데이터 가져오기
    let allMonthData = [];
    let hasMore = true;
    let offset = 0;
    const limit = 1000;
    
    while (hasMore) {
      const { data: monthData, error: monthError } = await supabase
        .from('products')
        .select('base_month')
        .eq('status', 'active')
        .not('base_month', 'is', null)
        .order('base_month', { ascending: false })
        .range(offset, offset + limit - 1);
      
      if (monthError) {
        console.error('기준월 목록 로딩 오류:', monthError);
        return;
      }
      
      if (monthData && monthData.length > 0) {
        allMonthData = allMonthData.concat(monthData);
        offset += limit;
        
        // 더 이상 데이터가 없으면 중단
        if (monthData.length < limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    }
    
    console.log('가져온 기준월 데이터 개수:', allMonthData.length);
    
    // 중복 제거하고 최신순으로 정렬
    const monthSet = new Set();
    allMonthData.forEach((item) => {
      if (item.base_month) {
        monthSet.add(item.base_month);
      }
    });
    
    availableMonths.value = Array.from(monthSet).sort((a, b) => {
      return b.localeCompare(a); // 최신순 정렬
    });
    
    console.log('추출된 기준월 목록:', availableMonths.value);
    
    // 최신 연월을 기본값으로 설정하고 해당 월의 제품 불러오기
    if (availableMonths.value.length > 0) {
      selectedMonth.value = availableMonths.value[0];
      await fetchProductsByMonth(selectedMonth.value);
    }
  } catch (err) {
    console.error('기준월 목록 로딩 오류:', err);
  } finally {
    loading.value = false;
  }
}

// 선택된 기준월의 제품만 불러오는 함수
const fetchProductsByMonth = async (month) => {
  if (!month) return;
  
  loading.value = true;
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('status', 'active')
      .eq('base_month', month)
      .order('product_name', { ascending: true })
      .limit(1000); // 한 달에 423개이므로 1000개 제한으로 충분
    
    if (error) {
      console.error('제품 데이터 로딩 오류:', error);
      return;
    }
    
    products.value = data || [];
  } catch (err) {
    console.error('제품 데이터 로딩 오류:', err);
  } finally {
    loading.value = false;
  }
}

// 기준월 변경 시 제품 다시 불러오기
const filterByMonth = async () => {
  if (selectedMonth.value) {
    await fetchProductsByMonth(selectedMonth.value);
  }
}

const fetchUserCommissionGrade = async () => {
  try {
    const { data: { session } } = await supabase.auth.getSession();
    if (!session?.user) return;
    const { data: company, error } = await supabase
      .from('companies')
      .select('default_commission_grade')
      .eq('user_id', session.user.id)
      .single();
    if (!error && company) {
      userCommissionGrade.value = company.default_commission_grade || 'A';
    }
  } catch (err) {
    console.error('사용자 등급 조회 오류:', err);
    userCommissionGrade.value = 'A';
  }
};

// 엑셀 다운로드 함수
function downloadExcel() {
  if (!filteredProducts.value || filteredProducts.value.length === 0) {
    alert('다운로드할 데이터가 없습니다.');
    return;
  }

  // 엑셀 데이터 준비
  const excelData = filteredProducts.value.map((product, index) => ({
    'No': index + 1,
    '기준월': product.base_month || '',
    '제품명': product.product_name || '',
    '보험코드': product.insurance_code || '',
    '약가': product.price || 0,
    '수수료율(%)': getCommissionRate(product),
    '비고': product.remarks || ''
  }));

  // 워크북 생성
  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(excelData);

  // 컬럼 너비 설정
  ws['!cols'] = [
    { wpx: 50 },  // No
    { wpx: 80 },  // 기준월
    { wpx: 200 }, // 제품명
    { wpx: 120 }, // 보험코드
    { wpx: 80 },  // 약가
    { wpx: 100 }, // 수수료율
    { wpx: 150 }  // 비고
  ];

  // 숫자 형식 설정
  const range = XLSX.utils.decode_range(ws['!ref']);
  for (let R = range.s.r + 1; R <= range.e.r; R++) {
    // 약가 컬럼 (E열, 인덱스 4)
    const priceCell = XLSX.utils.encode_cell({ r: R, c: 4 });
    if (ws[priceCell] && typeof ws[priceCell].v === 'number') {
      ws[priceCell].z = '#,##0';
    }
  }

  // 워크시트를 워크북에 추가
  XLSX.utils.book_append_sheet(wb, ws, '제품 목록');

  // 파일명 생성
  const today = new Date();
  const dateStr = today.toISOString().slice(0, 10).replace(/-/g, '');
  let fileName = '제품목록';
  if (selectedMonth.value) {
    fileName += `_${selectedMonth.value}`;
  }
  fileName += `_${dateStr}.xlsx`;

  // 파일 다운로드
  XLSX.writeFile(wb, fileName);
}

onMounted(async () => {
  await fetchUserCommissionGrade();
  await fetchProducts();
});
</script>
