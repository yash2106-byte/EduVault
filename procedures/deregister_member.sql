CREATE OR REPLACE PROCEDURE deregister_member(p_member_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- CHECK IF MEMBER EXISTS
    IF NOT EXISTS (SELECT 1 FROM member WHERE member_id = p_member_id) THEN
        RAISE EXCEPTION 'Member ID % not found.', p_member_id;
    END IF;

    -- BLOCK DEREGISTRATION IF MEMBER HAS UNRETURNED BOOKS
    IF EXISTS (
        SELECT 1 FROM issue
        WHERE member_id = p_member_id AND status = 'Issued'
    ) THEN
        RAISE EXCEPTION 'Member % has unreturned books. Cannot deregister.', p_member_id;
    END IF;

    -- BLOCK DEREGISTRATION IF MEMBER HAS UNPAID FINES
    IF EXISTS (
        SELECT 1 FROM fine
        WHERE member_id = p_member_id AND payment_status = 'Pending'
    ) THEN
        RAISE EXCEPTION 'Member % has unpaid fines. Cannot deregister.', p_member_id;
    END IF;
    -- if all the conditions are not satified then only the member will be deregistered
    UPDATE member
    SET membership_status = 'Deregistered'
    WHERE member_id = p_member_id;

    RAISE NOTICE 'Member ID % has been deregistered.', p_member_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;