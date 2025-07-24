#!/usr/bin/env python3
"""
Supabase 백업 파일을 Docker PostgreSQL 데이터베이스에 복원하는 스크립트
"""

import os
import sys
import subprocess
import psycopg2
from datetime import datetime

# Docker PostgreSQL 설정
DOCKER_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'user': 'postgres',
    'password': 'postgres',  # Docker PostgreSQL 기본 비밀번호
    'database': 'postgres'  # 기본 데이터베이스
}

# 백업 파일 경로
BACKUP_FILE = 'db_cluster-22-07-2025@15-25-23.backup'

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

def check_backup_file():
    """백업 파일이 존재하는지 확인"""
    if os.path.exists(BACKUP_FILE):
        file_size = os.path.getsize(BACKUP_FILE)
        print(f"✅ 백업 파일 확인: {BACKUP_FILE} ({file_size:,} bytes)")
        return True
    else:
        print(f"❌ 백업 파일을 찾을 수 없습니다: {BACKUP_FILE}")
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

def restore_database_docker():
    """Docker PostgreSQL에 백업 파일 복원"""
    try:
        print(f"🔄 Docker PostgreSQL에 데이터베이스 복원 시작...")
        
        # Docker 컨테이너에 백업 파일 복사
        print("📁 백업 파일을 Docker 컨테이너에 복사 중...")
        copy_cmd = [
            'docker', 'cp', 
            BACKUP_FILE, 
            'shinil_project-postgres-1:/tmp/backup.sql'
        ]
        
        result = subprocess.run(copy_cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"❌ 백업 파일 복사 실패: {result.stderr}")
            return False
        
        print("✅ 백업 파일 복사 완료")
        
        # Docker 컨테이너에서 복원 실행
        print("🔄 데이터베이스 복원 실행 중...")
        restore_cmd = [
            'docker', 'exec', '-i', 'shinil_project-postgres-1',
            'psql', '-U', 'postgres', '-d', 'postgres', '-f', '/tmp/backup.sql'
        ]
        
        # 환경 변수 설정
        env = os.environ.copy()
        env['PGPASSWORD'] = 'postgres'
        
        print(f"실행 명령어: {' '.join(restore_cmd)}")
        
        # 복원 실행
        result = subprocess.run(restore_cmd, env=env, capture_output=True, text=True)
        
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
        conn = psycopg2.connect(**DOCKER_DB_CONFIG)
        cursor = conn.cursor()
        
        # 스키마 목록 조회
        cursor.execute("""
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
            ORDER BY schema_name
        """)
        
        schemas = cursor.fetchall()
        
        print(f"\n📋 복원된 스키마 목록 ({len(schemas)}개):")
        for schema in schemas:
            print(f"  - {schema[0]}")
            
            # 각 스키마의 테이블 목록 조회
            cursor.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = %s 
                AND table_type = 'BASE TABLE'
                ORDER BY table_name
            """, (schema[0],))
            
            tables = cursor.fetchall()
            for table in tables:
                try:
                    cursor.execute(f"SELECT COUNT(*) FROM {schema[0]}.{table[0]}")
                    count = cursor.fetchone()[0]
                    print(f"    - {table[0]}: {count:,}개 행")
                except:
                    print(f"    - {table[0]}: 확인 불가")
        
        cursor.close()
        conn.close()
        
        return True
        
    except Exception as e:
        print(f"❌ 복원 확인 실패: {e}")
        return False

def cleanup_backup_file():
    """Docker 컨테이너에서 백업 파일 정리"""
    try:
        cleanup_cmd = [
            'docker', 'exec', 'shinil_project-postgres-1',
            'rm', '-f', '/tmp/backup.sql'
        ]
        
        subprocess.run(cleanup_cmd, capture_output=True)
        print("🧹 백업 파일 정리 완료")
        
    except Exception as e:
        print(f"⚠️ 백업 파일 정리 실패: {e}")

def main():
    """메인 함수"""
    print("🚀 Supabase 백업 파일을 Docker PostgreSQL에 복원 시작")
    print("=" * 60)
    
    # Docker PostgreSQL 컨테이너 확인
    if not check_docker_postgres():
        print("Docker PostgreSQL 컨테이너를 먼저 시작해주세요.")
        print("docker-compose up -d postgres")
        return
    
    # 백업 파일 확인
    if not check_backup_file():
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
    
    # 데이터베이스 복원
    if not restore_database_docker():
        return
    
    # 복원 결과 확인
    verify_restoration()
    
    # 백업 파일 정리
    cleanup_backup_file()
    
    print("\n" + "=" * 60)
    print("🎉 Docker PostgreSQL 복원 완료!")
    print(f"📁 복원된 데이터베이스: {DOCKER_DB_CONFIG['database']}")
    print(f"🔗 연결 정보: postgresql://{DOCKER_DB_CONFIG['user']}@{DOCKER_DB_CONFIG['host']}:{DOCKER_DB_CONFIG['port']}/{DOCKER_DB_CONFIG['database']}")
    print(f"🐳 Docker 컨테이너: shinil_project-postgres-1")

if __name__ == "__main__":
    main() 