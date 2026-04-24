CREATE OR REPLACE PROCEDURE issue_book(
    p_member_id INT,
    p_book_id   INT,
    p_due_date  DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(20);
    v_avail  INT;
BEGIN
    -- CHECK MEMBER EXISTS AND IS ACTIVE
    SELECT membership_status INTO v_status
    FROM member WHERE member_id = p_member_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Member ID % not found.', p_member_id;
    END IF;

    IF v_status != 'Active' THEN
        RAISE EXCEPTION 'Member ID % is %. Cannot issue book.', p_member_id, v_status;
    END IF;

    -- CHECK BOOK AVAILABILITY
    SELECT available_quantity INTO v_avail
    FROM book WHERE book_id = p_book_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Book ID % not found.', p_book_id;
    END IF;

    IF v_avail <= 0 THEN
        RAISE EXCEPTION 'No copies of book ID % available.', p_book_id;
    END IF;

    -- CHECK MEMBER DOES NOT ALREADY HAVE THIS BOOK
    IF EXISTS (
        SELECT 1 FROM issue
        WHERE member_id = p_member_id
          AND book_id = p_book_id
          AND status = 'Issued'
    ) THEN
        RAISE EXCEPTION 'Member % already has book % issued.', p_member_id, p_book_id;
    END IF;

    -- INSERT ISSUE RECORD
    INSERT INTO issue (member_id, book_id, issue_date, due_date, status)
    VALUES (p_member_id, p_book_id, CURRENT_DATE, p_due_date, 'Issued');

    -- REDUCE AVAILABLE QUANTITY
    UPDATE book
    SET available_quantity = available_quantity - 1
    WHERE book_id = p_book_id;

    RAISE NOTICE 'Book % issued to member % successfully. Due: %', p_book_id, p_member_id, p_due_date;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;