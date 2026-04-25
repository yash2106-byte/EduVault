\echo ''
\echo '-------------- FINES ----------------'
\echo '1. View All Pending Fines'
\echo '2. Pay Fine'
\echo '3. Calculate Fine for Issue'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' fine_choice

SELECT
    :'fine_choice' = '1' AS do_viewall,
    :'fine_choice' = '2' AS do_pay,
    :'fine_choice' = '3' AS do_calc,
    :'fine_choice' = '0' AS do_back
\gset

\if :do_viewall
    SELECT f.fine_id, m.name AS member,
           f.overdue_days, f.fine_amount, f.payment_status
    FROM fine f
    JOIN member m ON f.member_id = m.member_id
    WHERE f.payment_status = 'Pending'
    ORDER BY f.fine_amount DESC;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/fine_menu.sql'

\elif :do_pay
    \prompt 'Fine ID to pay: ' p_fid
    CALL pay_fine(:p_fid);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/fine_menu.sql'

\elif :do_calc
    \prompt 'Issue ID: ' p_iid
    SELECT calculate_fine(:p_iid) AS estimated_fine;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/fine_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/fine_menu.sql'
\endif