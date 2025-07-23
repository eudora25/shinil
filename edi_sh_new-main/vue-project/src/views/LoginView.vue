<template>
  <div class="login-root">
    <div class="login-right">
      <div class="login-logo">신일제약 실적관리 시스템</div>
      <form class="login-form" @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="email">아이디(이메일)</label>
          <input id="email" type="email" v-model="email" ref="emailInputRef" />
        </div>
        <div class="form-group" style="margin-top: 0rem; margin-bottom: 1rem;">
          <label for="password">비밀번호</label>
          <div style="position: relative;">
            <input
              id="password"
              :type="showPassword ? 'text' : 'password'"
              v-model="password"
              style="padding-right: 2.5rem;"
            />
            <i
              :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showPassword = !showPassword"
            ></i>
          </div>
        </div>
        <Button :label="'로그인'" class="login-btn" :disabled="!canLogin" :style="loginBtnStyle" @click="handleLogin" />
        <Button label="회원가입" class="signup-btn" @click="$router.push('/signup')" />
        <div class="login-link">
          <a href="#" @click.prevent="openPasswordResetModal">비밀번호를 잊으셨나요?</a>
        </div>
      </form>
      <div class="copyright">© 2025. 주식회사 팜플코리아 All Rights Reserved.</div>
    </div>

    <!-- 비밀번호 재설정 이메일 입력 모달 -->
    <teleport to="body">
      <div v-if="isPasswordResetModalOpen" class="modal-overlay" @click="closePasswordResetModal">
        <div class="modal-content modal-center" @click.stop>
          <div class="modal-header">
            <h2>비밀번호 찾기</h2>
            <button @click="closePasswordResetModal" class="btn-close-nobg">X</button>
          </div>
          <div class="modal-body">
            <p style="margin-bottom: 1rem;">비밀번호를 재설정하려면 아이디(이메일)를 입력해주세요.</p>
            <input 
              v-model="resetEmail" 
              type="email" 
              placeholder="가입 시 사용한 이메일 주소"
              class="modal-input"
            />
          </div>
          <div class="modal-footer">
            <button class="btn-cancel" @click="closePasswordResetModal">취소</button>
            <button class="btn-primary" @click="handlePasswordReset" :disabled="loading">
              {{ loading ? '전송 중...' : '비밀번호 재설정 링크 받기' }}
            </button>
          </div>
        </div>
      </div>
    </teleport>

    <!-- 재설정 이메일 발송 완료 안내 모달 -->
    <teleport to="body">
       <div v-if="isConfirmationModalOpen" class="modal-overlay" @click="closeConfirmationModal">
        <div class="modal-content modal-center" @click.stop>
          <div class="modal-header">
            <h2>안내</h2>
             <button @click="closeConfirmationModal" class="btn-close-nobg">X</button>
          </div>
          <div class="modal-body">
            <p>비밀번호 재설정 이메일을 보냈습니다.<br>받은 편지함을 확인해주세요.</p>
          </div>
          <div class="modal-footer">
            <button class="btn-primary" @click="closeConfirmationModal">확인</button>
          </div>
        </div>
      </div>
    </teleport>

  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import Button from 'primevue/button';
import { supabase } from '@/supabase';
import { useRouter } from 'vue-router';

const email = ref('');
const password = ref('');
const loading = ref(false);
const router = useRouter();
const emailInputRef = ref(null);

const isPasswordResetModalOpen = ref(false);
const isConfirmationModalOpen = ref(false);
const resetEmail = ref('');
const showPassword = ref(false);

const canLogin = computed(() => email.value.trim() !== '' && password.value.trim() !== '');
const loginBtnStyle = computed(() => ({
  background: canLogin.value ? '#5FA56B' : '#ABCEB2',
  color: canLogin.value ? '#fff' : '#fff',
  border: 'none',
  width: '100%',
  marginBottom: '0.5rem',
  fontSize: '1rem',
  cursor: canLogin.value ? 'pointer' : 'not-allowed',
}));

const handleLogin = async () => {
  if (!canLogin.value) return;
  loading.value = true;
  try {
    const { data: companyRow } = await supabase
      .from('companies')
      .select('id, approval_status, user_type')
      .eq('email', email.value.trim().toLowerCase())
      .maybeSingle();
    if (!companyRow) {
      alert('아이디(이메일) 정보가 없습니다. 다시 확인해주세요.');
      loading.value = false;
      return;
    }
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });
    if (authError) {
      alert('비밀번호가 일치하지 않습니다. 다시 확인해주세요.');
      loading.value = false;
      return;
    }
    if (companyRow.approval_status !== 'approved') {
      alert('미승인 회원입니다. 관리자에게 승인을 요청해주세요.');
      await supabase.auth.signOut();
      loading.value = false;
      return;
    }
    if (companyRow.user_type === 'admin') {
      router.push('/admin/notices');
    } else {
      router.push('/notices');
    }
  } catch (error) {
    alert('로그인 중 오류가 발생했습니다.');
  } finally {
    loading.value = false;
  }
};

const openPasswordResetModal = () => {
  resetEmail.value = email.value; // 로그인 폼에 입력된 이메일을 기본값으로 설정
  isPasswordResetModalOpen.value = true;
};

const closePasswordResetModal = () => {
  isPasswordResetModalOpen.value = false;
  loading.value = false;
};

const closeConfirmationModal = () => {
  isConfirmationModalOpen.value = false;
};

const handlePasswordReset = async () => {
  if (!resetEmail.value) {
    alert('아이디(이메일)를 입력해주세요.'); // 모달 내에서의 유효성 검사는 간단하게 alert 사용
    return;
  }
  loading.value = true;
  try {
    const { error } = await supabase.auth.resetPasswordForEmail(resetEmail.value, {
      redirectTo: `${window.location.origin}/reset-password`,
    });
    if (error) {
      if (error.message.includes('not found')) {
        alert('가입되지 않은 이메일입니다. 이메일 주소를 다시 확인해주세요.');
      } else {
        alert(`오류가 발생했습니다: ${error.message}`);
      }
    } else {
      closePasswordResetModal();
      isConfirmationModalOpen.value = true;
    }
  } catch (err) {
    alert('예기치 않은 오류가 발생했습니다.');
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  document.body.classList.add('no-main-padding');
  if (emailInputRef.value) {
    emailInputRef.value.focus();
  }
});

onUnmounted(() => {
  document.body.classList.remove('no-main-padding');
});
</script> 