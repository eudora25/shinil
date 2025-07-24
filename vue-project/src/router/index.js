import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import SignupView from '../views/SignupView.vue'
import AdminNoticesView from '../views/admin/AdminNoticesView.vue'
import NoticesView from '@/views/user/NoticesView.vue'

import AdminCompaniesApprovedView from '../views/admin/AdminCompaniesApprovedView.vue'
import AdminCompaniesPendingView from '../views/admin/AdminCompaniesPendingView.vue'
import AdminCompanyCreateView from '../views/admin/AdminCompanyCreateView.vue'
import AdminCompanyDetailView from '../views/admin/AdminCompanyDetailView.vue'
import AdminCompanyEditView from '../views/admin/AdminCompanyEditView.vue'
import AdminProductsView from '../views/admin/AdminProductsView.vue'
import AdminProductCreateView from '../views/admin/AdminProductCreateView.vue'
import AdminClientsView from '../views/admin/AdminClientsView.vue'
import AdminClientsCreateView from '../views/admin/AdminClientsCreateView.vue'
import AdminPharmaciesView from '../views/admin/AdminPharmaciesView.vue'
import AdminPharmaciesCreateView from '../views/admin/AdminPharmaciesCreateView.vue'
import AdminWholesaleRevenueView from '../views/admin/AdminWholesaleRevenueView.vue'
import AdminWholesaleRevenueCreateView from '../views/admin/AdminWholesaleRevenueCreateView.vue'

import AdminDirectRevenueView from '../views/admin/AdminDirectRevenueView.vue'
import AdminDirectRevenueCreateView from '../views/admin/AdminDirectRevenueCreateView.vue'
import AdminSettlementMonthsView from '../views/admin/AdminSettlementMonthsView.vue'
import AdminSettlementMonthsCreateView from '../views/admin/AdminSettlementMonthsCreateView.vue'
import AdminSettlementMonthsDetailView from '../views/admin/AdminSettlementMonthsDetailView.vue'
import AdminSettlementMonthsEditView from '../views/admin/AdminSettlementMonthsEditView.vue'

import { supabase } from '@/supabase'; // <<< Supabase 클라이언트 임포트
import { ref, onMounted } from 'vue'

function sanitizeFileName(name) {
  // 한글, 공백, 특수문자 제거 → 영문, 숫자, 언더스코어, 점만 남김
  return name.replace(/[^a-zA-Z0-9._-]/g, '_');
}

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../views/AboutView.vue')
    // },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/reset-password',
      name: 'ResetPassword',
      component: () => import('@/views/ResetPasswordView.vue'),
      meta: { layout: 'empty' }
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView
    },
    // { // <<< 기존 About 라우트 예시 (참고용)
    //   path: '/about',
    //   name: 'about',
    //   component: () => import('../views/AboutView.vue')
    // },
    { // <<< 여기에 새로운 Companies 라우트 추가
      path: '/admin/companies/approved',
      name: 'AdminCompaniesApproved',
      component: () => import('@/views/admin/AdminCompaniesApprovedView.vue'),
      meta: { menu: '업체 관리', submenu: '승인 업체', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/companies/pending',
      name: 'AdminCompaniesPending',
      component: () => import('@/views/admin/AdminCompaniesPendingView.vue'),
      meta: { menu: '업체 관리', submenu: '미승인 업체', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/notices',
      name: 'AdminNotices',
      component: () => import('@/views/admin/AdminNoticesView.vue'),
      meta: { menu: '공지사항 관리', submenu: '공지사항 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/notices/create',
      name: 'AdminNoticeCreate',
      component: () => import('@/views/admin/AdminNoticeCreateView.vue'),
      meta: { menu: '공지사항 관리', submenu: '공지사항 등록', requiresAuth: true, isAdmin: true },
    },
    // 추가된 관리자 라우트
    // {
    //   path: '/admin/approval-requests',
    //   name: 'admin-approval-requests',
    //   component: AdminApprovalRequestsView, // 삭제
    //   meta: { requiresAuth: true, role: 'admin' }
    // },
    {
      path: '/admin/products',
      name: 'AdminProducts',
      component: () => import('@/views/admin/AdminProductsView.vue'),
      meta: { menu: '제품 관리', submenu: '제품 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/products/create',
      name: 'admin-product-create',
      component: AdminProductCreateView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/products/:id',
      name: 'admin-product-detail',
      component: () => import('../views/admin/AdminProductDetailView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/products/:id/edit',
      name: 'admin-product-edit',
      component: () => import('../views/admin/AdminProductEditView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/clients',
      name: 'AdminClients',
      component: () => import('@/views/admin/AdminClientsView.vue'),
      meta: { menu: '병의원 관리', submenu: '병의원 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/clients/create',
      name: 'AdminClientCreate',
      component: () => import('@/views/admin/AdminClientsCreateView.vue'),
      meta: { menu: '병의원 관리', submenu: '병의원 등록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/clients/:id',
      name: 'AdminClientDetail',
      component: () => import('@/views/admin/AdminClientsDetailView.vue'),
      meta: { menu: '병의원 관리', submenu: '병의원 상세', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/clients/:id/edit',
      name: 'admin-clients-edit',
      component: () => import('../views/admin/AdminClientsEditView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/clients/assign-companies',
      name: 'AdminClientsAssignCompanies',
      component: () => import('@/views/admin/AdminClientsAssignCompaniesView.vue'),
      meta: { menu: '병의원 관리', submenu: '담당업체 지정', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/clients/commission-grades',
      name: 'AdminClientsCommissionGrades',
      component: () => import('@/views/admin/AdminClientsCommissionGradesView.vue'),
      meta: { menu: '병의원 관리', submenu: '수수료 등급 설정', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/clients/assign-pharmacies',
      name: 'AdminClientsAssignPharmacies',
      component: () => import('@/views/admin/AdminClientsAssignPharmaciesView.vue'),
      meta: { menu: '병의원 관리', submenu: '문전약국 지정', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/pharmacies',
      name: 'AdminPharmacies',
      component: () => import('@/views/admin/AdminPharmaciesView.vue'),
      meta: { menu: '문전약국 관리', submenu: '문전약국 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/pharmacies/create',
      name: 'admin-pharmacies-create',
      component: AdminPharmaciesCreateView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/pharmacies/:id',
      name: 'admin-pharmacies-detail',
      component: () => import('../views/admin/AdminPharmaciesDetailView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/pharmacies/:id/edit',
      name: 'admin-pharmacies-edit',
      component: () => import('../views/admin/AdminPharmaciesEditView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/wholesale-revenue',
      name: 'AdminWholesaleRevenue',
      component: () => import('@/views/admin/AdminWholesaleRevenueView.vue'),
      meta: { menu: '매출 관리', submenu: '도매매출 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/wholesale-revenue/create',
      name: 'admin-wholesale-revenue-create',
      component: AdminWholesaleRevenueCreateView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/direct-revenue',
      name: 'AdminDirectRevenue',
      component: () => import('@/views/admin/AdminDirectRevenueView.vue'),
      meta: { menu: '매출 관리', submenu: '직거래매출 목록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/direct-revenue/create',
      name: 'admin-direct-revenue-create',
      component: AdminDirectRevenueCreateView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/settlement-month',
      name: 'admin-settlement-month',
      component: AdminSettlementMonthsView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/performance/register',
      name: 'AdminPerformanceRegister',
      component: () => import('@/views/admin/AdminPerformanceRegisterView.vue'),
      meta: { menu: '실적 관리', submenu: '실적 등록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/performance/companies',
      name: 'AdminPerformanceCompanies',
      component: () => import('@/views/admin/AdminPerformanceCompaniesView.vue'),
      meta: { menu: '실적 관리', submenu: '업체별 등록 현황', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/performance/whole',
      name: 'AdminPerformanceWhole',
      component: () => import('@/views/admin/AdminPerformanceWholeView.vue'),
      meta: { menu: '실적 관리', submenu: '전체 등록 현황', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/performance-list',
      name: 'AdminPerformanceRegisterList',
      component: () => import('../views/admin/AdminPerformanceRegisterList.vue'),
      meta: { requiresAuth: true, role: 'admin' },
      redirect: '/admin/performance/whole'
    },
    {
      path: '/admin/performance/review',
      name: 'AdminPerformanceReview',
      component: () => import('@/views/admin/AdminPerformanceReviewView.vue'),
      meta: { menu: '정산 관리', submenu: '실적 검수', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/absorption-analysis',
      name: 'AdminAbsorptionAnalysis',
      component: () => import('@/views/admin/AdminAbsorptionAnalysisView.vue'),
      meta: { menu: '정산 관리', submenu: '흡수율 분석', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/settlement-months',
      name: 'AdminSettlementMonths',
      component: () => import('@/views/admin/AdminSettlementMonthsView.vue'),
      meta: { menu: '실적 관리', submenu: '정산월 관리', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/settlement-months/create',
      name: 'AdminSettlementMonthsCreate',
      component: () => import('@/views/admin/AdminSettlementMonthsCreateView.vue'),
      meta: { menu: '실적 관리', submenu: '정산월 등록', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/settlement-months/:id',
      name: 'admin-settlement-months-detail',
      component: AdminSettlementMonthsDetailView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/settlement-months/:id/edit',
      name: 'AdminSettlementMonthsEdit',
      component: () => import('@/views/admin/AdminSettlementMonthsEditView.vue'),
      meta: { menu: '실적 관리', submenu: '정산월 수정', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/notices',
      name: 'Notices',
      component: () => import('@/views/user/NoticesView.vue'),
      meta: { menu: '공지사항 조회', submenu: '공지사항 목록', requiresAuth: true },
    },
    {
      path: '/notices/:id',
      name: 'NoticeDetail',
      component: () => import('@/views/user/NoticeDetailView.vue'),
      meta: { menu: '공지사항 조회', submenu: '공지사항 상세', requiresAuth: true },
    },
    {
      path: '/admin/notices/:id',
      name: 'AdminNoticeDetail',
      component: () => import('../views/admin/AdminNoticeDetailView.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/notices/:id/edit',
      name: 'AdminNoticeEdit',
      component: () => import('@/views/admin/AdminNoticeEditView.vue'),
      meta: { menu: '공지사항 관리', submenu: '공지사항 수정', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/companies/create',
      name: 'admin-company-create',
      component: AdminCompanyCreateView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/companies/:id',
      name: 'AdminCompanyDetail',
      component: () => import('@/views/admin/AdminCompanyDetailView.vue'),
      meta: { menu: '업체 관리', submenu: '업체 상세', requiresAuth: true, isAdmin: true },
    },
    {
      path: '/admin/companies/:id/edit',
      name: 'admin-company-edit',
      component: AdminCompanyEditView,
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/products',
      name: 'Products',
      component: () => import('@/views/user/ProductsView.vue'),
      meta: { menu: '제품 조회', submenu: '제품 목록', requiresAuth: true },
    },
    {
      path: '/products/:id',
      name: 'user-product-detail',
      component: () => import('../views/user/ProductDetailView.vue'),
      meta: { requiresAuth: true, role: 'user' }
    },
    {
      path: '/clients',
      name: 'Clients',
      component: () => import('@/views/user/ClientsView.vue'),
      meta: { menu: '병의원 조회', submenu: '병의원 목록', requiresAuth: true },
    },
    {
      path: '/clients/:id',
      name: 'user-client-detail',
      component: () => import('../views/user/ClientsDetailView.vue'),
      meta: { requiresAuth: true, role: 'user' }
    },
    {
      path: '/performance/register',
      name: 'PerformanceRegister',
      component: () => import('@/views/user/PerformanceRegister.vue'),
      meta: { menu: '실적 관리', submenu: '실적 등록', requiresAuth: true },
    },
    {
      path: '/performance/list',
      name: 'PerformanceRegisterList',
      component: () => import('@/views/user/PerformanceRegisterList.vue'),
      meta: { menu: '실적 관리', submenu: '등록 현황', requiresAuth: true },
    },
    {
      path: '/performance/register/edit',
      name: 'PerformanceRegisterEdit',
      component: () => import('@/views/user/PerformanceRegisterEdit.vue'),
      meta: { menu: '실적 관리', submenu: '실적 등록', requiresAuth: true },
    },
    {
      path: '/my-info',
      name: 'MyInfo',
      component: () => import('@/views/user/MyInfoView.vue'),
      meta: { menu: '내 정보', submenu: '내 정보', requiresAuth: true },
    },
    {
      path: '/my-info/edit',
      name: 'MyInfoEdit',
      component: () => import('@/views/user/MyInfoEditView.vue'),
      meta: { menu: '내 정보', submenu: '내 정보 수정', requiresAuth: true },
    },
    {
      path: '/my-info/change-password',
      name: 'ChangePassword',
      component: () => import('@/views/user/ChangePasswordView.vue'),
      meta: { menu: '내 정보', submenu: '비밀번호 변경', requiresAuth: true },
    },
    {
      path: '/admin/settlement-share',
      name: 'AdminSettlementShare',
      component: () => import('@/views/admin/AdminSettlementShareView.vue'),
      meta: {
        menu: '정산 관리',
        submenu: '정산내역서 공유',
        requiresAuth: true,
        isAdmin: true,
      },
    },
    {
      path: '/admin/settlement-share/detail',
      name: 'AdminSettlementShareDetail',
      component: () => import('@/views/admin/AdminSettlementShareDetailView.vue'),
      meta: {
        menu: '정산 관리',
        submenu: '정산내역서 상세',
        requiresAuth: true,
        isAdmin: true,
      },
    },
    {
      path: '/settlements',
      name: 'Settlements',
      component: () => import('@/views/user/SettlementShareDetailView.vue'),
      meta: { menu: '정산내역서 조회', submenu: '월별 정산 목록', requiresAuth: true },
    },
    {
      path: '/manual',
      component: () => import('@/views/ManualView.vue')
    },
    {
      path: '/admin-manual',
      component: () => import('@/views/ManualView.vue')
    }
  ]
})

// (선택 사항) 네비게이션 가드 추가: requiresAuth 메타 필드가 있는 라우트에 대해 인증 여부 확인
router.beforeEach(async (to, from, next) => {
  console.log(`[Router Guard] Navigating from: ${from.fullPath} to: ${to.fullPath}`);

  // 로그인 및 회원가입 페이지는 항상 접근 허용
  if (to.name === 'login' || to.name === 'signup') {
    console.log('[Router Guard] Accessing login/signup page. Allowing.');
    return next();
  }

  const { data: { session }, error: sessionError } = await supabase.auth.getSession();

  if (sessionError) {
    console.error('[Router Guard] Error getting session:', sessionError.message);
    // 세션 가져오기 실패 시 로그인 페이지로 (심각한 오류 상황)
    return next({ name: 'login', query: { redirect: to.fullPath } });
  }
  console.log('[Router Guard] Session:', session ? 'Exists' : 'Does not exist');

  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  console.log(`[Router Guard] Route requiresAuth: ${requiresAuth}`);

  if (requiresAuth) {
    if (!session) {
      console.log('[Router Guard] Auth required, but no session. Redirecting to login.');
      return next({ name: 'login', query: { redirect: to.fullPath } }); // 로그인 후 원래 경로로 리디렉션하기 위한 query 추가
    }

    // 세션이 있는 경우, 역할 검사
    const userRole = session.user?.user_metadata?.user_type;
    console.log(`[Router Guard] User role from session: ${userRole}`);

    const requiredRole = to.meta.role; // 가장 일치하는 라우트의 role을 직접 사용
    console.log(`[Router Guard] Required role for route: ${requiredRole}`);

    if (requiredRole) {
      if (userRole === requiredRole) {
        console.log('[Router Guard] Role matched. Proceeding.');
        return next();
      } else {
        console.log(`[Router Guard] Role mismatch. User role: ${userRole}, Required: ${requiredRole}. Redirecting to home.`);
        alert('접근 권한이 없습니다. (역할 불일치)');
        return next({ name: 'home' }); // 또는 사용자의 기본 대시보드나 로그인 페이지
      }
    } else {
      // requiresAuth는 true이지만, 특정 role이 명시되지 않은 경우 (예: 로그인한 모든 사용자 접근 가능)
      console.log('[Router Guard] Auth required, no specific role. Session exists. Proceeding.');
      return next();
    }
  } else {
    // 인증이 필요 없는 페이지
    console.log('[Router Guard] No auth required for this route. Proceeding.');
    return next();
  }
});

const files = ref([]); // 여러 파일 저장
const fileNames = ref([]);

function onFileChange(e) {
  files.value = Array.from(e.target.files).slice(0, 5); // 최대 5개
  fileNames.value = files.value.map(f => f.name);
}

async function uploadFiles() {
  let fileUrls = [];
  for (const f of files.value) {
    const safeName = sanitizeFileName(f.name);
    const filePath = `attachments/${Date.now()}_${safeName}`;
    const { data, error } = await supabase.storage
      .from('notices')
      .upload(filePath, f);
    if (error) {
      alert('파일 업로드 실패: ' + error.message);
      return;
    }
    const url = data?.path
      ? supabase.storage.from('notices').getPublicUrl(data.path).data.publicUrl
      : null;
    fileUrls.push(url);
  }

  const { error: insertError } = await supabase.from('notices').insert([
    {
      title: title.value,
      content: content.value,
      is_pinned: isPinned.value,
      view_count: 0,
      file_url: fileUrls // 배열 또는 문자열
    }
  ]);
}

const userType = ref('');

onMounted(async () => {
  // 기존 공지사항 데이터 불러오는 코드 아래에 추가
  const { data: { session } } = await supabase.auth.getSession();
  userType.value = session?.user?.user_metadata?.user_type || '';
});

export default router