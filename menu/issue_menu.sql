\echo ''
\echo '---------- ISSUE AND RETURN ----------'
\echo '1. Issue Book'
\echo '2. Return Book'
\echo '3. View Active Issues'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' iss_choice

SELECT
    :'iss_choice' = '1' AS do_issue,
    :'iss_choice' = '2' AS do_return,
    :'iss_choice' = '3' AS do_viewall,
    :'iss_choice' = '0' AS do_back
\gset

\if :do_issue
    \prompt 'Member ID             : ' p_mid
    \prompt 'Book ID               : ' p_bid
    \prompt 'Due Date (YYYY-MM-DD) : ' p_due
    CALL issue_book(:p_mid, :p_bid, :'p_due'::DATE);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/issue_menu.sql'

\elif :do_return
    \prompt 'Issue ID: ' p_iid
    CALL return_book(:p_iid);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/issue_menu.sql'

\elif :do_viewall
    SELECT i.issue_id, m.name AS member, b.title AS book,
           i.issue_date, i.due_date,
           (CURRENT_DATE - i.due_date) AS days_overdue
    FROM issue i
    JOIN member m ON i.member_id = m.member_id
    JOIN book   b ON i.book_id   = b.book_id
    WHERE i.status = 'Issued'
    ORDER BY days_overdue DESC;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/issue_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/issue_menu.sql'
\endif