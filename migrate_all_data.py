#!/usr/bin/env python3
"""
신일제약 실적관리프로그램 - 전체 데이터 마이그레이션 스크립트
원격 Supabase에서 로컬 PostgreSQL로 모든 데이터를 이전합니다.
"""

import psycopg2
import requests
import json
import os
from datetime import datetime
import time

# 원격 Supabase 설정
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

# 마이그레이션할 테이블 목록 (우선순위 순서)
TABLES = [
    # 기본 마스터 데이터
    'companies',
    'products', 
    'clients',
    'pharmacies',
    'settlement_months',
    
    # 거래 데이터
    'wholesale_sales',
    'direct_sales',
    
    # 실적 데이터
    'performance_records',
    'absorption_analysis',
    
    # 시스템 데이터
    'notices',
    'users',
    'profiles'
]

def get_supabase_data(table_name, limit=None):
    """Supabase에서 테이블 데이터를 가져옵니다."""
    url = f"{SUPABASE_URL}/rest/v1/{table_name}"
    headers = {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'Content-Type': 'application/json'
    }
    
    params = {}
    if limit:
        params['limit'] = limit
    
    try:
        print(f"📡 {table_name} 테이블 데이터 가져오는 중...")
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()
        print(f"✅ {table_name}: {len(data)}개 레코드 가져옴")
        return data
    except requests.exceptions.RequestException as e:
        print(f"❌ {table_name} 테이블 데이터 가져오기 실패: {e}")
        return None

def create_table_schema(conn, table_name, data):
    """테이블 스키마를 생성합니다."""
    if not data or len(data) == 0:
        print(f"⚠️ {table_name} 테이블에 데이터가 없어 스키마 생성 건너뜀")
        return False
    
    try:
        cursor = conn.cursor()
        
        # 첫 번째 레코드에서 컬럼 정보 추출
        first_record = data[0]
        columns = []
        column_definitions = []
        
        for column_name, value in first_record.items():
            columns.append(column_name)
            
            # 데이터 타입 추정
            if value is None:
                column_definitions.append(f"{column_name} TEXT")
            elif isinstance(value, bool):
                column_definitions.append(f"{column_name} BOOLEAN")
            elif isinstance(value, int):
                column_definitions.append(f"{column_name} INTEGER")
            elif isinstance(value, float):
                column_definitions.append(f"{column_name} NUMERIC")
            elif isinstance(value, str):
                # 날짜/시간 형식 확인
                if 'T' in value and ('Z' in value or '+' in value):
                    column_definitions.append(f"{column_name} TIMESTAMP")
                else:
                    column_definitions.append(f"{column_name} TEXT")
            else:
                column_definitions.append(f"{column_name} TEXT")
        
        # 테이블이 이미 존재하는지 확인
        cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = %s
            );
        """, (table_name,))
        
        if cursor.fetchone()[0]:
            print(f"ℹ️ {table_name} 테이블이 이미 존재합니다")
            return True
        
        # 테이블 생성
        create_sql = f"""
        CREATE TABLE {table_name} (
            {', '.join(column_definitions)}
        );
        """
        
        cursor.execute(create_sql)
        conn.commit()
        print(f"✅ {table_name} 테이블 생성 완료")
        return True
        
    except Exception as e:
        print(f"❌ {table_name} 테이블 생성 실패: {e}")
        conn.rollback()
        return False

def insert_data(conn, table_name, data):
    """데이터를 테이블에 삽입합니다."""
    if not data or len(data) == 0:
        print(f"⚠️ {table_name} 테이블에 삽입할 데이터가 없습니다")
        return False
    
    try:
        cursor = conn.cursor()
        
        # 기존 데이터 삭제 (전체 마이그레이션)
        cursor.execute(f"DELETE FROM {table_name}")
        print(f"🗑️ {table_name} 기존 데이터 삭제 완료")
        
        # 컬럼명 추출
        columns = list(data[0].keys())
        placeholders = ', '.join(['%s'] * len(columns))
        column_names = ', '.join(columns)
        
        # 배치 삽입
        batch_size = 1000
        total_inserted = 0
        
        for i in range(0, len(data), batch_size):
            batch = data[i:i + batch_size]
            values_list = []
            
            for record in batch:
                values = []
                for column in columns:
                    value = record.get(column)
                    # None 값을 NULL로 처리
                    if value is None:
                        values.append(None)
                    else:
                        values.append(value)
                values_list.append(tuple(values))
            
            insert_sql = f"""
            INSERT INTO {table_name} ({column_names})
            VALUES ({placeholders})
            """
            
            cursor.executemany(insert_sql, values_list)
            total_inserted += len(batch)
            
            if len(data) > batch_size:
                print(f"📊 {table_name}: {total_inserted}/{len(data)} 레코드 삽입 완료")
        
        conn.commit()
        print(f"✅ {table_name}: 총 {total_inserted}개 레코드 삽입 완료")
        return True
        
    except Exception as e:
        print(f"❌ {table_name} 데이터 삽입 실패: {e}")
        conn.rollback()
        return False

def get_table_info(conn, table_name):
    """테이블 정보를 조회합니다."""
    try:
        cursor = conn.cursor()
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        count = cursor.fetchone()[0]
        
        cursor.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '{table_name}' ORDER BY ordinal_position")
        columns = cursor.fetchall()
        
        return {
            'count': count,
            'columns': [{'name': col[0], 'type': col[1]} for col in columns]
        }
    except Exception as e:
        print(f"❌ {table_name} 테이블 정보 조회 실패: {e}")
        return None

def main():
    """메인 마이그레이션 함수"""
    print("🚀 신일제약 실적관리프로그램 - 전체 데이터 마이그레이션 시작")
    print("=" * 60)
    print(f"📅 시작 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"🌐 원격 Supabase: {SUPABASE_URL}")
    print(f"🗄️ 로컬 PostgreSQL: {LOCAL_DB_CONFIG['host']}:{LOCAL_DB_CONFIG['port']}/{LOCAL_DB_CONFIG['database']}")
    print("=" * 60)
    
    # 로컬 PostgreSQL 연결
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        print("✅ 로컬 PostgreSQL 연결 성공")
    except Exception as e:
        print(f"❌ 로컬 PostgreSQL 연결 실패: {e}")
        return
    
    # 마이그레이션 통계
    migration_stats = {
        'total_tables': len(TABLES),
        'successful_tables': 0,
        'failed_tables': 0,
        'total_records': 0,
        'start_time': datetime.now()
    }
    
    # 각 테이블 처리
    for i, table_name in enumerate(TABLES, 1):
        print(f"\n📋 [{i}/{len(TABLES)}] {table_name} 테이블 처리 중...")
        print("-" * 40)
        
        # 데이터 가져오기
        data = get_supabase_data(table_name)
        if data is None:
            print(f"⚠️ {table_name} 테이블 건너뜀")
            migration_stats['failed_tables'] += 1
            continue
        
        if len(data) == 0:
            print(f"⚠️ {table_name} 테이블에 데이터가 없습니다")
            migration_stats['successful_tables'] += 1
            continue
        
        # 테이블 스키마 생성
        if not create_table_schema(conn, table_name, data):
            print(f"❌ {table_name} 테이블 스키마 생성 실패")
            migration_stats['failed_tables'] += 1
            continue
        
        # 데이터 삽입
        if insert_data(conn, table_name, data):
            migration_stats['successful_tables'] += 1
            migration_stats['total_records'] += len(data)
            
            # 테이블 정보 출력
            table_info = get_table_info(conn, table_name)
            if table_info:
                print(f"📊 {table_name} 테이블 정보:")
                print(f"   - 레코드 수: {table_info['count']:,}개")
                print(f"   - 컬럼 수: {len(table_info['columns'])}개")
        else:
            migration_stats['failed_tables'] += 1
        
        # 진행률 표시
        progress = (i / len(TABLES)) * 100
        print(f"📈 진행률: {progress:.1f}% ({i}/{len(TABLES)})")
        
        # 잠시 대기 (API 호출 제한 방지)
        if i < len(TABLES):
            time.sleep(1)
    
    # 마이그레이션 완료
    conn.close()
    end_time = datetime.now()
    duration = end_time - migration_stats['start_time']
    
    print("\n" + "=" * 60)
    print("🎉 마이그레이션 완료!")
    print("=" * 60)
    print(f"📅 완료 시간: {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"⏱️ 소요 시간: {duration}")
    print(f"📊 전체 테이블: {migration_stats['total_tables']}개")
    print(f"✅ 성공: {migration_stats['successful_tables']}개")
    print(f"❌ 실패: {migration_stats['failed_tables']}개")
    print(f"📝 총 레코드: {migration_stats['total_records']:,}개")
    print("=" * 60)
    
    # 최종 테이블 목록 출력
    print("\n📋 마이그레이션된 테이블 목록:")
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT table_name, 
                   (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
            FROM information_schema.tables t
            WHERE table_schema = 'public'
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        """)
        
        tables = cursor.fetchall()
        for table_name, column_count in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            record_count = cursor.fetchone()[0]
            print(f"   - {table_name}: {record_count:,}개 레코드, {column_count}개 컬럼")
        
        conn.close()
    except Exception as e:
        print(f"❌ 테이블 목록 조회 실패: {e}")
    
    print("\n🔗 다음 단계:")
    print("1. pgAdmin에서 데이터 확인: http://localhost:5050")
    print("2. API 테스트: http://localhost:3000/test")
    print("3. 데이터베이스 연결 확인: http://localhost:3001/api/test")

if __name__ == "__main__":
    main() 