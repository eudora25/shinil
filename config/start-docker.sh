#!/bin/bash

# 신일제약 실적관리 시스템 Docker 실행 스크립트

echo "🐳 신일제약 실적관리 시스템 Docker 실행 스크립트"
echo "================================================"

# Docker 설치 확인
if ! command -v docker &> /dev/null; then
    echo "❌ Docker가 설치되어 있지 않습니다."
    echo "Docker Desktop을 설치해주세요: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose가 설치되어 있지 않습니다."
    exit 1
fi

echo "✅ Docker 및 Docker Compose 확인 완료"

# 환경 변수 파일 확인
if [ ! -f "vue-project/.env" ]; then
    echo "⚠️  vue-project/.env 파일이 없습니다."
    echo "env.example을 복사하여 .env 파일을 생성합니다..."
    cp vue-project/env.example vue-project/.env
    echo "📝 vue-project/.env 파일을 편집하여 Supabase 설정을 입력해주세요."
    echo "   - VITE_SUPABASE_URL"
    echo "   - VITE_SUPABASE_ANON_KEY"
    read -p "계속하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 실행 모드 선택
echo ""
echo "실행 모드를 선택하세요:"
echo "1) 개발 환경 (Vue.js + PostgreSQL + pgAdmin)"
echo "2) 전체 환경 (Vue.js + Supabase + PostgreSQL)"
echo "3) Vue.js만 실행"
read -p "선택 (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 개발 환경으로 실행합니다..."
        docker-compose -f docker-compose.dev.yml up -d
        COMPOSE_FILE="docker-compose.dev.yml"
        ;;
    2)
        echo "🚀 전체 환경으로 실행합니다..."
        docker-compose up -d
        COMPOSE_FILE="docker-compose.yml"
        ;;
    3)
        echo "🚀 Vue.js만 실행합니다..."
        docker-compose -f docker-compose.dev.yml up -d vue-app
        COMPOSE_FILE="docker-compose.dev.yml"
        ;;
    *)
        echo "❌ 잘못된 선택입니다."
        exit 1
        ;;
esac

# 컨테이너 상태 확인
echo ""
echo "⏳ 컨테이너 시작 중..."
sleep 10

echo ""
echo "📊 컨테이너 상태:"
docker-compose -f $COMPOSE_FILE ps

echo ""
echo "🌐 접속 정보:"
echo "   Vue.js 앱: http://localhost:3000"
if [[ $REPLY == 1 ]]; then
    echo "   pgAdmin: http://localhost:5050 (admin@shinil.com / admin)"
    echo "   PostgreSQL: localhost:5432"
fi
if [[ $REPLY == 2 ]]; then
    echo "   Supabase Studio: http://localhost:54321"
    echo "   Supabase API: http://localhost:54322"
fi

echo ""
echo "📋 유용한 명령어:"
echo "   로그 확인: docker-compose -f $COMPOSE_FILE logs -f"
echo "   컨테이너 중지: docker-compose -f $COMPOSE_FILE down"
echo "   컨테이너 재시작: docker-compose -f $COMPOSE_FILE restart"

echo ""
echo "✅ 실행 완료! 브라우저에서 http://localhost:3000 으로 접속하세요." 