import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import SignupView from '../views/SignupView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: {
        template: '<div>Page Not Found</div>'
      }
    }
  ]
})

// 간단한 네비게이션 가드 - API 라우트는 모두 허용
router.beforeEach((to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);
  
  // 현재 라우팅은 단순 페이지 이동만 처리합니다.
  next();
});
export default router
