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

SELECT
    :'main_choice' = '1' AS go_member,
    :'main_choice' = '2' AS go_book,
    :'main_choice' = '3' AS go_issue,
    :'main_choice' = '4' AS go_demand,
    :'main_choice' = '5' AS go_fine,
    :'main_choice' = '6' AS go_notice,
    :'main_choice' = '7' AS go_complaint,
    :'main_choice' = '8' AS go_reports,
    :'main_choice' = '0' AS go_exit
\gset

\if :go_member
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'
\elif :go_book
    \i 'C:/Users/YASH/Desktop/dbms project/menu/book_menu.sql'
\elif :go_issue
    \i 'C:/Users/YASH/Desktop/dbms project/menu/issue_menu.sql'
\elif :go_demand
    \i 'C:/Users/YASH/Desktop/dbms project/menu/demand_menu.sql'
\elif :go_fine
    \i 'C:/Users/YASH/Desktop/dbms project/menu/fine_menu.sql'
\elif :go_notice
    \i 'C:/Users/YASH/Desktop/dbms project/menu/notice_menu.sql'
\elif :go_complaint
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'
\elif :go_reports
    \i 'C:/Users/YASH/Desktop/dbms project/menu/reports_menu.sql'
\elif :go_exit
    \echo 'Goodbye! Thank you for using Library Portal.'
\else
    \echo 'Invalid choice. Run menu.sql again.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/menu.sql'
\endif