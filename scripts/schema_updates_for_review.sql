-- 실적 검수 기능을 위한 DB 스키마 변경

-- 1. performance_records 테이블에 검수 관련 필드 추가
ALTER TABLE performance_records 
ADD COLUMN review_status text DEFAULT '미검수' CHECK (review_status IN ('미검수', '검수완료')),
ADD COLUMN review_action text CHECK (review_action IS NULL OR review_action IN ('수정', '제외', '추가'));

-- 2. absorption_analysis 테이블에 performance_record_id 참조 필드 추가
ALTER TABLE absorption_analysis 
ADD COLUMN performance_record_id bigint REFERENCES performance_records(id);

-- 3. 기존 데이터들의 검수 상태를 '미검수'로 설정 (이미 DEFAULT로 설정되지만 명시적으로)
UPDATE performance_records 
SET review_status = '미검수' 
WHERE review_status IS NULL;

-- 4. 인덱스 추가 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_performance_records_review_status ON performance_records(review_status);
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_performance_record_id ON absorption_analysis(performance_record_id);

-- 5. 검수 상태별 조회를 위한 뷰 생성 (선택사항)
CREATE OR REPLACE VIEW performance_records_with_review AS
SELECT 
  pr.*,
  c.company_name,
  c.company_group,
  c.assigned_pharmacist_contact,
  cl.name as client_name,
  p.product_name,
  p.insurance_code,
  p.price
FROM performance_records pr
LEFT JOIN companies c ON pr.company_id = c.id
LEFT JOIN clients cl ON pr.client_id = cl.id
LEFT JOIN products p ON pr.product_id = p.id; 