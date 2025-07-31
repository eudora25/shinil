# 신일 프로젝트 API 문서

## 개요

이 문서는 신일 프로젝트의 REST API에 대한 Swagger UI 문서입니다. 사용자 인증, 제품 관리, 고객 관리, 공지사항 등의 기능을 제공하는 API들을 문서화했습니다.

## 파일 구조

```
├── swagger-ui.html          # Swagger UI 인터페이스
├── swagger-spec.json        # OpenAPI 3.0 스펙 파일
└── API_DOCUMENTATION_README.md  # 이 파일
```

## 사용법

### 1. 로컬에서 실행

#### 방법 1: 테스트 API 서버 (권장 - API 테스트 가능)

1. 프로젝트 루트에서 다음 명령어를 실행합니다:

```bash
# 테스트 API 서버 실행
node test-api-server.js
```

2. 웹 브라우저에서 다음 URL로 접속합니다:
   ```
   http://localhost:8080/swagger-ui.html
   ```

3. Swagger UI에서 서버 선택 드롭다운에서 "로컬 테스트 API 서버 (실제 테스트 가능)"를 선택합니다.

4. API 테스트를 위한 테스트 계정:
   - 이메일: `test@example.com`
   - 비밀번호: `password123`

#### 방법 2: Vercel 개발 서버 (API 테스트 가능)

1. Vercel CLI를 설치하고 프로젝트 루트에서 다음 명령어를 실행합니다:

```bash
# Vercel CLI 설치 (처음 한 번만)
npm install -g vercel

# Vercel 개발 서버 실행
npx vercel dev --port 3000
```

2. 웹 브라우저에서 다음 URL로 접속합니다:
   ```
   http://localhost:3000/swagger-ui.html
   ```

3. Swagger UI에서 서버 선택 드롭다운에서 "로컬 Vercel 개발 서버"를 선택합니다.

#### 방법 2: 정적 파일 서버 (문서만)

1. 프로젝트 루트 디렉토리에서 다음 명령어를 실행합니다:

```bash
# Python 3
python3 -m http.server 8080

# 또는 Node.js
npx http-server -p 8080

# 또는 PHP
php -S localhost:8080
```

2. 웹 브라우저에서 다음 URL로 접속합니다:
   ```
   http://localhost:8080/swagger-ui.html
   ```

3. Swagger UI에서 서버 선택 드롭다운에서 "로컬 정적 파일 서버 (문서만)"를 선택합니다.

### 2. Vercel 배포 시

1. `swagger-ui.html`과 `swagger-spec.json` 파일을 프로젝트 루트에 배치합니다.
2. Vercel에 배포 후 다음 URL로 접속합니다:
   ```
   https://your-domain.vercel.app/swagger-ui.html
   ```

## API 엔드포인트

### 인증 관련 API

- **POST /api/auth** - 사용자 로그인
- **POST /api/verify-token** - 토큰 검증

### 사용자 관리 API

- **POST /api/create-user** - 새 사용자 생성 (관리자 전용)

### 데이터 조회 API

- **GET /api/products** - 제품 목록 조회
- **GET /api/clients** - 고객 목록 조회
- **GET /api/notices** - 공지사항 목록 조회

### 시스템 API

- **GET /api/** - API 상태 확인
- **GET /api/health** - 헬스 체크

## 인증

대부분의 API는 JWT 토큰 기반 인증을 사용합니다. 로그인 후 받은 토큰을 Authorization 헤더에 포함하여 요청해야 합니다:

```
Authorization: Bearer <your-jwt-token>
```

## 응답 형식

모든 API는 JSON 형식으로 응답하며, 다음과 같은 공통 구조를 따릅니다:

### 성공 응답
```json
{
  "success": true,
  "message": "작업이 성공적으로 완료되었습니다",
  "data": {
    // 실제 데이터
  }
}
```

### 오류 응답
```json
{
  "success": false,
  "message": "오류 메시지",
  "error": "상세 오류 정보 (선택사항)"
}
```

## 환경 변수 설정

API가 정상적으로 작동하려면 다음 환경 변수들이 설정되어야 합니다:

```bash
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
```

## 개발 및 테스트

### API 테스트

Swagger UI를 통해 각 API 엔드포인트를 직접 테스트할 수 있습니다:

1. Swagger UI 페이지에서 원하는 API를 선택합니다.
2. "Try it out" 버튼을 클릭합니다.
3. 필요한 파라미터를 입력합니다.
4. "Execute" 버튼을 클릭하여 API를 테스트합니다.

### 로컬 개발 서버

로컬에서 API를 테스트하려면:

```bash
# Vercel CLI 사용
npm install -g vercel
vercel dev

# 또는 Next.js 개발 서버
npm run dev
```

## 문제 해결

### "no Route matched with those values" 오류

이 오류는 Swagger UI에서 API 엔드포인트를 찾지 못할 때 발생합니다. 해결 방법:

1. **올바른 서버 선택**: Swagger UI 상단의 서버 선택 드롭다운에서 적절한 서버를 선택하세요.
2. **Vercel 개발 서버 사용**: API를 실제로 테스트하려면 Vercel 개발 서버를 사용하세요.
3. **환경 변수 설정**: `.env.local` 파일에 Supabase 환경 변수가 설정되어 있는지 확인하세요.

### CORS 오류

API에서 CORS 오류가 발생하는 경우, `api/index.js` 파일에서 CORS 헤더가 올바르게 설정되어 있는지 확인하세요.

### 인증 오류

토큰이 만료되었거나 유효하지 않은 경우, `/api/auth` 엔드포인트를 통해 다시 로그인하여 새로운 토큰을 발급받으세요.

### 서버 오류

500 오류가 발생하는 경우, 환경 변수가 올바르게 설정되어 있는지 확인하세요.

### 포트 충돌

포트가 이미 사용 중인 경우, 다른 포트를 사용하세요:
```bash
# 다른 포트로 서버 실행
python3 -m http.server 8081
```

## 업데이트

API 스펙을 업데이트하려면:

1. `swagger-spec.json` 파일을 수정합니다.
2. 새로운 엔드포인트나 파라미터를 추가합니다.
3. Swagger UI를 새로고침하여 변경사항을 확인합니다.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 