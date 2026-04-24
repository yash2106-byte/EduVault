MEMBER 1 ISSUED ON 2024-03-03, DUE 2024-03-31
TODAY IS 2026, SO HEAVILY OVERDUE
SELECT calculate_fine(1001);   -- should return a large amount

-- CHECK MANUALLY
SELECT CURRENT_DATE - DATE '2024-03-31' AS overdue_days,
       (CURRENT_DATE - DATE '2024-03-31') * 2 AS expected_fine;

