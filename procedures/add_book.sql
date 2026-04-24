CREATE OR REPLACE PROCEDURE add_book(
    p_book_id   INT,
    p_title     VARCHAR,
    p_author    VARCHAR,
    p_category  VARCHAR,
    p_isbn      VARCHAR,
    p_publisher VARCHAR,
    p_quantity  INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM book WHERE book_id = p_book_id) THEN
        RAISE EXCEPTION 'Book ID % already exists.', p_book_id;
    END IF;

    IF EXISTS (SELECT 1 FROM book WHERE isbn = p_isbn) THEN
        RAISE EXCEPTION 'ISBN % already registered.', p_isbn;
    END IF;

    INSERT INTO book (book_id, title, author, category, isbn,
                      publisher, stock_quantity, available_quantity)
    VALUES (p_book_id, p_title, p_author, p_category, p_isbn,
            p_publisher, p_quantity, p_quantity);
    -- available = stock on fresh entry, no copies issued yet

    RAISE NOTICE 'Book "%" added successfully with % copies.', p_title, p_quantity;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;