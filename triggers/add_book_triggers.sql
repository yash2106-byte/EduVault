-- TRIGGER 5 — AUTO INCREASE STOCK WHEN NEW PURCHASE ADDED
CREATE OR REPLACE FUNCTION fn_update_stock_on_purchase()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.item_type = 'Book' THEN
        UPDATE book
        SET stock_quantity     = stock_quantity     + NEW.quantity,
            available_quantity = available_quantity + NEW.quantity
        WHERE book_id = NEW.item_id;

        RAISE NOTICE 'Stock updated for book ID % after purchase.', NEW.item_id;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_stock_on_purchase
AFTER INSERT ON purchases
FOR EACH ROW EXECUTE FUNCTION fn_update_stock_on_purchase();

-- --------------------------------------------------------

-- TRIGGER 6 — AUTO DECREASE STOCK WHEN DISPOSAL ADDED
CREATE OR REPLACE FUNCTION fn_update_stock_on_disposal()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_current_stock INT;
BEGIN
    IF NEW.item_type = 'Book' THEN
        SELECT stock_quantity INTO v_current_stock
        FROM book WHERE book_id = NEW.item_id;

        IF v_current_stock < NEW.quantity THEN
            RAISE EXCEPTION 'Cannot dispose % copies. Only % in stock.',
                              NEW.quantity, v_current_stock;
        END IF;

        UPDATE book
        SET stock_quantity     = stock_quantity     - NEW.quantity,
            available_quantity = available_quantity - NEW.quantity
        WHERE book_id = NEW.item_id;

        RAISE NOTICE '% copies of book ID % marked as disposed.',
                      NEW.quantity, NEW.item_id;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_stock_on_disposal
AFTER INSERT ON disposal
FOR EACH ROW EXECUTE FUNCTION fn_update_stock_on_disposal();