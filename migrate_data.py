#!/usr/bin/env python3
"""
Supabase에서 로컬 PostgreSQL로 데이터 마이그레이션 스크립트
"""

import psycopg2
import requests
import json
import os
from datetime import datetime

# Supabase 설정
SUPABASE_URL = "https://selklngerzfmuvagcvvf.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U"

# 로컬 PostgreSQL 설정
LOCAL_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'shinil_pms',
    'user': 'postgres',
    'password': 'postgres'
}

def get_supabase_data(table_name):
    """Supabase에서 테이블 데이터 가져오기"""
    url = f"{SUPABASE_URL}/rest/v1/{table_name}"
    headers = {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'Content-Type': 'application/json'
    }
    
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"❌ {table_name} 테이블 데이터 가져오기 실패: {e}")
        return None

def get_supabase_tables():
    """Supabase에서 테이블 목록 가져오기"""
    url = f"{SUPABASE_URL}/rest/v1/"
    headers = {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}'
    }
    
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"❌ 테이블 목록 가져오기 실패: {e}")
        return []

def create_table_schema(conn, table_name, data):
    """테이블 스키마 생성"""
    if not data:
        return False
    
    # 첫 번째 레코드로 컬럼 구조 파악
    first_record = data[0]
    columns = []
    
    for col_name, value in first_record.items():
        if value is None:
            col_type = "TEXT"
        elif isinstance(value, bool):
            col_type = "BOOLEAN"
        elif isinstance(value, int):
            col_type = "INTEGER"
        elif isinstance(value, float):
            col_type = "NUMERIC"
        elif isinstance(value, str):
            # 날짜 형식 확인
            try:
                datetime.fromisoformat(value.replace('Z', '+00:00'))
                col_type = "TIMESTAMP"
            except:
                col_type = "TEXT"
        else:
            col_type = "TEXT"
        
        columns.append(f"{col_name} {col_type}")
    
    # 테이블 생성 SQL
    create_sql = f"""
    CREATE TABLE IF NOT EXISTS {table_name} (
        {', '.join(columns)}
    );
    """
    
    try:
        with conn.cursor() as cursor:
            cursor.execute(create_sql)
            conn.commit()
            print(f"✅ {table_name} 테이블 스키마 생성 완료")
            return True
    except Exception as e:
        print(f"❌ {table_name} 테이블 스키마 생성 실패: {e}")
        return False

def insert_data(conn, table_name, data):
    """데이터 삽입"""
    if not data:
        return False
    
    try:
        with conn.cursor() as cursor:
            # 컬럼명 추출
            columns = list(data[0].keys())
            placeholders = ', '.join(['%s'] * len(columns))
            column_names = ', '.join(columns)
            
            # 데이터 삽입
            for record in data:
                values = [record.get(col) for col in columns]
                insert_sql = f"INSERT INTO {table_name} ({column_names}) VALUES ({placeholders})"
                cursor.execute(insert_sql, values)
            
            conn.commit()
            print(f"✅ {table_name} 테이블에 {len(data)}개 레코드 삽입 완료")
            return True
    except Exception as e:
        print(f"❌ {table_name} 테이블 데이터 삽입 실패: {e}")
        conn.rollback()
        return False

def main():
    print("🚀 Supabase에서 로컬 PostgreSQL로 데이터 마이그레이션 시작")
    print("=" * 60)
    
    # 로컬 PostgreSQL 연결
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        print("✅ 로컬 PostgreSQL 연결 성공")
    except Exception as e:
        print(f"❌ 로컬 PostgreSQL 연결 실패: {e}")
        return
    
    # 테이블 목록 가져오기 (수동으로 지정)
    tables = [
        'companies',
        'products', 
        'clients',
        'performance_records',
        'absorption_analysis'
    ]
    
    for table_name in tables:
        print(f"\n📋 {table_name} 테이블 처리 중...")
        
        # Supabase에서 데이터 가져오기
        data = get_supabase_data(table_name)
        if data is None:
            continue
        
        if len(data) == 0:
            print(f"⚠️ {table_name} 테이블에 데이터가 없습니다")
            continue
        
        # 테이블 스키마 생성
        if not create_table_schema(conn, table_name, data):
            continue
        
        # 데이터 삽입
        insert_data(conn, table_name, data)
    
    conn.close()
    print("\n🎉 데이터 마이그레이션 완료!")

if __name__ == "__main__":
    main() 