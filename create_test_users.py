#!/usr/bin/env python3
"""
테스트용 사용자 데이터 생성 스크립트
"""

import psycopg2
from datetime import datetime

# 로컬 PostgreSQL 설정
LOCAL_DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'shinil_pms',
    'user': 'postgres',
    'password': 'postgres'
}

def create_profiles_table(conn):
    """profiles 테이블을 생성합니다."""
    try:
        cursor = conn.cursor()
        
        # 테이블이 이미 존재하는지 확인
        cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'profiles'
            );
        """)
        
        if cursor.fetchone()[0]:
            print("ℹ️ profiles 테이블이 이미 존재합니다")
            return True
        
        # profiles 테이블 생성
        create_sql = """
        CREATE TABLE profiles (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            email VARCHAR(255) UNIQUE NOT NULL,
            full_name VARCHAR(255),
            user_type VARCHAR(50) DEFAULT 'user',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """
        
        cursor.execute(create_sql)
        conn.commit()
        print("✅ profiles 테이블 생성 완료")
        return True
        
    except Exception as e:
        print(f"❌ profiles 테이블 생성 실패: {e}")
        conn.rollback()
        return False

def insert_test_users(conn):
    """테스트용 사용자 데이터를 삽입합니다."""
    try:
        cursor = conn.cursor()
        
        # 기존 데이터 삭제
        cursor.execute("DELETE FROM profiles")
        print("🗑️ 기존 사용자 데이터 삭제 완료")
        
        # 테스트 사용자 데이터
        test_users = [
            {
                'email': 'admin@shinil.com',
                'full_name': '관리자',
                'user_type': 'admin'
            },
            {
                'email': 'user@shinil.com',
                'full_name': '일반사용자',
                'user_type': 'user'
            },
            {
                'email': 'manager@shinil.com',
                'full_name': '매니저',
                'user_type': 'manager'
            }
        ]
        
        # 사용자 데이터 삽입
        for user in test_users:
            cursor.execute("""
                INSERT INTO profiles (email, full_name, user_type)
                VALUES (%s, %s, %s)
            """, (user['email'], user['full_name'], user['user_type']))
        
        conn.commit()
        print(f"✅ {len(test_users)}명의 테스트 사용자 생성 완료")
        
        # 생성된 사용자 목록 출력
        cursor.execute("SELECT email, full_name, user_type FROM profiles ORDER BY created_at")
        users = cursor.fetchall()
        
        print("\n📋 생성된 사용자 목록:")
        for email, full_name, user_type in users:
            print(f"   - {email} ({full_name}) - {user_type}")
        
        return True
        
    except Exception as e:
        print(f"❌ 테스트 사용자 생성 실패: {e}")
        conn.rollback()
        return False

def main():
    """메인 함수"""
    print("👥 테스트용 사용자 데이터 생성 시작")
    print("=" * 50)
    
    try:
        conn = psycopg2.connect(**LOCAL_DB_CONFIG)
        print("✅ PostgreSQL 연결 성공")
    except Exception as e:
        print(f"❌ PostgreSQL 연결 실패: {e}")
        return
    
    # profiles 테이블 생성
    if not create_profiles_table(conn):
        conn.close()
        return
    
    # 테스트 사용자 생성
    if not insert_test_users(conn):
        conn.close()
        return
    
    conn.close()
    
    print("\n" + "=" * 50)
    print("🎉 테스트 사용자 생성 완료!")
    print("=" * 50)
    print("\n🔑 로그인 정보:")
    print("   - 관리자: admin@shinil.com / admin123")
    print("   - 일반사용자: user@shinil.com / admin123")
    print("   - 매니저: manager@shinil.com / admin123")
    print("\n📝 참고: 모든 사용자의 비밀번호는 'admin123'입니다")
    print("\n🔗 다음 단계:")
    print("1. 보안 API 서버 시작")
    print("2. 로그인 API 테스트")
    print("3. 토큰 기반 데이터 접근 테스트")

if __name__ == "__main__":
    main() 