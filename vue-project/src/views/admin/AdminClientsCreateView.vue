<template>
  <div class="board_640">
    <div class="form-title">병의원 등록</div>
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
        <button class="btn-cancel" type="button" @click="goList">취소</button>
        <button class="btn-add" type="submit">저장</button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const clientCode = ref('');
const name = ref('');
const businessNumber = ref('');
const ownerName = ref('');
const address = ref('');
const status = ref('active');
const remarks = ref('');
const router = useRouter();

const handleSubmit = async () => {
  if (!name.value || !businessNumber.value) {
    alert('필수 항목을 모두 입력하세요.');
    return;
  }
  const { error } = await supabase.from('clients').insert([{
    client_code: clientCode.value,
    name: name.value,
    business_registration_number: businessNumber.value,
    owner_name: ownerName.value,
    address: address.value,
    status: status.value,
    remarks: remarks.value
  }]);
  if (error) {
    alert('등록 실패: ' + error.message);
  } else {
    alert('등록되었습니다.');
    router.push('/admin/clients');
  }
};

function goList() {
  router.push('/admin/clients');
}
</script>
