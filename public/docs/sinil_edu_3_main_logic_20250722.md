# 신일 PMS 주요 기능 및 핵심 로직 (v3.0)

**문서 버전: 3.0 (2025-07-22)**

## 1. 개요

본 문서는 신일 PMS의 핵심 기능인 '실적 검수', '흡수율 분석', '정산내역서 공유'의 상세한 동작 방식과 내부 로직을 설명합니다. 각 기능은 데이터베이스의 뷰(View)와 함수(RPC)를 적극적으로 활용하여 프론트엔드의 복잡성을 낮추고, 시스템 전체의 안정성과 일관성을 확보하는 방향으로 설계되었습니다.

---

## 2. 실적 검수 (`AdminPerformanceReviewView.vue`)

관리자가 사용자의 실적을 검수하고 확정하는 가장 중요하고 복잡한 기능입니다. 모든 데이터 변경 이력은 이 화면에서 발생하며, 프론트엔드는 사용자의 인터랙션을 `performance_records_absorption` 테이블의 변경 이력으로 변환하는 역할을 수행합니다.

### 2.1. 주요 상태 변수 (State Variables)

-   `loading` (ref): 데이터 로딩 상태를 제어하는 boolean. API 호출 시 `true`로 설정되어 로딩 인디케이터를 표시.
-   `displayRows` (ref): 화면의 데이터 테이블에 실제로 표시되는 데이터 배열.
-   `selectedRows` (ref): 사용자가 체크박스를 통해 선택한 행들의 데이터 배열.
-   `isAnyEditing` (computed): 현재 편집 중인 행이 하나라도 있는지 여부를 계산하는 boolean. 편집 중일 때는 다른 액션 버튼들을 비활성화하는 데 사용됨.
-   `fieldRefs`, `productInputRefs`: 인라인 편집 시 각 입력 필드(input, select)에 대한 참조(reference)를 저장하여, 키보드 네비게이션 등으로 직접 포커스를 제어하는 데 사용.

### 2.2. 데이터 조회 및 필터링 (`loadPerformanceData`)

-   **역할**: 필터 조건에 맞는 데이터를 조회하여 `displayRows`에 채워 넣는 메인 함수.
-   **동작 순서**:
    1.  필터링의 기준이 되는 `performance_records` 테이블을 직접 조회합니다.
    2.  `selectedSettlementMonth`, `selectedCompanyId`, `selectedHospitalId` 등 UI 필터 값을 바탕으로 `WHERE` 조건을 동적으로 추가합니다.
    3.  `selectedReviewStatus` 값에 따라 분기 처리됩니다.
        -   `'신규'`: '대기' 상태의 실적을 '검수중'으로 전환시킨 후, '검수중' 상태의 데이터를 조회합니다.
        -   `'전체'`: 마찬가지로 '대기' 상태 데이터를 '검수중'으로 전환한 후, 상태 조건 없이 모든 데이터를 조회합니다.
    4.  조회된 데이터를 `map()`을 통해 순회하며, 화면 표시에 필요한 형식(예: 숫자 포맷팅)으로 가공합니다.
    5.  가공된 데이터를 정해진 규칙(상태 > 작업 > 업체명 순)에 따라 `sort()`하고 최종적으로 `displayRows.value`에 할당합니다.

### 2.3. 데이터 동기화 (`syncNewRecordsToAnalysis`)

-   **역할**: 사용자가 입력한 '대기' 상태의 실적을 관리자가 검수할 수 있도록 `performance_records_absorption` 테이블로 가져오는 핵심 백그라운드 작업.
-   **상세 로직**:
    1.  `performance_records` 테이블에서 현재 선택된 '정산월'에 해당하는 `'대기'` 상태의 실적을 모두 `select` 합니다.
    2.  찾아낸 실적들의 데이터를 기반으로 `performance_records_absorption` 테이블에 삽입(INSERT)할 레코드 객체 배열을 생성합니다.
    3.  **가장 중요한 부분**: 이 때, 관리자가 직접 추가한 데이터와 구분하기 위해 `company_id_add`와 `client_id_add` 필드의 값을 **반드시 `NULL`로 명시**하여 삽입합니다. `review_status`는 '검수중'으로 설정합니다.
    4.  준비된 레코드 목록을 `performance_records_absorption`에 `insert`합니다.
    5.  성공적으로 삽입되면, 원본 실적의 `review_status`를 '대기'에서 **'검수중'**으로 `update`하여 중복해서 불러오는 것을 방지합니다.

### 2.4. 인라인 수정 및 저장 (`saveEdit`)

-   **역할**: 사용자가 수정한 내용을 데이터베이스에 저장하는 함수. `isNewRow` 플래그로 수정과 추가 로직을 분기합니다.
-   **수정 로직 (`isNewRow === false`)**:
    1.  사용자가 수정한 값들(처방월, 제품, 수량 등)을 모아 `recordData` 객체를 생성합니다. 이 객체에는 **`..._modify`** 필드들만 포함됩니다.
    2.  `review_action` 필드를 **'수정'**으로 설정하여 변경 이력을 남깁니다.
    3.  **핵심**: 이 로직에서는 `company_id_add`나 `client_id_add` 필드를 **절대 건드리지 않습니다.** 따라서 `NULL` 상태가 유지됩니다.
    4.  `supabase.from('performance_records_absorption').update(recordData).eq('id', row.id)`를 호출하여 DB를 업데이트합니다.
-   **추가 로직 (`isNewRow === true`)**:
    1.  `review_action` 필드를 **'추가'**로 설정하여 신규 데이터임을 명시합니다.
    2.  **핵심**: `company_id_add`와 `client_id_add` 필드에 **기준이 되었던 바로 위 행의 업체 ID (`row.company_id`)와 거래처 ID (`row.client_id`)**를 저장합니다.
    3.  나머지 수정된 정보(`..._modify` 필드)와 함께 `supabase.from('performance_records_absorption').insert(recordData)`를 호출하여 DB에 삽입합니다.

---

## 3. 흡수율 분석 (`AdminAbsorptionAnalysisView.vue`)

-   **역할**: 검수가 완료된 데이터를 기준으로, 제품별 처방액 대비 실제 매출(도매+직거래)의 비율을 분석합니다.
-   **핵심 로직**:
    -   프론트엔드에서는 복잡한 계산을 수행하지 않고, **`calculate_absorption_rates`** 라는 데이터베이스 함수(RPC)를 호출합니다.
    -   **`calculate_absorption_rates` 함수의 역할**:
        1.  `settlement_month`를 인자로 받습니다.
        2.  해당 월의 모든 '완료'된 실적(`review_status` = '완료')을 조회합니다.
        3.  각 실적의 `client_id`와 `product_id`를 기준으로, 관련된 도매/직거래 매출 테이블에서 해당 월의 매출 데이터를 찾아 합산합니다.
        4.  `(합산된 매출액 / 처방액) * 100` 공식을 통해 흡수율(%)을 계산합니다.
        5.  `performance_records_absorption`의 `id`와 계산된 결과를 함께 반환합니다.
    -   프론트엔드는 이 함수가 반환한 계산 결과를 기존에 `displayRows`에 있던 데이터와 `id` 기준으로 매핑하여 '합산액', '흡수율' 열을 업데이트합니다.

---

## 4. 정산내역서 공유 (`AdminSettlementShareView.vue`)

-   **역할**: 검수가 끝난 최종 실적을 **업체별로 합산**하여 보여주고, 각 업체에게 해당 내역을 공유할지 여부를 설정합니다.
-   **핵심 로직**:
    1.  **데이터 조회 (`loadSettlementData`)**:
        -   이 함수는 **`get_settlement_summary_by_company`** 라는 전용 데이터베이스 함수(RPC)를 호출하는 것이 전부입니다. 다른 프론트엔드 계산 로직이 전혀 없습니다.
    2.  **`get_settlement_summary_by_company` 함수의 내부 동작**:
        -   `performance_records_absorption`에서 특정 '정산월'과 `review_status`가 '완료'인 데이터를 모두 조회합니다.
        -   **`GROUP BY company_id`** 구문을 사용하여, 다른 어떤 필드에도 방해받지 않고 오직 **업체 ID를 기준으로** 모든 데이터를 완벽하게 합산합니다.
        -   합산 항목: `COUNT(DISTINCT client_id)`로 병의원 수를, `COUNT(*)`로 처방 건수를, `SUM()`으로 총 처방액/지급액을 계산합니다.
        -   `company_name` 등 그룹화되지 않은 다른 문자열 필드는 `MAX()` 집계 함수를 사용하여 대표값을 선택합니다. (업체 ID가 동일하면 이 값들은 모두 동일하므로 어떤 집계 함수든 무방합니다.)
        -   `settlement_share` 테이블과 `LEFT JOIN` 하여 현재 공유 상태까지 가져와 최종 결과를 한 번의 쿼리로 반환합니다.
    3.  **공유 상태 저장 (`saveShareStatus`)**:
        -   사용자가 체크박스를 변경하면, 변경된 내용(`company_id`, `is_shared`, `settlement_share_id`)만 `shareChanges` 객체에 추적됩니다.
        -   '저장' 버튼을 누르면, `shareChanges`에 기록된 업체들만 `settlement_share` 테이블에 `INSERT` (기존 공유 기록이 없던 업체) 또는 `UPDATE` (기존 공유 기록이 있던 업체)를 수행하여 불필요한 DB 접근을 최소화합니다.
    4.  **기대 효과**: 모든 계산과 그룹화가 데이터베이스 안에서 완벽하게 처리되므로, 프론트엔드 코드는 극적으로 단순해졌고 데이터 정합성 오류가 발생할 가능성이 원천적으로 차단되었습니다.

---

## 5. 실적 등록 시 초기 상태 차이

### 5.1. 이용자 vs 관리자 실적 등록 초기 상태

신일 PMS에서는 **등록자의 권한에 따라 실적의 초기 검수 상태가 다르게 설정**됩니다.

#### 5.1.1. 이용자 실적 등록
- **초기 상태**: `review_status = '대기'`
- **설명**: 이용자가 등록한 실적은 관리자의 검수를 거쳐야 하므로 초기 상태가 '대기'로 설정됩니다.
- **코드 위치**: `vue-project/src/views/user/PerformanceRegisterEdit.vue`

```javascript
// 관리자가 입력하는 경우 바로 완료 상태로 저장
const reviewStatus = (route.query.companyId && isAdminUser.value) ? '완료' : '대기';
```

#### 5.1.2. 관리자 실적 등록
- **초기 상태**: `review_status = '완료'`
- **설명**: 관리자가 등록한 실적은 이미 검수가 완료된 것으로 간주하여 바로 '완료' 상태로 설정됩니다.
- **조건**: `route.query.companyId`가 존재하고 `isAdminUser.value`가 `true`인 경우
- **코드 위치**: `vue-project/src/views/user/PerformanceRegisterEdit.vue`

```javascript
// 관리자가 입력하는 경우 바로 완료 상태로 저장
const reviewStatus = (route.query.companyId && isAdminUser.value) ? '완료' : '대기';
```

#### 5.1.3. 관리자 실적 검수 화면에서 추가
- **초기 상태**: `review_status = '검수중'`
- **설명**: 관리자가 실적 검수 화면에서 새로 추가하는 실적은 검수 과정에 포함되어야 하므로 '검수중' 상태로 설정됩니다.
- **코드 위치**: `vue-project/src/views/admin/AdminPerformanceReviewView.vue`

```javascript
// 추가 (INSERT)
saveData = {
  ...saveData,
  created_at: new Date().toISOString(),
  registered_by: adminUserId,
  review_action: '추가',
  review_status: '검수중'
};
```

### 5.2. 상태별 의미 및 데이터 흐름

| 상태 | 의미 | 등록자 | 데이터 흐름 |
|------|------|--------|-------------|
| `대기` | 이용자가 등록한 실적, 관리자 검수 대기 | 이용자 | 이용자 등록 → 관리자 검수 화면에서 '검수중'으로 변경 |
| `검수중` | 관리자가 검수 중인 실적 | 관리자 | 관리자 검수 화면에서 추가/수정 → 검수 완료 시 '완료'로 변경 |
| `완료` | 검수가 완료된 최종 실적 | 관리자/이용자 | 흡수율 분석, 정산내역서 공유 대상 |

### 5.3. 구현 상세

#### 5.3.1. 이용자 실적 등록 시
```javascript
// INSERT 시
const dataToInsert = rowsToInsert.map(row => ({
  // ... 기타 필드들
  registered_by: currentUserUid,
  review_status: '대기', // 이용자는 항상 '대기' 상태
  commission_rate: commissionRate
}));

// UPDATE 시
const updatePromises = rowsToUpdate.map(row => 
  supabase.from('performance_records').update({
    // ... 기타 필드들
    review_status: '대기', // 이용자는 항상 '대기' 상태
    updated_by: currentUserUid,
    updated_at: new Date().toISOString()
  }).eq('id', row.id)
);
```

#### 5.3.2. 관리자 실적 등록 시
```javascript
// 관리자 권한 확인
const reviewStatus = (route.query.companyId && isAdminUser.value) ? '완료' : '대기';

// INSERT 시
const dataToInsert = rowsToInsert.map(row => ({
  // ... 기타 필드들
  registered_by: currentUserUid,
  review_status: reviewStatus, // 관리자는 '완료' 상태
  commission_rate: commissionRate
}));

// UPDATE 시
const updatePromises = rowsToUpdate.map(row => 
  supabase.from('performance_records').update({
    // ... 기타 필드들
    review_status: reviewStatus, // 관리자는 '완료' 상태
    updated_by: currentUserUid,
    updated_at: new Date().toISOString()
  }).eq('id', row.id)
);
```

### 5.4. 비즈니스 로직의 의의

1. **검수 프로세스 보장**: 이용자 등록 실적은 반드시 관리자 검수를 거치도록 강제
2. **관리자 권한 인정**: 관리자가 등록한 실적은 즉시 활용 가능하도록 설계
3. **데이터 무결성**: 상태에 따른 명확한 데이터 흐름으로 시스템 일관성 확보
4. **업무 효율성**: 관리자의 즉시 등록과 이용자의 검수 대기 프로세스 분리

---

## 6. Database Functions 상세 분석

### 6.1. 핵심 비즈니스 로직 함수들

#### `calculate_absorption_rates(p_settlement_month text)`
```sql
-- Returns: TABLE(analysis_id bigint, wholesale_revenue numeric, direct_revenue numeric)
-- Security: Invoker
```
- **목적**: 흡수율 분석을 실행하고, 각 실적별로 연결된 도매/직거래 매출액을 계산
- **핵심 로직**:
  1. `review_details_view`에서 '완료' 상태의 실적 데이터 조회
  2. 병원-약국 매핑 정보를 통한 약국 연결
  3. 도매/직거래 매출 데이터와 매칭하여 매출액 계산
  4. 약국별 병원 수에 따른 매출 분배 로직 적용

#### `get_settlement_summary_by_company(p_settlement_month text)`
```sql
-- Returns: TABLE(company_id, company_name, client_count, total_records, total_prescription_amount, total_payment_amount, is_shared, settlement_share_id)
-- Security: DEFINER
```
- **목적**: 정산내역서 공유용 업체별 합산 데이터 조회
- **핵심 로직**:
  1. `performance_records_absorption`에서 '완료' 상태 데이터 조회
  2. 업체별로 GROUP BY하여 합산 계산
  3. `settlement_share` 테이블과 JOIN하여 공유 상태 포함

### 5.2. 변경사항 감지 함수들

#### `check_for_updates(p_settlement_month text)`
```sql
-- Returns: JSON
-- Security: Invoker
```
- **목적**: 정산월별 변경사항 확인 (검수, 매핑, 매출 데이터 변경)
- **반환 데이터**:
  ```json
  {
    "updated_reviews": 0,
    "updated_mappings": 0,
    "updated_sales": 0,
    "has_changes": false
  }
  ```

#### `check_performance_changes(p_settlement_month text)`
```sql
-- Returns: jsonb
-- Security: Invoker
```
- **목적**: 실적 데이터 변경사항 확인 (추가, 수정, 삭제 건수)
- **반환 데이터**:
  ```json
  {
    "added_count": 0,
    "modified_count": 0,
    "deleted_count": 0
  }
  ```

### 5.3. 데이터 조회 함수들

#### `get_absorption_analysis_details(p_settlement_month, p_company_id, p_client_id)`
```sql
-- Returns: TABLE(id, company_name, client_name, prescription_month, product_name, prescription_qty, prescription_amount, commission_rate, payment_amount, remarks, created_at, created_by)
-- Security: Invoker
```
- **목적**: 흡수율 분석 화면의 상세 데이터 조회
- **필터링**: 정산월, 업체, 거래처별 필터링 지원

#### `get_distinct_companies_from_analysis(p_settlement_month)`
```sql
-- Returns: TABLE(id uuid, company_name text)
-- Security: Invoker
```
- **목적**: 업체 필터 목록 조회
- **로직**: '완료' 상태 실적에 연결된 모든 업체 중복 제거

### 5.4. 디버깅 함수들

#### `debug_absorption_rates(p_settlement_month text)`
```sql
-- Returns: TABLE(absorption_analysis_id, pharmacy_brn_from_prescription, standard_code_from_prescription, month_from_prescription, brn_from_sales, standard_code_from_sales, month_from_sales, sales_amount)
-- Security: Invoker
```
- **목적**: 흡수율 분석 디버깅용 (상세 매칭 정보)
- **용도**: 매출 데이터 매칭 과정에서 발생하는 문제 진단

#### `debug_distribution_ratios(p_settlement_month text)`
```sql
-- Returns: TABLE(absorption_analysis_id, company_name, client_name, product_name, pharmacy_brn, prescription_qty, total_group_qty, distribution_ratio)
-- Security: Invoker
```
- **목적**: 분배 비율 디버깅용
- **용도**: 약국별 매출 분배 로직 검증

---

## 6. 최신 RLS 정책 (Row Level Security)

### 6.1. 핵심 정책 개요

시스템은 Supabase의 RLS를 활용하여 데이터 접근을 제어합니다:

- **`companies` 테이블**: 
  - 관리자는 모든 업체 데이터 조회 가능
  - 일반 사용자는 자신의 업체 데이터만 조회/수정 가능
  - 회원가입 시 자동으로 업체 정보 생성

- **`performance_records` 테이블**:
  - 관리자는 모든 실적 데이터 접근 가능
  - 일반 사용자는 자신의 업체 실적만 조회/수정 가능

- **`notices` 테이블**:
  - 모든 인증된 사용자가 공지사항 조회 가능
  - 관리자만 공지사항 작성/수정/삭제 가능

- **`products` 테이블**:
  - 모든 인증된 사용자가 활성 제품 조회 가능
  - 관리자만 제품 관리 가능

### 6.2. 권한 관리 체계

- **`user_type`**: 'admin' 또는 'user'로 구분
- **`approval_status`**: 'pending', 'approved', 'rejected'로 업체 승인 상태 관리
- **`status`**: 'active', 'inactive'로 데이터 활성 상태 관리

---

## 7. 파일 업로드 시스템

### 7.1. 실적 증빙 파일 (`performance_evidence_files`)

- **저장 위치**: Supabase Storage
- **접근 권한**: 업체별로 자신의 파일만 관리 가능
- **파일 정보**: 파일명, 경로, 크기, 업로드자, 업로드 시각 추적

### 7.2. 공지사항 첨부 파일

- **파일 URL**: `notices.file_url` 필드에 저장
- **링크 정보**: `notices.links` 필드에 외부 링크 저장
- **관리 권한**: 관리자만 파일 업로드/관리 가능

---

## 8. 실적 등록 시 처방월 변경 로직

### 8.1. 제품 정보 자동 업데이트 규칙

**목적**: 사용자가 실적 등록 중 처방월을 변경할 때, 해당 월의 제품 정보(약가, 수수료율)를 자동으로 업데이트

**핵심 로직**:
1. **검색 기준**: 이미 선택된 제품의 **보험코드**를 사용
2. **검색 대상**: 변경된 처방월의 `base_month`에서 해당 보험코드 검색
3. **결과 처리**: 
   - **여러 결과가 있는 경우**: 첫 번째 결과만 사용 (`.limit(1)` 적용)
   - **결과가 없는 경우**: 제품 선택 해제 (제품명, 보험코드, 약가, 수수료율 등 모든 정보 초기화)
   - **결과가 있는 경우**: 새로운 제품 정보로 자동 업데이트 (약가, 수수료율, 처방액 재계산)

**구현 위치**: `PerformanceRegisterEdit.vue` - `updateProductInfoForMonthChange()` 함수

**동작 시나리오**:
- **시나리오 1**: 2025-05에서 가모피드정 5mg 선택 → 2025-04로 변경 → 보험코드로 검색하여 약가 4원, 수수료율 40%로 자동 업데이트
- **시나리오 2**: 2025-05에서 가모피드정 5mg 선택 → 2025-03으로 변경 → 보험코드가 2025-03에 없으므로 제품 선택 해제

**기술적 특징**:
- `.single()` 대신 `.limit(1)` 사용으로 여러 결과 처리 가능
- 에러 처리 개선으로 쿼리 에러와 데이터 없음을 분리
- 처방수량이 있는 경우 처방액 자동 재계산

---

## 9. 실적입력기간 제한 시스템

### 9.1. 개요

시스템은 실적 등록을 관리자가 설정한 기간 내에서만 허용하는 제한 시스템을 운영합니다. 이는 데이터 입력의 일관성과 관리 효율성을 위한 핵심 기능입니다.

### 9.2. 데이터 구조

**`settlement_months` 테이블**:
- `settlement_month`: 정산월 (예: '2025-01')
- `start_date`: 실적입력 시작일 (YYYY-MM-DD)
- `end_date`: 실적입력 종료일 (YYYY-MM-DD)
- `notice`: 전달 사항
- `status`: 활성/비활성 상태
- `remarks`: 비고

### 9.3. 권한별 실적입력기간 제한

#### 9.3.1. 일반 사용자 (CSO 업체)
- **제한 적용**: 실적입력기간 내에서만 실적 등록/수정 가능
- **검증 로직**: `checkInputPeriod()` 함수에서 현재 시간과 `start_date`, `end_date` 비교
- **UI 제어**: 실적입력기간 외에는 모든 입력 버튼 비활성화
- **구현 위치**: `PerformanceRegister.vue`, `PerformanceRegisterEdit.vue`

#### 9.3.2. 관리자 (신일제약)
- **제한 없음**: 실적입력기간과 무관하게 언제든지 실적 등록/수정 가능
- **우회 로직**: `checkInputPeriod()` 함수에서 `isInputPeriod.value = true`로 강제 설정
- **구현 위치**: `AdminPerformanceRegisterView.vue`

### 9.4. 핵심 로직

#### 9.4.1. 실적입력기간 체크 함수
```javascript
// 일반 사용자용
const checkInputPeriod = async () => {
  if (!selectedSettlementMonth.value) return
  const { data, error } = await supabase
    .from('settlement_months')
    .select('start_date, end_date')
    .eq('settlement_month', selectedSettlementMonth.value)
    .single()
  
  if (!error && data) {
    const now = new Date()
    const startDate = new Date(data.start_date)
    const endDate = new Date(data.end_date)
    endDate.setHours(23, 59, 59, 999) // 종료일을 그날의 마지막 시간으로 설정
    isInputPeriod.value = now >= startDate && now <= endDate
  } else {
    isInputPeriod.value = false
  }
}

// 관리자용 (우회)
const checkInputPeriod = async () => {
  // 관리자는 항상 입력 가능
  isInputPeriod.value = true
  return
  // ... 일반 사용자 로직 (실행되지 않음)
}
```

#### 9.4.2. UI 제어 로직
- **버튼 비활성화**: `:disabled="!isInputPeriod"`
- **실적 등록**: `:disabled="!isInputPeriod"`
- **실적 수정**: `:disabled="!isInputPeriod"`
- **파일 업로드**: `:disabled="!isInputPeriod"`

### 9.5. 관리자 설정 화면

**`AdminSettlementMonthsCreateView.vue`**:
- 정산월 설정
- 실적입력 시작일/종료일 설정
- 전달 사항 입력
- 상태 관리 (활성/비활성)

### 9.6. 동작 시나리오

#### 9.6.1. 일반 사용자 시나리오
1. **기간 내**: 실적 등록/수정 버튼 활성화 → 정상 입력 가능
2. **기간 외**: 실적 등록/수정 버튼 비활성화 → 입력 불가
3. **기간 변경**: 관리자가 기간을 수정하면 즉시 반영

#### 9.6.2. 관리자 시나리오
1. **언제든지**: 실적 등록/수정 버튼 항상 활성화
2. **기간 무관**: 설정된 실적입력기간과 관계없이 입력 가능
3. **긴급 대응**: 기간 외에도 실적 데이터 수정 가능

### 9.7. 보안 및 데이터 무결성

- **데이터베이스 레벨**: RLS 정책으로 추가 보안 강화
- **프론트엔드 레벨**: UI 제어로 사용자 경험 개선
- **관리자 권한**: `user_type = 'admin'` 확인 후 우회 로직 적용

---

## 10. 실적 등록 시 제품 선택 및 키보드 네비게이션 시스템

### 10.1. 제품 선택 방식

#### 10.1.1. 제품 선택 방식 (2가지)

**방식 1: 제품명 검색 + 드롭다운**
- **검색 방식**: 제품명 또는 보험코드로 실시간 검색
- **드롭다운 표시**: 검색 결과를 드롭다운으로 표시 (제품명 + 보험코드)
- **선택 방법**: 
  - 마우스 클릭으로 선택
  - 키보드 상하 화살표로 탐색 후 Enter로 선택

**방식 2: 드롭다운 아이콘 클릭**
- **동작**: 드롭다운 아이콘(▼) 클릭 시 해당 처방월의 모든 제품 표시
- **유니크 처리**: 보험코드 기준으로 중복 제거하여 유니크하게 표시
- **표시 내용**: 제품명 + 보험코드
- **구현 위치**: `PerformanceRegisterEdit.vue` - `toggleProductDropdown()` 함수

#### 10.1.2. 검색 로직

**방식 1: 제품명 실시간 검색**
```javascript
// 제품명 입력 시 실시간 검색
function handleProductNameInput(rowIndex, event) {
  const query = event.target.value.toLowerCase();
  const month = inputRows.value[rowIndex].prescription_month;
  
  productSearchForRow.value.activeRowIndex = rowIndex;
  productSearchForRow.value.results = productList.filter(
    product => product.product_name.toLowerCase().includes(query) ||
               product.insurance_code.toLowerCase().includes(query)
  );
  productSearchForRow.value.selectedIndex = -1;
  productSearchForRow.value.show = productSearchForRow.value.results.length > 0;
}
```

**방식 2: 드롭다운 아이콘 클릭 (전체 제품 표시)**
```javascript
// 드롭다운 아이콘 클릭 시 해당 월의 모든 제품 표시
function toggleProductDropdown(rowIndex) {
  if (!isInputEnabled.value) return;
  
  // 이미 열려있으면 닫기
  if (productSearchForRow.value.show && productSearchForRow.value.activeRowIndex === rowIndex) {
    productSearchForRow.value.show = false;
    productSearchForRow.value.activeRowIndex = -1;
    return;
  }
  
  // 처방월에 맞는 제품만 필터링 (보험코드 기준 유니크)
  const month = inputRows.value[rowIndex].prescription_month;
  productSearchForRow.value.activeRowIndex = rowIndex;
  productSearchForRow.value.results = productsByMonth.value[month] || [];
  productSearchForRow.value.selectedIndex = -1;
  productSearchForRow.value.show = productSearchForRow.value.results.length > 0;
}
```

**제품 유니크 처리 로직**
```javascript
// 보험코드 기준으로 유니크하게 제품 처리
async function fetchProductsForMonth(month) {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('status', 'active')
    .eq('base_month', month)
    .range(0, 2999);

  if (!error && data) {
    const uniqByMonthAndInsurance = {};
    const noInsurance = [];
    
    data.forEach(p => {
      const key = `${p.base_month}_${p.insurance_code || ''}`;
      if (p.insurance_code) {
        // 보험코드가 있으면 유니크 처리
        if (!uniqByMonthAndInsurance[key]) uniqByMonthAndInsurance[key] = p;
      } else {
        // 보험코드가 없으면 별도 배열에 추가
        noInsurance.push(p);
      }
    });
    
    // 유니크 처리된 제품 + 보험코드 없는 제품
    productsByMonth.value[month] = [...Object.values(uniqByMonthAndInsurance), ...noInsurance];
  }
}
```

### 10.2. 키보드 네비게이션 규칙

#### 10.2.1. Enter 키 동작
- **제품명 필드**: 선택된 제품 적용 후 처방수량 필드로 이동
- **처방수량 필드**: 제품명과 수량이 모두 입력된 경우 다음 행으로 이동 (자동 행 추가)
- **비고 필드**: 제품명과 수량이 모두 입력된 경우 다음 행으로 이동 (자동 행 추가)

#### 10.2.2. 화살표 키 동작
- **상하 화살표**: 같은 열에서 위아래 행으로 이동
- **좌우 화살표**: 같은 행에서 좌우 열로 이동
- **이동 순서**: 처방월 → 제품명 → 처방수량 → 처방구분 → 비고
- **제품 검색 중**: 상하 화살표는 드롭다운 탐색, 좌우 화살표는 차단

#### 10.2.3. 특수 키 동작
- **ESC 키**: 현재 행의 모든 입력 정보 초기화 (제품명, 처방수량, 비고 등)
- **Delete 키**: 현재 행 삭제 (최소 1행은 유지)
- **Insert 키**: 현재 행 아래에 새 행 추가

### 10.3. 자동 행 관리 시스템

#### 10.3.1. 자동 행 추가
- **조건**: 마지막 행에 제품명 또는 처방수량이 입력되면 자동으로 새 행 추가
- **구현**: `watch(inputRows)` 감시자로 실시간 모니터링
- **기본값**: 새 행의 처방월은 정산월 - 1M, 처방구분은 'EDI'

#### 10.3.2. 행 초기화 로직
```javascript
function resetRow(rowIdx) {
  const row = inputRows.value[rowIdx];
  row.prescription_month = getDefaultPrescriptionMonth();
  row.product_name_display = '';
  row.product_id = null;
  row.insurance_code = '';
  row.price = '';
  row.prescription_qty = '';
  row.prescription_amount = '';
  row.prescription_type = 'EDI';
  row.remarks = '';
  row.commission_rate_a = null;
  row.commission_rate_b = null;
  
  // 제품 검색 드롭다운 숨기기
  if (productSearchForRow.value.show && productSearchForRow.value.activeRowIndex === rowIdx) {
    productSearchForRow.value.show = false;
    productSearchForRow.value.activeRowIndex = -1;
  }
  
  // 해당 행의 제품명 필드로 포커스 이동
  nextTick(() => {
    focusField(rowIdx, 'product_name');
  });
}
```

### 10.4. 전역 키보드 이벤트 처리

#### 10.4.1. 핸들러 등록
```javascript
// 컴포넌트 마운트 시 등록
onMounted(() => {
  document.addEventListener('keydown', handleGlobalKeydown);
  document.addEventListener('click', handleGlobalClick);
});

// 컴포넌트 언마운트 시 해제
onUnmounted(() => {
  document.removeEventListener('keydown', handleGlobalKeydown);
  document.removeEventListener('click', handleGlobalClick);
});
```

#### 10.4.2. 전역 키 처리 로직
```javascript
function handleGlobalKeydown(e) {
  // 제품 검색 드롭다운이 열려있으면 Insert/Delete/Escape 키 차단
  if (isProductSearchOpen.value) {
    if (e.key === 'Delete' || e.key === 'Insert' || e.key === 'Escape') {
      e.preventDefault();
      return;
    }
  }
  
  if (e.key === 'Delete') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    if (inputRows.value.length > 1) {
      confirmDeleteRow(currentRowIdx);
    }
  } else if (e.key === 'Insert') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    confirmAddRowBelow(currentRowIdx);
  } else if (e.key === 'Escape') {
    e.preventDefault();
    const currentRowIdx = currentCell.value.row;
    if (isRowEditable(inputRows.value[currentRowIdx])) {
      resetRow(currentRowIdx);
    }
  }
}
```

### 10.5. 포커스 관리 시스템

#### 10.5.1. 셀 포커스 추적
- **현재 셀**: `currentCell.value = { row: rowIdx, col: colName }`
- **포커스 스타일**: `cellClass()` 함수로 현재 셀 하이라이트
- **자동 포커스**: 행 추가/삭제 시 적절한 필드로 자동 포커스

#### 10.5.2. 필드별 포커스 규칙
- **처방월**: 드롭다운 선택 후 제품명으로 이동
- **제품명**: 제품 선택 후 처방수량으로 이동
- **처방수량**: 입력 완료 후 다음 행 제품명으로 이동
- **처방구분**: 선택 후 비고로 이동
- **비고**: 입력 완료 후 다음 행 제품명으로 이동

### 10.6. 사용자 경험 최적화

#### 10.6.1. 편집 상태별 제어
- **편집 가능**: 모든 키보드 기능 활성화
- **편집 불가**: 키보드 기능 비활성화, 읽기 전용 모드
- **관리자**: 모든 상태에서 편집 가능

#### 10.6.2. 실시간 피드백
- **처방액 자동 계산**: 처방수량 입력 시 실시간 계산
- **제품 정보 자동 업데이트**: 처방월 변경 시 제품 정보 자동 업데이트
- **처방구분 자동 복사**: 한 행의 처방구분 변경 시 아래 행들에 자동 적용

---

## 11. 정렬 규칙 시스템

### 11.1. 개요

시스템은 사용자 권한과 화면 목적에 따라 다른 정렬 규칙을 적용합니다. 기본적으로 가나다순 정렬을 사용하되, 입력 상태와 검수 상태에 따라 우선순위를 조정합니다.

### 11.2. 사용자별 정렬 규칙

#### 11.2.1. 일반 사용자 (CSO 업체)
- **정렬 대상**: 거래처 목록
- **정렬 방식**: 
  - **1순위**: 처방건수 0건 → 1건 이상 (입력된 것이 아래로)
  - **2순위**: 각 그룹 내 가나다순 정렬
- **구현 위치**: `PerformanceRegister.vue`, `PerformanceRegisterList.vue`

```javascript
// 정렬: 처방건수 0건 → 1건 이상, 각 그룹 내 가나다순
const noData = unsortedList
  .filter((c) => !c.performance_count || Number(c.performance_count) === 0)
  .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
const hasData = unsortedList
  .filter((c) => Number(c.performance_count) > 0)
  .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
clientList.value = [...noData, ...hasData] // 입력된 것이 아래로
```

#### 11.2.2. 관리자 (신일제약)
- **정렬 대상**: 업체 목록, 거래처 목록
- **업체 정렬**: 가나다순 (company_name 기준)
- **거래처 정렬**: 
  - **1순위**: 처방건수 0건 → 1건 이상 (입력된 것이 위로)
  - **2순위**: 각 그룹 내 가나다순 정렬
- **구현 위치**: `AdminPerformanceRegisterView.vue`, `AdminPerformanceReviewView.vue`

```javascript
// 업체 목록 정렬 (가나다순)
const { data, error } = await supabase
  .from('companies')
  .select('id, company_name')
  .eq('approval_status', 'approved')
  .eq('status', 'active')
  .eq('user_type', 'user')
  .order('company_name', { ascending: true }) // 가나다순

// 거래처 목록 정렬 (입력된 것이 위로)
const noData = unsortedList
  .filter((c) => !c.performance_count || Number(c.performance_count) === 0)
  .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
const hasData = unsortedList
  .filter((c) => Number(c.performance_count) > 0)
  .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
clientList.value = [...hasData, ...noData] // 입력된 것이 위로
```

### 11.3. 실적 검수 화면 정렬 규칙

#### 11.3.1. 검수 상태별 정렬
- **정렬 우선순위**: 신규 > 검수중 > 완료
- **상태 표시**: 
  - `review_status = '대기'` → `display_status = '신규'`
  - `review_status = '검수중'` → `display_status = '검수중'`
  - `review_status = '완료'` → `display_status = '완료'`

#### 11.3.2. 필터 옵션 정렬
```javascript
// 업체 필터 정렬 (가나다순)
monthlyCompanies.value = companies.sort((a, b) => 
  a.company_name.localeCompare(b.company_name, 'ko')
);

// 거래처 필터 정렬 (가나다순)
monthlyHospitals.value = clients.sort((a, b) => 
  a.name.localeCompare(b.name, 'ko')
);
```

### 11.4. 정렬 로직 상세

#### 11.4.1. 가나다순 정렬
- **사용 언어**: 한국어 (`'ko'` 로케일)
- **정렬 방식**: `localeCompare()` 메서드 사용
- **대소문자**: 구분하지 않음

#### 11.4.2. 상태별 그룹화 정렬
1. **데이터 분리**: 조건에 따라 그룹별로 분리
2. **그룹 내 정렬**: 각 그룹 내에서 가나다순 정렬
3. **그룹 결합**: 우선순위에 따라 그룹들을 결합

#### 11.4.3. 실시간 정렬
- **Computed 속성**: `displayRows` computed로 실시간 정렬
- **필터 적용**: 처방월, 업체, 거래처 필터와 함께 적용
- **성능 최적화**: 필요한 경우에만 정렬 수행

### 11.5. 정렬 규칙 요약

| 사용자 유형 | 정렬 대상 | 1순위 | 2순위 | 입력 데이터 위치 |
|------------|----------|-------|-------|----------------|
| 일반 사용자 | 거래처 | 처방건수 (0건 → 1건+) | 가나다순 | 아래로 |
| 관리자 | 업체 | 가나다순 | - | - |
| 관리자 | 거래처 | 처방건수 (0건 → 1건+) | 가나다순 | 위로 |
| 관리자 | 실적 검수 | 검수상태 (신규 → 검수중 → 완료) | 가나다순 | - | 