<template>
  <div class="admin-settlement-months-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">정산월 관리</div>
    </div>
    <div class="filter-card">
      <div class="filter-row">
        <span class="p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="정산월, 내용 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>
    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ filteredSettlementMonths.length }} 건
        </div>
        <div>
          <button class="btn-save" @click="goCreate">신규 등록</button>
        </div>
      </div>
      <DataTable
        :value="filteredSettlementMonths"
        :loading="loading"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        class="admin-settlement-months-table"
        v-model:first="currentPageFirstIndex"
        v-model:filters="filters"
        :globalFilterFields="['settlement_month', 'notice']"
      >
        <template #empty>
          <div v-if="!loading">등록된 정산월이 없습니다.</div>
        </template>
        <template #loading>정산월 목록을 불러오는 중입니다...</template>
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">
            {{ slotProps.index + currentPageFirstIndex + 1 }}
          </template>
        </Column>
        <Column field="settlement_month" header="정산월" :headerStyle="{ width: columnWidths.settlement_month }">
          <template #body="slotProps">
            <a href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">
              {{ slotProps.data.settlement_month }}
            </a>
          </template>
        </Column>
        <Column field="start_date" header="실적입력 시작일" :headerStyle="{ width: columnWidths.start_date }" />
        <Column field="end_date" header="실적입력 종료일" :headerStyle="{ width: columnWidths.end_date }" />
        <Column field="notice" header="전달 사항" :headerStyle="{ width: columnWidths.notice }" />
        <Column field="remarks" header="비고" :headerStyle="{ width: columnWidths.remarks }" />
        <Column field="status" header="상태" :headerStyle="{ width: columnWidths.status }">
          <template #body="slotProps">
            <span :class="slotProps.data.status === 'active' ? 'active-badge' : 'inactive-badge'">
              {{ slotProps.data.status === 'active' ? '활성' : '비활성' }}
            </span>
          </template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import InputText from 'primevue/inputtext';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  settlement_month: '6%',
  start_date: '8%',
  end_date: '8%',
  notice: '48%',
  remarks: '20%',
  status: '6%'
};

const settlementMonths = ref([]);
const loading = ref(false);
const router = useRouter();
const currentPageFirstIndex = ref(0);
const filters = ref({ global: { value: null, matchMode: 'contains' } });

const filteredSettlementMonths = computed(() => {
  if (!filters.value.global.value) return settlementMonths.value;
  const keyword = filters.value.global.value.toLowerCase();
  return settlementMonths.value.filter(item =>
    (item.settlement_month || '').toLowerCase().includes(keyword) ||
    (item.notice || '').toLowerCase().includes(keyword)
  );
});

function goCreate() {
  router.push('/admin/settlement-months/create');
}

function goToDetail(id) {
  router.push(`/admin/settlement-months/${id}`);
}

const fetchSettlementMonths = async () => {
  loading.value = true;
  try {
    const { data, error } = await supabase
      .from('settlement_months')
      .select('*')
      .order('settlement_month', { ascending: false });
    if (!error && data) {
      settlementMonths.value = data;
    }
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchSettlementMonths();
});
</script> 