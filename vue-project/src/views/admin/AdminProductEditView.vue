<template>
  <div class="board_640">
    <div class="form-title">제품 수정</div>
    <form @submit.prevent="handleSubmit" class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">기준월 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="baseMonth" type="text" placeholder="YYYY-MM" maxlength="7" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">제품명 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="productName" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">보험코드 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="insuranceCode" type="number" maxlength="9" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">약가 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="price" type="number" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수수료율 A</label>
        </div>
        <div class="form-col input-col">
          <input v-model="commissionA" type="number" step="0.001" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수수료율 B</label>
        </div>
        <div class="form-col input-col">
          <input v-model="commissionB" type="number" step="0.001" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수수료율 C</label>
        </div>
        <div class="form-col input-col">
          <input v-model="commissionC" type="number" step="0.001" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">표준코드 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="standardCode" type="text" maxlength="13" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">단위/포장형태</label>
        </div>
        <div class="form-col input-col">
          <input v-model="unitPackagingDesc" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">단위수량</label>
        </div>
        <div class="form-col input-col">
          <input v-model="unitQuantity" type="number" />
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
        <button class="btn-save" type="submit">저장</button>
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
const baseMonth = ref('');
const productName = ref('');
const insuranceCode = ref('');
const price = ref('');
const commissionA = ref('');
const commissionB = ref('');
const commissionC = ref('');
const standardCode = ref('');
const unitPackagingDesc = ref('');
const unitQuantity = ref('');
const status = ref('active');
const remarks = ref('');

onMounted(async () => {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', route.params.id)
    .single();
  if (!error && data) {
    baseMonth.value = data.base_month;
    productName.value = data.product_name;
    insuranceCode.value = data.insurance_code;
    price.value = data.price;
    commissionA.value = data.commission_rate_a ? data.commission_rate_a * 100 : '';
    commissionB.value = data.commission_rate_b ? data.commission_rate_b * 100 : '';
    commissionC.value = data.commission_rate_c ? data.commission_rate_c : '';
    standardCode.value = data.standard_code;
    unitPackagingDesc.value = data.unit_packaging_desc;
    unitQuantity.value = data.unit_quantity;
    status.value = data.status;
    remarks.value = data.remarks;
  }
});

const handleSubmit = async () => {
  if (!baseMonth.value || !productName.value || !insuranceCode.value || !price.value || !commissionA.value || !commissionB.value || !standardCode.value) {
    alert('필수 항목을 모두 입력하세요.');
    return;
  }
  const dataToUpdate = {
    base_month: baseMonth.value,
    product_name: productName.value,
    insurance_code: insuranceCode.value === '' ? null : Number(insuranceCode.value),
    price: price.value === '' ? null : Number(price.value),
    commission_rate_a: commissionA.value === '' ? null : Number(commissionA.value) / 100,
    commission_rate_b: commissionB.value === '' ? null : Number(commissionB.value) / 100,
    commission_rate_c: commissionC.value === '' ? null : Number(commissionC.value),
    standard_code: standardCode.value === '' ? null : standardCode.value,
    unit_packaging_desc: unitPackagingDesc.value,
    unit_quantity: unitQuantity.value === '' ? null : Number(unitQuantity.value),
    status: status.value,
    remarks: remarks.value
  };
  const { error } = await supabase
    .from('products')
    .update(dataToUpdate)
    .eq('id', route.params.id);
  if (error) {
    alert('수정 실패: ' + error.message);
  } else {
    alert('수정되었습니다.');
    router.push('/admin/products');
  }
};

function goDetail() {
  router.push(`/admin/products/${route.params.id}`);
}
</script>
