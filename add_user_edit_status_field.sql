-- performance_records 테이블에 사용자 편집 상태 필드 추가
-- 대기: 사용자가 등록한 초기 상태 (수정 가능)
-- 검수중: 관리자가 흡수율 분석으로 불러온 상태 (수정 불가)
-- 완료: 관리자가 검수 완료 처리한 상태 (수정 불가)

ALTER TABLE performance_records 
ADD COLUMN user_edit_status text DEFAULT '대기' 
CHECK (user_edit_status IN ('대기', '검수중', '완료'));

-- 기존 데이터의 상태 설정
UPDATE performance_records 
SET user_edit_status = CASE 
  WHEN review_status = '검수완료' THEN '완료'
  ELSE '대기'
END;

-- 인덱스 추가 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_performance_records_user_edit_status ON performance_records(user_edit_status);

-- 확인용 쿼리
SELECT user_edit_status, COUNT(*) 
FROM performance_records 
GROUP BY user_edit_status; 