import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// API 경로를 포트 3001로 프록시하는 플러그인
function apiPlugin() {
  return {
    name: 'api-plugin',
    configureServer(server) {
      server.middlewares.use(async (req, res, next) => {
        // API 경로인 경우 포트 3001로 프록시
        if (req.url.startsWith('/api/')) {
          try {
            const response = await fetch(`http://localhost:3001${req.url}`, {
              method: req.method,
              headers: {
                'Content-Type': 'application/json',
                ...req.headers
              },
              body: req.method !== 'GET' ? JSON.stringify(req.body) : undefined
            });
            
            const data = await response.json();
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify(data));
            return;
          } catch (error) {
            console.error('API proxy error:', error);
            res.status(500).json({
              success: false,
              message: 'API 서버 연결 오류',
              error: error.message
            });
            return;
          }
        }
        
        next();
      });
    }
  }
}

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // 환경 변수 파일 로드
  const env = mode === 'production' ? '.env.production' : '.env.production'
  
  return {
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
    // 환경 변수 설정 - .env.production 파일을 강제로 사용
    envDir: '.',
    envPrefix: 'VITE_',
    define: {
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
      'import.meta.env.VITE_SUPABASE_URL': JSON.stringify('https://qtnhpuzfxiblltvytigl.supabase.co'),
      'import.meta.env.VITE_SUPABASE_ANON_KEY': JSON.stringify('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0bmhwdXpmeGlibGx0dnl0aWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3NjY1NTYsImV4cCI6MjA2OTM0MjU1Nn0.XAra9lsCKqTEsP-0w91-AwRvWKjx5Wh4Jascd1YqoVE')
    }
  }
})
