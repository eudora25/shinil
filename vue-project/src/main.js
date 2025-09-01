import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/main.css'

// Swagger UI 경로들은 Vue.js 애플리케이션에서 제외
const excludedPaths = ['/swagger-ui.html', '/docs', '/api-docs', '/swagger', '/swagger-spec.json']

if (!excludedPaths.includes(window.location.pathname)) {
  const app = createApp(App)
  app.use(router)
  app.mount('#app')
}
