-- absorption_analysis 테이블에 product_id 컬럼 추가

-- 1. product_id 컬럼 추가
ALTER TABLE public.absorption_analysis 
ADD COLUMN product_id uuid NULL;

-- 2. products 테이블과의 외래키 제약조건 추가
ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT absorption_analysis_product_id_fkey 
FOREIGN KEY (product_id) REFERENCES products(id);

-- 3. product_id 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_product_id 
ON public.absorption_analysis USING btree (product_id);

-- 4. 기존 데이터가 있다면 product_name을 기반으로 product_id 업데이트
UPDATE public.absorption_analysis 
SET product_id = products.id 
FROM products 
WHERE absorption_analysis.product_name = products.product_name; 