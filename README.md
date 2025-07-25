# 🏥 신일제약 PMS (Prescription Management System)

신일제약의 실적관리 시스템입니다. Vue.js 3와 Supabase를 기반으로 구축된 현대적인 웹 애플리케이션입니다.

## 🚀 빠른 시작

### 프로덕션 배포
- **메인 애플리케이션**: https://shinil.vercel.app/
- **API 시스템**: https://shinil.vercel.app/api/
- **관리자 계정**: admin@admin.com / admin123

### 로컬 개발 환경
```bash
# 1. 저장소 클론
git clone https://github.com/eudora25/shinil.git
cd shinil

# 2. 환경 변수 설정
cp env.example .env
# .env 파일에서 필요한 값들을 설정

# 3. Docker 컨테이너 실행
docker-compose up -d

# 4. 브라우저에서 확인
# http://localhost:3000/
```

## 📚 문서

모든 프로젝트 문서는 [`docs/`](./docs/) 폴더에서 관리됩니다.

### 📋 주요 문서
- **[📊 프로젝트 상태](./docs/PROJECT_STATUS_20250724.md)** - 전체 프로젝트 진행 상황
- **[🔐 API 문서](./docs/API_DOCUMENTATION.md)** - 외부 API 시스템 가이드
- **[🛡️ 보안 가이드](./docs/SECURITY.md)** - 보안 정책 및 가이드라인
- **[📖 문서 목록](./docs/README.md)** - 모든 문서 목록 및 개요

## 🎯 주요 기능

### 관리자 기능
- 사용자 승인 및 관리
- 업체/제품/고객 정보 관리
- 실적 데이터 관리
- 정산 및 수수료 계산
- 흡수율 분석

### 사용자 기능
- 제품 및 병의원 정보 조회
- 실적 등록 및 관리
- EDI 및 결제 관리
- 개인정보 관리

### 외부 API
- 토큰 기반 인증 시스템
- 제품/고객/공지사항 API
- 실시간 데이터 동기화

## 🛠 기술 스택

- **Frontend**: Vue.js 3, Vite, PrimeVue
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Deployment**: Vercel
- **Container**: Docker & Docker Compose
- **API**: RESTful API, JWT 토큰 인증

## 📁 프로젝트 구조 (정리 완료)

```
shinil_project/
├── 📚 docs/                    # 📖 프로젝트 문서
├── 🎨 vue-project/            # Vue.js 애플리케이션
├── 🔧 admin-scripts/          # 관리자 스크립트
├── 🗄️ sql-scripts/            # SQL 스크립트
├── 💾 database-backup/        # 데이터베이스 백업
├── 📖 public/docs/            # 사용자 매뉴얼
├── 🔌 api/                    # Vercel API Routes
├── 🐳 docker-compose.yml      # Docker 설정
├── 🐳 docker-compose.secure.yml # 보안 강화 Docker 설정
├── 🚀 vercel.json            # Vercel 배포 설정
├── 📄 README.md              # 프로젝트 개요 (현재 파일)
├── 🔧 env.example            # 환경 변수 예시
└── 🚫 .gitignore             # Git 제외 파일 설정
```

## 🔒 보안

- **인증**: Supabase Auth 기반 JWT 토큰
- **승인 시스템**: 관리자 승인 후 접근 가능
- **환경 변수**: 민감 정보 보호
- **HTTPS**: 모든 통신 암호화

## 📞 지원

- **GitHub Issues**: https://github.com/eudora25/shinil/issues
- **개발팀**: admin@admin.com
- **문서**: [`docs/`](./docs/) 폴더 참조

## 📄 라이선스

이 프로젝트는 신일제약 내부 사용을 목적으로 개발되었습니다.

---

**최종 업데이트**: 2025-07-25  
**버전**: 1.3.0  
**상태**: ✅ 프로덕션 배포 완료 + 🧹 프로젝트 정리 완료 