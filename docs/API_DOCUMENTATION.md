# Shinil PMS API Documentation

## 개요
신일제약 PMS(Prescription Management System)의 외부 API 문서입니다.

## 기본 정보
- **Base URL**: `https://shinil.vercel.app/api`
- **Content-Type**: `application/json`
- **인증**: JWT 토큰 기반 (Supabase 연동)
- **보안**: 승인된 사용자만 접근 가능

## 🔐 인증 시스템

### 사용자 승인 정책
- **관리자 계정**: 즉시 접근 가능 (`admin@admin.com`)
- **일반 사용자**: 관리자 승인 후 접근 가능
- **승인 대기 사용자**: API 접근 차단 (403 Forbidden)

### 실제 등록된 사용자 계정
```
관리자:
- 이메일: admin@admin.com
- 비밀번호: admin123
- 상태: 승인됨 (approved)

일반 사용자 (승인 대기):
- 이메일: user1@user.com / 비밀번호: user123
- 이메일: user2@user.com / 비밀번호: user123
- 이메일: user3@user.com / 비밀번호: user123
- 이메일: tt1@tt.com / 비밀번호: user123
- 이메일: moonmvp@twosun.com / 비밀번호: user123
- 이메일: sjchoi@twosun.com / 비밀번호: user123
- 이메일: d1@123.com / 비밀번호: user123
```

## 인증 API

### 1. 토큰 발행 (POST /auth)
사용자 인증 후 JWT 토큰을 발행합니다.

**Endpoint**: `POST https://shinil.vercel.app/api/auth`

**Request Body**:
```json
{
  "email": "admin@admin.com",
  "password": "admin123"
}
```

**Response (성공 - 200)**:
```json
{
  "success": true,
  "message": "Authentication successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsImtpZCI6Im5pWjg5RFlrSUZsaFZwSE0iLCJ0eXAiOiJKV1QifQ...",
    "refreshToken": "yymlm45yofoc",
    "user": {
      "id": "523907e7-b0d6-45b7-93a0-a93d9ee64951",
      "email": "admin@admin.com",
      "role": "admin",
      "approvalStatus": "approved",
      "createdAt": "2025-07-24T08:21:36.430473Z",
      "lastSignIn": "2025-07-25T02:08:01.268106913Z"
    },
    "expiresIn": "24h",
    "expiresAt": "2025-07-25T03:08:01.000Z"
  }
}
```

**Response (승인 대기 - 403)**:
```json
{
  "success": false,
  "message": "Account is pending approval. Please contact administrator."
}
```

**Response (인증 실패 - 401)**:
```json
{
  "success": false,
  "message": "Invalid email or password",
  "error": "Invalid login credentials"
}
```

### 2. 토큰 검증 (POST /verify-token)
JWT 토큰의 유효성을 검증합니다.

**Endpoint**: `POST https://shinil.vercel.app/api/verify-token`

**Request Body**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsImtpZCI6Im5pWjg5RFlrSUZsaFZwSE0iLCJ0eXAiOiJKV1QifQ..."
}
```

**Response (성공 - 200)**:
```json
{
  "success": true,
  "message": "Token is valid",
  "data": {
    "user": {
      "id": "523907e7-b0d6-45b7-93a0-a93d9ee64951",
      "email": "admin@admin.com",
      "role": "admin",
      "approvalStatus": "approved",
      "createdAt": "2025-07-24T08:21:36.430473Z",
      "lastSignIn": "2025-07-25T02:08:01.268106Z"
    },
    "valid": true
  }
}
```

**Response (실패 - 401)**:
```json
{
  "success": false,
  "message": "Invalid or expired token",
  "error": "JWT expired"
}
```

## 데이터 API

### 1. 헬스체크 (GET /health)
API 서버 상태를 확인합니다.

**Endpoint**: `GET https://shinil.vercel.app/api/health`

**Response**:
```json
{
  "test": "001",
  "status": "OK",
  "timestamp": "2025-07-25T01:20:24.291Z",
  "version": "1.0.0",
  "environment": "production",
  "message": "Health check API working correctly"
}
```

### 2. 제품 목록 (GET /products)
승인된 제품 목록을 조회합니다.

**Endpoint**: `GET https://shinil.vercel.app/api/products`

**Query Parameters**:
- `limit` (optional): 페이지당 항목 수 (기본값: 100)
- `offset` (optional): 건너뛸 항목 수 (기본값: 0)
- `search` (optional): 제품명 검색

**Response**:
```json
{
  "test": "002",
  "message": "Products API endpoint",
  "timestamp": "2025-07-25T01:20:24.291Z",
  "data": []
}
```

### 3. 병의원 목록 (GET /clients)
병의원 목록을 조회합니다.

**Endpoint**: `GET https://shinil.vercel.app/api/clients`

**Query Parameters**:
- `limit` (optional): 페이지당 항목 수
- `offset` (optional): 건너뛸 항목 수
- `search` (optional): 병의원명 검색
- `company_id` (optional): 담당업체 ID 필터

**Response**:
```json
{
  "test": "003",
  "message": "Clients API endpoint",
  "timestamp": "2025-07-25T01:20:24.291Z",
  "data": []
}
```

### 4. 공지사항 목록 (GET /notices)
공지사항 목록을 조회합니다.

**Endpoint**: `GET https://shinil.vercel.app/api/notices`

**Query Parameters**:
- `limit` (optional): 페이지당 항목 수
- `offset` (optional): 건너뛸 항목 수
- `search` (optional): 제목 검색
- `status` (optional): 상태 필터 (active/inactive)

**Response**:
```json
{
  "test": "004",
  "message": "Notices API endpoint",
  "timestamp": "2025-07-25T01:20:24.291Z",
  "data": []
}
```

## 사용 예시

### cURL 예시

#### 토큰 발행:
```bash
curl -X POST https://shinil.vercel.app/api/auth \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@admin.com",
    "password": "admin123"
  }'
```

#### 토큰으로 API 호출:
```bash
curl -X GET https://shinil.vercel.app/api/products \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### JavaScript 예시

#### 토큰 발행:
```javascript
const response = await fetch('https://shinil.vercel.app/api/auth', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'admin@admin.com',
    password: 'admin123'
  })
});

const data = await response.json();
console.log(data.data.token); // JWT 토큰
```

#### API 호출:
```javascript
const response = await fetch('https://shinil.vercel.app/api/products', {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const products = await response.json();
```

### Python 예시

#### 토큰 발행:
```python
import requests

response = requests.post('https://shinil.vercel.app/api/auth', 
  json={
    'email': 'admin@admin.com',
    'password': 'admin123'
  }
)

data = response.json()
token = data['data']['token']
```

#### API 호출:
```python
headers = {'Authorization': f'Bearer {token}'}
response = requests.get('https://shinil.vercel.app/api/products', headers=headers)
products = response.json()
```

## 에러 코드

| HTTP Status | 설명 |
|-------------|------|
| 200 | 성공 |
| 400 | 잘못된 요청 (필수 필드 누락, 잘못된 형식) |
| 401 | 인증 실패 (잘못된 이메일/비밀번호, 만료된 토큰) |
| 403 | 접근 거부 (승인 대기 중인 계정) |
| 405 | 허용되지 않는 HTTP 메서드 |
| 500 | 서버 내부 오류 |

## 보안 고려사항

1. **HTTPS 사용**: 모든 API 호출은 HTTPS를 통해 이루어져야 합니다.
2. **토큰 보안**: JWT 토큰은 안전하게 저장하고 전송해야 합니다.
3. **토큰 만료**: 토큰은 24시간 후 만료됩니다.
4. **승인 시스템**: 승인된 사용자만 API 접근 가능합니다.
5. **환경 변수**: API 키는 환경 변수로 안전하게 관리됩니다.

## 제한사항

- API 호출 빈도 제한
- 토큰 만료 시간: 24시간
- 최대 응답 크기: 10MB
- 동시 연결 수 제한
- 승인된 사용자만 접근 가능

## 테스트 도구

### 로컬 테스트 스크립트
```bash
# 테스트 스크립트 실행
node test-auth-api.js
```

이 스크립트는 실제 데이터베이스의 모든 사용자 계정으로 인증을 테스트합니다.

## 지원

API 사용에 대한 문의사항이 있으시면 개발팀에 연락해주세요.

---

**최종 업데이트**: 2025-07-25
**버전**: 1.2.0
**보안 레벨**: 프로덕션 준비 완료 
**버전**: 1.0.0 