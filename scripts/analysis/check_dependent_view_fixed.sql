-- performance_records_with_review 뷰 확인 및 처리 (수정된 쿼리)

-- 1. 뷰 정의 확인
SELECT 
    schemaname,
    viewname,
    definition
FROM pg_views 
WHERE viewname = 'performance_records_with_review';

-- 2. 뷰가 사용하는 컬럼들 확인 (수정된 쿼리)
SELECT 
    table_name,
    column_name
FROM information_schema.view_column_usage 
WHERE view_name = 'performance_records_with_review';

-- 3. 모든 뷰 목록 확인 (performance_records 관련)
SELECT 
    schemaname,
    viewname
FROM pg_views 
WHERE definition LIKE '%performance_records%';

-- 단계별 처리:

-- 4-A. 뷰 삭제 후 컬럼 삭제 (안전한 방법)
-- DROP VIEW IF EXISTS performance_records_with_review;
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_status;
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_action;

-- 4-B. CASCADE로 한번에 삭제 (빠른 방법, 하지만 의존 객체들도 함께 삭제됨)
-- ALTER TABLE public.performance_records DROP COLUMN review_status CASCADE;
-- ALTER TABLE public.performance_records DROP COLUMN review_action CASCADE; 