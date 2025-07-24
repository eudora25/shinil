-- absorption_analysis 테이블의 company_id 정리

-- 1. 기존의 잘못된 company_id 기본값 제거
ALTER TABLE public.absorption_analysis 
ALTER COLUMN company_id DROP DEFAULT;

-- 2. companies 테이블과의 외래키 제약조건 추가 (아직 없다면)
ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT absorption_analysis_company_id_fkey 
FOREIGN KEY (company_id) REFERENCES companies(id);

-- 3. 기존 데이터가 있다면 company_name을 기반으로 company_id 업데이트
UPDATE public.absorption_analysis 
SET company_id = companies.id 
FROM companies 
WHERE absorption_analysis.company_name = companies.company_name;

-- 4. company_id 인덱스 추가 (아직 없다면)
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_company_id 
ON public.absorption_analysis USING btree (company_id);

-- 5. 현재 상태 확인
SELECT 
    COUNT(*) as total_records,
    COUNT(company_id) as records_with_company_id,
    COUNT(client_id) as records_with_client_id
FROM public.absorption_analysis; 