<template>
  <TopNavigationBar :breadcrumbMenu="'업체 관리'" :breadcrumbSubMenu="breadcrumbSubMenu" />
  <div class="board_640">
    <div class="form-title">신규 업체 등록</div>
    <form @submit.prevent="handleSubmit" class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">아이디(이메일) <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="email" type="email" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">비밀번호 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col" style="position: relative;">
          <input v-model="password" :type="showPassword ? 'text' : 'password'" required style="padding-right:2.5rem;" />
          <i
            :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
            style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
            @click="showPassword = !showPassword"
          ></i>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">비밀번호 확인 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col" style="position: relative;">
          <input v-model="confirmPassword" :type="showPassword2 ? 'text' : 'password'" required style="padding-right:2.5rem;" />
          <i
            :class="showPassword2 ? 'pi pi-eye-slash' : 'pi pi-eye'"
            style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
            @click="showPassword2 = !showPassword2"
          ></i>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">업체명 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="companyName" type="text" required />
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
          <label style="text-align: right;">대표자 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="representative" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">사업장 소재지 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="address" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">유선전화</label>
        </div>
        <div class="form-col input-col">
          <input v-model="landline" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">담당자 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="contactPerson" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">휴대폰 번호 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col">
          <input v-model="mobile" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">휴대폰 번호 2</label>
        </div>
        <div class="form-col input-col">
          <input v-model="mobile2" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수신용 이메일</label>
        </div>
        <div class="form-col input-col">
          <input v-model="receiveEmail" type="email" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">구분</label>
        </div>
        <div class="form-col input-col">
          <input v-model="companyGroup" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">수수료 등급</label>
        </div>
        <div class="form-col input-col">
          <select v-model="commissionGrade">
            <option disabled value="">등급 선택</option>
            <option v-for="item in commissionGradeOptions" :key="item.value" :value="item.value">
              {{ item.label }}
            </option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">관리자</label>
        </div>
        <div class="form-col input-col">
          <input v-model="manager" type="text" />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col">
          <label style="text-align: right;">승인여부</label>
        </div>
        <div class="form-col input-col">
          <select v-model="approvalStatus">
            <option disabled value="">승인여부 선택</option>
            <option v-for="item in approvalStatusOptions" :key="item.value" :value="item.value">
              {{ item.label }}
            </option>
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
        <Button class="btn-cancel" type="button" @click="goList" label="취소" />
        <Button class="btn-save" type="submit" label="등록" />
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Dropdown from 'primevue/dropdown'
import Button from 'primevue/button'
import { supabase } from '@/supabase'
import TopNavigationBar from '@/components/TopNavigationBar.vue'

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const companyName = ref('')
const businessNumber = ref('')
const representative = ref('')
const address = ref('')
const landline = ref('')
const contactPerson = ref('')
const mobile = ref('')
const mobile2 = ref('')
const receiveEmail = ref('')
const companyGroup = ref('')
const commissionGrade = ref('A')
const manager = ref('')
const remarks = ref('')
const approvalStatus = ref('미승인')
const router = useRouter()
const route = useRoute()
const loading = ref(false)
const showPassword = ref(false)
const showPassword2 = ref(false)

const commissionGradeOptions = [
  { label: 'A', value: 'A' },
  { label: 'B', value: 'B' },
  { label: 'C', value: 'C' },
]
const approvalStatusOptions = [
  { label: '승인', value: '승인' },
  { label: '미승인', value: '미승인' },
]

const breadcrumbSubMenu = computed(() => {
  if (route.query.from === 'pending') return '미승인 업체'
  return '승인 업체'
})

function getListPath() {
  // 쿼리 또는 라우트에서 listType(approved/pending) 확인
  const type = route.query.from
  if (type === 'pending') return '/admin/companies/pending'
  return '/admin/companies/approved'
}

function goList() {
  const from = route.query.from === 'pending' ? 'pending' : 'approved';
  router.push(`/admin/companies/${from}`);
}

const handleSubmit = async () => {
  if (loading.value) return;
  
  // 필수 입력값 체크
  if (
    !email.value ||
    !password.value ||
    !confirmPassword.value ||
    !companyName.value ||
    !businessNumber.value ||
    !representative.value ||
    !address.value ||
    !contactPerson.value ||
    !mobile.value
  ) {
    alert('필수 항목을 모두 입력해 주세요.');
    return;
  }

  if (password.value !== confirmPassword.value) {
    alert('비밀번호가 일치하지 않습니다.');
    return;
  }

  loading.value = true;
  try {
    // 1. 이메일 중복 체크
    const { data: emailDup } = await supabase
      .from('companies')
      .select('id')
      .eq('email', email.value)
      .maybeSingle();
    if (emailDup) {
      alert('이미 등록된 이메일입니다.');
      return;
    }

    // 2. 사업자등록번호 중복 체크
    const { data: brnDup } = await supabase
      .from('companies')
      .select('id')
      .eq('business_registration_number', businessNumber.value)
      .maybeSingle();
    if (brnDup) {
      alert('이미 등록된 사업자등록번호입니다.');
      return;
    }

    // 3. Supabase Auth 회원가입
    const { data: signUpData, error: signUpError } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        data: {
          user_type: 'user',
          company_name: companyName.value,
        },
      },
    });
    if (signUpError) {
      alert('회원가입 실패: ' + signUpError.message);
      return;
    }

    const userId = signUpData.user?.id;

    // 4. companies 테이블에 데이터 저장
    const companyDataToInsert = {
      email: email.value,
      company_name: companyName.value,
      business_registration_number: businessNumber.value,
      representative_name: representative.value,
      business_address: address.value,
      landline_phone: landline.value,
      contact_person_name: contactPerson.value,
      mobile_phone: mobile.value,
      mobile_phone_2: mobile2.value,
      receive_email: receiveEmail.value,
      company_group: companyGroup.value,
      default_commission_grade: commissionGrade.value,
      assigned_pharmacist_contact: manager.value,
      approval_status: approvalStatus.value === '승인' ? 'approved' : 'pending',
      remarks: remarks.value,
      user_id: userId,
      user_type: 'user',
      status: 'active',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      created_by: userId,
    };

    if (approvalStatus.value === '승인') {
      companyDataToInsert.approved_at = new Date().toISOString();
    }

    const { error: insertError } = await supabase.from('companies').insert(companyDataToInsert);
    if (insertError) {
      alert('업체 등록 실패: ' + insertError.message);
      return;
    }

    alert('등록되었습니다.');
    const from = route.query.from === 'pending' ? 'pending' : 'approved';
    router.push(`/admin/companies/${from}`);
  } catch (err) {
    console.error('업체 등록 중 오류가 발생했습니다.', err);
    alert('업체 등록에 실패했습니다.');
  } finally {
    loading.value = false;
  }
};
</script>
