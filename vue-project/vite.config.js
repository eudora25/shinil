import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// API 경로를 가로채는 플러그인
function apiPlugin() {
  return {
    name: 'api-plugin',
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        // API 루트 경로 (/api/)
        if (req.url === '/api/' || req.url === '/api') {
          res.setHeader('Content-Type', 'application/json')
          res.end(JSON.stringify({
            test: "001",
            status: "OK",
            timestamp: new Date().toISOString(),
            version: "1.0.0",
            environment: "development"
          }))
          return
        }
        
        // API health 엔드포인트
        if (req.url === '/api/health') {
          res.setHeader('Content-Type', 'application/json')
          res.end(JSON.stringify({
            test: "001",
            status: "OK",
            timestamp: new Date().toISOString(),
            version: "1.0.0",
            environment: "development"
          }))
          return
        }
        
        // API products 엔드포인트
        if (req.url === '/api/products') {
          res.setHeader('Content-Type', 'application/json')
          res.end(JSON.stringify({
            test: "002",
            message: "Products API endpoint",
            timestamp: new Date().toISOString(),
            data: []
          }))
          return
        }
        
        // API clients 엔드포인트
        if (req.url === '/api/clients') {
          res.setHeader('Content-Type', 'application/json')
          res.end(JSON.stringify({
            test: "003",
            message: "Clients API endpoint",
            timestamp: new Date().toISOString(),
            data: []
          }))
          return
        }
        
        // API notices 엔드포인트
        if (req.url === '/api/notices') {
          res.setHeader('Content-Type', 'application/json')
          res.end(JSON.stringify({
            test: "004",
            message: "Notices API endpoint",
            timestamp: new Date().toISOString(),
            data: []
          }))
          return
        }
        
        next()
      })
    }
  }
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
    apiPlugin()
  ],
  server: {
    port: 3000,
    host: true
  },
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  optimizeDeps: {
    include: ['primevue/api', 'jszip'],
  },
})
