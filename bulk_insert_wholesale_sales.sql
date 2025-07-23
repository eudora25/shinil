-- 도매매출(wholesale_sales) 일괄 등록 SQL

INSERT INTO wholesale_sales (
  pharmacy_name,           -- 약국명
  business_registration_number, -- 사업자번호
  address,                 -- 주소
  standard_code,           -- 표준코드
  product_name,            -- 제품명
  sales_amount,            -- 매출액
  sales_date               -- 매출일자 (YYYY-MM-DD)
) VALUES
-- 예시 데이터
('건강드림약국', '657-13-00785', '전라남도 순천시 순광로 14 (조례동)', '8806538013749', '리피칸정 10mg', 79560, '2025-03-01'),
('행복한약국', '123-45-67890', '서울시 강남구 테헤란로 123', '8806538013749', '리피칸정 10mg', 50000, '2025-03-01'),
('미래약국', '234-56-78901', '경기도 성남시 분당구 판교로 456', '8806538031835', '네오반정 80mg', 120000, '2025-03-02'),
('건강약국', '345-67-89012', '부산시 해운대구 해운대로 789', '8806538053400', '네오스타정40/10mg', 85000, '2025-03-03'),
('희망약국', '456-78-90123', '대구시 수성구 수성로 321', '8806538062426', '네오반정 160mg', 95000, '2025-03-03');

-- 등록 결과 확인
SELECT 
  pharmacy_name,
  business_registration_number,
  standard_code,
  product_name,
  sales_amount,
  sales_date
FROM wholesale_sales 
WHERE sales_date >= '2025-03-01'
ORDER BY sales_date, pharmacy_name; 