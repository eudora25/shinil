#!/usr/bin/env python3
"""
Supabase에 복원된 데이터를 확인하는 스크립트
"""

from supabase import create_client, Client

# Supabase 설정
SUPABASE_URL = "https://mctzuqctekhhdfwimxek.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jdHp1cWN0ZWtoaGRmd2lteGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzUyNTUsImV4cCI6MjA2ODkxMTI1NX0.zLH2UFBUG7Zn1ow80Fg69Se8OLN7oRPRrmzFvu9_7gY"

def create_supabase_client() -> Client:
    """Supabase 클라이언트 생성"""
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
        print("✅ Supabase 클라이언트 생성 성공")
        return supabase
    except Exception as e:
        print(f"❌ Supabase 클라이언트 생성 실패: {e}")
        return None

def check_table_data(supabase: Client, table_name: str):
    """테이블 데이터 확인"""
    try:
        # 전체 행 수 확인
        response = supabase.table(table_name).select('*', count='exact').execute()
        total_count = response.count if hasattr(response, 'count') else len(response.data)
        
        print(f"📊 {table_name}: {total_count:,}개 행")
        
        # 샘플 데이터 확인 (상위 3개)
        if total_count > 0:
            sample_response = supabase.table(table_name).select('*').limit(3).execute()
            samples = sample_response.data
            
            print(f"  📋 샘플 데이터:")
            for i, sample in enumerate(samples, 1):
                # ID와 주요 필드만 표시
                if 'id' in sample:
                    print(f"    {i}. ID: {sample['id']}")
                if 'name' in sample:
                    print(f"       이름: {sample['name']}")
                elif 'company_name' in sample:
                    print(f"       회사명: {sample['company_name']}")
                elif 'product_name' in sample:
                    print(f"       제품명: {sample['product_name']}")
                elif 'pharmacy_name' in sample:
                    print(f"       약국명: {sample['pharmacy_name']}")
        
        return total_count
        
    except Exception as e:
        print(f"❌ {table_name} 확인 실패: {e}")
        return 0

def main():
    """메인 함수"""
    print("🔍 Supabase 복원 데이터 확인")
    print("=" * 50)
    
    # Supabase 클라이언트 생성
    supabase = create_supabase_client()
    if not supabase:
        return
    
    print(f"📊 대상: {SUPABASE_URL}")
    print()
    
    # 확인할 테이블 목록
    tables_to_check = [
        'companies',
        'products', 
        'clients',
        'pharmacies',
        'wholesale_sales',
        'direct_sales',
        'performance_records',
        'settlement_months',
        'notices'
    ]
    
    total_rows = 0
    
    for table in tables_to_check:
        count = check_table_data(supabase, table)
        total_rows += count
        print()
    
    print("=" * 50)
    print(f"🎉 총 복원된 데이터: {total_rows:,}개 행")
    print("✅ Supabase 데이터 복원 확인 완료!")

if __name__ == "__main__":
    main() 