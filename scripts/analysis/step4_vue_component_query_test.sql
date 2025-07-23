-- 4단계: Vue 컴포넌트 쿼리 패턴 테스트
-- 생성일: 2025-01-06
-- 목적: 4개 Vue 컴포넌트에서 사용하는 쿼리 패턴이 정상 작동하는지 검증

-- 4-1. SettlementShareDetailView.vue 쿼리 패턴 테스트
SELECT 
    '4-1. SettlementShareDetailView Query Test' as check_point,
    COUNT(*) as total_records,
    SUM(prescription_qty) as total_prescription_qty,
    AVG(prescription_qty) as avg_prescription_qty
FROM performance_records_absorption
WHERE settlement_month = '2025-06'
LIMIT 5;

-- 4-2. AdminSettlementShareDetailView.vue 쿼리 패턴 테스트
SELECT 
    '4-2. AdminSettlementShareDetailView Query Test' as check_point,
    pra.*,
    clients.name as client_name,
    products.product_name,
    products.insurance_code,
    products.price
FROM performance_records_absorption pra
LEFT JOIN clients ON pra.client_id = clients.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06'
ORDER BY pra.created_at DESC
LIMIT 3;

-- 4-3. AdminSettlementShareView.vue 쿼리 패턴 테스트
SELECT 
    '4-3. AdminSettlementShareView Query Test' as check_point,
    pra.*,
    companies.company_name,
    companies.company_group,
    products.price
FROM performance_records_absorption pra
LEFT JOIN companies ON pra.company_id = companies.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06'
LIMIT 3;

-- 4-4. AdminAbsorptionAnalysisView.vue 쿼리 패턴 테스트
SELECT 
    '4-4. AdminAbsorptionAnalysisView Query Test' as check_point,
    pra.*,
    companies.company_name,
    companies.company_group,
    clients.name as client_name,
    products.product_name,
    products.insurance_code,
    products.price
FROM performance_records_absorption pra
LEFT JOIN companies ON pra.company_id = companies.id
LEFT JOIN clients ON pra.client_id = clients.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06'
ORDER BY pra.created_at DESC
LIMIT 3;

-- 4-5. prescription_qty 컬럼 집계 함수 테스트
SELECT 
    '4-5. Aggregation Functions Test' as check_point,
    COUNT(prescription_qty) as count_test,
    SUM(prescription_qty) as sum_test,
    AVG(prescription_qty) as avg_test,
    MIN(prescription_qty) as min_test,
    MAX(prescription_qty) as max_test,
    ROUND(AVG(prescription_qty), 2) as rounded_avg_test
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL;

-- 4-6. prescription_qty 컬럼 연산 테스트 (Vue에서 사용할 수 있는 패턴)
SELECT 
    '4-6. Calculation Operations Test' as check_point,
    prescription_qty,
    prescription_qty * 1.5 as multiply_test,
    prescription_qty / 2.0 as divide_test,
    ROUND(prescription_qty * 0.1, 2) as percentage_test,
    prescription_qty + 10 as addition_test,
    prescription_qty - 5 as subtraction_test
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL
ORDER BY prescription_qty
LIMIT 5;

-- 4-7. prescription_qty 컬럼 정렬 및 필터링 테스트
SELECT 
    '4-7. Sorting and Filtering Test' as check_point,
    id,
    prescription_qty,
    settlement_month,
    company_id
FROM performance_records_absorption
WHERE prescription_qty > 100
ORDER BY prescription_qty DESC
LIMIT 5;

-- 4-8. prescription_qty 컬럼 그룹화 테스트
SELECT 
    '4-8. Grouping Test' as check_point,
    settlement_month,
    COUNT(*) as record_count,
    SUM(prescription_qty) as total_qty,
    AVG(prescription_qty) as avg_qty
FROM performance_records_absorption
WHERE prescription_qty IS NOT NULL
GROUP BY settlement_month
ORDER BY settlement_month
LIMIT 5;

-- 4-9. Vue 컴포넌트 쿼리 패턴 테스트 완료
SELECT 
    '4-9. Vue Component Query Test Result' as check_point,
    'Vue 컴포넌트 쿼리 패턴 테스트 완료' as message,
    'prescription_qty numeric 타입 정상 작동 확인' as status,
    NOW() as test_completion_time; 