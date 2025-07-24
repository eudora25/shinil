-- settlement_share 테이블에 (settlement_month, company_id) 복합 유니크 제약조건 추가
-- 개발 서버에서 실행하여 운영 서버와 동일한 구조로 만들기

-- 1. 기존 제약조건 확인
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    tc.constraint_type
FROM 
    information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu 
        ON tc.constraint_name = kcu.constraint_name
WHERE 
    tc.table_name = 'settlement_share'
    AND tc.constraint_type = 'UNIQUE';

-- 2. 복합 유니크 제약조건 추가
ALTER TABLE settlement_share 
ADD CONSTRAINT settlement_share_settlement_month_company_id_unique 
UNIQUE (settlement_month, company_id);

-- 3. 제약조건이 제대로 추가되었는지 확인
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    tc.constraint_type
FROM 
    information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu 
        ON tc.constraint_name = kcu.constraint_name
WHERE 
    tc.table_name = 'settlement_share'
    AND tc.constraint_type = 'UNIQUE'
ORDER BY tc.constraint_name, kcu.ordinal_position; 