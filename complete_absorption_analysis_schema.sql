-- absorption_analysis 테이블 스키마 완전 정리

-- 1. 필요한 ID 컬럼들 추가
ALTER TABLE public.absorption_analysis 
ADD COLUMN IF NOT EXISTS client_id uuid NULL,
ADD COLUMN IF NOT EXISTS product_id uuid NULL;

-- 2. 외래키 제약조건 추가
ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT IF NOT EXISTS absorption_analysis_client_id_fkey 
FOREIGN KEY (client_id) REFERENCES clients(id);

ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT IF NOT EXISTS absorption_analysis_product_id_fkey 
FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT IF NOT EXISTS absorption_analysis_company_id_fkey 
FOREIGN KEY (company_id) REFERENCES companies(id);

-- 3. 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_client_id 
ON public.absorption_analysis USING btree (client_id);

CREATE INDEX IF NOT EXISTS idx_absorption_analysis_product_id 
ON public.absorption_analysis USING btree (product_id);

CREATE INDEX IF NOT EXISTS idx_absorption_analysis_company_id 
ON public.absorption_analysis USING btree (company_id);

-- 4. 기존 데이터 업데이트
-- client_id 업데이트
UPDATE public.absorption_analysis 
SET client_id = clients.id 
FROM clients 
WHERE absorption_analysis.client_name = clients.name 
AND absorption_analysis.client_id IS NULL;

-- product_id 업데이트  
UPDATE public.absorption_analysis 
SET product_id = products.id 
FROM products 
WHERE absorption_analysis.product_name = products.product_name 
AND absorption_analysis.product_id IS NULL;

-- company_id 업데이트
UPDATE public.absorption_analysis 
SET company_id = companies.id 
FROM companies 
WHERE absorption_analysis.company_name = companies.company_name 
AND absorption_analysis.company_id IS NULL;

-- 5. company_id 기본값 제거
ALTER TABLE public.absorption_analysis 
ALTER COLUMN company_id DROP DEFAULT;

-- 6. 현재 상태 확인
SELECT 
    'Data Status Check' as info,
    COUNT(*) as total_records,
    COUNT(company_id) as records_with_company_id,
    COUNT(client_id) as records_with_client_id,
    COUNT(product_id) as records_with_product_id
FROM public.absorption_analysis; 