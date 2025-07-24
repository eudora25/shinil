# 로컬 Docker PostgreSQL → 새로운 Supabase 복원 가이드

## 📋 개요
로컬 Docker PostgreSQL에 있는 데이터를 새로운 Supabase 프로젝트로 복원하는 과정을 설명합니다.

## 🔧 준비사항
- 로컬 Docker PostgreSQL 실행 중
- 새로운 Supabase 프로젝트 생성 완료
- Python 3.x 및 필요한 패키지 설치

## 📊 Supabase 프로젝트 정보
- **URL**: https://mctzuqctekhhdfwimxek.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jdHp1cWN0ZWtoaGRmd2lteGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzUyNTUsImV4cCI6MjA2ODkxMTI1NX0.zLH2UFBUG7Zn1ow80Fg69Se8OLN7oRPRrmzFvu9_7gY

## 🚀 복원 과정

### 1단계: 스키마 SQL 파일 생성
```bash
python3 generate_schema_sql.py
```

**결과**: `supabase_schema_20250724_163043.sql` 파일 생성
- 9개 테이블 스키마 분석 완료
- Supabase SQL Editor용 SQL 파일 생성

### 2단계: Supabase에 테이블 생성
1. **Supabase Dashboard 접속**
   - https://supabase.com/dashboard
   - 프로젝트 선택: mctzuqctekhhdfwimxek

2. **SQL Editor 이동**
   - 좌측 메뉴에서 "SQL Editor" 클릭

3. **SQL 실행**
   - `supabase_schema_20250724_163043.sql` 파일의 내용을 복사
   - SQL Editor에 붙여넣기 후 "Run" 클릭

**생성될 테이블**:
- `companies` (24개 컬럼)
- `products` (15개 컬럼)
- `clients` (10개 컬럼)
- `pharmacies` (9개 컬럼)
- `wholesale_sales` (13개 컬럼)
- `direct_sales` (13개 컬럼)
- `performance_records` (16개 컬럼)
- `settlement_months` (8개 컬럼)
- `notices` (10개 컬럼)

### 3단계: 데이터 복원
```bash
python3 restore_to_supabase.py
```

**기능**:
- 로컬 Docker PostgreSQL에서 데이터 추출
- Supabase 테이블 데이터 삭제 후 새로 삽입
- 배치 처리로 대용량 데이터 처리
- 복원 결과 검증

## 📁 생성된 파일들

### 1. `generate_schema_sql.py`
- 로컬 데이터베이스 스키마 분석
- Supabase용 CREATE TABLE SQL 생성

### 2. `restore_to_supabase.py`
- 로컬 → Supabase 데이터 복원
- 배치 처리 및 검증 기능

### 3. `supabase_schema_20250724_163043.sql`
- Supabase SQL Editor에서 실행할 SQL 파일
- 9개 테이블 생성 스크립트

## 🔍 데이터 검증

### 복원 전 확인사항
```bash
python3 check_restored_data_fixed.py
```

### 복원 후 확인사항
- Supabase Dashboard > Table Editor에서 각 테이블 데이터 확인
- 행 수 및 샘플 데이터 검증

## ⚠️ 주의사항

1. **데이터 백업**
   - 복원 전 기존 Supabase 데이터가 있다면 백업 필요
   - `restore_to_supabase.py`는 기존 데이터를 삭제하고 새로 삽입

2. **권한 설정**
   - Supabase RLS(Row Level Security) 설정 확인
   - 필요한 경우 테이블별 권한 설정

3. **외래키 제약조건**
   - 복원 순서: companies → products → clients → pharmacies → sales → performance_records
   - 외래키 제약조건이 있는 경우 순서 고려

## 🛠️ 문제 해결

### 일반적인 오류들

1. **연결 실패**
   ```
   ❌ Supabase 클라이언트 생성 실패
   ```
   - URL과 Anon Key 확인
   - 네트워크 연결 상태 확인

2. **테이블 생성 실패**
   ```
   ❌ 테이블 생성 실패
   ```
   - SQL Editor에서 SQL 문법 확인
   - 테이블명 충돌 확인

3. **데이터 삽입 실패**
   ```
   ❌ 복원 실패
   ```
   - 데이터 타입 불일치 확인
   - NULL 제약조건 확인

## 📞 지원

문제가 발생하면 다음 정보를 확인해주세요:
- 오류 메시지 전체
- 실행한 명령어
- 로컬 데이터베이스 상태
- Supabase 프로젝트 설정

## 🎯 완료 확인

복원이 완료되면 다음을 확인하세요:
- [ ] 모든 테이블이 Supabase에 생성됨
- [ ] 각 테이블의 행 수가 로컬과 일치
- [ ] 샘플 데이터가 정상적으로 복원됨
- [ ] 애플리케이션에서 정상 연결 확인 