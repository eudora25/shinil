<template>
  <div class="home">
    <h1>신일제약 PMS</h1>
    <p>Prescription Management System</p>
    <div class="actions">
      <router-link to="/login" class="btn btn-primary">로그인</router-link>
      <router-link to="/signup" class="btn btn-secondary">회원가입</router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeView'
}
</script>

<style scoped>
.home {
  padding: 2rem;
}

.actions {
  margin-top: 2rem;
}

.btn {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  margin: 0 0.5rem;
  text-decoration: none;
  border-radius: 4px;
  font-weight: bold;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}
</style>
