#!/usr/bin/env python3
"""
복원된 데이터베이스 데이터 확인 스크립트 (수정 버전)
"""

import psycopg2

# Docker PostgreSQL 설정
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',
    'database': 'postgres'
}

def check_data():
    """복원된 데이터 확인"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print("📊 복원된 데이터 확인")
        print("=" * 40)
        
        # 주요 테이블 데이터 확인
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
        
        for table in tables_to_check:
            try:
                cursor.execute(f"SELECT COUNT(*) FROM public.{table}")
                count = cursor.fetchone()[0]
                print(f"✅ {table}: {count:,}개 행")
            except Exception as e:
                print(f"❌ {table}: 확인 불가 ({e})")
        
        # 샘플 데이터 확인
        print("\n📋 샘플 데이터:")
        print("-" * 40)
        
        # companies 테이블 샘플
        cursor.execute("SELECT company_name, business_registration_number FROM public.companies LIMIT 3")
        companies = cursor.fetchall()
        print("🏢 업체 정보 (상위 3개):")
        for company in companies:
            print(f"  - {company[0]} ({company[1]})")
        
        # products 테이블 컬럼 확인
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'products' AND table_schema = 'public' ORDER BY ordinal_position")
        columns = cursor.fetchall()
        print(f"\n💊 products 테이블 컬럼: {[col[0] for col in columns]}")
        
        # products 테이블 샘플 (첫 번째 컬럼 사용)
        if columns:
            first_col = columns[0][0]
            cursor.execute(f"SELECT {first_col} FROM public.products LIMIT 3")
            products = cursor.fetchall()
            print(f"💊 제품 정보 (상위 3개, {first_col}):")
            for product in products:
                print(f"  - {product[0]}")
        
        cursor.close()
        conn.close()
        
        print("\n🎉 데이터 확인 완료!")
        
    except Exception as e:
        print(f"❌ 데이터 확인 실패: {e}")

if __name__ == "__main__":
    check_data() 