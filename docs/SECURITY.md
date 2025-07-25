# 🔒 Shinil Project 보안 가이드

## 🚨 주요 보안 이슈 및 해결책

### 1. 기본 비밀번호 변경 (필수)
현재 사용 중인 기본 비밀번호들을 모두 변경해야 합니다:

#### PostgreSQL
- **현재**: `postgres`
- **권장**: `ShinilSecurePass2024!` (또는 더 강력한 비밀번호)

#### pgAdmin
- **현재**: `admin@admin.com` / `admin`
- **권장**: `admin@shinil.com` / `ShinilPgAdminPass2024!`

#### Supabase Dashboard
- **현재**: `supabase` / `this_password_is_insecure_and_should_be_updated`
- **권장**: `shinil_admin` / `ShinilDashboardPass2024!`

### 2. JWT Secret 변경 (필수)
- **현재**: `your-super-secret-jwt-token-with-at-least-32-characters-long`
- **권장**: `shinil-jwt-secret-2024-very-long-and-secure-token-for-production`

### 3. 포트 노출 제한
개발 환경에서만 필요한 포트들을 외부에 노출하고 있습니다:

#### 현재 노출된 포트들:
- `3000` - Vue.js 애플리케이션
- `5432` - PostgreSQL (로컬호스트로 제한됨)
- `5050` - pgAdmin (로컬호스트로 제한됨)
- `54321-54327` - Supabase
- `8000-8001` - Supabase
- `8443-8444` - Supabase

### 4. 보안 강화된 설정 사용

#### 환경 변수 설정:
```bash
# .env 파일 생성 (git에 커밋하지 마세요!)
cp env.example .env

# .env 파일에서 비밀번호들을 변경하세요
```

#### 보안 강화된 docker-compose 사용:
```bash
# 기존 컨테이너 중지
docker-compose down

# 보안 강화된 설정으로 시작
docker-compose -f docker-compose.secure.yml up -d
```

### 5. 프로덕션 환경 보안 체크리스트

- [ ] 모든 기본 비밀번호 변경
- [ ] JWT Secret 변경
- [ ] 환경 변수를 .env 파일로 관리
- [ ] PostgreSQL 포트 외부 노출 제거
- [ ] pgAdmin 포트 외부 노출 제거
- [ ] SSL/TLS 인증서 설정
- [ ] 방화벽 설정
- [ ] 정기적인 보안 업데이트
- [ ] 로그 모니터링 설정

### 6. 네트워크 보안

현재 설정된 네트워크:
- **Subnet**: `172.20.0.0/16`
- **Driver**: `bridge`
- **Isolation**: 컨테이너 간 통신만 허용

### 7. 볼륨 보안

데이터 볼륨들이 로컬 드라이버로 설정되어 있어 호스트 시스템에 저장됩니다:
- `supabase-data`: Supabase 데이터
- `postgres-data`: PostgreSQL 데이터

### 8. 권장사항

1. **정기적인 비밀번호 변경** (3개월마다)
2. **환경별 설정 분리** (개발/스테이징/프로덕션)
3. **백업 정책 수립**
4. **모니터링 및 로깅 설정**
5. **정기적인 보안 스캔**

### 9. 긴급 조치사항

만약 현재 설정이 프로덕션에서 사용되고 있다면:

1. **즉시 모든 비밀번호 변경**
2. **외부 포트 노출 제한**
3. **방화벽 설정**
4. **보안 감사 수행**

---

**⚠️ 주의**: 이 문서의 설정은 개발 환경을 위한 것입니다. 프로덕션 환경에서는 추가적인 보안 조치가 필요합니다. 