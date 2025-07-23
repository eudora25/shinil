-- performance_records_with_review 뷰 확인 및 처리

-- 1. 뷰 정의 확인
SELECT 
    schemaname,
    viewname,
    definition
FROM pg_views 
WHERE viewname = 'performance_records_with_review';

-- 2. 뷰가 사용하는 컬럼들 확인
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.view_column_usage 
WHERE view_name = 'performance_records_with_review';

-- 3. 뷰 삭제 (더 이상 필요하지 않다면)
-- DROP VIEW IF EXISTS performance_records_with_review;

-- 4. 그 다음 performance_records 컬럼 삭제
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_status;
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_action;

-- 또는 CASCADE를 사용해서 한번에 삭제
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_status CASCADE;
-- ALTER TABLE public.performance_records DROP COLUMN IF EXISTS review_action CASCADE; 