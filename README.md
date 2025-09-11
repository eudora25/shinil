# Shinil API Server

신일 프로젝트의 API 서버입니다. Swagger UI와 토큰 인증 기능을 포함합니다.

## 🚀 주요 기능

- **API 서버**: Express.js 기반 REST API
- **Swagger UI**: API 문서화 및 테스트 인터페이스
- **토큰 인증**: JWT 기반 인증 시스템
- **Supabase 연동**: 데이터베이스 및 인증 서비스

## 📁 프로젝트 구조

```
shinil_project/
├── api/                    # API 엔드포인트
│   ├── auth.js            # 인증 관련 API
│   ├── products.js        # 제품 관련 API
│   ├── clients.js         # 거래처 관련 API
│   ├── companies.js       # 업체 관련 API
│   ├── health.js          # 헬스체크 API
│   └── ...                # 기타 API 엔드포인트
├── lib/                   # 공통 라이브러리
│   ├── apiClient.js       # API 클라이언트
│   ├── tokenManager.js    # 토큰 관리
│   └── tokenRefresh.js    # 토큰 갱신
├── middleware/            # 미들웨어
│   └── authMiddleware.js  # 인증 미들웨어
├── swagger-spec.json      # Swagger API 명세
├── swagger-ui.html        # Swagger UI 페이지
└── docker-compose.api-only.yml  # Docker 설정
```

## 🛠️ 설치 및 실행

### 1. 의존성 설치
```bash
npm install
```

### 2. 환경 변수 설정
```bash
# .env 파일 생성
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. 로컬 실행
```bash
npm start
```

### 4. Docker 실행
```bash
# 컨테이너 시작
npm run docker:up

# 컨테이너 중지
npm run docker:down

# 로그 확인
npm run docker:logs
```

## 🌐 접속 정보

- **API 서버**: http://localhost:3001
- **Swagger UI**: http://localhost:3001/swagger-ui.html
- **헬스체크**: http://localhost:3001/api/health

## 📚 API 문서

Swagger UI를 통해 모든 API 엔드포인트를 확인하고 테스트할 수 있습니다.

## 🔐 인증

JWT 토큰 기반 인증을 사용합니다. 토큰은 자동으로 갱신됩니다.

## 🐳 Docker

Docker를 사용하여 컨테이너로 실행할 수 있습니다.

```bash
docker-compose -f docker-compose.api-only.yml up -d
```