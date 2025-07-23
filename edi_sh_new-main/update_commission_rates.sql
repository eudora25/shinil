-- 제품 테이블의 수수료율을 백분율에서 소수로 변환하는 SQL
-- 현재 45.0으로 저장된 값을 0.45로 변환

-- 먼저 현재 데이터 확인
SELECT 
  product_name,
  commission_rate_a,
  commission_rate_b
FROM products 
WHERE commission_rate_a > 1 OR commission_rate_b > 1
ORDER BY product_name
LIMIT 10;

-- 수수료율 일괄 변환 (1보다 큰 값들만 변환)
UPDATE products 
SET 
  commission_rate_a = commission_rate_a / 100,
  commission_rate_b = commission_rate_b / 100
WHERE 
  commission_rate_a > 1 OR commission_rate_b > 1;

-- 변환 결과 확인
SELECT 
  product_name,
  commission_rate_a,
  commission_rate_b
FROM products 
ORDER BY product_name
LIMIT 10; 