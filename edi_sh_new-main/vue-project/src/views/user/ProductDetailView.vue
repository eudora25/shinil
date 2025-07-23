<template>
  <div class="board_640">
    <div class="form-title">제품 상세</div>
    <div class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">기준월</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.base_month || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">제품명</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.product_name || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">보험코드</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.insurance_code || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">약가</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.price || '-'" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수수료율(%)</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="getCommissionRate()" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">상태</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.status === 'active' ? '활성' : (product.status === 'inactive' ? '비활성' : '-')" readonly disabled />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">비고</label>
        </div>
        <div class="form-col input-col">
          <input class="input-readonly-detail" :value="product.remarks || '-'" readonly disabled />
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
const product = ref({});
const userCommissionGrade = ref('A'); // 사용자 등급 (기본값 A)

// 사용자 등급에 따른 수수료율 반환
function getCommissionRate() {
  let rate = 0;
  if (userCommissionGrade.value === 'A') {
    rate = product.value.commission_rate_a || 0;
  } else if (userCommissionGrade.value === 'B') {
    rate = product.value.commission_rate_b || 0;
  } else {
    // C 등급이나 기타 등급의 경우 기본적으로 A 등급 수수료율 표시
    rate = product.value.commission_rate_a || 0;
  }
  
  return rate ? (rate * 100).toFixed(1) : '-';
}

// 사용자 등급 정보 가져오기
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
    userCommissionGrade.value = 'A'; // 오류 시 기본값
  }
};

onMounted(async () => {
  await fetchUserCommissionGrade();
  
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', route.params.id)
    .single();
  if (!error && data) {
    product.value = data;
  }
});

function goList() {
  router.push('/products');
}
</script>
