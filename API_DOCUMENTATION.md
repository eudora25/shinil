# 🔌 Shinil Project API Documentation

## 📋 개요

신일제약 실적관리 시스템의 외부 API 문서입니다. 이 API들은 로그인 없이도 접근 가능하며, 외부 시스템에서 데이터를 조회할 수 있습니다.

## 🌐 기본 정보

- **Base URL**: `https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app`
- **Content-Type**: `application/json`
- **인증**: 불필요 (공개 API)

## 📊 API 엔드포인트

### 1. 헬스체크 API

시스템 상태를 확인하는 API입니다.

```http
GET /api/health
```

**응답 예시:**
```json
{
  "status": "OK",
  "timestamp": "2025-01-01T00:00:00.000Z",
  "version": "1.0.0",
  "environment": "production"
}
```

### 2. 제품 목록 API

승인된 제품 목록을 조회합니다.

```http
GET /api/products
```

**쿼리 파라미터:**
- `limit` (optional): 조회할 제품 수 (기본값: 100, 최대: 1000)
- `offset` (optional): 건너뛸 제품 수 (페이지네이션용)
- `search` (optional): 제품명 검색

**응답 예시:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "product_name": "제품명",
      "manufacturer": "제조사",
      "specification": "규격",
      "unit": "단위",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0,
  "timestamp": "2025-01-01T00:00:00.000Z"
}
```

**사용 예시:**
```bash
# 기본 조회
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products"

# 검색
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products?search=아스피린"

# 페이지네이션
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products?limit=10&offset=20"
```

### 3. 병의원 목록 API

병의원 목록을 조회합니다.

```http
GET /api/clients
```

**쿼리 파라미터:**
- `limit` (optional): 조회할 병의원 수 (기본값: 100, 최대: 1000)
- `offset` (optional): 건너뛸 병의원 수 (페이지네이션용)
- `search` (optional): 병원명 검색
- `company_id` (optional): 특정 업체가 담당하는 병의원만 조회

**응답 예시:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "hospital_name": "병원명",
      "representative_name": "대표자명",
      "address": "주소",
      "phone": "연락처",
      "assigned_company_name": "담당업체명",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0,
  "timestamp": "2025-01-01T00:00:00.000Z"
}
```

**사용 예시:**
```bash
# 기본 조회
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/clients"

# 검색
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/clients?search=서울대병원"

# 특정 업체 담당 병의원
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/clients?company_id=1"
```

### 4. 공지사항 목록 API

공지사항 목록을 조회합니다.

```http
GET /api/notices
```

**쿼리 파라미터:**
- `limit` (optional): 조회할 공지사항 수 (기본값: 100, 최대: 1000)
- `offset` (optional): 건너뛸 공지사항 수 (페이지네이션용)
- `search` (optional): 제목 검색
- `status` (optional): 상태 필터 (active, inactive)

**응답 예시:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "공지사항 제목",
      "content": "공지사항 내용",
      "created_by_name": "작성자명",
      "created_at": "2025-01-01T00:00:00Z",
      "view_count": 0,
      "status": "active"
    }
  ],
  "total": 10,
  "limit": 100,
  "offset": 0,
  "timestamp": "2025-01-01T00:00:00.000Z"
}
```

**사용 예시:**
```bash
# 기본 조회
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/notices"

# 활성 공지사항만
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/notices?status=active"

# 검색
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/notices?search=중요"
```

## 🔧 Supabase Edge Functions

Vercel 배포 환경에서도 작동하는 Supabase Edge Functions를 제공합니다.

### Edge Function URL 구조

```
https://[PROJECT_REF].supabase.co/functions/v1/[FUNCTION_NAME]
```

### 사용 예시

```bash
# 제품 목록 (Edge Function)
curl "https://mctzuqctekhhdfwimxek.supabase.co/functions/v1/api-products"

# 병의원 목록 (Edge Function)
curl "https://mctzuqctekhhdfwimxek.supabase.co/functions/v1/api-clients"

# 공지사항 목록 (Edge Function)
curl "https://mctzuqctekhhdfwimxek.supabase.co/functions/v1/api-notices"
```

## 📝 응답 형식

### 성공 응답

모든 API는 다음과 같은 표준 응답 형식을 따릅니다:

```json
{
  "success": true,
  "data": [...],
  "total": 100,
  "limit": 100,
  "offset": 0,
  "timestamp": "2025-01-01T00:00:00.000Z"
}
```

### 오류 응답

```json
{
  "success": false,
  "error": "오류 메시지",
  "message": "사용자 친화적 오류 메시지"
}
```

## 🚀 사용 예시

### JavaScript (Fetch API)

```javascript
// 제품 목록 조회
async function getProducts(search = '', limit = 100) {
  const url = `https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products?search=${search}&limit=${limit}`;
  
  try {
    const response = await fetch(url);
    const data = await response.json();
    
    if (data.success) {
      return data.data;
    } else {
      throw new Error(data.message);
    }
  } catch (error) {
    console.error('API 호출 오류:', error);
    throw error;
  }
}

// 사용 예시
getProducts('아스피린', 10)
  .then(products => console.log('제품 목록:', products))
  .catch(error => console.error('오류:', error));
```

### Python (requests)

```python
import requests

def get_products(search='', limit=100):
    url = f"https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products"
    params = {
        'search': search,
        'limit': limit
    }
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        
        if data['success']:
            return data['data']
        else:
            raise Exception(data['message'])
    except Exception as e:
        print(f'API 호출 오류: {e}')
        raise

# 사용 예시
try:
    products = get_products('아스피린', 10)
    print('제품 목록:', products)
except Exception as e:
    print('오류:', e)
```

### cURL

```bash
# 제품 검색
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/products?search=아스피린&limit=10"

# 병의원 검색
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/clients?search=서울대병원"

# 공지사항 조회
curl "https://shinil-o4usv46mi-eudoras-projects-4c806a21.vercel.app/api/notices?status=active&limit=5"
```

## 🔒 보안 및 제한사항

### CORS 정책
- 모든 API는 CORS를 지원하여 브라우저에서 직접 호출 가능
- `Access-Control-Allow-Origin: *` 설정

### 요청 제한
- `limit` 파라미터 최대값: 1000
- 기본 제한: 100개 레코드

### 데이터 접근 권한
- 읽기 전용 API (수정 불가)
- 승인된 데이터만 노출
- 민감한 정보는 제외

## 📞 지원

API 사용에 대한 문의사항이 있으시면 다음으로 연락주세요:

- **GitHub Issues**: https://github.com/eudora25/shinil/issues
- **이메일**: admin@admin.com

## 📄 라이선스

이 API는 신일제약 내부 사용을 목적으로 제공됩니다.

---

**문서 버전**: 1.0.0  
**최종 업데이트**: 2025년 7월 25일 