-- 기존 테이블들의 id 컬럼 타입 확인
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('clients', 'companies', 'products', 'absorption_analysis')
AND column_name IN ('id', 'client_id', 'company_id', 'product_id')
ORDER BY table_name, column_name; 