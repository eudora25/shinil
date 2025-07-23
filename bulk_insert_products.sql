-- 제품 일괄 등록 SQL
-- 수수료율은 백분율로 입력하되 소수로 저장 (예: 45.0 입력 시 0.45로 저장)

INSERT INTO products (
  base_month,
  product_name,
  insurance_code,
  price,
  commission_rate_a,
  commission_rate_b,
  standard_code,
  unit_packaging_desc,
  unit_quantity,
  status,
  remarks
) VALUES
-- 예시 데이터 (실제 데이터로 교체하세요)
('2025-05', '네오민정 80mg', 653803180, 525, 48.0/100, 48.0/100, '8806538031835', '100정/PTP', 1, 'active', ''),
('2025-05', '가모렌정 5mg', 653800020, 103, 43.0/100, 45.0/100, '8806538000206', '소화', 1, 'active', ''),
('2025-05', '네오스틴정40/10mg', 653805340, 648, 50.0/100, 50.0/100, '8806538053400', '100정/병', 1, 'active', ''),
('2025-05', '네오민정 160mg', 653806240, 898, 48.0/100, 48.0/100, '8806538062426', '100정/병', 30, 'active', ''),
('2025-05', '그리벤-에스정 300mg', 653800060, 115, 30.0/100, 35.0/100, '8806538000602', '500정/병', 28, 'active', ''),
('2025-05', '네오스틴정40/5mg', 653805360, 600, 50.0/100, 50.0/100, '8806538053615', '30정/PTP', 30, 'active', ''),
('2025-05', '네오스틴정80/5mg', 653805350, 725, 50.0/100, 50.0/100, '8806538053530', '100정/병', 10, 'active', '');

-- 등록 결과 확인
SELECT 
  base_month,
  product_name,
  insurance_code,
  price,
  commission_rate_a,
  commission_rate_b,
  standard_code,
  status
FROM products 
WHERE base_month = '2025-05'
ORDER BY product_name; 