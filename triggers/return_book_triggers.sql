-- TRIGGER 4 — AUTO INSERT FINE WHEN STATUS SET TO Overdue
CREATE OR REPLACE FUNCTION fn_auto_fine_on_overdue()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_overdue_days INT;
    v_fine_amount  DECIMAL(8,2);
    v_rate         DECIMAL(5,2) := 2.00;
BEGIN
    IF NEW.status = 'Overdue' AND OLD.status != 'Overdue' THEN
        v_overdue_days := GREATEST(0, CURRENT_DATE - NEW.due_date);
        v_fine_amount  := v_overdue_days * v_rate;

        IF NOT EXISTS (SELECT 1 FROM fine WHERE issue_id = NEW.issue_id) THEN
            INSERT INTO fine (issue_id, member_id, overdue_days,
                              fine_amount, payment_status)
            VALUES (NEW.issue_id, NEW.member_id,
                    v_overdue_days, v_fine_amount, 'Pending');

            RAISE NOTICE 'Fine of Rs. % auto-created for issue ID %.',
                          v_fine_amount, NEW.issue_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_auto_fine_on_overdue
AFTER UPDATE ON issue
FOR EACH ROW EXECUTE FUNCTION fn_auto_fine_on_overdue();