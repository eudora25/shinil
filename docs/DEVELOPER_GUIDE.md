# 개발자 가이드

## 프로젝트 구조

```
shinil_project/
├── vue-project/           # Vue.js 애플리케이션
│   ├── src/              # 소스 코드
│   │   ├── components/   # Vue 컴포넌트
│   │   ├── views/        # 페이지 컴포넌트
│   │   ├── router/       # 라우터 설정
│   │   └── assets/       # 정적 자산
│   ├── public/           # 정적 파일
│   └── dist/             # 빌드 결과물
├── scripts/              # SQL 스크립트
│   ├── migrations/       # 데이터베이스 마이그레이션
│   ├── backups/          # 백업 파일
│   └── analysis/         # 분석 스크립트
├── config/               # 설정 파일
├── docs/                 # 문서
└── README.md             # 프로젝트 개요
```

## 개발 환경 설정

### 1. 필수 도구
- Node.js 18+
- npm 또는 yarn
- Git
- VS Code (권장)

### 2. VS Code 확장 프로그램
- Vetur 또는 Volar (Vue.js)
- ESLint
- Prettier
- Auto Rename Tag
- Bracket Pair Colorizer

### 3. 프로젝트 설정
```bash
# 저장소 클론
git clone https://github.com/eudora25/shinil.git
cd shinil

# 의존성 설치
cd vue-project
npm install
```

## 코딩 컨벤션

### 1. 파일 명명 규칙
- 컴포넌트: PascalCase (예: `UserProfile.vue`)
- 페이지: PascalCase (예: `HomeView.vue`)
- 유틸리티: camelCase (예: `formatDate.js`)

### 2. Vue 컴포넌트 구조
```vue
<template>
  <!-- 템플릿 내용 -->
</template>

<script setup>
// 스크립트 내용
</script>

<style scoped>
/* 스타일 내용 */
</style>
```

### 3. ESLint 규칙
- `no-console`: 프로덕션에서 경고
- `no-debugger`: 프로덕션에서 경고
- `prefer-const`: const 사용 권장
- `no-var`: var 사용 금지

## 개발 워크플로우

### 1. 브랜치 전략
- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/*`: 기능 개발 브랜치
- `hotfix/*`: 긴급 수정 브랜치

### 2. 커밋 메시지 규칙
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 추가/수정
chore: 빌드 프로세스 또는 보조 도구 변경
```

### 3. Git Hooks
- pre-commit: ESLint 및 Prettier 자동 실행
- 커밋 전 코드 품질 검사

## 테스트

### 1. 단위 테스트
```bash
# 테스트 실행
npm run test

# 테스트 커버리지
npm run test:coverage
```

### 2. E2E 테스트
```bash
# E2E 테스트 실행
npm run test:e2e
```

## 성능 최적화

### 1. 번들 분석
```bash
npm run analyze
```

### 2. 성능 모니터링
- Lighthouse 성능 테스트
- 번들 크기 모니터링
- 로딩 속도 최적화

## 문제 해결

### 1. 빌드 오류
```bash
# 캐시 클리어
rm -rf node_modules
npm install
npm run build
```

### 2. ESLint 오류
```bash
# 자동 수정
npm run lint --fix
```

### 3. 포맷팅 오류
```bash
# 자동 포맷팅
npm run format
```

## 배포

### 1. 스테이징 배포
```bash
vercel
```

### 2. 프로덕션 배포
```bash
vercel --prod
```

### 3. 배포 확인
- https://shinil.vercel.app
- Vercel 대시보드에서 로그 확인 