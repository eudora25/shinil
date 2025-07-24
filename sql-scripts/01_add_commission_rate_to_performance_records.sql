-- performance_records 테이블에 최종 수수료율을 저장하기 위한 컬럼을 추가합니다.
-- 이 컬럼은 실적 생성 시 기본값이 채워지고, 관리자가 검수 시 수정할 수 있습니다.

ALTER TABLE public.performance_records
ADD COLUMN commission_rate NUMERIC; 