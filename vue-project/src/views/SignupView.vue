<template>
  <div class="signup-root">
    <div class="signup-right">
      <div class="signup-logo">신일제약 실적관리 시스템</div>
      <form class="signup-form" @submit.prevent="handleSignup">
        <div class="form-row" v-for="field in fields" :key="field.key">
          <label :for="field.key">{{ field.label }}</label>
          <input
            v-if="field.type !== 'password' && field.type !== 'password2'"
            :id="field.key"
            :type="field.inputType"
            v-model="formData[field.key]"
          />
          <div v-else-if="field.type === 'password'" style="position: relative;">
            <input
              :id="field.key"
              :type="showPassword ? 'text' : 'password'"
              v-model="formData.password"
              style="padding-right: 2.5rem;"
            />
            <i
              :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showPassword = !showPassword"
            ></i>
          </div>
          <div v-else-if="field.type === 'password2'" style="position: relative;">
            <input
              :id="field.key"
              :type="showPassword2 ? 'text' : 'password'"
              v-model="formData.confirmPassword"
              style="padding-right: 2.5rem;"
            />
            <i
              :class="showPassword2 ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showPassword2 = !showPassword2"
            ></i>
          </div>
        </div>
        <div class="button-row">
          <Button label="회원가입" class="signup-btn" @click="handleSignup" />
          <Button label="취소" class="cancel-btn" @click.prevent="goToLogin" />
        </div>
        <div class="login-link">
          <a @click.prevent="goToLogin" href="#">이미 계정이 있으신가요? 로그인</a>
        </div>
      </form>
      <div class="copyright">© 2025. 주식회사 팜플코리아 All Rights Reserved.</div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import Button from 'primevue/button';
import { supabase } from '@/supabase';
import { useRouter } from 'vue-router';
import { onMounted, onUnmounted } from 'vue';

const formData = ref({
  email: '',
  password: '',
  confirmPassword: '',
  companyName: '',
  businessRegistrationNumber: '',
  representativeName: '',
  businessAddress: '',
  contactPersonName: '',
  mobilePhone: '',
});
const router = useRouter();

const fields = [
  { key: 'email', label: '아이디(이메일)', inputType: 'email' },
  { key: 'password', label: '비밀번호', type: 'password' },
  { key: 'confirmPassword', label: '비밀번호 확인', type: 'password2' },
  { key: 'companyName', label: '업체명', inputType: 'text' },
  { key: 'businessRegistrationNumber', label: '사업자등록번호', inputType: 'text' },
  { key: 'representativeName', label: '대표자명', inputType: 'text' },
  { key: 'businessAddress', label: '사업장 소재지', inputType: 'text' },
  { key: 'contactPersonName', label: '담당자명', inputType: 'text' },
  { key: 'mobilePhone', label: '휴대폰번호', inputType: 'text' },
];

const showPassword = ref(false);
const showPassword2 = ref(false);

const handleSignup = async () => {
  if (formData.value.password !== formData.value.confirmPassword) {
    alert('비밀번호가 일치하지 않습니다.');
    return;
  }
  try {
    const emailLower = formData.value.email.trim().toLowerCase();
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: emailLower,
      password: formData.value.password,
      options: {
        data: {
          user_type: 'user',
          approval_status: 'pending'
        }
      }
    });
    if (authError) throw authError;

    if (authData && authData.user) {
      const companyDataToInsert = {
        user_id: authData.user.id,
        email: emailLower,
        company_name: formData.value.companyName,
        business_registration_number: formData.value.businessRegistrationNumber,
        representative_name: formData.value.representativeName,
        business_address: formData.value.businessAddress,
        contact_person_name: formData.value.contactPersonName,
        mobile_phone: formData.value.mobilePhone,
        user_type: 'user',
        approval_status: 'pending',
        created_by: authData.user.id,
      };

      // 1. companies 테이블에 먼저 insert
      const { error: companyInsertError } = await supabase
        .from('companies')
        .insert([companyDataToInsert]);
      if (companyInsertError) throw companyInsertError;

      // 2. 안내 후 로그아웃
      alert('가입 요청이 완료되었습니다. 관리자 승인 후 로그인 가능합니다.');
      await supabase.auth.signOut();
      router.push('/login');
    } else {
      throw new Error('사용자 정보가 생성되지 않았습니다.');
    }
  } catch (error) {
    alert('가입 요청 실패: ' + (error.error_description || error.message));
  }
};

const goToLogin = () => {
  router.push('/login');
};

onMounted(() => {
  document.body.classList.add('no-main-padding');
});

onUnmounted(() => {
  document.body.classList.remove('no-main-padding');
});
</script> 