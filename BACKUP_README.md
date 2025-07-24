# Supabase 데이터베이스 백업 스크립트

이 스크립트는 Supabase 데이터베이스의 모든 테이블을 CSV 파일로 백업합니다.

## 📋 백업된 테이블

- `companies` - 업체 정보
- `products` - 제품 정보  
- `clients` - 고객 정보
- `pharmacies` - 약국 정보
- `wholesale_sales` - 도매 매출 정보
- `direct_sales` - 직거래 매출 정보
- `performance_records` - 실적 기록
- `settlement_months` - 정산 월 정보
- `notices` - 공지사항

## 🚀 사용법

### 1. 필요한 패키지 설치

```bash
pip3 install supabase pandas python-dotenv
```

### 2. 백업 실행

#### 간단한 방법:
```bash
python3 backup_database_improved.py
```

#### 쉘 스크립트 사용:
```bash
chmod +x run_backup.sh
./run_backup.sh
```

## 📁 백업 결과

백업이 완료되면 다음과 같은 구조로 파일이 생성됩니다:

```
database_backup_YYYYMMDD_HHMMSS/
├── backup_summary.json          # 백업 요약 정보
├── companies.csv                # 업체 정보
├── products.csv                 # 제품 정보
├── clients.csv                  # 고객 정보
├── pharmacies.csv               # 약국 정보
├── wholesale_sales.csv          # 도매 매출 정보
├── direct_sales.csv             # 직거래 매출 정보
├── performance_records.csv      # 실적 기록
├── settlement_months.csv        # 정산 월 정보
└── notices.csv                  # 공지사항
```

## 📊 백업 요약 정보

`backup_summary.json` 파일에는 다음 정보가 포함됩니다:

```json
{
  "backup_timestamp": "2025-07-24T15:58:18.582205",
  "total_tables": 9,
  "successful_backups": 9,
  "failed_backups": 0,
  "backup_directory": "database_backup_20250724_155818",
  "tables": ["companies", "products", ...],
  "supabase_url": "https://selklngerzfmuvagcvvf.supabase.co"
}
```

## ⚙️ 설정

스크립트 상단에서 다음 설정을 확인/수정할 수 있습니다:

```python
SUPABASE_URL = "https://selklngerzfmuvagcvvf.supabase.co"
SUPABASE_ANON_KEY = "your-anon-key-here"
```

## 🔧 문제 해결

### 테이블이 존재하지 않는 경우
- 스크립트는 자동으로 존재하지 않는 테이블을 건너뜁니다
- 실제 존재하는 테이블만 백업됩니다

### 데이터가 없는 테이블
- 데이터가 없는 테이블은 빈 CSV 파일로 생성됩니다
- `no_data` 헤더가 포함됩니다

### 권한 오류
- Supabase anon key가 올바른지 확인하세요
- 테이블에 대한 읽기 권한이 있는지 확인하세요

## 📝 주의사항

1. **데이터 제한**: 각 테이블당 최대 10,000개 행만 백업됩니다
2. **인코딩**: 모든 CSV 파일은 UTF-8 인코딩으로 저장됩니다
3. **백업 위치**: 현재 디렉토리에 타임스탬프가 포함된 폴더가 생성됩니다
4. **보안**: Supabase 키가 스크립트에 하드코딩되어 있으므로 주의하세요

## 🔄 자동화

정기적인 백업을 위해 cron job을 설정할 수 있습니다:

```bash
# 매일 새벽 2시에 백업 실행
0 2 * * * cd /path/to/project && python3 backup_database_improved.py
``` 