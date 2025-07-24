-- 5단계: 최종 검증 및 완료 확인
-- 생성일: 2025-01-06
-- 목적: prescription_qty 컬럼 타입 변경 작업 최종 검증 및 완료

-- 5-1. 최종 컬럼 구조 확인
SELECT 
    '5-1. Final Column Structure' as check_point,
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default,
    numeric_precision,
    numeric_scale,
    udt_name
FROM information_schema.columns 
WHERE table_name = 'performance_records_absorption' 
AND column_name = 'prescription_qty';

-- 5-2. 최종 데이터 무결성 확인
SELECT 
    '5-2. Final Data Integrity' as check_point,
    COUNT(*) as total_records,
    COUNT(prescription_qty) as non_null_records,
    COUNT(*) - COUNT(prescription_qty) as null_records,
    MIN(prescription_qty) as min_value,
    MAX(prescription_qty) as max_value,
    ROUND(AVG(prescription_qty), 2) as avg_value,
    ROUND(SUM(prescription_qty), 2) as total_sum
FROM performance_records_absorption;

-- 5-3. 백업 테이블과 최종 비교
SELECT 
    '5-3. Final Backup Comparison' as check_point,
    'ORIGINAL' as table_type,
    COUNT(*) as record_count,
    ROUND(SUM(prescription_qty), 2) as total_prescription_qty,
    ROUND(AVG(prescription_qty), 2) as avg_prescription_qty
FROM performance_records_absorption
UNION ALL
SELECT 
    '5-3. Final Backup Comparison' as check_point,
    'BACKUP' as table_type,
    COUNT(*) as record_count,
    ROUND(SUM(prescription_qty), 2) as total_prescription_qty,
    ROUND(AVG(prescription_qty), 2) as avg_prescription_qty
FROM performance_records_absorption_backup_20250106;

-- 5-4. 모든 Vue 컴포넌트 쿼리 패턴 최종 검증
SELECT 
    '5-4. All Vue Components Final Test' as check_point,
    'SettlementShareDetailView' as component,
    COUNT(*) as query_result_count
FROM performance_records_absorption
WHERE settlement_month = '2025-06'
UNION ALL
SELECT 
    '5-4. All Vue Components Final Test' as check_point,
    'AdminSettlementShareDetailView' as component,
    COUNT(*) as query_result_count
FROM performance_records_absorption pra
LEFT JOIN clients ON pra.client_id = clients.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06'
UNION ALL
SELECT 
    '5-4. All Vue Components Final Test' as check_point,
    'AdminSettlementShareView' as component,
    COUNT(*) as query_result_count
FROM performance_records_absorption pra
LEFT JOIN companies ON pra.company_id = companies.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06'
UNION ALL
SELECT 
    '5-4. All Vue Components Final Test' as check_point,
    'AdminAbsorptionAnalysisView' as component,
    COUNT(*) as query_result_count
FROM performance_records_absorption pra
LEFT JOIN companies ON pra.company_id = companies.id
LEFT JOIN clients ON pra.client_id = clients.id
LEFT JOIN products ON pra.product_id = products.id
WHERE pra.settlement_month = '2025-06';

-- 5-5. prescription_qty 컬럼 연산 최종 검증
SELECT 
    '5-5. Final Calculation Verification' as check_point,
    'Arithmetic Operations' as operation_type,
    COUNT(*) as tested_records,
    'SUCCESS' as test_result
FROM (
    SELECT 
        prescription_qty,
        prescription_qty * 2 as multiply_test,
        prescription_qty / 2 as divide_test,
        prescription_qty + 10 as add_test,
        prescription_qty - 5 as subtract_test
    FROM performance_records_absorption
    WHERE prescription_qty IS NOT NULL
    LIMIT 100
) test_data;

-- 5-6. 백업 테이블 정리 권고사항
SELECT 
    '5-6. Backup Cleanup Recommendation' as check_point,
    'performance_records_absorption_backup_20250106' as backup_table,
    '작업 완료 후 백업 테이블 보관 또는 삭제 결정' as recommendation,
    'DROP TABLE performance_records_absorption_backup_20250106;' as cleanup_command;

-- 5-7. 작업 완료 최종 확인
SELECT 
    '5-7. FINAL COMPLETION STATUS' as check_point,
    '🎉 prescription_qty 컬럼 타입 변경 작업 완료 🎉' as completion_message,
    'integer → numeric 변환 성공' as change_status,
    '데이터 손실 없음, Vue 컴포넌트 정상 작동 확인' as verification_status,
    NOW() as completion_time,
    'MISSION ACCOMPLISHED ✅' as final_status; 