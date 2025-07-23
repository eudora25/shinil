<template>
  <div class="reset-password-container">
    <div class="reset-password-card">
      <h2>비밀번호 재설정</h2>
      
      <div v-if="loading" class="loading">
        처리 중입니다...
      </div>
      
      <div v-else-if="error" class="error">
        {{ error }}
        <button @click="goToLogin" class="btn-login">로그인 페이지로 이동</button>
      </div>
      
      <form v-else @submit.prevent="handleResetPassword" class="reset-form">
        <div class="form-group">
          <label for="password">새 비밀번호</label>
          <div style="position: relative;">
            <input 
              :type="showPassword ? 'text' : 'password'" 
              id="password" 
              v-model="password" 
              required 
              minlength="6"
              placeholder="새 비밀번호를 입력하세요"
              style="padding-right:2.5rem;"
            />
            <i
              :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showPassword = !showPassword"
            ></i>
          </div>
        </div>
        
        <div class="form-group">
          <label for="confirmPassword">비밀번호 확인</label>
          <div style="position: relative;">
            <input 
              :type="showPassword2 ? 'text' : 'password'" 
              id="confirmPassword" 
              v-model="confirmPassword" 
              required 
              minlength="6"
              placeholder="비밀번호를 다시 입력하세요"
              style="padding-right:2.5rem;"
            />
            <i
              :class="showPassword2 ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showPassword2 = !showPassword2"
            ></i>
          </div>
        </div>
        
        <button type="submit" :disabled="!canSubmit" class="btn-submit">
          비밀번호 변경
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const router = useRouter();
const loading = ref(true);
const error = ref('');
const password = ref('');
const confirmPassword = ref('');
const showPassword = ref(false);
const showPassword2 = ref(false);

const canSubmit = computed(() => {
  return password.value.length >= 6 && 
         password.value === confirmPassword.value;
});

onMounted(async () => {
  try {
    // URL에서 access_token과 refresh_token 확인
    const hashParams = new URLSearchParams(window.location.hash.substring(1));
    const accessToken = hashParams.get('access_token');
    const refreshToken = hashParams.get('refresh_token');
    
    if (!accessToken) {
      throw new Error('유효하지 않은 재설정 링크입니다.');
    }
    
    // 세션 설정
    const { error: sessionError } = await supabase.auth.setSession({
      access_token: accessToken,
      refresh_token: refreshToken
    });
    
    if (sessionError) {
      throw new Error('세션 설정에 실패했습니다.');
    }
    
    loading.value = false;
  } catch (err) {
    console.error('비밀번호 재설정 페이지 초기화 오류:', err);
    error.value = err.message;
    loading.value = false;
  }
});

async function handleResetPassword() {
  if (!canSubmit.value) return;
  
  loading.value = true;
  
  try {
    const { error: updateError } = await supabase.auth.updateUser({
      password: password.value
    });
    
    if (updateError) {
      throw new Error(updateError.message);
    }
    
    alert('비밀번호가 성공적으로 변경되었습니다.');
    
    // 로그아웃 후 로그인 페이지로 이동
    await supabase.auth.signOut();
    router.push('/login');
    
  } catch (err) {
    console.error('비밀번호 변경 오류:', err);
    alert('비밀번호 변경 실패: ' + err.message);
    loading.value = false;
  }
}

function goToLogin() {
  router.push('/login');
}
</script>

<style scoped>
.reset-password-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  padding: 20px;
}

.reset-password-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.reset-password-card h2 {
  text-align: center;
  margin-bottom: 1.5rem;
  color: #333;
}

.loading {
  text-align: center;
  padding: 2rem;
  color: #666;
}

.error {
  text-align: center;
  color: #e74c3c;
  padding: 1rem;
}

.reset-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
  color: #333;
}

.form-group input {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.form-group input:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
}

.btn-submit {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  margin-top: 1rem;
}

.btn-submit:hover:not(:disabled) {
  background-color: #0056b3;
}

.btn-submit:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.btn-login {
  background-color: #6c757d;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 1rem;
}

.btn-login:hover {
  background-color: #545b62;
}
</style> 