-- absorption_analysis 테이블 스키마 완전 정리 (PostgreSQL 문법 수정)

-- 1. 필요한 ID 컬럼들 추가 (개별적으로)
ALTER TABLE public.absorption_analysis 
ADD COLUMN IF NOT EXISTS client_id uuid NULL;

ALTER TABLE public.absorption_analysis 
ADD COLUMN IF NOT EXISTS product_id uuid NULL;

-- 2. 외래키 제약조건 추가 (존재 여부 확인 후)
-- client_id 외래키
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'absorption_analysis_client_id_fkey'
    ) THEN
        ALTER TABLE public.absorption_analysis 
        ADD CONSTRAINT absorption_analysis_client_id_fkey 
        FOREIGN KEY (client_id) REFERENCES clients(id);
    END IF;
END $$;

-- product_id 외래키
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'absorption_analysis_product_id_fkey'
    ) THEN
        ALTER TABLE public.absorption_analysis 
        ADD CONSTRAINT absorption_analysis_product_id_fkey 
        FOREIGN KEY (product_id) REFERENCES products(id);
    END IF;
END $$;

-- company_id 외래키
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'absorption_analysis_company_id_fkey'
    ) THEN
        ALTER TABLE public.absorption_analysis 
        ADD CONSTRAINT absorption_analysis_company_id_fkey 
        FOREIGN KEY (company_id) REFERENCES companies(id);
    END IF;
END $$;

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

-- 5. company_id 기본값 제거 (존재하는 경우)
DO $$ 
BEGIN
    BEGIN
        ALTER TABLE public.absorption_analysis 
        ALTER COLUMN company_id DROP DEFAULT;
    EXCEPTION 
        WHEN OTHERS THEN 
            -- 기본값이 없으면 무시
            NULL;
    END;
END $$;

-- 6. 현재 상태 확인
SELECT 
    'Data Status Check' as info,
    COUNT(*) as total_records,
    COUNT(company_id) as records_with_company_id,
    COUNT(client_id) as records_with_client_id,
    COUNT(product_id) as records_with_product_id
FROM public.absorption_analysis; 