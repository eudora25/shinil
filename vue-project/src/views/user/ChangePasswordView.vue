<template>
  <div class="board_640">
    <div class="form-title">비밀번호 변경</div>
    <form @submit.prevent="handleSubmit" class="notice-form grid-form">
      <div class="form-row">
        <div class="form-col">
          <label>현재 비밀번호 <span class="required">*</span></label>
          <div style="position: relative;">
            <input 
              v-model="currentPassword" 
              :type="showCurrentPassword ? 'text' : 'password'" 
              required 
              placeholder="현재 비밀번호를 입력하세요"
              style="padding-right:2.5rem;"
            />
            <i
              :class="showCurrentPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showCurrentPassword = !showCurrentPassword"
            ></i>
          </div>
        </div>
        <div class="form-col"></div>
        <div class="form-col"></div>
      </div>
      <div class="form-row">
        <div class="form-col">
          <label>새 비밀번호 <span class="required">*</span></label>
          <div style="position: relative;">
            <input 
              v-model="newPassword" 
              :type="showNewPassword ? 'text' : 'password'" 
              required 
              placeholder="새 비밀번호를 입력하세요"
              minlength="6"
              style="padding-right:2.5rem;"
            />
            <i
              :class="showNewPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showNewPassword = !showNewPassword"
            ></i>
          </div>
        </div>
        <div class="form-col">
          <label>새 비밀번호 확인 <span class="required">*</span></label>
          <div style="position: relative;">
            <input 
              v-model="confirmPassword" 
              :type="showConfirmPassword ? 'text' : 'password'" 
              required 
              placeholder="새 비밀번호를 다시 입력하세요"
              minlength="6"
              style="padding-right:2.5rem;"
            />
            <i
              :class="showConfirmPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"
              style="position: absolute; right: 0.7rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 1.2rem;"
              @click="showConfirmPassword = !showConfirmPassword"
            ></i>
          </div>
        </div>
        <div class="form-col"></div>
      </div>
      
      <div class="form-row" style="margin-top: 1rem;">
        <div class="form-col col-3">
          <div style="color: #666; font-size: 0.9rem; line-height: 1.4;">
            • 비밀번호는 최소 6자 이상이어야 합니다.<br>
            • 보안을 위해 주기적으로 비밀번호를 변경해 주세요.
          </div>
        </div>
      </div>
      
      <div class="btn-row" style="justify-content: flex-end; margin-top: 2rem;">
        <button class="btn-cancel" type="button" @click="goBack">취소</button>
        <button class="btn-primary" type="submit" :disabled="loading">
          {{ loading ? '변경 중...' : '변경' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/supabase'

const router = useRouter()
const loading = ref(false)

const currentPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const showCurrentPassword = ref(false)
const showNewPassword = ref(false)
const showConfirmPassword = ref(false)

function goBack() {
  router.push('/my-info')
}

const handleSubmit = async () => {
  if (loading.value) return

  // 새 비밀번호와 확인 비밀번호 일치 확인
  if (newPassword.value !== confirmPassword.value) {
    alert('새 비밀번호와 비밀번호 확인이 일치하지 않습니다.')
    return
  }

  // 새 비밀번호 길이 확인
  if (newPassword.value.length < 6) {
    alert('새 비밀번호는 최소 6자 이상이어야 합니다.')
    return
  }

  // 현재 비밀번호와 새 비밀번호가 같은지 확인
  if (currentPassword.value === newPassword.value) {
    alert('새 비밀번호는 현재 비밀번호와 달라야 합니다.')
    return
  }

  loading.value = true

  try {
    // 먼저 현재 비밀번호가 맞는지 확인
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) {
      alert('사용자 정보를 확인할 수 없습니다.')
      return
    }

    // 현재 비밀번호로 재인증 시도
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: user.email,
      password: currentPassword.value
    })

    if (signInError) {
      alert('현재 비밀번호가 올바르지 않습니다.')
      return
    }

    // 비밀번호 변경
    const { error: updateError } = await supabase.auth.updateUser({
      password: newPassword.value
    })

    if (updateError) {
      alert('비밀번호 변경 실패: ' + updateError.message)
      return
    }

    alert('비밀번호가 성공적으로 변경되었습니다.')
    
    // 폼 초기화
    currentPassword.value = ''
    newPassword.value = ''
    confirmPassword.value = ''
    
    // 내 정보 페이지로 이동
    router.push('/my-info')

  } catch (err) {
    console.error('비밀번호 변경 오류:', err)
    alert('비밀번호 변경 중 오류가 발생했습니다: ' + (err.message || err))
  } finally {
    loading.value = false
  }
}
</script> 