#!/usr/bin/env python3
"""
Docker PostgreSQL 데이터를 CSV 파일로 백업하는 스크립트
"""

import os
import sys
import csv
import json
import subprocess
from datetime import datetime
import psycopg2

# Docker PostgreSQL 설정
DOCKER_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',
    'database': 'postgres'
}

# 백업할 테이블 목록 (public 스키마의 주요 테이블들)
TABLES_TO_BACKUP = [
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

def check_docker_postgres():
    """Docker PostgreSQL 컨테이너 상태 확인"""
    try:
        result = subprocess.run(['docker', 'ps', '--filter', 'name=shinil_project-postgres-1', '--format', '{{.Status}}'], 
                              capture_output=True, text=True)
        
        if result.returncode == 0 and result.stdout.strip():
            print(f"✅ Docker PostgreSQL 컨테이너 실행 중: {result.stdout.strip()}")
            return True
        else:
            print("❌ Docker PostgreSQL 컨테이너가 실행되지 않았습니다.")
            return False
    except Exception as e:
        print(f"❌ Docker 확인 실패: {e}")
        return False

def test_database_connection():
    """데이터베이스 연결 테스트"""
    try:
        conn = psycopg2.connect(**DOCKER_DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        print(f"✅ 데이터베이스 연결 성공: {version.split(',')[0]}")
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"❌ 데이터베이스 연결 실패: {e}")
        return False

def get_existing_tables():
    """실제 존재하는 테이블 목록 가져오기"""
    try:
        conn = psycopg2.connect(**DOCKER_DB_CONFIG)
        cursor = conn.cursor()
        
        existing_tables = []
        for table in TABLES_TO_BACKUP:
            cursor.execute("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = %s
                )
            """, (table,))
            
            if cursor.fetchone()[0]:
                existing_tables.append(table)
                print(f"  ✅ {table}")
            else:
                print(f"  ❌ {table} (존재하지 않음)")
        
        cursor.close()
        conn.close()
        
        return existing_tables
        
    except Exception as e:
        print(f"❌ 테이블 확인 실패: {e}")
        return []

def backup_table_to_csv(table_name: str, backup_dir: str):
    """단일 테이블을 CSV로 백업"""
    try:
        print(f"📊 {table_name} 테이블 백업 중...")
        
        # Docker 컨테이너에서 CSV 내보내기
        csv_file_path = os.path.join(backup_dir, f"{table_name}.csv")
        
        # psql COPY 명령어로 CSV 내보내기
        copy_cmd = [
            'docker', 'exec', '-i', 'shinil_project-postgres-1',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', f"COPY public.{table_name} TO STDOUT WITH CSV HEADER"
        ]
        
        # 환경 변수 설정
        env = os.environ.copy()
        env['PGPASSWORD'] = 'postgres'
        
        # CSV 파일로 출력
        with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
            result = subprocess.run(copy_cmd, env=env, stdout=csvfile, stderr=subprocess.PIPE, text=True)
        
        if result.returncode == 0:
            # 파일 크기 확인
            file_size = os.path.getsize(csv_file_path)
            print(f"  ✅ {table_name} 백업 완료 ({file_size:,} bytes)")
            return True
        else:
            print(f"  ❌ {table_name} 백업 실패: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"  ❌ {table_name} 백업 실패: {e}")
        return False

def create_backup_directory():
    """백업 디렉토리 생성"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = f"docker_backup_{timestamp}"
    
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
        "source": "Docker PostgreSQL",
        "connection_info": DOCKER_DB_CONFIG
    }
    
    summary_file = os.path.join(backup_dir, "backup_summary.json")
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    print(f"📋 백업 요약 저장: {summary_file}")

def main():
    """메인 함수"""
    print("🚀 Docker PostgreSQL 데이터를 CSV로 백업 시작")
    print("=" * 60)
    
    # Docker PostgreSQL 컨테이너 확인
    if not check_docker_postgres():
        print("Docker PostgreSQL 컨테이너를 먼저 시작해주세요.")
        return
    
    # 데이터베이스 연결 테스트
    if not test_database_connection():
        print("Docker PostgreSQL 연결에 실패했습니다.")
        return
    
    print(f"\n📊 Docker PostgreSQL 설정:")
    print(f"  호스트: {DOCKER_DB_CONFIG['host']}")
    print(f"  포트: {DOCKER_DB_CONFIG['port']}")
    print(f"  사용자: {DOCKER_DB_CONFIG['user']}")
    print(f"  데이터베이스: {DOCKER_DB_CONFIG['database']}")
    
    # 실제 존재하는 테이블 목록 가져오기
    print(f"\n🔍 테이블 존재 여부 확인 중...")
    existing_tables = get_existing_tables()
    
    if not existing_tables:
        print("❌ 백업할 테이블이 없습니다.")
        return
    
    print(f"\n📦 백업할 테이블: {len(existing_tables)}개")
    
    # 백업 디렉토리 생성
    backup_dir = create_backup_directory()
    
    print(f"\n📦 테이블 백업 시작")
    print("=" * 60)
    
    # 각 테이블 백업
    success_count = 0
    for table in existing_tables:
        if backup_table_to_csv(table, backup_dir):
            success_count += 1
    
    # 백업 요약 생성
    create_backup_summary(backup_dir, existing_tables, success_count, len(existing_tables))
    
    print("\n" + "=" * 60)
    print("🎉 Docker PostgreSQL CSV 백업 완료!")
    print(f"📁 백업 위치: {backup_dir}")
    print(f"✅ 성공: {success_count}/{len(existing_tables)} 테이블")
    print(f"❌ 실패: {len(existing_tables) - success_count}/{len(existing_tables)} 테이블")
    
    if success_count == len(existing_tables):
        print("🎯 모든 테이블 백업 성공!")
    else:
        print("⚠️ 일부 테이블 백업에 실패했습니다.")

if __name__ == "__main__":
    main() 