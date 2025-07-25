# 📚 신일제약 PMS 문서

이 폴더는 신일제약 PMS(Prescription Management System) 프로젝트의 모든 문서를 포함합니다.

## 📋 문서 목록

### 📊 프로젝트 상태
- **[PROJECT_STATUS_20250724.md](./PROJECT_STATUS_20250724.md)** - 프로젝트 전체 상태 및 진행 상황
  - 현재 버전: 1.2.0
  - 마지막 업데이트: 2025-07-25
  - 내용: 배포 상태, 기능 완료도, 기술 스택, 보안 정책

### 🔐 API 문서
- **[API_DOCUMENTATION.md](./API_DOCUMENTATION.md)** - 외부 API 시스템 문서
  - 현재 버전: 1.2.0
  - 마지막 업데이트: 2025-07-25
  - 내용: 인증 API, 데이터 API, 사용 예시, 보안 정책

### 🛡️ 보안 가이드
- **[SECURITY.md](./SECURITY.md)** - 보안 정책 및 가이드라인
  - 마지막 업데이트: 2025-07-25
  - 내용: Docker 보안, 환경 변수 관리, 취약점 분석

## 🚀 빠른 시작

### 프로젝트 개요
신일제약의 실적관리 시스템으로, Vue.js 3와 Supabase를 기반으로 구축된 웹 애플리케이션입니다.

### 주요 기능
- 실적 관리 및 분석
- 거래처 관리 (병의원, 약국, 제약회사)
- 정산 관리 및 수수료 계산
- 관리자 기능 (사용자 승인, 데이터 관리)
- 외부 API 시스템 (토큰 기반 인증)

### 기술 스택
- **Frontend**: Vue.js 3, Vite, PrimeVue
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Deployment**: Vercel
- **Container**: Docker & Docker Compose

## 📞 지원

### 접속 정보
- **프로덕션 URL**: https://shinil.vercel.app/
- **API Base URL**: https://shinil.vercel.app/api/
- **관리자 계정**: admin@admin.com / admin123

### 개발팀 연락처
- **GitHub Issues**: https://github.com/eudora25/shinil/issues
- **이메일**: admin@admin.com

## 📈 프로젝트 상태

### ✅ 완료된 작업
- [x] 데이터베이스 마이그레이션 (로컬 → Supabase)
- [x] 사용자 인증 시스템 구축
- [x] Docker 환경 통합
- [x] Vercel 배포 완료
- [x] 외부 API 시스템 구축
- [x] 보안 강화 완료
- [x] 토큰 기반 인증 API

### 🔄 진행 중인 작업
- [ ] 사용자 승인 워크플로우 개선
- [ ] API 사용량 모니터링
- [ ] 자동화된 테스트 스위트

### 📋 향후 계획
- [ ] 모바일 앱 개발
- [ ] 고급 분석 기능
- [ ] AI 기반 분석 도입

---

**문서 관리**: 이 폴더의 모든 문서는 프로젝트 진행 상황에 따라 정기적으로 업데이트됩니다.

**최종 업데이트**: 2025-07-25 