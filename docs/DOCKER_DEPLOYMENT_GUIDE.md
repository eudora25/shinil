# 🐳 Docker 배포 가이드 - 신일제약 PMS

## 📋 **개요**

신일제약 실적관리프로그램을 Docker 컨테이너로 배포하는 방법을 설명합니다.

## 🏗️ **Docker 아키텍처**

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose Environment               │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Vue.js App    │  Express API    │   PostgreSQL Database   │
│   (Port 3000)   │   (Port 3001)   │     (Port 5432)        │
├─────────────────┼─────────────────┼─────────────────────────┤
│   Nginx Proxy   │   pgAdmin       │   Redis (Optional)      │
│   (Port 80)     │   (Port 5050)   │     (Port 6379)         │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 📁 **Docker 파일 구조**

### **1. 메인 Docker Compose 파일**
- **`docker-compose.yml`**: 개발 환경용
- **`docker-compose.prod.yml`**: 프로덕션 환경용

### **2. Dockerfile들**
- **`vue-project/Dockerfile`**: Vue.js 프론트엔드
- **`vue-project/Dockerfile.api`**: Express API 서버
- **`vue-project/Dockerfile.prod`**: 프로덕션용 Vue.js

### **3. 설정 파일들**
- **`vue-project/nginx.conf`**: Nginx 프록시 설정
- **`postgres-init/01-init.sql`**: PostgreSQL 초기화 스크립트

## 🚀 **배포 방법**

### **1. 개발 환경 배포**

#### **기본 배포**
```bash
# 모든 서비스 시작
docker-compose up -d

# 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs -f
```

#### **선택적 배포**
```bash
# 프론트엔드만 시작
docker-compose up -d vue-app

# API 서버만 시작
docker-compose up -d api-server

# 데이터베이스만 시작
docker-compose up -d postgres
```

### **2. 프로덕션 환경 배포**

#### **프로덕션 배포 스크립트 사용**
```bash
# 배포 스크립트 실행 권한 부여
chmod +x deploy.sh

# 개발 환경 배포
./deploy.sh dev

# 프로덕션 환경 배포
./deploy.sh prod
```

#### **수동 프로덕션 배포**
```bash
# 환경변수 설정
export DOCKER_USERNAME=your-docker-username
export DB_PASSWORD=your-secure-password
export JWT_SECRET=your-jwt-secret

# 프로덕션 컨테이너 시작
docker-compose -f docker-compose.prod.yml up -d

# 상태 확인
docker-compose -f docker-compose.prod.yml ps
```

## 🔧 **서비스 구성**

### **1. Vue.js 프론트엔드**
```yaml
vue-app:
  build:
    context: ./vue-project
    dockerfile: Dockerfile
  ports:
    - "3000:5173"
  volumes:
    - ./vue-project:/app
    - /app/node_modules
  environment:
    - NODE_ENV=development
  networks:
    - shinil-network
```

### **2. Express API 서버**
```yaml
api-server:
  build:
    context: ./vue-project
    dockerfile: Dockerfile.api
  ports:
    - "3001:3001"
  environment:
    - DB_HOST=postgres
    - DB_PORT=5432
    - DB_NAME=shinil_pms
    - DB_USER=postgres
    - DB_PASSWORD=postgres
  networks:
    - shinil-network
  depends_on:
    - postgres
```

### **3. PostgreSQL 데이터베이스**
```yaml
postgres:
  image: postgres:15
  ports:
    - "5432:5432"
  environment:
    - POSTGRES_DB=postgres
    - POSTGRES_USER=postgres
    - POSTGRES_PASSWORD=postgres
  volumes:
    - postgres-data:/var/lib/postgresql/data
    - ./postgres-init:/docker-entrypoint-initdb.d
  networks:
    - shinil-network
  command: >
    postgres
    -c wal_level=logical
    -c max_replication_slots=5
    -c max_wal_senders=10
    -c shared_preload_libraries=pg_stat_statements
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U postgres"]
    interval: 10s
    timeout: 5s
    retries: 5
```

### **4. pgAdmin (데이터베이스 관리)**
```yaml
pgadmin:
  image: dpage/pgadmin4
  ports:
    - "5050:80"
  environment:
    - PGADMIN_DEFAULT_EMAIL=admin@shinil.com
    - PGADMIN_DEFAULT_PASSWORD=admin
    - PGADMIN_CONFIG_SERVER_MODE=False
    - PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False
    - PGADMIN_CONFIG_CSRF_PROTECTION=False
  volumes:
    - pgadmin-data:/var/lib/pgadmin
  networks:
    - shinil-network
  depends_on:
    - postgres
```

## 📊 **접속 정보**

### **개발 환경**
| 서비스 | URL | 포트 | 설명 |
|--------|-----|------|------|
| Vue.js 앱 | http://localhost:3000 | 3000 | 메인 애플리케이션 |
| API 서버 | http://localhost:3001 | 3001 | 백엔드 API |
| PostgreSQL | localhost | 5432 | 데이터베이스 |
| pgAdmin | http://localhost:5050 | 5050 | DB 관리 도구 |

### **프로덕션 환경**
| 서비스 | URL | 포트 | 설명 |
|--------|-----|------|------|
| Vue.js 앱 | http://your-domain.com | 80 | 메인 애플리케이션 |
| API 서버 | http://your-domain.com:3001 | 3001 | 백엔드 API |
| PostgreSQL | your-domain.com | 5432 | 데이터베이스 |

## 🔐 **보안 설정**

### **1. 환경변수 관리**
```bash
# .env 파일 생성 (프로덕션용)
cat > .env << EOF
DB_PASSWORD=your-secure-password
JWT_SECRET=your-jwt-secret-key
DOCKER_USERNAME=your-docker-username
EOF
```

### **2. 네트워크 보안**
```yaml
networks:
  shinil-network:
    driver: bridge
    # 추가 보안 설정
    driver_opts:
      com.docker.network.bridge.name: shinil-bridge
```

### **3. 볼륨 보안**
```yaml
volumes:
  postgres-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /path/to/secure/data
```

## 🧪 **테스트 및 검증**

### **1. 컨테이너 상태 확인**
```bash
# 모든 컨테이너 상태
docker-compose ps

# 특정 서비스 로그
docker-compose logs vue-app
docker-compose logs api-server
docker-compose logs postgres

# 실시간 로그 모니터링
docker-compose logs -f
```

### **2. API 테스트**
```bash
# API 서버 상태 확인
curl http://localhost:3001/api/test

# 로그인 테스트
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@shinil.com","password":"admin123"}'

# 데이터베이스 연결 테스트
docker-compose exec postgres pg_isready -U postgres
```

### **3. 웹 애플리케이션 테스트**
```bash
# 프론트엔드 접속 테스트
curl -I http://localhost:3000

# 보안 API 테스트 페이지
curl -I http://localhost:3000/secure-api-test.html
```

## 🛠️ **문제 해결**

### **1. 컨테이너 시작 실패**
```bash
# 컨테이너 재빌드
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# 볼륨 초기화 (주의: 데이터 삭제됨)
docker-compose down -v
docker-compose up -d
```

### **2. 포트 충돌**
```bash
# 사용 중인 포트 확인
lsof -i :3000
lsof -i :3001
lsof -i :5432

# 포트 변경 (docker-compose.yml 수정)
ports:
  - "3001:3001"  # 호스트:컨테이너
```

### **3. 데이터베이스 연결 오류**
```bash
# PostgreSQL 컨테이너 상태 확인
docker-compose exec postgres pg_isready -U postgres

# 데이터베이스 로그 확인
docker-compose logs postgres

# 수동 연결 테스트
docker-compose exec postgres psql -U postgres -d shinil_pms
```

### **4. 메모리 부족**
```bash
# Docker 리소스 확인
docker system df

# 사용하지 않는 리소스 정리
docker system prune -a

# 컨테이너 리소스 제한 설정
services:
  postgres:
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

## 📈 **성능 최적화**

### **1. 멀티스테이지 빌드**
```dockerfile
# 개발용
FROM node:18-alpine as development
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "run", "dev"]

# 프로덕션용
FROM node:18-alpine as production
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["npm", "start"]
```

### **2. 볼륨 최적화**
```yaml
volumes:
  - ./vue-project:/app
  - /app/node_modules  # 노드 모듈 캐싱
  - postgres-data:/var/lib/postgresql/data
```

### **3. 네트워크 최적화**
```yaml
networks:
  shinil-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

## 🔄 **백업 및 복구**

### **1. 데이터베이스 백업**
```bash
# 백업 생성
docker-compose exec postgres pg_dump -U postgres shinil_pms > backup.sql

# 백업 복구
docker-compose exec -T postgres psql -U postgres shinil_pms < backup.sql
```

### **2. 볼륨 백업**
```bash
# 볼륨 백업
docker run --rm -v shinil_project_postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /data .

# 볼륨 복구
docker run --rm -v shinil_project_postgres-data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /data
```

## 📋 **체크리스트**

### **배포 전 확인사항**
- [ ] Docker 및 Docker Compose 설치 확인
- [ ] 필요한 포트(3000, 3001, 5432, 5050) 사용 가능 확인
- [ ] 환경변수 설정 완료
- [ ] 데이터베이스 초기화 스크립트 준비
- [ ] 테스트 사용자 데이터 생성

### **배포 후 확인사항**
- [ ] 모든 컨테이너 정상 실행 확인
- [ ] API 서버 응답 확인
- [ ] 데이터베이스 연결 확인
- [ ] 웹 애플리케이션 접속 확인
- [ ] 보안 API 테스트 완료
- [ ] 로그 모니터링 설정

## 📞 **지원 및 문의**

### **유용한 명령어**
```bash
# 전체 시스템 상태 확인
docker-compose ps
docker system df

# 로그 확인
docker-compose logs -f [service-name]

# 컨테이너 내부 접속
docker-compose exec [service-name] sh

# 환경변수 확인
docker-compose exec [service-name] env
```

### **문서 정보**
- **버전**: 1.0.0
- **최종 업데이트**: 2024년 12월 22일
- **작성자**: AI Assistant

---

**🎉 Docker를 통한 안전하고 확장 가능한 배포 환경이 구축되었습니다!** 