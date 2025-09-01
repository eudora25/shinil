import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

// API 뷰 컴포넌트들
import ApiProductsView from '../views/api/ApiProductsView.vue'
import ApiClientsView from '../views/api/ApiClientsView.vue'
import ApiNoticesView from '../views/api/ApiNoticesView.vue'
import ApiHealthView from '../views/api/ApiHealthView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    
    // API 라우트들 (인증 불필요)
    {
      path: '/api/health',
      name: 'ApiHealth',
      component: ApiHealthView,
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/products',
      name: 'ApiProducts',
      component: ApiProductsView,
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/clients',
      name: 'ApiClients',
      component: ApiClientsView,
      meta: { requiresAuth: false, isApi: true }
    },
    {
      path: '/api/notices',
      name: 'ApiNotices',
      component: ApiNoticesView,
      meta: { requiresAuth: false, isApi: true }
    }
  ]
})

// 간단한 네비게이션 가드 - API 라우트는 모두 허용
router.beforeEach((to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);
  
  // 모든 라우트 허용 (홈과 API만 있음)
  next();
});

export default router