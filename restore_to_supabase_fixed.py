#!/usr/bin/env python3
"""
로컬 Docker PostgreSQL 데이터를 Supabase에 복원하는 스크립트 (수정 버전)
"""

import os
import sys
import csv
import json
import subprocess
from datetime import datetime
from decimal import Decimal
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

# 복원할 테이블 목록
TABLES_TO_RESTORE = [
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

def create_supabase_client() -> Client:
    """Supabase 클라이언트 생성"""
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
        print("✅ Supabase 클라이언트 생성 성공")
        return supabase
    except Exception as e:
        print(f"❌ Supabase 클라이언트 생성 실패: {e}")
        sys.exit(1)

def check_local_database():
    """로컬 데이터베이스 연결 확인"""
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        print(f"✅ 로컬 데이터베이스 연결 성공: {version.split(',')[0]}")
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"❌ 로컬 데이터베이스 연결 실패: {e}")
        return False

def get_local_table_data(table_name: str):
    """로컬 테이블에서 데이터 가져오기"""
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        
        # 테이블 데이터 조회
        cursor.execute(f"SELECT * FROM public.{table_name}")
        rows = cursor.fetchall()
        
        # 컬럼명 가져오기
        cursor.execute(f"""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name = '{table_name}' 
            AND table_schema = 'public' 
            ORDER BY ordinal_position
        """, (table_name,))
        columns = [col[0] for col in cursor.fetchall()]
        
        cursor.close()
        conn.close()
        
        # 딕셔너리 리스트로 변환 (데이터 타입 처리 포함)
        data = []
        for row in rows:
            row_dict = {}
            for i, value in enumerate(row):
                if isinstance(value, Decimal):
                    # Decimal을 float로 변환
                    row_dict[columns[i]] = float(value)
                elif isinstance(value, datetime):
                    # datetime을 ISO 문자열로 변환
                    row_dict[columns[i]] = value.isoformat()
                else:
                    row_dict[columns[i]] = value
            data.append(row_dict)
        
        return data
        
    except Exception as e:
        print(f"❌ {table_name} 테이블 데이터 조회 실패: {e}")
        return []

def clear_supabase_table(supabase: Client, table_name: str):
    """Supabase 테이블 데이터 삭제 (개선된 버전)"""
    try:
        print(f"🗑️ {table_name} 테이블 데이터 삭제 중...")
        
        # 테이블의 모든 데이터 삭제 (더 안전한 방법)
        response = supabase.table(table_name).delete().gte('id', 0).execute()
        
        print(f"  ✅ {table_name} 테이블 데이터 삭제 완료")
        return True
        
    except Exception as e:
        print(f"  ❌ {table_name} 테이블 데이터 삭제 실패: {e}")
        # 삭제 실패해도 계속 진행
        return True

def restore_table_to_supabase(supabase: Client, table_name: str, data: list):
    """테이블 데이터를 Supabase에 복원 (개선된 버전)"""
    try:
        print(f"📊 {table_name} 테이블 복원 중...")
        
        if not data:
            print(f"  ⚠️ {table_name} 테이블에 데이터가 없습니다.")
            return True
        
        # 데이터를 배치로 나누어 삽입 (Supabase 제한 고려)
        batch_size = 50  # 배치 크기를 줄임
        total_rows = len(data)
        
        for i in range(0, total_rows, batch_size):
            batch = data[i:i + batch_size]
            
            # 데이터 전처리
            processed_batch = []
            for row in batch:
                processed_row = {}
                for key, value in row.items():
                    if value is None:
                        processed_row[key] = None
                    elif isinstance(value, str) and key == 'id' and len(value) == 36:
                        # UUID 형식인 경우 그대로 유지
                        processed_row[key] = value
                    elif isinstance(value, (int, float, str, bool)):
                        processed_row[key] = value
                    else:
                        # 기타 타입은 문자열로 변환
                        processed_row[key] = str(value) if value is not None else None
                processed_batch.append(processed_row)
            
            # Supabase에 데이터 삽입
            response = supabase.table(table_name).insert(processed_batch).execute()
            
            print(f"  📦 배치 {i//batch_size + 1}/{(total_rows + batch_size - 1)//batch_size} 완료 ({len(batch)}개 행)")
        
        print(f"  ✅ {table_name} 복원 완료 ({total_rows}개 행)")
        return True
        
    except Exception as e:
        print(f"  ❌ {table_name} 복원 실패: {e}")
        return False

def verify_restoration(supabase: Client, table_name: str, expected_count: int):
    """복원 결과 확인"""
    try:
        response = supabase.table(table_name).select('*', count='exact').execute()
        actual_count = response.count if hasattr(response, 'count') else len(response.data)
        
        if actual_count == expected_count:
            print(f"  ✅ {table_name} 검증 성공: {actual_count}개 행")
            return True
        else:
            print(f"  ⚠️ {table_name} 검증 실패: 예상 {expected_count}개, 실제 {actual_count}개")
            return False
            
    except Exception as e:
        print(f"  ❌ {table_name} 검증 실패: {e}")
        return False

def create_restore_summary(restore_dir: str, tables: list, success_count: int, total_count: int):
    """복원 요약 정보 생성"""
    summary = {
        "restore_timestamp": datetime.now().isoformat(),
        "total_tables": total_count,
        "successful_restores": success_count,
        "failed_restores": total_count - success_count,
        "restore_directory": restore_dir,
        "tables": tables,
        "source": "Local Docker PostgreSQL",
        "target": "Supabase",
        "supabase_url": SUPABASE_URL
    }
    
    summary_file = os.path.join(restore_dir, "restore_summary.json")
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    print(f"📋 복원 요약 저장: {summary_file}")

def main():
    """메인 함수"""
    print("🚀 로컬 Docker PostgreSQL 데이터를 Supabase에 복원 시작 (수정 버전)")
    print("=" * 70)
    
    # Supabase 클라이언트 생성
    supabase = create_supabase_client()
    
    # 로컬 데이터베이스 연결 확인
    if not check_local_database():
        print("로컬 Docker PostgreSQL 연결에 실패했습니다.")
        return
    
    print(f"\n📊 복원 설정:")
    print(f"  소스: 로컬 Docker PostgreSQL")
    print(f"  대상: Supabase ({SUPABASE_URL})")
    print(f"  복원할 테이블: {len(TABLES_TO_RESTORE)}개")
    
    # 복원 디렉토리 생성
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    restore_dir = f"supabase_restore_{timestamp}"
    os.makedirs(restore_dir, exist_ok=True)
    print(f"📁 복원 디렉토리 생성: {restore_dir}")
    
    print(f"\n📦 테이블 복원 시작")
    print("=" * 70)
    
    # 각 테이블 복원
    success_count = 0
    total_rows = 0
    
    for table in TABLES_TO_RESTORE:
        print(f"\n🔄 {table} 테이블 처리 중...")
        
        # 로컬에서 데이터 가져오기
        local_data = get_local_table_data(table)
        
        if not local_data:
            print(f"  ⚠️ {table} 테이블에 데이터가 없습니다.")
            continue
        
        # Supabase 테이블 데이터 삭제
        if not clear_supabase_table(supabase, table):
            continue
        
        # Supabase에 데이터 복원
        if restore_table_to_supabase(supabase, table, local_data):
            # 복원 결과 확인
            if verify_restoration(supabase, table, len(local_data)):
                success_count += 1
                total_rows += len(local_data)
        
        print(f"  📊 {table}: {len(local_data)}개 행 처리 완료")
    
    # 복원 요약 생성
    create_restore_summary(restore_dir, TABLES_TO_RESTORE, success_count, len(TABLES_TO_RESTORE))
    
    print("\n" + "=" * 70)
    print("🎉 Supabase 복원 완료!")
    print(f"📁 복원 로그: {restore_dir}")
    print(f"✅ 성공: {success_count}/{len(TABLES_TO_RESTORE)} 테이블")
    print(f"❌ 실패: {len(TABLES_TO_RESTORE) - success_count}/{len(TABLES_TO_RESTORE)} 테이블")
    print(f"📊 총 복원된 행: {total_rows:,}개")
    
    if success_count == len(TABLES_TO_RESTORE):
        print("🎯 모든 테이블 복원 성공!")
    else:
        print("⚠️ 일부 테이블 복원에 실패했습니다.")

if __name__ == "__main__":
    main() 