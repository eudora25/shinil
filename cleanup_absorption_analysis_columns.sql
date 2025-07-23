-- absorption_analysis 테이블에서 불필요한 컬럼 제거
-- ⚠️ 주의: ID 컬럼들이 정상 작동하는 것을 확인 후에 실행하세요!

-- 1. 중복 데이터 컬럼들 제거 (JOIN으로 대체 가능)
-- ALTER TABLE public.absorption_analysis DROP COLUMN IF EXISTS client_name;
-- ALTER TABLE public.absorption_analysis DROP COLUMN IF EXISTS product_name;  
-- ALTER TABLE public.absorption_analysis DROP COLUMN IF EXISTS insurance_code;
-- ALTER TABLE public.absorption_analysis DROP COLUMN IF EXISTS price;

-- 2. 유지해야 할 컬럼들
-- ✅ commission_rate (수정 가능해야 함)
-- ✅ company_name (성능상 유지)
-- ✅ settlement_month, prescription_month (필수)
-- ✅ prescription_qty, prescription_amount (필수)
-- ✅ payment_amount, wholesale_sales, direct_sales (필수)

-- 현재 최종 테이블 구조 확인
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'absorption_analysis' 
ORDER BY ordinal_position; 