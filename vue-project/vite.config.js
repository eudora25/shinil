import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // 환경 변수 파일 로드
  const env = mode === 'production' ? '.env.production' : '.env.production'
  
  return {
    plugins: [
      vue(),
      vueDevTools()
    ],
    server: {
      port: 3000,
      host: true,
      proxy: {
        '/api': {
          target: 'http://localhost:3001',
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path
        }
      }
    },
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      },
    },
    optimizeDeps: {
      include: ['primevue/api', 'jszip', 'xlsx'],
    },
    build: {
      rollupOptions: {
        external: ['xlsx'],
      },
    },
    // 환경 변수 설정 - .env 파일들을 자동으로 로드
    envDir: '.',
    envPrefix: 'VITE_',
    define: {
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development')
    },
    // Swagger UI 파일들을 빌드 결과물에 포함
    publicDir: 'public'
  }
})
