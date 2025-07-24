#!/usr/bin/env python3
"""
로컬 데이터베이스 스키마를 분석하여 Supabase용 SQL 파일 생성
"""

import psycopg2
from datetime import datetime

# 로컬 Docker PostgreSQL 설정
LOCAL_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',
    'database': 'postgres'
}

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
    sql_parts = [f"-- {table_name} 테이블 생성"]
    sql_parts.append(f"CREATE TABLE public.{table_name} (")
    
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
                # 시퀀스는 Supabase에서 자동으로 처리되므로 제거
                pass
            elif col_default.startswith("'") and col_default.endswith("'"):
                default = f" DEFAULT {col_default}"
            else:
                default = f" DEFAULT {col_default}"
        
        column_definitions.append(f"    {col_name} {pg_type}{nullable}{default}")
    
    sql_parts.append(",\n".join(column_definitions))
    sql_parts.append(");")
    sql_parts.append("")  # 빈 줄 추가
    
    return "\n".join(sql_parts)

def main():
    """메인 함수"""
    print("🚀 로컬 데이터베이스 스키마를 분석하여 Supabase용 SQL 파일 생성")
    print("=" * 70)
    
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
    
    # 생성할 테이블 목록
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
    
    print(f"\n📊 SQL 파일 생성 설정:")
    print(f"  생성할 테이블: {len(tables_to_create)}개")
    
    # SQL 파일 생성
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    sql_filename = f"supabase_schema_{timestamp}.sql"
    
    with open(sql_filename, 'w', encoding='utf-8') as f:
        # 헤더 작성
        f.write("-- Supabase 테이블 생성 SQL\n")
        f.write(f"-- 생성일시: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("-- 사용법: Supabase Dashboard > SQL Editor에서 이 파일의 내용을 실행하세요.\n")
        f.write("\n")
        
        success_count = 0
        
        for table in tables_to_create:
            print(f"🔄 {table} 테이블 스키마 분석 중...")
            
            # 로컬에서 스키마 정보 가져오기
            columns = get_local_table_schema(table)
            
            if not columns:
                print(f"  ❌ {table} 테이블 스키마를 가져올 수 없습니다.")
                continue
            
            # CREATE TABLE SQL 생성
            create_sql = generate_create_table_sql(table, columns)
            f.write(create_sql)
            
            print(f"  ✅ {table} 테이블 SQL 생성 완료 ({len(columns)}개 컬럼)")
            success_count += 1
    
    print("\n" + "=" * 70)
    print("🎉 Supabase용 SQL 파일 생성 완료!")
    print(f"📁 파일명: {sql_filename}")
    print(f"✅ 성공: {success_count}/{len(tables_to_create)} 테이블")
    print(f"❌ 실패: {len(tables_to_create) - success_count}/{len(tables_to_create)} 테이블")
    
    print(f"\n📋 다음 단계:")
    print(f"1. Supabase Dashboard에 로그인")
    print(f"2. SQL Editor로 이동")
    print(f"3. {sql_filename} 파일의 내용을 복사하여 실행")
    print(f"4. 테이블 생성 완료 후 restore_to_supabase.py 스크립트 실행")

if __name__ == "__main__":
    main() 