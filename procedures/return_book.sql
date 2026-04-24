CREATE OR REPLACE PROCEDURE return_book(p_issue_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_book_id     INT;
    v_member_id   INT;
    v_status      VARCHAR(20);
    v_due_date    DATE;
    v_overdue     INT;
    v_fine        DECIMAL(8,2);
BEGIN
    -- FETCH ISSUE DETAILS
    SELECT book_id, member_id, status, due_date
    INTO v_book_id, v_member_id, v_status, v_due_date
    FROM issue
    WHERE issue_id = p_issue_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Issue ID % not found.', p_issue_id;
    END IF;

    -- CHECK IF ALREADY RETURNED
    IF v_status = 'Returned' THEN
        RAISE EXCEPTION 'Issue ID % is already returned.', p_issue_id;
    END IF;

    -- MARK AS RETURNED AND SET RETURN DATE
    UPDATE issue
    SET return_date = CURRENT_DATE,
        status      = 'Returned'
    WHERE issue_id = p_issue_id;

    -- INCREASE AVAILABLE QUANTITY
    UPDATE book
    SET available_quantity = available_quantity + 1
    WHERE book_id = v_book_id;

    -- CHECK IF OVERDUE
    v_overdue := GREATEST(0, CURRENT_DATE - v_due_date);

    IF v_overdue > 0 THEN
        v_fine := calculate_fine(p_issue_id);

        -- INSERT FINE RECORD ONLY IF NOT ALREADY EXISTS
        IF NOT EXISTS (
            SELECT 1 FROM fine WHERE issue_id = p_issue_id
        ) THEN
            INSERT INTO fine (issue_id, member_id, overdue_days,
                              fine_amount, payment_status)
            VALUES (p_issue_id, v_member_id, v_overdue, v_fine, 'Pending');

            RAISE NOTICE 'Book returned. Overdue by % days. Fine: Rs. %', 
                          v_overdue, v_fine;
        ELSE
            RAISE NOTICE 'Book returned. Fine record already exists.';
        END IF;

    ELSE
        RAISE NOTICE 'Book ID % returned on time by member %.', 
                      v_book_id, v_member_id;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;