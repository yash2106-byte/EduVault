\echo ''
\echo '---------- BOOK MANAGEMENT ----------'
\echo '1. Add New Book'
\echo '2. View All Books'
\echo '3. Search Book by ID'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' book_choice

\if :'book_choice' = '1'
    \prompt 'Book ID    : ' p_bid
    \prompt 'Title      : ' p_title
    \prompt 'Author     : ' p_author
    \prompt 'Category   : ' p_cat
    \prompt 'ISBN       : ' p_isbn
    \prompt 'Publisher  : ' p_pub
    \prompt 'Quantity   : ' p_qty
    CALL add_book(:p_bid, :'p_title', :'p_author',
                  :'p_cat', :'p_isbn', :'p_pub', :p_qty);

\elif :'book_choice' = '2'
    SELECT book_id, title, author, category,
           stock_quantity, available_quantity
    FROM book ORDER BY book_id;

\elif :'book_choice' = '3'
    \prompt 'Enter Book ID: ' p_bid
    SELECT book_id, title, author, category,
           isbn, publisher, stock_quantity, available_quantity
    FROM book WHERE book_id = :p_bid;

\elif :'book_choice' = '0'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'
\endif