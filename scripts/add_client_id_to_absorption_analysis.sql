-- absorption_analysis 테이블에 client_id 컬럼 추가
ALTER TABLE public.absorption_analysis 
ADD COLUMN client_id uuid NULL;

-- clients 테이블과의 외래키 제약조건 추가
ALTER TABLE public.absorption_analysis 
ADD CONSTRAINT absorption_analysis_client_id_fkey 
FOREIGN KEY (client_id) REFERENCES clients(id);

-- client_id 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_absorption_analysis_client_id 
ON public.absorption_analysis USING btree (client_id);

-- 기존 데이터가 있다면 client_name을 기반으로 client_id 업데이트
UPDATE public.absorption_analysis 
SET client_id = clients.id 
FROM clients 
WHERE absorption_analysis.client_name = clients.name; 