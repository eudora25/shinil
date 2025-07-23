<template>
  <div class="board_960">
    <div class="form-title">정산월 등록</div>
    <form @submit.prevent="handleSubmit" class="notice-form grid-form">
      <div class="form-row">
        <div class="form-col col-2">
          <label>정산월 <span class="required">*</span></label>
          <input v-model="settlementMonth" type="month" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col col-2">
          <label>실적입력 시작일 <span class="required">*</span></label>
          <input v-model="startDate" type="date" required />
        </div>
        <div class="form-col col-2">
          <label>실적입력 종료일 <span class="required">*</span></label>
          <input v-model="endDate" type="date" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col col-3">
          <label>전달 사항</label>
          <textarea v-model="notice" ref="noticeArea" rows="6" style="resize:vertical; min-height:80px; height:120px; white-space: pre-wrap;" @input="adjustTextareaHeight"></textarea>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col col-3">
          <label>비고</label>
          <input v-model="remarks" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col col-2">
          <label>상태</label>
          <select v-model="status">
            <option value="active">활성</option>
            <option value="inactive">비활성</option>
          </select>
        </div>
      </div>
      <div class="btn-row" style="justify-content: flex-end; margin-top: 1.2rem">
        <button class="btn-cancel" type="button" @click="goList">취소</button>
        <button class="btn-save" type="submit">저장</button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const settlementMonth = ref('');
const startDate = ref('');
const endDate = ref('');
const notice = ref('');
const status = ref('active');
const remarks = ref('');
const router = useRouter();
const noticeArea = ref(null);

const adjustTextareaHeight = () => {
  if (noticeArea.value) {
    noticeArea.value.style.height = 'auto';
    noticeArea.value.style.height = `${noticeArea.value.scrollHeight}px`;
  }
};

import { watch } from 'vue';
watch(notice, () => {
  nextTick(adjustTextareaHeight);
});

const handleSubmit = async () => {
  if (!settlementMonth.value || !startDate.value || !endDate.value) {
    alert('필수 항목을 모두 입력하세요.');
    return;
  }

  const { error } = await supabase.from('settlement_months').insert([{
    settlement_month: settlementMonth.value,
    start_date: startDate.value,
    end_date: endDate.value,
    notice: notice.value,
    status: status.value,
    remarks: remarks.value
  }]);

  if (error) {
    alert('등록 실패: ' + error.message);
  } else {
    alert('등록되었습니다.');
    router.push('/admin/settlement-months');
  }
};

function goList() {
  router.push('/admin/settlement-months');
}
</script> 