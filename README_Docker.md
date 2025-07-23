# Docker를 이용한 신일제약 실적관리 시스템 실행 가이드

## 🐳 개요

이 가이드는 Docker를 사용하여 신일제약 실적관리 시스템을 로컬 환경에서 실행하는 방법을 설명합니다.

## 📋 사전 요구사항

- Docker Desktop 설치
- Docker Compose 설치
- 최소 4GB RAM (권장: 8GB)

## 🚀 빠른 시작

### 1. 환경 변수 설정

```bash
# vue-project 폴더에 .env 파일 생성
cd vue-project
cp env.example .env
```

`.env` 파일을 편집하여 Supabase 설정을 입력하세요:

```env
VITE_SUPABASE_URL=your_supabase_url_here
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

### 2. Docker 컨테이너 실행

```bash
# 프로젝트 루트 디렉토리에서
docker-compose -f docker-compose.dev.yml up -d
```

### 3. 애플리케이션 접속

- **Vue.js 앱**: http://localhost:3000
- **pgAdmin**: http://localhost:5050
  - 이메일: admin@shinil.com
  - 비밀번호: admin

## 🔧 상세 설정

### 개발 환경 (권장)

```bash
# 개발 모드로 실행
docker-compose -f docker-compose.dev.yml up -d

# 로그 확인
docker-compose -f docker-compose.dev.yml logs -f vue-app

# 컨테이너 중지
docker-compose -f docker-compose.dev.yml down
```

### 전체 환경 (Supabase 포함)

```bash
# 모든 서비스 실행
docker-compose up -d

# 특정 서비스만 실행
docker-compose up -d vue-app postgres
```

## 📊 서비스 포트

| 서비스 | 포트 | 설명 |
|--------|------|------|
| Vue.js 앱 | 3000 | 메인 애플리케이션 |
| PostgreSQL | 5432 | 데이터베이스 |
| pgAdmin | 5050 | 데이터베이스 관리 도구 |
| Supabase Studio | 54321 | Supabase 대시보드 |
| Supabase API | 54322 | API 게이트웨이 |

## 🛠️ 개발 작업

### 코드 변경사항 반영

Vue.js 앱은 볼륨 마운트되어 있어 코드 변경 시 자동으로 반영됩니다.

### 의존성 추가

```bash
# 컨테이너 내부에서 npm 설치
docker-compose -f docker-compose.dev.yml exec vue-app npm install package-name

# 또는 로컬에서 설치 후 컨테이너 재시작
npm install package-name
docker-compose -f docker-compose.dev.yml restart vue-app
```

### 데이터베이스 초기화

```bash
# PostgreSQL 데이터 초기화
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

## 🔍 문제 해결

### 포트 충돌

```bash
# 사용 중인 포트 확인
netstat -tulpn | grep :3000

# 다른 포트 사용
# docker-compose.dev.yml 파일에서 포트 변경
ports:
  - "3001:5173"  # 3000 대신 3001 사용
```

### 메모리 부족

```bash
# Docker Desktop 설정에서 메모리 증가
# Docker Desktop > Settings > Resources > Memory: 8GB 이상
```

### 컨테이너 로그 확인

```bash
# Vue.js 앱 로그
docker-compose -f docker-compose.dev.yml logs vue-app

# PostgreSQL 로그
docker-compose -f docker-compose.dev.yml logs postgres

# 실시간 로그
docker-compose -f docker-compose.dev.yml logs -f
```

### 컨테이너 재빌드

```bash
# 이미지 재빌드
docker-compose -f docker-compose.dev.yml build --no-cache

# 컨테이너 재시작
docker-compose -f docker-compose.dev.yml up -d --force-recreate
```

## 📁 프로젝트 구조

```
shinil_project/
├── vue-project/
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── env.example
│   └── src/
├── docker-compose.yml
├── docker-compose.dev.yml
└── README_Docker.md
```

## 🔐 보안 설정

### 프로덕션 환경

```bash
# 환경 변수 파일 생성
cp vue-project/env.example vue-project/.env.production

# 프로덕션용 docker-compose 실행
docker-compose -f docker-compose.prod.yml up -d
```

### 데이터베이스 보안

```bash
# 강력한 비밀번호 설정
POSTGRES_PASSWORD=your_strong_password_here
PGADMIN_DEFAULT_PASSWORD=your_strong_password_here
```

## 🧹 정리

### 컨테이너 및 볼륨 삭제

```bash
# 컨테이너 중지 및 삭제
docker-compose -f docker-compose.dev.yml down

# 볼륨까지 삭제 (데이터 손실)
docker-compose -f docker-compose.dev.yml down -v

# 이미지 삭제
docker rmi shinil_project_vue-app
```

### 시스템 정리

```bash
# 사용하지 않는 Docker 리소스 정리
docker system prune -a

# 볼륨 정리
docker volume prune
```

## 📞 지원

문제가 발생하거나 추가 도움이 필요하시면:

1. Docker 로그 확인
2. 포트 충돌 확인
3. 메모리 사용량 확인
4. 환경 변수 설정 확인

---

**마지막 업데이트**: 2025-01-15 