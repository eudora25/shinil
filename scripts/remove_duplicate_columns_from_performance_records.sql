-- performance_records 테이블에서 중복된 컬럼 제거
-- ⚠️ 주의: absorption_analysis에 review_status, review_action이 정상 작동하는 것을 확인 후 실행하세요!

-- 1. 현재 performance_records 테이블 구조 확인
SELECT 
    'Before cleanup - performance_records columns' as info,
    column_name,
    data_type,
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'performance_records'
AND column_name IN ('review_status', 'review_action', 'user_edit_status')
ORDER BY column_name;

-- 2. review_status 컬럼 제거 (absorption_analysis로 이관됨)
ALTER TABLE public.performance_records 
DROP COLUMN IF EXISTS review_status;

-- 3. review_action 컬럼 제거 (absorption_analysis로 이관됨)
ALTER TABLE public.performance_records 
DROP COLUMN IF EXISTS review_action;

-- 4. 정리 후 performance_records 테이블 구조 확인
SELECT 
    'After cleanup - performance_records columns' as info,
    column_name,
    data_type,
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'performance_records'
AND column_name IN ('user_edit_status')
ORDER BY column_name;

-- 5. absorption_analysis의 검수 상태 컬럼 확인
SELECT 
    'absorption_analysis review columns' as info,
    column_name,
    data_type,
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'absorption_analysis'
AND column_name IN ('review_status', 'review_action')
ORDER BY column_name;

-- 6. 최종 상태 확인 - 각 테이블의 역할
SELECT 
    'Final Structure Summary' as info,
    'performance_records.user_edit_status: 사용자 편집 제어 (대기/검수중/완료)' as performance_records_role,
    'absorption_analysis.review_status: 관리자 검수 상태 (검수중/완료)' as absorption_review_status,
    'absorption_analysis.review_action: 관리자 액션 (수정/제외/추가)' as absorption_review_action; 