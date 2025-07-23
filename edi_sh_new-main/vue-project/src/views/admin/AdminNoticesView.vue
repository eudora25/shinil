<template>
  <div class="admin-notices-view page-container">
    <div class="page-header-title-area">
      <div class="header-title">공지사항 목록</div>
    </div>

    <div class="filter-card">
      <div class="filter-row">
        <span class="filter-item p-input-icon-left">
          <InputText
            v-model="filters['global'].value"
            placeholder="제목 검색"
            class="search-input"
          />
        </span>
      </div>
    </div>

    <div class="data-card">
      <div class="data-card-header">
        <div class="total-count-display">
          전체 {{ filteredNotices.length }} 건
        </div>
        <div class="action-buttons-group">
          <button class="btn-save" @click="goCreate">신규 등록</button>
        </div>
      </div>

      <DataTable
        :value="filteredNotices"
        :loading="loading"
        paginator
        :rows="50"
        :rowsPerPageOptions="[20, 50, 100]"
        scrollable
        scrollHeight="calc(100vh - 250px)"
        v-model:filters="filters"
        :globalFilterFields="['title']"
        class="admin-notices-table"
        v-model:first="currentPageFirstIndex"
      >
        <template #empty>
          <div v-if="!loading">등록된 공지사항이 없습니다.</div>
        </template>
        <template #loading>공지사항 목록을 불러오는 중입니다...</template>
        
        <Column header="No" :headerStyle="{ width: columnWidths.no }">
          <template #body="slotProps">{{ slotProps.index + currentPageFirstIndex + 1 }}</template>
        </Column>
        <Column field="is_pinned" header="필수" :headerStyle="{ width: columnWidths.is_pinned }">
          <template #body="slotProps">
            <span v-if="slotProps.data.is_pinned === true" class="required-badge">필수</span>
          </template>
        </Column>
        <Column field="title" header="제목" :headerStyle="{ width: columnWidths.title }">
          <template #body="slotProps">
            <a href="#" class="text-link" @click.prevent="goToDetail(slotProps.data.id)">{{ slotProps.data.title }}</a>
          </template>
        </Column>
        <Column field="content" header="내용" :headerStyle="{ width: columnWidths.content }">
          <template #body="slotProps">
            <span class="content-preview">{{ slotProps.data.content }}</span>
          </template>
        </Column>
        <Column field="file_count" header="첨부파일" :headerStyle="{ width: columnWidths.file_count }">
          <template #body="slotProps">
            <span>{{ slotProps.data.file_count > 0 ? slotProps.data.file_count : '-' }}</span>
          </template>
        </Column>
        <Column field="view_count" header="조회수" :headerStyle="{ width: columnWidths.view_count }" />
        <Column field="created_at" header="작성일시" :headerStyle="{ width: columnWidths.created_at }">
          <template #body="slotProps">{{ formatKST(slotProps.data.created_at) }}</template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { supabase } from '@/supabase';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import { useRouter } from 'vue-router';
import InputText from 'primevue/inputtext';

const notices = ref([]);
const loading = ref(false);
const router = useRouter();
const userType = ref('');
const search = ref('');
const currentPageFirstIndex = ref(0);

const filters = ref({
  'global': { value: null, matchMode: 'contains' }
});

// 컬럼 너비 한 곳에서 관리
const columnWidths = {
  no: '4%',
  is_pinned: '6%',
  title: '32%',
  content: '40%',
  file_count: '6%',
  view_count: '6%',
  created_at: '10%'
};

function goCreate() {
  router.push('/admin/notices/create');
}

function goToDetail(id) {
  router.push(`/admin/notices/${id}`);
}

function goEdit(id) {
  router.push(`/admin/notices/${id}/edit`);
}

function formatKST(dateStr) {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  // UTC → KST 변환
  date.setHours(date.getHours() + 9);
  const yyyy = date.getFullYear();
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const dd = String(date.getDate()).padStart(2, '0');
  const hh = String(date.getHours()).padStart(2, '0');
  const min = String(date.getMinutes()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd} ${hh}:${min}`;
}

const filteredNotices = computed(() => {
  if (!search.value) return notices.value;
  return notices.value.filter(n =>
    n.title?.includes(search.value) ||
    formatKST(n.created_at)?.includes(search.value)
  );
});

async function handleDelete(id) {
  if (!confirm('정말 삭제하시겠습니까?')) return;
  const { error } = await supabase.from('notices').delete().eq('id', id);
  if (error) {
    alert('삭제 실패: ' + error.message);
  } else {
    alert('삭제되었습니다.');
    router.push('/admin/notices'); // 삭제 후 목록으로 이동
  }
}

onMounted(async () => {
  loading.value = true;
  const { data, error } = await supabase
    .from('notices')
    .select('id, title, content, created_at, is_pinned, view_count, file_url')
    .order('is_pinned', { ascending: false })
    .order('created_at', { ascending: false });
  console.log('공지사항 데이터:', data);
  if (!error && data) {
    notices.value = data.map(n => {
      let count = 0;
      try {
        const arr = JSON.parse(n.file_url || '[]');
        count = Array.isArray(arr) ? arr.length : 0;
      } catch {
        count = 0;
      }
      return { ...n, file_count: count };
    });
  }
  loading.value = false;
  const { data: { session } } = await supabase.auth.getSession();
  userType.value = session?.user?.user_metadata?.user_type || '';
});

import { watch } from 'vue';

watch(filteredNotices, (val) => {
  console.log('filteredNotices:', val);
});
</script>