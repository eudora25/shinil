# Sinil PMS API 엔드포인트 목록

## 📋 개요
이 문서는 Sinil PMS 시스템의 모든 API 엔드포인트를 정리한 목록입니다.

## 🔐 인증 관련 API

### 1. 사용자 로그인
- **엔드포인트**: `/auth`
- **메서드**: `POST`
- **설명**: 사용자 로그인 및 토큰 발급
- **요청 본문**:
  ```json
  {
    "email": "admin@admin.com",
    "password": "asdf1234"
  }
  ```

### 2. 토큰 검증
- **엔드포인트**: `/verify-token`
- **메서드**: `POST`
- **설명**: JWT 토큰 유효성 검증
- **요청 본문**:
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
  ```

## 📊 시스템 상태 API

### 3. API 상태 확인
- **엔드포인트**: `/`
- **메서드**: `GET`
- **설명**: API 서버 상태 및 기본 정보 확인
- **응답 예시**:
  ```json
  {
    "name": "Sinil PMS API",
    "version": "1.0.0",
    "status": "running",
    "timestamp": "2025-01-18T05:04:17.093Z",
    "environment": "development"
  }
  ```

### 4. 시스템 상태 확인
- **엔드포인트**: `/health`
- **메서드**: `GET`
- **설명**: 시스템 상태 및 데이터베이스 연결 상태 확인

## 🏢 기본 정보 관리 API

### 5. 회사정보 조회
- **엔드포인트**: `/companies`
- **메서드**: `GET`
- **설명**: 등록된 회사 정보 목록 조회
- **인증**: Bearer Token 필요

### 6. 제품정보 조회
- **엔드포인트**: `/products`
- **메서드**: `GET`
- **설명**: 등록된 제품 정보 목록 조회
- **인증**: Bearer Token 필요

### 7. 병원정보 조회
- **엔드포인트**: `/clients`
- **메서드**: `GET`
- **설명**: 등록된 병원 정보 목록 조회
- **인증**: Bearer Token 필요

### 8. 약국정보 조회
- **엔드포인트**: `/pharmacies`
- **메서드**: `GET`
- **설명**: 등록된 약국 정보 목록 조회
- **인증**: Bearer Token 필요

### 9. 공지사항 조회
- **엔드포인트**: `/notices`
- **메서드**: `GET`
- **설명**: 시스템 공지사항 목록 조회
- **인증**: Bearer Token 필요

## 🔗 관계 정보 관리 API

### 10. 병원-업체 관계 정보
- **엔드포인트**: `/hospital-company-mappings`
- **메서드**: `GET`
- **설명**: 병원과 업체 간의 관계 정보 조회
- **인증**: Bearer Token 필요

### 11. 병원-약국 관계 정보
- **엔드포인트**: `/hospital-pharmacy-mappings`
- **메서드**: `GET`
- **설명**: 병원과 약국 간의 관계 정보 조회
- **인증**: Bearer Token 필요

### 12. 병원-업체 매핑정보
- **엔드포인트**: `/client-company-assignments`
- **메서드**: `GET`
- **설명**: 병원과 업체 간의 배정 정보 조회
- **인증**: Bearer Token 필요

### 13. 병원-약국 매핑정보
- **엔드포인트**: `/client-pharmacy-assignments`
- **메서드**: `GET`
- **설명**: 병원과 약국 간의 배정 정보 조회
- **인증**: Bearer Token 필요

### 14. 제품-업체 미배정 매핑
- **엔드포인트**: `/product-company-not-assignments`
- **메서드**: `GET`
- **설명**: 업체에 배정되지 않은 제품 정보 조회
- **인증**: Bearer Token 필요

## 💰 매출 관리 API

### 15. 도매 매출 조회
- **엔드포인트**: `/wholesale-sales`
- **메서드**: `GET`
- **설명**: 도매 매출 데이터 조회
- **인증**: Bearer Token 필요

### 16. 직매 매출 조회
- **엔드포인트**: `/direct-sales`
- **메서드**: `GET`
- **설명**: 직매 매출 데이터 조회
- **인증**: Bearer Token 필요

## 📈 실적 관리 API

### 17. 실적정보 목록 조회
- **엔드포인트**: `/performance-records`
- **메서드**: `GET`
- **설명**: 실적 정보 목록 조회
- **인증**: Bearer Token 필요

### 18. 실적-흡수율 정보
- **엔드포인트**: `/performance-records-absorption`
- **메서드**: `GET`
- **설명**: 실적 흡수율 분석 정보 조회
- **인증**: Bearer Token 필요

### 19. 실적 증빙 파일
- **엔드포인트**: `/performance-evidence-files`
- **메서드**: `GET`
- **설명**: 실적 증빙 파일 정보 조회
- **인증**: Bearer Token 필요

## 💳 정산 관리 API

### 20. 정산월 목록 조회
- **엔드포인트**: `/settlement-months`
- **메서드**: `GET`
- **설명**: 정산월 목록 조회
- **인증**: Bearer Token 필요

### 21. 정산내역서 목록 조회
- **엔드포인트**: `/settlement-share`
- **메서드**: `GET`
- **설명**: 정산내역서 목록 조회
- **인증**: Bearer Token 필요

## 🔧 사용 방법

### 인증 토큰 사용
대부분의 API는 인증이 필요합니다. 로그인 후 받은 토큰을 Authorization 헤더에 포함하여 요청하세요:

```bash
curl -X GET "https://shinil.vercel.app/api/companies" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 토큰 검증
토큰 검증은 요청 본문에 토큰을 포함하여 요청하세요:

```bash
curl -X POST "https://shinil.vercel.app/api/verify-token" \
  -H "Content-Type: application/json" \
  -d '{"token": "YOUR_TOKEN_HERE"}'
```

## 📍 배포 환경

### Vercel 배포 사이트
- **URL**: https://shinil.vercel.app/
- **API 기본 경로**: https://shinil.vercel.app/api/

### 로컬 개발 환경
- **URL**: http://localhost:3001/
- **API 기본 경로**: http://localhost:3001/api/

## 📝 참고사항

- 모든 API는 JSON 형식으로 요청/응답합니다
- 인증이 필요한 API는 Bearer Token을 Authorization 헤더에 포함해야 합니다
- 에러 응답은 `success: false`와 함께 에러 메시지가 포함됩니다
- 성공 응답은 `success: true`와 함께 데이터가 포함됩니다

---
**문서 생성일**: 2025년 1월 18일  
**API 버전**: 1.0.0  
**시스템**: Sinil PMS
