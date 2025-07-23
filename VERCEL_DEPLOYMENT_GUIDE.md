# 🚀 Vercel 배포 가이드 - 신일제약 PMS

## 📋 **배포 전 준비사항**

### **1. Vercel 프로젝트 설정**

1. **Vercel 대시보드 접속**
   - https://vercel.com/dashboard
   - GitHub 저장소 연결

2. **환경변수 설정**
   ```
   VERCEL_SUPABASE_URL=https://selklngerzfmuvagcvvf.supabase.co
   VERCEL_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U
   JWT_SECRET=shinil-pms-secret-key-2024-production
   ```

### **2. Supabase 데이터베이스 준비**

1. **profiles 테이블 생성**
   ```sql
   CREATE TABLE profiles (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
       email VARCHAR(255) UNIQUE NOT NULL,
       full_name VARCHAR(255),
       user_type VARCHAR(50) DEFAULT 'user',
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **테스트 사용자 데이터 삽입**
   ```sql
   INSERT INTO profiles (email, full_name, user_type) VALUES
   ('admin@shinil.com', '관리자', 'admin'),
   ('user@shinil.com', '일반사용자', 'user'),
   ('manager@shinil.com', '매니저', 'manager');
   ```

## 🔄 **배포 프로세스**

### **1. GitHub 푸시**
```bash
git add .
git commit -m "Add Vercel Serverless Functions for secure API"
git push origin main
```

### **2. Vercel 자동 배포**
- GitHub 푸시 시 자동으로 Vercel이 배포를 시작
- 배포 URL: `https://your-project.vercel.app`

### **3. 배포 확인**
```bash
# 배포 상태 확인
curl https://your-project.vercel.app/api/auth/login

# 응답 예시
{"success":false,"error":"method_not_allowed","message":"POST 메서드만 허용됩니다"}
```

## 🧪 **API 테스트**

### **1. 로그인 테스트**
```bash
curl -X POST https://your-project.vercel.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@shinil.com","password":"admin123"}'
```

### **2. 데이터 조회 테스트**
```bash
# 토큰 발급 후
TOKEN="your_jwt_token_here"

# 회사 데이터 조회
curl -H "Authorization: Bearer $TOKEN" \
  https://your-project.vercel.app/api/companies

# 제품 데이터 조회
curl -H "Authorization: Bearer $TOKEN" \
  https://your-project.vercel.app/api/products

# 고객 데이터 조회
curl -H "Authorization: Bearer $TOKEN" \
  https://your-project.vercel.app/api/clients
```

### **3. 웹 페이지 테스트**
- **보안 API 테스트**: `https://your-project.vercel.app/vercel-secure-api-test.html`
- **메인 애플리케이션**: `https://your-project.vercel.app`

## 🔐 **보안 기능**

### **1. JWT 토큰 인증**
- ✅ 모든 API 엔드포인트에 인증 필요
- ✅ 토큰 만료 시간: 24시간
- ✅ 서버리스 환경에서 안전한 토큰 검증

### **2. CORS 설정**
- ✅ 적절한 CORS 헤더 설정
- ✅ OPTIONS 요청 처리
- ✅ 보안 헤더 추가

### **3. 에러 처리**
- ✅ 명확한 에러 메시지
- ✅ 적절한 HTTP 상태 코드
- ✅ 보안 정보 노출 방지

## 📊 **API 엔드포인트**

| 엔드포인트 | 메서드 | 설명 | 인증 필요 |
|-----------|--------|------|----------|
| `/api/auth/login` | POST | 로그인 및 토큰 발급 | ❌ |
| `/api/companies` | GET | 회사 데이터 조회 | ✅ |
| `/api/products` | GET | 제품 데이터 조회 | ✅ |
| `/api/clients` | GET | 고객 데이터 조회 | ✅ |

## 🛠️ **문제 해결**

### **1. 배포 실패 시**
```bash
# 로컬에서 Vercel CLI로 테스트
npm i -g vercel
vercel dev
```

### **2. 환경변수 문제**
- Vercel 대시보드에서 환경변수 재설정
- 배포 후 환경변수 적용 확인

### **3. API 오류 시**
```bash
# Vercel 함수 로그 확인
vercel logs your-project.vercel.app
```

## 📱 **접속 정보**

### **배포 후 접속 URL**
- **메인 애플리케이션**: `https://your-project.vercel.app`
- **보안 API 테스트**: `https://your-project.vercel.app/vercel-secure-api-test.html`

### **테스트 계정**
- **관리자**: `admin@shinil.com` / `admin123`
- **일반사용자**: `user@shinil.com` / `admin123`
- **매니저**: `manager@shinil.com` / `admin123`

## 🎯 **성공 지표**

✅ **배포 성공**: Vercel 대시보드에서 "Ready" 상태  
✅ **API 작동**: 로그인 API 호출 시 정상 응답  
✅ **보안 확인**: 토큰 없이 데이터 접근 시 401 에러  
✅ **데이터 조회**: 인증된 토큰으로 데이터 정상 조회  

---

**🎉 이제 GitHub에 푸시하면 Vercel에서 자동으로 보안 API가 배포됩니다!** 