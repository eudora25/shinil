<template>
  <div class="board_640">
    <div class="form-title">병의원 수정</div>
    <form @submit.prevent="handleSubmit" class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">병의원코드</label>
        </div>
        <div class="form-col input-col">
          <input v-model="clientCode" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">병의원명 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="name" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">사업자등록번호 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="businessNumber" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">원장명</label>
        </div>
        <div class="form-col input-col">
          <input v-model="ownerName" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">주소</label>
        </div>
        <div class="form-col input-col">
          <input v-model="address" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">상태</label>
        </div>
        <div class="form-col input-col">
          <select v-model="status">
            <option value="active">활성</option>
            <option value="inactive">비활성</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">비고</label>
        </div>
        <div class="form-col input-col">
          <input v-model="remarks" type="text" />
        </div>
      </div>
      <div class="btn-row" style="justify-content: flex-end; margin-top: 1.2rem">
        <button class="btn-cancel" type="button" @click="goDetail">취소</button>
        <button class="btn-add" type="submit">저장</button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const route = useRoute();
const router = useRouter();
const clientCode = ref('');
const name = ref('');
const businessNumber = ref('');
const ownerName = ref('');
const address = ref('');
const status = ref('active');
const remarks = ref('');

onMounted(async () => {
  const { data, error } = await supabase
    .from('clients')
    .select('*')
    .eq('id', route.params.id)
    .single();
  if (!error && data) {
    clientCode.value = data.client_code;
    name.value = data.name;
    businessNumber.value = data.business_registration_number;
    ownerName.value = data.owner_name;
    address.value = data.address;
    status.value = data.status;
    remarks.value = data.remarks;
  }
});

const handleSubmit = async () => {
  // 필수 항목: 병의원명, 사업자등록번호
  if (!name.value || !businessNumber.value) {
    alert('필수 항목(병의원명, 사업자등록번호)을 모두 입력하세요.');
    return;
  }
  const { error } = await supabase
    .from('clients')
    .update({
      client_code: clientCode.value,
      name: name.value,
      business_registration_number: businessNumber.value,
      owner_name: ownerName.value,
      address: address.value,
      status: status.value,
      remarks: remarks.value
    })
    .eq('id', route.params.id);
  if (error) {
    alert('수정 실패: ' + error.message);
  } else {
    alert('수정되었습니다.');
    router.push('/admin/clients');
  }
};

function goDetail() {
  router.push(`/admin/clients/${route.params.id}`);
}
</script>
