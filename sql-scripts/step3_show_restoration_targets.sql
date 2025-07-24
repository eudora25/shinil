-- 3단계: 복원 대상 34개 레코드 확인
-- 목적: 실제 복원해야 할 데이터 내용 확인

SELECT 
    '3. Restoration Target Records (34개)' as step,
    pr.id,
    pr.prescription_qty as original_value,
    pra.prescription_qty as current_value,
    pr.prescription_qty - pra.prescription_qty as lost_decimal,
    pr.settlement_month,
    pr.company_id
FROM performance_records pr
JOIN performance_records_absorption pra ON pr.id = pra.id
WHERE pr.prescription_qty IS NOT NULL 
  AND pra.prescription_qty IS NOT NULL
  AND pr.prescription_qty != pra.prescription_qty
  AND pr.prescription_qty != FLOOR(pr.prescription_qty)  -- 원본이 소수점 있는 경우
ORDER BY pr.id; 