--  LIBRARY PORTAL — INTERACTIVE MENU


\echo '=============================================='
\echo '        WELCOME TO LIBRARY PORTAL            '
\echo '=============================================='
\echo ''
\echo '1. Member Management'
\echo '2. Book Management'
\echo '3. Issue and Return'
\echo '4. Demands and Purchases'
\echo '5. Fines'
\echo '6. Notices and Announcements'
\echo '7. Complaints'
\echo '8. Reports'
\echo '0. Exit'
\echo ''

\prompt 'Enter your choice: ' main_choice

\if :main_choice = '1'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/member_menu.sql'
\elif :main_choice = '2'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/book_menu.sql'
\elif :main_choice = '3'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/issue_menu.sql'
\elif :main_choice = '4'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/demand_menu.sql'
\elif :main_choice = '5'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/fine_menu.sql'
\elif :main_choice = '6'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/notice_menu.sql'
\elif :main_choice = '7'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/complaint_menu.sql'
\elif :main_choice = '8'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menus/reports_menu.sql'
\elif :main_choice = '0'
    \echo 'Goodbye! Thank you for using Library Portal.'
\else
    \echo 'Invalid choice. Please run menu.sql again.'
\endif