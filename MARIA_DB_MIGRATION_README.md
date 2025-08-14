# MariaDB 마이그레이션 가이드

이 문서는 Supabase PostgreSQL 데이터베이스를 MariaDB로 마이그레이션하는 방법을 설명합니다.

## 파일 구성

1. **`mariadb_schema_restore.sql`** - 데이터베이스 스키마 생성 파일
2. **`mariadb_data_restore.sql`** - 데이터 복원 파일
3. **`MARIA_DB_MIGRATION_README.md`** - 이 가이드 문서

## 사전 준비사항

1. MariaDB 서버가 설치되어 있어야 합니다.
2. MariaDB 클라이언트 도구가 필요합니다.
3. Supabase에서 데이터를 내보낼 준비가 되어 있어야 합니다.

## 마이그레이션 단계

### 1단계: MariaDB 서버 준비

```bash
# MariaDB 서버 시작 (Docker 사용 시)
docker run --name mariadb-shinil \
  -e MYSQL_ROOT_PASSWORD=your_password \
  -e MYSQL_DATABASE=shinil_project \
  -p 3306:3306 \
  -d mariadb:latest

# 또는 로컬 MariaDB 서버 사용
sudo systemctl start mariadb
```

### 2단계: 스키마 생성

```bash
# 스키마 파일 실행
mysql -u root -p < mariadb_schema_restore.sql
```

### 3단계: 데이터 준비

Supabase에서 데이터를 내보내는 방법:

#### 3-1. Supabase Dashboard에서 데이터 내보내기
1. Supabase 프로젝트 대시보드 접속
2. Table Editor에서 각 테이블 선택
3. Export 기능을 사용하여 CSV 또는 JSON 형식으로 내보내기

#### 3-2. SQL 쿼리로 데이터 내보내기
```sql
-- 사용자 데이터 내보내기
SELECT * FROM auth.users;

-- 제품 데이터 내보내기
SELECT * FROM products;

-- 클라이언트 데이터 내보내기
SELECT * FROM clients;

-- 기타 테이블들...
```

### 4단계: 데이터 변환

내보낸 데이터를 MariaDB 형식으로 변환:

1. **UUID 형식 변환**: PostgreSQL의 UUID를 MariaDB의 UUID() 함수로 변환
2. **타임스탬프 형식 변환**: PostgreSQL의 타임스탬프를 MariaDB 형식으로 변환
3. **JSON 데이터 변환**: PostgreSQL의 JSONB를 MariaDB의 JSON으로 변환

### 5단계: 데이터 삽입

```bash
# 데이터 복원 파일 실행 (실제 데이터로 수정 후)
mysql -u root -p shinil_project < mariadb_data_restore.sql
```

## 주요 변환 사항

### 1. 데이터 타입 변환

| PostgreSQL | MariaDB |
|------------|---------|
| `UUID` | `VARCHAR(255)` |
| `TIMESTAMP WITH TIME ZONE` | `TIMESTAMP` |
| `JSONB` | `JSON` |
| `BOOLEAN` | `BOOLEAN` |
| `DECIMAL` | `DECIMAL` |

### 2. 스키마 변경사항

- **스키마 제거**: PostgreSQL의 `auth.`, `public.` 스키마를 제거하고 단일 데이터베이스로 통합
- **인덱스 최적화**: MariaDB에 맞는 인덱스 구조로 변경
- **외래키 제약조건**: CASCADE 옵션 추가

### 3. 함수 및 트리거

- **UUID 생성**: `gen_random_uuid()` → `UUID()`
- **타임스탬프**: `NOW()` 함수 사용
- **트리거**: `updated_at` 자동 업데이트 트리거 추가

## 데이터 검증

마이그레이션 후 데이터 검증:

```sql
-- 테이블별 레코드 수 확인
SELECT 'users' AS table_name, COUNT(*) AS count FROM users
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS count FROM products
UNION ALL
SELECT 'clients' AS table_name, COUNT(*) AS count FROM clients
UNION ALL
SELECT 'companies' AS table_name, COUNT(*) AS count FROM companies;

-- 데이터 무결성 확인
SELECT 
    pr.id,
    c.client_name,
    p.product_name,
    comp.company_name
FROM performance_records pr
LEFT JOIN clients c ON pr.client_id = c.id
LEFT JOIN products p ON pr.product_id = p.id
LEFT JOIN companies comp ON pr.company_id = comp.id
LIMIT 10;
```

## 애플리케이션 설정 변경

### 1. 데이터베이스 연결 설정

```javascript
// 기존 Supabase 설정
const supabase = createClient(supabaseUrl, supabaseAnonKey);

// MariaDB 설정 (mysql2 사용)
const mysql = require('mysql2/promise');
const connection = await mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'your_password',
  database: 'shinil_project'
});
```

### 2. 쿼리 변환

```sql
-- PostgreSQL
SELECT * FROM auth.users WHERE email = $1;

-- MariaDB
SELECT * FROM users WHERE email = ?;
```

## 주의사항

1. **데이터 백업**: 마이그레이션 전 반드시 원본 데이터를 백업하세요.
2. **테스트 환경**: 먼저 테스트 환경에서 마이그레이션을 수행하세요.
3. **성능 최적화**: 대용량 데이터의 경우 배치 처리로 나누어 수행하세요.
4. **문자셋**: UTF-8 문자셋을 사용하여 한글 데이터 손실을 방지하세요.

## 문제 해결

### 일반적인 오류

1. **문자셋 오류**
   ```sql
   SET NAMES utf8mb4;
   SET CHARACTER SET utf8mb4;
   ```

2. **외래키 제약조건 오류**
   ```sql
   SET FOREIGN_KEY_CHECKS = 0;
   -- 데이터 삽입
   SET FOREIGN_KEY_CHECKS = 1;
   ```

3. **UUID 함수 오류**
   ```sql
   -- MariaDB 10.1+ 에서 UUID() 함수 사용 가능
   -- 이전 버전의 경우 UUID 생성 함수를 직접 구현
   ```

## 지원

마이그레이션 과정에서 문제가 발생하면 다음을 확인하세요:

1. MariaDB 버전 호환성
2. 데이터 타입 변환 정확성
3. 외래키 제약조건 설정
4. 인덱스 최적화

---

**마이그레이션 완료 후 반드시 애플리케이션 테스트를 수행하세요!**
