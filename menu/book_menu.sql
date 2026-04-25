\echo ''
\echo '---------- BOOK MANAGEMENT ----------'
\echo '1. Add New Book'
\echo '2. View All Books'
\echo '3. Search Book by ID'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' book_choice

SELECT
    :'book_choice' = '1' AS do_add,
    :'book_choice' = '2' AS do_viewall,
    :'book_choice' = '3' AS do_search,
    :'book_choice' = '0' AS do_back
\gset

\if :do_add
    \prompt 'Book ID    : ' p_bid
    \prompt 'Title      : ' p_title
    \prompt 'Author     : ' p_author
    \prompt 'Category   : ' p_cat
    \prompt 'ISBN       : ' p_isbn
    \prompt 'Publisher  : ' p_pub
    \prompt 'Quantity   : ' p_qty
    CALL add_book(:p_bid, :'p_title', :'p_author',
                  :'p_cat', :'p_isbn', :'p_pub', :p_qty);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'

\elif :do_viewall
    SELECT book_id, title, author, category,
           stock_quantity, available_quantity
    FROM book ORDER BY book_id;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'

\elif :do_search
    \prompt 'Enter Book ID: ' p_bid
    SELECT book_id, title, author, category,
           isbn, publisher, stock_quantity, available_quantity
    FROM book WHERE book_id = :p_bid;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'

\endif