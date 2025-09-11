import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: {
        template: '<div><h1>Shinil API Server</h1><p>Welcome to Shinil API Server</p></div>'
      }
    },
    
    // API 라우트들 (컴포넌트 없이 텍스트 응답)
    {
      path: '/api/health',
      name: 'ApiHealth',
      component: {
        template: '<div>API Health Check - OK</div>'
      },
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/products',
      name: 'ApiProducts',
      component: {
        template: '<div>Products API - Use /api/products endpoint</div>'
      },
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/clients',
      name: 'ApiClients',
      component: {
        template: '<div>Clients API - Use /api/clients endpoint</div>'
      },
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/notices',
      name: 'ApiNotices',
      component: {
        template: '<div>Notices API - Use /api/notices endpoint</div>'
      },
      meta: { requiresAuth: false, isApi: true }
    },
    
    // 기본 라우트
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: {
        template: '<div>Page Not Found</div>'
      }
    }
  ]
})

// 라우터 가드
router.beforeEach(async (to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);
  
  // API 라우트는 인증 불필요
  if (to.meta.isApi) {
    return next()
  }
  
  // 모든 다른 라우트는 홈으로
  next()
})

export default router
