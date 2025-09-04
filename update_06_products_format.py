#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import os

def update_products_excel():
    """06_제품정보_조회.xlsx 파일을 실제 API 응답에 맞춰 업데이트"""
    
    file_path = "API_Files/06_제품정보_조회.xlsx"
    
    if not os.path.exists(file_path):
        print(f"❌ 파일을 찾을 수 없습니다: {file_path}")
        return False
    
    try:
        # 기존 파일 읽기
        df = pd.read_excel(file_path)
        
        # 새로운 데이터 생성 (실제 API 응답에 맞춤)
        new_data = [
            ["URI", "/products", "", "", ""],
            ["설명", "등록된 제품 정보 목록 조회", "", "", ""],
            ["주기", "실시간", "", "", ""],
            ["메서드", "GET", "", "", ""],
            ["인증", "Bearer Token", "", "", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["입력 파라미터", "", "", "", ""],
            ["파라미터명", "타입", "설명", "필수", ""],
            ["", "", "", "", ""],
            ["page", "INTEGER", "페이지 번호 (기본값: 1)", "N", ""],
            ["", "", "", "", ""],
            ["limit", "INTEGER", "페이지당 항목 수 (기본값: 100, 최대: 1000)", "N", ""],
            ["", "", "", "", ""],
            ["startDate", "STRING", "검색 시작일 (YYYY-MM-DD 형식, 기본값: 오늘)", "N", ""],
            ["", "", "", "", ""],
            ["endDate", "STRING", "검색 종료일 (YYYY-MM-DD 형식, 기본값: 오늘)", "N", ""],
            ["", "", "", "", ""],
            ["", "", "", "", ""],
            ["출력 파라미터", "", "", "", ""],
            ["파라미터명", "타입", "설명", "필수", "비고"],
            ["", "", "", "", ""],
            ["success", "BOOLEAN", "성공 여부", "Y", ""],
            ["", "", "", "", ""],
            ["data", "ARRAY", "제품 정보 목록", "Y", ""],
            ["", "", "", "", ""],
            ["data[].id", "UUID", "제품 ID", "Y", ""],
            ["", "", "", "", ""],
            ["data[].product_name", "STRING", "제품명", "Y", ""],
            ["", "", "", "", ""],
            ["data[].insurance_code", "STRING", "보험 코드", "N", ""],
            ["", "", "", "", ""],
            ["data[].price", "INTEGER", "가격", "N", ""],
            ["", "", "", "", ""],
            ["data[].commission_rate_a", "NUMERIC", "A등급 수수료율", "Y", ""],
            ["", "", "", "", ""],
            ["data[].commission_rate_b", "NUMERIC", "B등급 수수료율", "Y", ""],
            ["", "", "", "", ""],
            ["data[].commission_rate_c", "NUMERIC", "C등급 수수료율", "N", ""],
            ["", "", "", "", ""],
            ["data[].commission_rate_d", "NUMERIC", "D등급 수수료율", "N", ""],
            ["", "", "", "", ""],
            ["data[].commission_rate_e", "NUMERIC", "E등급 수수료율", "N", ""],
            ["", "", "", "", ""],
            ["data[].standard_code", "STRING", "표준 코드", "Y", ""],
            ["", "", "", "", ""],
            ["data[].unit_packaging_desc", "STRING", "단위 포장 설명", "N", ""],
            ["", "", "", "", ""],
            ["data[].unit_quantity", "INTEGER", "단위 수량", "N", ""],
            ["", "", "", "", ""],
            ["data[].remarks", "STRING", "비고", "N", ""],
            ["", "", "", "", ""],
            ["data[].status", "STRING", "상태", "Y", "active/inactive"],
            ["", "", "", "", ""],
            ["data[].base_month", "STRING", "기준월", "Y", ""],
            ["", "", "", "", ""],
            ["data[].created_at", "TIMESTAMP", "생성일시", "Y", ""],
            ["", "", "", "", ""],
            ["data[].updated_at", "TIMESTAMP", "수정일시", "Y", ""],
            ["", "", "", "", ""],
            ["data[].created_by", "UUID", "생성자 ID", "N", ""],
            ["", "", "", "", ""],
            ["data[].updated_by", "UUID", "수정자 ID", "N", ""],
            ["", "", "", "", ""],
            ["count", "INTEGER", "전체 항목 수", "Y", ""],
            ["", "", "", "", ""],
            ["page", "INTEGER", "현재 페이지", "Y", ""],
            ["", "", "", "", ""],
            ["limit", "INTEGER", "페이지당 항목 수", "Y", ""]
        ]
        
        # 새로운 DataFrame 생성
        new_df = pd.DataFrame(new_data, columns=['항목', '내용', 'Unnamed: 2', 'Unnamed: 3', 'Unnamed: 4'])
        
        # Excel 파일로 저장
        with pd.ExcelWriter(file_path, engine='openpyxl') as writer:
            new_df.to_excel(writer, sheet_name='Sheet', index=False, header=False)
            
            # 워크시트 스타일링
            worksheet = writer.sheets['Sheet']
            
            # 열 너비 조정
            worksheet.column_dimensions['A'].width = 25
            worksheet.column_dimensions['B'].width = 40
            worksheet.column_dimensions['C'].width = 15
            worksheet.column_dimensions['D'].width = 15
            worksheet.column_dimensions['E'].width = 15
        
        print(f"✅ {file_path} 파일이 성공적으로 업데이트되었습니다!")
        print("📋 추가된 필드들:")
        print("   - data[].commission_rate_d (D등급 수수료율)")
        print("   - data[].commission_rate_e (E등급 수수료율)")
        print("   - data[].created_by (생성자 ID)")
        print("   - data[].updated_by (수정자 ID)")
        
        return True
        
    except Exception as e:
        print(f"❌ 파일 업데이트 중 오류 발생: {str(e)}")
        return False

if __name__ == "__main__":
    update_products_excel()
