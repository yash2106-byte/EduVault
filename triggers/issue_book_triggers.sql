-- TRIGGER 1 — BLOCK ISSUE IF MEMBER IS NOT ACTIVE
CREATE OR REPLACE FUNCTION fn_check_member_status()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT membership_status INTO v_status
    FROM member WHERE member_id = NEW.member_id;

    IF v_status != 'Active' THEN
        RAISE EXCEPTION 'Member ID % is %. Book cannot be issued.',
                          NEW.member_id, v_status;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_member_status
BEFORE INSERT ON issue
FOR EACH ROW EXECUTE FUNCTION fn_check_member_status();

-- --------------------------------------------------------

-- TRIGGER 2 — BLOCK ISSUE IF BOOK NOT AVAILABLE
CREATE OR REPLACE FUNCTION fn_check_book_availability()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_avail INT;
BEGIN
    SELECT available_quantity INTO v_avail
    FROM book WHERE book_id = NEW.book_id;

    IF v_avail <= 0 THEN
        RAISE EXCEPTION 'Book ID % is not available. All copies are issued.',
                          NEW.book_id;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_book_availability
BEFORE INSERT ON issue
FOR EACH ROW EXECUTE FUNCTION fn_check_book_availability();

-- --------------------------------------------------------

-- TRIGGER 3 — AUTO DECREASE available_quantity ON ISSUE
CREATE OR REPLACE FUNCTION fn_decrease_available()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    UPDATE book
    SET available_quantity = available_quantity - 1
    WHERE book_id = NEW.book_id;

    RAISE NOTICE 'Available quantity decreased for book ID %.', NEW.book_id;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_decrease_available
AFTER INSERT ON issue
FOR EACH ROW EXECUTE FUNCTION fn_decrease_available();