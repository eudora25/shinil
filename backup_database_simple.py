#!/usr/bin/env python3
"""
Supabase 데이터베이스 백업 스크립트 (간단 버전)
모든 테이블을 CSV 파일로 백업합니다.
"""

import os
import sys
import csv
import json
from datetime import datetime
from supabase import create_client, Client

# Supabase 설정
SUPABASE_URL = "https://selklngerzfmuvagcvvf.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlbGtsbmdlcnpmbXV2YWdjdnZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzQ5MDUsImV4cCI6MjA2ODMxMDkwNX0.cRe78UqA-HDdVClq0qrXlOXxwNpQWLB6ycFnoHzQI4U"

# 백업할 테이블 목록 (프로젝트에서 확인된 테이블들)
TABLES_TO_BACKUP = [
    'users',
    'companies', 
    'products',
    'clients',
    'pharmacies',
    'wholesale_sales',
    'direct_sales',
    'performance_records',
    'settlement_months',
    'absorption_analysis',
    'notices',
    'commission_grades',
    'review_records'
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

def backup_table_to_csv(supabase: Client, table_name: str, backup_dir: str) -> bool:
    """단일 테이블을 CSV로 백업"""
    try:
        print(f"📊 {table_name} 테이블 백업 중...")
        
        # 테이블 데이터 조회 (최대 10000개 행)
        response = supabase.table(table_name).select('*').limit(10000).execute()
        
        if not response.data:
            print(f"  ⚠️ {table_name} 테이블에 데이터가 없습니다.")
            # 빈 CSV 파일 생성
            csv_file_path = os.path.join(backup_dir, f"{table_name}.csv")
            with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow(['no_data'])
            return True
        
        # CSV 파일 경로
        csv_file_path = os.path.join(backup_dir, f"{table_name}.csv")
        
        # 데이터를 CSV로 저장
        with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
            if response.data:
                fieldnames = response.data[0].keys()
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerows(response.data)
        
        print(f"  ✅ {table_name} 백업 완료 ({len(response.data)}개 행)")
        return True
        
    except Exception as e:
        print(f"  ❌ {table_name} 백업 실패: {e}")
        return False

def create_backup_directory() -> str:
    """백업 디렉토리 생성"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = f"database_backup_{timestamp}"
    
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
        print(f"📁 백업 디렉토리 생성: {backup_dir}")
    
    return backup_dir

def create_backup_summary(backup_dir: str, tables: list, success_count: int, total_count: int):
    """백업 요약 정보 생성"""
    summary = {
        "backup_timestamp": datetime.now().isoformat(),
        "total_tables": total_count,
        "successful_backups": success_count,
        "failed_backups": total_count - success_count,
        "backup_directory": backup_dir,
        "tables": tables,
        "supabase_url": SUPABASE_URL
    }
    
    summary_file = os.path.join(backup_dir, "backup_summary.json")
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    print(f"📋 백업 요약 저장: {summary_file}")

def main():
    """메인 함수"""
    print("🚀 Supabase 데이터베이스 백업 시작")
    print("=" * 50)
    print(f"📍 Supabase URL: {SUPABASE_URL}")
    print(f"📦 백업할 테이블: {len(TABLES_TO_BACKUP)}개")
    
    # Supabase 클라이언트 생성
    supabase = create_supabase_client()
    
    # 백업 디렉토리 생성
    backup_dir = create_backup_directory()
    
    print(f"\n📦 테이블 백업 시작")
    print("=" * 50)
    
    # 각 테이블 백업
    success_count = 0
    for table in TABLES_TO_BACKUP:
        if backup_table_to_csv(supabase, table, backup_dir):
            success_count += 1
    
    # 백업 요약 생성
    create_backup_summary(backup_dir, TABLES_TO_BACKUP, success_count, len(TABLES_TO_BACKUP))
    
    print("\n" + "=" * 50)
    print(f"🎉 백업 완료!")
    print(f"📁 백업 위치: {backup_dir}")
    print(f"✅ 성공: {success_count}/{len(TABLES_TO_BACKUP)} 테이블")
    print(f"❌ 실패: {len(TABLES_TO_BACKUP) - success_count}/{len(TABLES_TO_BACKUP)} 테이블")
    
    if success_count == len(TABLES_TO_BACKUP):
        print("🎯 모든 테이블 백업 성공!")
    else:
        print("⚠️ 일부 테이블 백업에 실패했습니다.")

if __name__ == "__main__":
    main() 