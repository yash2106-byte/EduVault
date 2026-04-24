CREATE OR REPLACE PROCEDURE add_notice(
    p_title       VARCHAR,
    p_content     TEXT,
    p_notice_type VARCHAR DEFAULT 'General',
    p_expiry_date DATE    DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_expiry_date IS NOT NULL AND p_expiry_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Expiry date cannot be in the past.';
    END IF;

    INSERT INTO notice (title, content, notice_type,
                        posted_date, expiry_date, status)
    VALUES (p_title, p_content, p_notice_type,
            CURRENT_DATE, p_expiry_date, 'Active');

    RAISE NOTICE 'Notice "%" posted successfully.', p_title;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;