CREATE OR REPLACE PROCEDURE raise_complaint(
    p_member_id   INT,
    p_category    VARCHAR,
    p_description TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM member WHERE member_id = p_member_id
    ) THEN
        RAISE EXCEPTION 'Member ID % not found.', p_member_id;
    END IF;

    INSERT INTO complaint (member_id, category, description,
                           complaint_date, status)
    VALUES (p_member_id, p_category, p_description,
            CURRENT_DATE, 'Open');

    RAISE NOTICE 'Complaint registered successfully for member %.', p_member_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;