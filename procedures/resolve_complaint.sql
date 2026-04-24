CREATE OR REPLACE PROCEDURE resolve_complaint(
    p_complaint_id INT,
    p_resolution   TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT status INTO v_status
    FROM complaint WHERE complaint_id = p_complaint_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Complaint ID % not found.', p_complaint_id;
    END IF;

    IF v_status = 'Resolved' OR v_status = 'Closed' THEN
        RAISE EXCEPTION 'Complaint ID % is already %.', p_complaint_id, v_status;
    END IF;

    UPDATE complaint
    SET status        = 'Resolved',
        resolution    = p_resolution,
        resolved_date = CURRENT_DATE
    WHERE complaint_id = p_complaint_id;

    RAISE NOTICE 'Complaint ID % resolved successfully.', p_complaint_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;