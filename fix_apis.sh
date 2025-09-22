#!/bin/bash

# API 파일들을 Vercel 호환성에 맞게 수정하는 스크립트

cd api

# 수정할 파일 목록 (이미 수정된 파일들 제외)
files=(
    "client-company-assignments.js"
    "client-pharmacy-assignments.js"
    "hospital-pharmacy-mappings.js"
    "hospital-company-mappings.js"
    "settlement-share.js"
    "settlement-months.js"
    "performance-evidence-files.js"
    "performance-records-absorption.js"
    "performance-records.js"
    "wholesale-sales.js"
    "product-company-not-assignments.js"
    "products/index.js"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        
        # 임시 파일 생성
        temp_file="${file}.tmp"
        
        # 파일 내용을 읽어서 수정
        {
            echo "// Vercel 서버리스 함수 형식"
            echo "import { createClient } from '@supabase/supabase-js'"
            echo ""
            echo "// Vercel에서는 환경 변수가 자동으로 로드됨"
            echo "console.log('✅ Vercel 환경 변수 로드됨')"
            echo ""
            echo "// IP 제한 함수 (Vercel 환경용)"
            echo "function checkIPAccess(req) {"
            echo "  console.log('🔓 Vercel 환경: IP 제한 비활성화')"
            echo "  return { allowed: true }"
            echo "}"
            echo ""
            
            # 원본 파일에서 export default 부분만 추출
            grep -A 1000 "export default" "$file" | head -n -1
        } > "$temp_file"
        
        # 원본 파일을 임시 파일로 교체
        mv "$temp_file" "$file"
        
        echo "✅ $file 수정 완료"
    else
        echo "⚠️ $file 파일을 찾을 수 없습니다"
    fi
done

echo "모든 API 파일 수정 완료!"
