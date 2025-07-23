-- 1단계: client_company_assignments 테이블에 수수료 등급 컬럼 추가
ALTER TABLE client_company_assignments 
ADD COLUMN company_default_commission_grade TEXT DEFAULT 'A',
ADD COLUMN modified_commission_grade TEXT;

-- 2단계: 기존 데이터 초기화 (모든 매핑을 'A' 등급으로 설정)
UPDATE client_company_assignments 
SET company_default_commission_grade = 'A'
WHERE company_default_commission_grade IS NULL;

-- 3단계: 자동 동기화를 위한 트리거 함수 생성
CREATE OR REPLACE FUNCTION sync_commission_grade()
RETURNS TRIGGER AS $$
BEGIN
    -- companies.default_commission_grade 변경 시 
    -- 해당 업체와 매핑된 모든 client_company_assignments의 company_default_commission_grade 업데이트
    UPDATE client_company_assignments 
    SET company_default_commission_grade = NEW.default_commission_grade
    WHERE company_id = NEW.id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4단계: 트리거 생성
DROP TRIGGER IF EXISTS trigger_sync_commission_grade ON companies;
CREATE TRIGGER trigger_sync_commission_grade
    AFTER UPDATE OF default_commission_grade ON companies
    FOR EACH ROW
    WHEN (OLD.default_commission_grade IS DISTINCT FROM NEW.default_commission_grade)
    EXECUTE FUNCTION sync_commission_grade();

-- 5단계: 검증 쿼리 (실행 후 확인용)
-- SELECT 
--     cca.id,
--     c.name as client_name,
--     comp.company_name,
--     comp.default_commission_grade as company_grade,
--     cca.company_default_commission_grade,
--     cca.modified_commission_grade
-- FROM client_company_assignments cca
-- JOIN clients c ON cca.client_id = c.id
-- JOIN companies comp ON cca.company_id = comp.id
-- ORDER BY c.name, comp.company_name; 