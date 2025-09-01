<template>
  <div class="board_640">
    <div class="form-title">병의원 상세</div>
    <div class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">병의원코드</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.client_code || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">병의원명</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.name || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">사업자등록번호</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.business_registration_number || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">원장명</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.owner_name || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">주소</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.address || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">상태</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.status === 'active' ? '활성' : (client.status === 'inactive' ? '비활성' : '-')" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">비고</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="client.remarks || '-'" readonly disabled />
        </div>
      </div>
      <div class="btn-row" style="justify-content: flex-end; margin-top: 1.2rem">
        <button class="btn-list" type="button" @click="goList">목록</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const route = useRoute();
const router = useRouter();
const client = ref({});

onMounted(async () => {
  const { data, error } = await supabase
    .from('clients')
    .select('*')
    .eq('id', route.params.id)
    .single();
  if (!error && data) {
    client.value = data;
  }
});

function goList() {
  // 이전 화면이 실적 등록인지 확인
  if (route.query.from === 'performance-register') {
    router.push('/performance/register');
  } else {
    router.push('/clients');
  }
}
</script>