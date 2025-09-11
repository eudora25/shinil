<template>
  <div class="signup">
    <h2>회원가입</h2>
    <form @submit.prevent="handleSignup">
      <div class="form-group">
        <label for="email">이메일</label>
        <input type="email" id="email" v-model="email" required>
      </div>
      <div class="form-group">
        <label for="password">비밀번호</label>
        <input type="password" id="password" v-model="password" required>
      </div>
      <div class="form-group">
        <label for="confirmPassword">비밀번호 확인</label>
        <input type="password" id="confirmPassword" v-model="confirmPassword" required>
      </div>
      <button type="submit" class="btn btn-primary">회원가입</button>
    </form>
    <router-link to="/login">로그인</router-link>
  </div>
</template>

<script>
export default {
  name: 'SignupView',
  data() {
    return {
      email: '',
      password: '',
      confirmPassword: ''
    }
  },
  methods: {
    handleSignup() {
      if (this.password !== this.confirmPassword) {
        alert('비밀번호가 일치하지 않습니다.')
        return
      }
      // 회원가입 로직 구현
      console.log('회원가입 시도:', this.email)
    }
  }
}
</script>

<style scoped>
.signup {
  max-width: 400px;
  margin: 0 auto;
  padding: 2rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
}

.form-group input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.btn {
  width: 100%;
  padding: 0.75rem;
  margin-top: 1rem;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}
</style>
