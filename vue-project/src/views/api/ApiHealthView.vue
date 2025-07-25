<template>
  <div class="api-container">
    <div class="api-response">
      <h2>API Health Check</h2>
      <div class="status-info">
        <p><strong>Status:</strong> <span class="status-ok">OK</span></p>
        <p><strong>Timestamp:</strong> {{ timestamp }}</p>
        <p><strong>Version:</strong> 1.0.0</p>
        <p><strong>Environment:</strong> {{ environment }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const timestamp = ref('')
const environment = ref('production')

onMounted(() => {
  timestamp.value = new Date().toISOString()
  environment.value = import.meta.env.MODE || 'development'
})
</script>

<style scoped>
.api-container {
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
  font-family: 'Courier New', monospace;
}

.api-response {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 2rem;
}

.status-info {
  margin-top: 1rem;
}

.status-info p {
  margin: 0.5rem 0;
  font-size: 1rem;
}

.status-ok {
  color: #28a745;
  font-weight: bold;
}

h2 {
  color: #333;
  margin-bottom: 1rem;
}
</style> 