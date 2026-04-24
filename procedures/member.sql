--You write this header to define a reusable database function-like block that accepts inputs and performs a specific task (like inserting a member), think of it as a java function which will create or overwrite that function
CREATE OR REPLACE PROCEDURE register_member(
    p_member_id       INT,
    p_name            VARCHAR,
    p_phone           VARCHAR,
    p_email           VARCHAR,
    p_department      VARCHAR,
    p_semester        INT,
    p_membership_date DATE
)

LANGUAGE plpgsql
AS $$
BEGIN
    -- CHECK IF MEMBER ALREADY EXISTS
    IF EXISTS (SELECT 1 FROM member WHERE member_id = p_member_id) THEN
        RAISE EXCEPTION 'Member ID % already exists.', p_member_id;
    END IF;

    -- CHECK IF PHONE OR EMAIL IS DUPLICATE
    IF EXISTS (SELECT 1 FROM member WHERE phone = p_phone) THEN
        RAISE EXCEPTION 'Phone number % is already registered.', p_phone;
    END IF;

    IF EXISTS (SELECT 1 FROM member WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % is already registered.', p_email;
    END IF;

    INSERT INTO member (member_id, name, phone, email, department,
                        semester, membership_date, membership_status)
    VALUES (p_member_id, p_name, p_phone, p_email, p_department,
            p_semester, p_membership_date, 'Active');

    RAISE NOTICE 'Member % registered successfully.', p_name;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;
