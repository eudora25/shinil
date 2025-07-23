-- absorption_analysis 테이블에 검수 상태 컬럼들 추가

-- 1. review_status 컬럼 추가 (관리자 검수 상태)
ALTER TABLE public.absorption_analysis 
ADD COLUMN IF NOT EXISTS review_status text DEFAULT '검수중' CHECK (review_status IN ('검수중', '완료'));

-- 2. review_action 컬럼 추가 (관리자 액션)
ALTER TABLE public.absorption_analysis 
ADD COLUMN IF NOT EXISTS review_action text CHECK (review_action IN ('수정', '제외', '추가') OR review_action IS NULL);

-- 3. 기존 데이터에 기본값 설정
UPDATE public.absorption_analysis 
SET review_status = '검수중' 
WHERE review_status IS NULL;

-- 4. 인덱스 추가 (검수 상태로 필터링할 때 성능 향상)
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_review_status 
ON public.absorption_analysis USING btree (review_status);

-- 5. 현재 상태 확인
SELECT 
    'Review Status Check' as info,
    review_status,
    COUNT(*) as count
FROM public.absorption_analysis 
GROUP BY review_status
ORDER BY review_status;

-- 6. 테이블 구조 확인
SELECT 
    column_name,
    data_type,
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'absorption_analysis'
AND column_name IN ('review_status', 'review_action')
ORDER BY column_name; 