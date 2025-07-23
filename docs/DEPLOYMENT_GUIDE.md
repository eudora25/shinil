# 배포 가이드

## Vercel 배포

### 1. 사전 준비
- Node.js 18+ 설치
- Vercel CLI 설치: `npm install -g vercel`
- GitHub 저장소 연결

### 2. 환경 변수 설정
Vercel 대시보드에서 다음 환경 변수를 설정:

```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_API_BASE_URL=your_api_base_url
VITE_ENVIRONMENT=production
```

### 3. 배포 명령어
```bash
# 프로덕션 배포
vercel --prod

# 프리뷰 배포
vercel
```

### 4. 배포 확인
- 메인 도메인: https://shinil.vercel.app
- 배포 상태: Vercel 대시보드에서 확인

## 로컬 개발 환경

### 1. 의존성 설치
```bash
cd vue-project
npm install
```

### 2. 개발 서버 실행
```bash
npm run dev
```

### 3. 빌드 테스트
```bash
npm run build
npm run preview
```

## 문제 해결

### 빌드 실패
1. Node.js 버전 확인 (18+)
2. 의존성 재설치: `rm -rf node_modules && npm install`
3. 캐시 클리어: `npm run build --force`

### 배포 후 404 에러
1. `vercel.json` 설정 확인
2. 빌드 로그 확인: `vercel inspect --logs [deployment-url]`
3. 환경 변수 설정 확인

### 성능 최적화
1. 번들 분석: `npm run analyze`
2. 청크 크기 확인
3. 불필요한 의존성 제거 