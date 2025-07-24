#!/bin/bash

echo "🚀 Supabase 데이터베이스 백업 스크립트 실행"
echo "=========================================="

# Python 가상환경 확인 및 활성화
if [ -d ".venv" ]; then
    echo "📦 가상환경 활성화 중..."
    source .venv/bin/activate
else
    echo "⚠️ 가상환경이 없습니다. 시스템 Python을 사용합니다."
fi

# 필요한 패키지 설치 확인
echo "📋 필요한 패키지 설치 확인 중..."
pip install -r requirements_backup.txt

# 백업 스크립트 실행
echo "🔄 백업 스크립트 실행 중..."
python backup_database_simple.py

echo "✅ 백업 스크립트 실행 완료" 