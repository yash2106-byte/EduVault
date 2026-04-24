CREATE OR REPLACE PROCEDURE raise_demand(
    p_member_id  INT,
    p_item_type  VARCHAR,
    p_title      VARCHAR,
    p_author     VARCHAR,
    p_publisher  VARCHAR,
    p_quantity   INT DEFAULT 1
)
LANGUAGE plpgsql AS $$
BEGIN
    -- CHECK MEMBER EXISTS AND IS ACTIVE
    IF NOT EXISTS (
        SELECT 1 FROM member
        WHERE member_id = p_member_id
        AND membership_status = 'Active'
    ) THEN
        RAISE EXCEPTION 'Member ID % not found or not Active.', p_member_id;
    END IF;

    INSERT INTO demands (member_id, item_type, title, author,
                         publisher, quantity, demand_date, status)
    VALUES (p_member_id, p_item_type, p_title, p_author,
            p_publisher, p_quantity, CURRENT_DATE, 'Pending');

    RAISE NOTICE 'Demand raised successfully for "%" by member %.',
                  p_title, p_member_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;