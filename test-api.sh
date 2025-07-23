#!/bin/bash

echo "🧪 API 테스트 스크립트"
echo "====================="

# Supabase API 상태 확인
echo "1. Supabase API 상태 확인..."
if curl -s http://localhost:54322/health > /dev/null; then
    echo "✅ Supabase API 정상"
else
    echo "❌ Supabase API 연결 실패"
    echo "   Supabase 로컬 환경이 아직 시작되지 않았을 수 있습니다."
    echo "   잠시 후 다시 시도해주세요."
    exit 1
fi

echo ""
echo "2. 실적 데이터 API 테스트..."

# API 호출
response=$(curl -s -X POST http://localhost:54322/functions/v1/performance-data \
  -H "Content-Type: application/json" \
  -d '{"limit": 5}')

if [ $? -eq 0 ]; then
    echo "✅ API 호출 성공"
    echo ""
    echo "📊 응답 결과:"
    echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
else
    echo "❌ API 호출 실패"
    echo "응답: $response"
fi

echo ""
echo "3. 다른 테스트 옵션들:"
echo "   - 브라우저: http://localhost:3000/api-test-example.html"
echo "   - Supabase Studio: http://localhost:54321"
echo "   - pgAdmin: http://localhost:5050" 