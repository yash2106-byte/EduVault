-- TThis is a function (not procedure) because it returns a value — the fine amount.

CREATE OR REPLACE FUNCTION calculate_fine(p_issue_id INT)
RETURNS DECIMAL(8,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_due_date    DATE;
    v_return_date DATE;
    v_overdue     INT;
    v_fine        DECIMAL(8,2);
    v_rate        DECIMAL(5,2) := 2.00;  -- RS. 2 PER OVERDUE DAY
BEGIN
    SELECT due_date, return_date
    INTO v_due_date, v_return_date
    FROM issue
    WHERE issue_id = p_issue_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Issue ID % not found.', p_issue_id;
    END IF;

    -- IF NOT YET RETURNED, CALCULATE AGAINST TODAY
    IF v_return_date IS NULL THEN
        v_overdue := GREATEST(0, CURRENT_DATE - v_due_date);
    ELSE
        v_overdue := GREATEST(0, v_return_date - v_due_date);
    END IF;

    v_fine := v_overdue * v_rate;

    RETURN v_fine;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in calculate_fine: %', SQLERRM;
        RETURN 0;
END;
$$;