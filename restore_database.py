#!/usr/bin/env python3
"""
Supabase 백업 파일을 로컬 PostgreSQL 데이터베이스에 복원하는 스크립트
"""

import os
import sys
import subprocess
import psycopg2
from datetime import datetime

# 로컬 PostgreSQL 설정
LOCAL_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',  # 실제 비밀번호로 변경하세요
    'database': 'shinil_project'
}

# 백업 파일 경로
BACKUP_FILE = 'db_cluster-22-07-2025@15-25-23.backup'

def check_postgresql_installed():
    """PostgreSQL이 설치되어 있는지 확인"""
    try:
        result = subprocess.run(['psql', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ PostgreSQL 설치 확인: {result.stdout.strip()}")
            return True
        else:
            print("❌ PostgreSQL이 설치되어 있지 않습니다.")
            return False
    except FileNotFoundError:
        print("❌ PostgreSQL이 설치되어 있지 않습니다.")
        return False

def check_backup_file():
    """백업 파일이 존재하는지 확인"""
    if os.path.exists(BACKUP_FILE):
        file_size = os.path.getsize(BACKUP_FILE)
        print(f"✅ 백업 파일 확인: {BACKUP_FILE} ({file_size:,} bytes)")
        return True
    else:
        print(f"❌ 백업 파일을 찾을 수 없습니다: {BACKUP_FILE}")
        return False

def create_database():
    """데이터베이스 생성"""
    try:
        # postgres 데이터베이스에 연결
        conn = psycopg2.connect(
            host=LOCAL_DB_CONFIG['host'],
            port=LOCAL_DB_CONFIG['port'],
            user=LOCAL_DB_CONFIG['user'],
            password=LOCAL_DB_CONFIG['password'],
            database='postgres'
        )
        conn.autocommit = True
        cursor = conn.cursor()
        
        # 데이터베이스가 존재하는지 확인
        cursor.execute("SELECT 1 FROM pg_database WHERE datname = %s", (LOCAL_DB_CONFIG['database'],))
        exists = cursor.fetchone()
        
        if exists:
            print(f"⚠️ 데이터베이스 '{LOCAL_DB_CONFIG['database']}'가 이미 존재합니다.")
            response = input("기존 데이터베이스를 삭제하고 새로 생성하시겠습니까? (y/N): ")
            if response.lower() == 'y':
                cursor.execute(f"DROP DATABASE {LOCAL_DB_CONFIG['database']}")
                print(f"🗑️ 기존 데이터베이스 삭제 완료")
            else:
                print("❌ 복원을 중단합니다.")
                return False
        
        # 새 데이터베이스 생성
        cursor.execute(f"CREATE DATABASE {LOCAL_DB_CONFIG['database']}")
        print(f"✅ 데이터베이스 '{LOCAL_DB_CONFIG['database']}' 생성 완료")
        
        cursor.close()
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ 데이터베이스 생성 실패: {e}")
        return False

def restore_database():
    """백업 파일을 데이터베이스에 복원"""
    try:
        print(f"🔄 데이터베이스 복원 시작...")
        
        # pg_restore 명령어 실행
        cmd = [
            'pg_restore',
            '--host', LOCAL_DB_CONFIG['host'],
            '--port', str(LOCAL_DB_CONFIG['port']),
            '--username', LOCAL_DB_CONFIG['user'],
            '--dbname', LOCAL_DB_CONFIG['database'],
            '--verbose',
            '--clean',
            '--if-exists',
            BACKUP_FILE
        ]
        
        # 환경 변수 설정
        env = os.environ.copy()
        env['PGPASSWORD'] = LOCAL_DB_CONFIG['password']
        
        print(f"실행 명령어: {' '.join(cmd)}")
        
        # 복원 실행
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ 데이터베이스 복원 완료!")
            if result.stdout:
                print("출력:", result.stdout)
            return True
        else:
            print(f"❌ 데이터베이스 복원 실패:")
            print("오류:", result.stderr)
            return False
            
    except Exception as e:
        print(f"❌ 복원 중 오류 발생: {e}")
        return False

def verify_restoration():
    """복원 결과 확인"""
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        cursor = conn.cursor()
        
        # 테이블 목록 조회
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name
        """)
        
        tables = cursor.fetchall()
        
        print(f"\n📋 복원된 테이블 목록 ({len(tables)}개):")
        for table in tables:
            # 각 테이블의 행 수 확인
            try:
                cursor.execute(f"SELECT COUNT(*) FROM {table[0]}")
                count = cursor.fetchone()[0]
                print(f"  - {table[0]}: {count:,}개 행")
            except:
                print(f"  - {table[0]}: 확인 불가")
        
        cursor.close()
        conn.close()
        
        return True
        
    except Exception as e:
        print(f"❌ 복원 확인 실패: {e}")
        return False

def main():
    """메인 함수"""
    print("🚀 Supabase 백업 파일 복원 시작")
    print("=" * 50)
    
    # PostgreSQL 설치 확인
    if not check_postgresql_installed():
        print("PostgreSQL을 먼저 설치해주세요.")
        print("macOS: brew install postgresql")
        print("Ubuntu: sudo apt-get install postgresql postgresql-contrib")
        return
    
    # 백업 파일 확인
    if not check_backup_file():
        return
    
    print(f"\n📊 로컬 데이터베이스 설정:")
    print(f"  호스트: {LOCAL_DB_CONFIG['host']}")
    print(f"  포트: {LOCAL_DB_CONFIG['port']}")
    print(f"  사용자: {LOCAL_DB_CONFIG['user']}")
    print(f"  데이터베이스: {LOCAL_DB_CONFIG['database']}")
    
    # 데이터베이스 생성
    if not create_database():
        return
    
    # 데이터베이스 복원
    if not restore_database():
        return
    
    # 복원 결과 확인
    verify_restoration()
    
    print("\n" + "=" * 50)
    print("🎉 데이터베이스 복원 완료!")
    print(f"📁 복원된 데이터베이스: {LOCAL_DB_CONFIG['database']}")
    print(f"🔗 연결 정보: postgresql://{LOCAL_DB_CONFIG['user']}@{LOCAL_DB_CONFIG['host']}:{LOCAL_DB_CONFIG['port']}/{LOCAL_DB_CONFIG['database']}")

if __name__ == "__main__":
    main() 