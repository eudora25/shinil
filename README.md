# 신일제약 실적관리프로그램

## 📋 프로젝트 개요

신일제약의 실적관리 시스템으로, Vue.js 3와 Supabase를 기반으로 구축된 웹 애플리케이션입니다.

## 🚀 주요 기능

- **실적 관리**: 제품별 실적 등록 및 관리
- **거래처 관리**: 병의원, 약국, 제약회사 정보 관리
- **정산 관리**: 월별 정산 및 수수료 계산
- **관리자 기능**: 사용자 승인, 데이터 일괄 등록
- **보고서**: Excel 내보내기 및 분석 리포트

## 🛠 기술 스택

- **Frontend**: Vue.js 3, Vite, PrimeVue
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Deployment**: Vercel
- **Database**: PostgreSQL

## 📁 프로젝트 구조

```
shinil_project/
├── vue-project/           # Vue.js 애플리케이션
│   ├── src/              # 소스 코드
│   ├── public/           # 정적 파일
│   └── dist/             # 빌드 결과물
├── scripts/              # SQL 스크립트
│   ├── migrations/       # 데이터베이스 마이그레이션
│   ├── backups/          # 백업 파일
│   └── analysis/         # 분석 스크립트
├── config/               # 설정 파일
│   ├── docker-compose.yml
│   └── vercel.json
├── docs/                 # 문서
└── deploy/               # 배포 관련
```

## 🔧 설치 및 실행

### 개발 환경 설정

```bash
# 의존성 설치
cd vue-project
npm install

# 개발 서버 실행
npm run dev

# 빌드
npm run build
```

### 환경 변수 설정

`.env` 파일을 생성하고 다음 변수들을 설정하세요:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_API_BASE_URL=your_api_base_url
```

## 🚀 배포

### Vercel 배포

```bash
# Vercel CLI 설치
npm i -g vercel

# 배포
vercel --prod
```

## 🔒 보안 개선사항

### 완료된 개선사항

- ✅ **보안 취약점 해결**: CKEditor 5 업데이트
- ✅ **의존성 최적화**: 서버 사이드 라이브러리 분리
- ✅ **프로젝트 구조 정리**: 파일 분류 및 정리
- ✅ **빌드 최적화**: 코드 분할 및 청크 최적화

### 남은 작업

- ⚠️ **XLSX 라이브러리**: 보안 취약점이 있는 xlsx 라이브러리를 exceljs로 교체 필요
- 📝 **문서화**: API 문서 및 사용자 매뉴얼 개선
- 🧪 **테스트**: 단위 테스트 및 통합 테스트 추가

## 📊 성능 최적화

### 빌드 최적화

- **코드 분할**: 라우트별 지연 로딩
- **청크 최적화**: vendor, primevue, editor, utils, supabase 분리
- **번들 크기**: 1MB 이하로 최적화

### 로딩 성능

- **이미지 최적화**: WebP 포맷 사용
- **폰트 최적화**: PrimeIcons 폰트 최적화
- **캐싱 전략**: 정적 자산 캐싱

## 🔧 개발 가이드

### 코드 스타일

```bash
# 코드 포맷팅
npm run format

# 린팅
npm run lint
```

### 데이터베이스 마이그레이션

```bash
# 마이그레이션 스크립트 실행
psql -d your_database -f scripts/migrations/migration_file.sql
```

## 📈 모니터링

### 성능 모니터링

- **Web Vitals**: Core Web Vitals 측정
- **API 성능**: 응답 시간 모니터링
- **에러 추적**: 에러 로깅 및 알림

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 신일제약의 내부 프로젝트입니다.

## 📞 문의

프로젝트 관련 문의사항이 있으시면 개발팀에 연락해주세요.

---

**마지막 업데이트**: 2025년 1월
**버전**: 1.0.0 