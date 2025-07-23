-- 실적 검수 기능 단순화를 위한 데이터베이스 스키마 변경 스크립트 (v3)
-- absorption_analysis 관련 객체 삭제는 보류하고, performance_records 테이블만 수정합니다.

-- 1단계: performance_records 테이블 구조 변경
-- 검수 상태를 나타내는 컬럼의 이름을 더 직관적으로 변경합니다.
ALTER TABLE public.performance_records
RENAME COLUMN user_edit_status TO review_status;

-- 관리자의 수정/추가/삭제 작업을 기록하기 위한 컬럼을 추가합니다.
ALTER TABLE public.performance_records
ADD COLUMN review_action TEXT;

-- 관리자가 레코드를 수정했을 때, 수정한 사용자의 ID를 기록하기 위한 컬럼을 추가합니다.
ALTER TABLE public.performance_records
ADD COLUMN updated_by UUID REFERENCES auth.users(id);

-- 참고: commission_rate 컬럼은 별도의 스키마 변경 없이 기존 컬럼을 그대로 활용하여,
-- 실적 생성 시 기본 수수료율을 저장하고 관리자 수정 시 덮어쓰는 방식으로 사용합니다.

-- 참고: absorption_analysis 테이블, 관련 뷰/함수 삭제는
-- 모든 기능이 안정화된 후 별도로 진행할 예정입니다. 