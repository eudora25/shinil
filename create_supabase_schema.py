#!/usr/bin/env python3
"""
로컬 데이터베이스 스키마를 분석하여 새로운 Supabase 프로젝트에 테이블 생성
"""

import psycopg2
from supabase import create_client, Client

# Supabase 설정
SUPABASE_URL = "https://mctzuqctekhhdfwimxek.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jdHp1cWN0ZWtoaGRmd2lteGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzUyNTUsImV4cCI6MjA2ODkxMTI1NX0.zLH2UFBUG7Zn1ow80Fg69Se8OLN7oRPRrmzFvu9_7gY"

# 로컬 Docker PostgreSQL 설정
LOCAL_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',
    'database': 'postgres'
}

def create_supabase_client() -> Client:
    """Supabase 클라이언트 생성"""
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
        print("✅ Supabase 클라이언트 생성 성공")
        return supabase
    except Exception as e:
        print(f"❌ Supabase 클라이언트 생성 실패: {e}")
        return None

def get_local_table_schema(table_name: str):
    """로컬 테이블의 스키마 정보 가져오기"""
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        
        # 테이블 컬럼 정보 조회
        cursor.execute("""
            SELECT 
                column_name,
                data_type,
                is_nullable,
                column_default,
                character_maximum_length,
                numeric_precision,
                numeric_scale
            FROM information_schema.columns 
            WHERE table_name = %s 
            AND table_schema = 'public' 
            ORDER BY ordinal_position
        """, (table_name,))
        
        columns = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        return columns
        
    except Exception as e:
        print(f"❌ {table_name} 스키마 조회 실패: {e}")
        return []

def generate_create_table_sql(table_name: str, columns: list):
    """CREATE TABLE SQL 생성"""
    sql_parts = [f"CREATE TABLE public.{table_name} ("]
    
    column_definitions = []
    for col in columns:
        col_name, data_type, is_nullable, col_default, char_max_len, num_precision, num_scale = col
        
        # 데이터 타입 변환
        if data_type == 'character varying':
            if char_max_len:
                pg_type = f"VARCHAR({char_max_len})"
            else:
                pg_type = "VARCHAR"
        elif data_type == 'character':
            pg_type = "CHAR"
        elif data_type == 'text':
            pg_type = "TEXT"
        elif data_type == 'integer':
            pg_type = "INTEGER"
        elif data_type == 'bigint':
            pg_type = "BIGINT"
        elif data_type == 'smallint':
            pg_type = "SMALLINT"
        elif data_type == 'numeric':
            if num_precision and num_scale:
                pg_type = f"NUMERIC({num_precision},{num_scale})"
            elif num_precision:
                pg_type = f"NUMERIC({num_precision})"
            else:
                pg_type = "NUMERIC"
        elif data_type == 'real':
            pg_type = "REAL"
        elif data_type == 'double precision':
            pg_type = "DOUBLE PRECISION"
        elif data_type == 'boolean':
            pg_type = "BOOLEAN"
        elif data_type == 'date':
            pg_type = "DATE"
        elif data_type == 'timestamp without time zone':
            pg_type = "TIMESTAMP"
        elif data_type == 'timestamp with time zone':
            pg_type = "TIMESTAMPTZ"
        elif data_type == 'time without time zone':
            pg_type = "TIME"
        elif data_type == 'uuid':
            pg_type = "UUID"
        elif data_type == 'json':
            pg_type = "JSON"
        elif data_type == 'jsonb':
            pg_type = "JSONB"
        else:
            pg_type = data_type.upper()
        
        # NULL 제약 조건
        nullable = "" if is_nullable == 'YES' else " NOT NULL"
        
        # 기본값
        default = ""
        if col_default:
            if col_default.startswith("nextval"):
                default = " DEFAULT nextval('" + col_default.split("'")[1] + "')"
            elif col_default.startswith("'") and col_default.endswith("'"):
                default = f" DEFAULT {col_default}"
            else:
                default = f" DEFAULT {col_default}"
        
        column_definitions.append(f"    {col_name} {pg_type}{nullable}{default}")
    
    sql_parts.append(",\n".join(column_definitions))
    sql_parts.append(");")
    
    return "\n".join(sql_parts)

def create_table_in_supabase(supabase: Client, table_name: str, create_sql: str):
    """Supabase에 테이블 생성"""
    try:
        print(f"📋 {table_name} 테이블 생성 중...")
        
        # RPC를 통해 SQL 실행
        response = supabase.rpc('exec_sql', {'sql': create_sql}).execute()
        
        print(f"  ✅ {table_name} 테이블 생성 완료")
        return True
        
    except Exception as e:
        print(f"  ❌ {table_name} 테이블 생성 실패: {e}")
        return False

def check_table_exists_in_supabase(supabase: Client, table_name: str):
    """Supabase에 테이블이 존재하는지 확인"""
    try:
        # 간단한 쿼리로 테이블 존재 여부 확인
        response = supabase.table(table_name).select('*').limit(1).execute()
        return True
    except:
        return False

def main():
    """메인 함수"""
    print("🚀 로컬 데이터베이스 스키마를 분석하여 Supabase 테이블 생성")
    print("=" * 70)
    
    # Supabase 클라이언트 생성
    supabase = create_supabase_client()
    if not supabase:
        return
    
    # 로컬 데이터베이스 연결 확인
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        print(f"✅ 로컬 데이터베이스 연결 성공: {version.split(',')[0]}")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"❌ 로컬 데이터베이스 연결 실패: {e}")
        return
    
    # 복원할 테이블 목록
    tables_to_create = [
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
    
    print(f"\n📊 테이블 생성 설정:")
    print(f"  대상: Supabase ({SUPABASE_URL})")
    print(f"  생성할 테이블: {len(tables_to_create)}개")
    
    print(f"\n📦 테이블 생성 시작")
    print("=" * 70)
    
    # 각 테이블 생성
    success_count = 0
    
    for table in tables_to_create:
        print(f"\n🔄 {table} 테이블 처리 중...")
        
        # 이미 존재하는지 확인
        if check_table_exists_in_supabase(supabase, table):
            print(f"  ⚠️ {table} 테이블이 이미 존재합니다.")
            success_count += 1
            continue
        
        # 로컬에서 스키마 정보 가져오기
        columns = get_local_table_schema(table)
        
        if not columns:
            print(f"  ❌ {table} 테이블 스키마를 가져올 수 없습니다.")
            continue
        
        # CREATE TABLE SQL 생성
        create_sql = generate_create_table_sql(table, columns)
        
        print(f"  📋 생성할 SQL:")
        print(f"  {create_sql}")
        
        # Supabase에 테이블 생성
        if create_table_in_supabase(supabase, table, create_sql):
            success_count += 1
    
    print("\n" + "=" * 70)
    print("🎉 Supabase 테이블 생성 완료!")
    print(f"✅ 성공: {success_count}/{len(tables_to_create)} 테이블")
    print(f"❌ 실패: {len(tables_to_create) - success_count}/{len(tables_to_create)} 테이블")
    
    if success_count == len(tables_to_create):
        print("🎯 모든 테이블 생성 성공!")
        print("이제 restore_to_supabase.py 스크립트를 실행하여 데이터를 복원할 수 있습니다.")
    else:
        print("⚠️ 일부 테이블 생성에 실패했습니다.")

if __name__ == "__main__":
    main() 