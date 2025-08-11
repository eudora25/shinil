# Swagger 페이지 IP 접근 제어 설정

## 개요

이 문서는 Swagger API 문서 페이지에 IP 기반 접근 제어를 설정하는 방법을 설명합니다.

## 구현된 방법

### 1. 서버 레벨 IP 제한 (로컬 개발용)

`vue-project/server.js`에서 Express 미들웨어를 통해 IP 제한을 구현했습니다.

### 2. Vercel 서버리스 함수 (프로덕션용)

`vue-project/supabase/functions/` 디렉토리에 서버리스 함수를 생성하여 Vercel 환경에서 IP 제한을 구현했습니다.

## 설정 방법

### 1. 허용할 IP 주소 설정

#### 방법 A: 환경 변수 사용 (권장)

`.env.local` 파일에 다음을 추가:

```bash
# 허용할 IP 주소 목록 (쉼표로 구분)
ALLOWED_IPS=127.0.0.1,::1,192.168.1.100,203.241.xxx.xxx
```

#### 방법 B: 코드에서 직접 설정

`vue-project/config/ip-access.js` 파일에서 `allowedIPs` 배열을 수정:

```javascript
allowedIPs: [
  '127.0.0.1',        // localhost
  '::1',              // localhost IPv6
  '192.168.1.100',    // 허용할 IP 주소
  '203.241.xxx.xxx'   // 허용할 IP 주소
]
```

### 2. CIDR 표기법 지원

네트워크 범위를 지정할 수 있습니다:

```javascript
allowedIPs: [
  '127.0.0.1',        // 단일 IP
  '192.168.1.0/24',   // 192.168.1.0 ~ 192.168.1.255
  '10.0.0.0/8'        // 10.0.0.0 ~ 10.255.255.255
]
```

## 사용법

### 로컬 개발 환경

1. 서버 실행:
```bash
cd vue-project
node server.js
```

2. Swagger 페이지 접근:
```
http://localhost:3001/swagger-ui.html
```

### Vercel 프로덕션 환경

1. 환경 변수 설정 (Vercel 대시보드):
   - `ALLOWED_IPS`: 허용할 IP 주소 목록

2. Swagger 페이지 접근:
```
https://your-domain.vercel.app/swagger-ui.html
```

## 보안 기능

### 1. IP 로깅

모든 접근 시도가 콘솔에 로깅됩니다:

```
🔒 IP 접근 시도: 192.168.1.100
✅ 접근 허용: 192.168.1.100
```

또는

```
🔒 IP 접근 시도: 203.241.xxx.xxx
❌ 접근 거부: 203.241.xxx.xxx
```

### 2. 상세한 오류 메시지

접근이 거부된 경우 상세한 오류 정보를 반환합니다:

```json
{
  "success": false,
  "message": "접근이 거부되었습니다. 허용된 IP에서만 접근 가능합니다.",
  "error": "IP_ACCESS_DENIED",
  "clientIP": "203.241.xxx.xxx"
}
```

### 3. 프록시 환경 지원

`X-Forwarded-For` 헤더를 통해 실제 클라이언트 IP를 확인합니다.

## IP 주소 확인 방법

### 1. 현재 IP 확인

```bash
# 터미널에서
curl ifconfig.me
# 또는
curl ipinfo.io/ip
```

### 2. 웹에서 확인

- https://whatismyipaddress.com/
- https://www.whatismyip.com/

### 3. 개발 환경에서 확인

브라우저 개발자 도구 콘솔에서:

```javascript
fetch('https://api.ipify.org?format=json')
  .then(response => response.json())
  .then(data => console.log('현재 IP:', data.ip))
```

## 문제 해결

### 1. 접근이 거부되는 경우

1. **IP 주소 확인**: 현재 IP가 허용 목록에 있는지 확인
2. **환경 변수 확인**: `ALLOWED_IPS` 환경 변수가 올바르게 설정되었는지 확인
3. **서버 재시작**: 환경 변수 변경 후 서버 재시작

### 2. 로컬에서 접근이 안 되는 경우

1. **localhost 확인**: `127.0.0.1` 또는 `::1`이 허용 목록에 있는지 확인
2. **방화벽 확인**: 로컬 방화벽이 포트를 차단하고 있지 않은지 확인

### 3. Vercel에서 접근이 안 되는 경우

1. **환경 변수 설정**: Vercel 대시보드에서 `ALLOWED_IPS` 환경 변수 설정
2. **배포 확인**: 변경사항이 배포되었는지 확인
3. **함수 로그 확인**: Vercel 대시보드에서 함수 로그 확인

## 고급 설정

### 1. 동적 IP 허용

특정 시간대에만 IP를 허용하거나, 특정 조건에 따라 동적으로 IP를 허용할 수 있습니다.

### 2. 추가 인증

IP 제한과 함께 추가적인 인증(예: API 키, JWT 토큰)을 요구할 수 있습니다.

### 3. 로그 저장

접근 로그를 데이터베이스에 저장하여 추후 분석에 활용할 수 있습니다.

## 주의사항

1. **IP 변경**: ISP에서 IP 주소가 변경될 수 있으므로 정기적으로 확인 필요
2. **VPN 사용**: VPN 사용 시 IP 주소가 변경될 수 있음
3. **모바일 네트워크**: 모바일 네트워크 사용 시 IP 주소가 자주 변경됨
4. **보안**: IP 제한만으로는 완전한 보안을 보장할 수 없으므로 추가 보안 조치 권장
