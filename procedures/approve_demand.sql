CREATE OR REPLACE PROCEDURE approve_demand(
    p_demand_id  INT,
    p_vendor     VARCHAR,
    p_amount     DECIMAL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_status    VARCHAR(20);
    v_item_type VARCHAR(20);
    v_quantity  INT;
BEGIN
    SELECT status, item_type, quantity
    INTO v_status, v_item_type, v_quantity
    FROM demands WHERE demand_id = p_demand_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Demand ID % not found.', p_demand_id;
    END IF;

    IF v_status != 'Pending' THEN
        RAISE EXCEPTION 'Demand ID % is already %. Cannot approve.',
                          p_demand_id, v_status;
    END IF;

    -- UPDATE DEMAND STATUS
    UPDATE demands
    SET status = 'Approved'
    WHERE demand_id = p_demand_id;

    -- CREATE PURCHASE RECORD
    INSERT INTO purchases (demand_id, item_type, purchase_date,
                           vendor, quantity, amount)
    VALUES (p_demand_id, v_item_type, CURRENT_DATE,
            p_vendor, v_quantity, p_amount);

    RAISE NOTICE 'Demand ID % approved. Purchase record created.', p_demand_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;