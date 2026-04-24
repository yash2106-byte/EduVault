CREATE OR REPLACE PROCEDURE pay_fine(p_fine_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status    VARCHAR(20);
    v_amount    DECIMAL(8,2);
    v_member_id INT;
BEGIN
    SELECT payment_status, fine_amount, member_id
    INTO v_status, v_amount, v_member_id
    FROM fine
    WHERE fine_id = p_fine_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Fine ID % not found.', p_fine_id;
    END IF;

    IF v_status = 'Paid' THEN
        RAISE EXCEPTION 'Fine ID % is already paid.', p_fine_id;
    END IF;

    IF v_status = 'Waived' THEN
        RAISE EXCEPTION 'Fine ID % has been waived. No payment needed.', p_fine_id;
    END IF;

    UPDATE fine
    SET payment_status = 'Paid',
        payment_date   = CURRENT_DATE
    WHERE fine_id = p_fine_id;

    RAISE NOTICE 'Fine ID % paid. Amount Rs. % collected from member %.', 
                  p_fine_id, v_amount, v_member_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;