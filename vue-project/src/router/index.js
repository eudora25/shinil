import { createRouter, createWebHistory } from 'vue-router'
<<<<<<< HEAD
=======
<<<<<<< HEAD
import HomeView from '../views/HomeView.vue'

// API 뷰 컴포넌트들
import ApiProductsView from '../views/api/ApiProductsView.vue'
import ApiClientsView from '../views/api/ApiClientsView.vue'
import ApiNoticesView from '../views/api/ApiNoticesView.vue'
import ApiHealthView from '../views/api/ApiHealthView.vue'
=======
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
>>>>>>> 6498a7c01ae8609f577b78e0fd9326bb9412e516

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
<<<<<<< HEAD
      component: {
        template: '<div><h1>Shinil API Server</h1><p>Welcome to Shinil API Server</p></div>'
      }
=======
      component: () => import('@/components/HomeComponent.vue')
>>>>>>> 6498a7c01ae8609f577b78e0fd9326bb9412e516
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
<<<<<<< HEAD
=======
    },
    
    // 기본 라우트
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: {
        template: '<div>Page Not Found</div>'
      }
<<<<<<< HEAD
=======
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716
>>>>>>> 6498a7c01ae8609f577b78e0fd9326bb9412e516
    }
  ]
})

<<<<<<< HEAD
// 라우터 가드
router.beforeEach(async (to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);
  
=======
<<<<<<< HEAD
// 간단한 네비게이션 가드 - API 라우트는 모두 허용
router.beforeEach((to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);
  
  // 모든 라우트 허용 (홈과 API만 있음)
  next();
});
=======
// 라우터 가드
router.beforeEach(async (to, from, next) => {
>>>>>>> 6498a7c01ae8609f577b78e0fd9326bb9412e516
  // API 라우트는 인증 불필요
  if (to.meta.isApi) {
    return next()
  }
  
  // 모든 다른 라우트는 홈으로
  next()
})
<<<<<<< HEAD

export default router
=======
>>>>>>> 14a20b52e32c177e5a54c7475ce8e70453839716

export default router
>>>>>>> 6498a7c01ae8609f577b78e0fd9326bb9412e516
