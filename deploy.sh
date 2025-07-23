#!/bin/bash

# 신일제약 PMS 배포 스크립트
# 사용법: ./deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}
COMPOSE_FILE="docker-compose.yml"

if [ "$ENVIRONMENT" = "prod" ]; then
    COMPOSE_FILE="docker-compose.prod.yml"
    echo "🚀 프로덕션 환경 배포 시작..."
else
    echo "🔧 개발 환경 배포 시작..."
fi

# Docker Compose 파일 확인
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ $COMPOSE_FILE 파일을 찾을 수 없습니다."
    exit 1
fi

# 환경 변수 설정
export DOCKER_USERNAME=${DOCKER_USERNAME:-shinil}
export DB_PASSWORD=${DB_PASSWORD:-postgres}
export JWT_SECRET=${JWT_SECRET:-shinil-pms-secret-key-2024}

echo "📋 배포 설정:"
echo "   - 환경: $ENVIRONMENT"
echo "   - Docker Compose: $COMPOSE_FILE"
echo "   - Docker Username: $DOCKER_USERNAME"
echo "   - JWT Secret: ${JWT_SECRET:0:10}..."

# 기존 컨테이너 중지 및 제거
echo "🛑 기존 컨테이너 중지..."
docker-compose -f $COMPOSE_FILE down --remove-orphans

# 이미지 풀
echo "📥 최신 이미지 다운로드..."
docker-compose -f $COMPOSE_FILE pull

# 컨테이너 시작
echo "🚀 컨테이너 시작..."
docker-compose -f $COMPOSE_FILE up -d

# 헬스체크
echo "🏥 서비스 상태 확인..."
sleep 10

# API 서버 상태 확인
if curl -f http://localhost:3001/api/test > /dev/null 2>&1; then
    echo "✅ API 서버 정상 작동"
else
    echo "⚠️ API 서버 상태 확인 필요"
fi

# 프론트엔드 상태 확인
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ 프론트엔드 정상 작동"
else
    echo "⚠️ 프론트엔드 상태 확인 필요"
fi

# 데이터베이스 상태 확인
if docker-compose -f $COMPOSE_FILE exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "✅ 데이터베이스 정상 작동"
else
    echo "⚠️ 데이터베이스 상태 확인 필요"
fi

# 컨테이너 상태 출력
echo "📊 컨테이너 상태:"
docker-compose -f $COMPOSE_FILE ps

echo ""
echo "🎉 배포 완료!"
echo ""
echo "📱 접속 정보:"
echo "   - 프론트엔드: http://localhost:3000"
echo "   - API 서버: http://localhost:3001"
echo "   - 보안 API 테스트: http://localhost:3000/secure-api-test.html"
echo ""
echo "🔑 테스트 계정:"
echo "   - 관리자: admin@shinil.com / admin123"
echo "   - 일반사용자: user@shinil.com / admin123"
echo ""
echo "📝 로그 확인:"
echo "   - 전체 로그: docker-compose -f $COMPOSE_FILE logs -f"
echo "   - API 로그: docker-compose -f $COMPOSE_FILE logs -f api-server"
echo "   - 프론트엔드 로그: docker-compose -f $COMPOSE_FILE logs -f vue-app" 