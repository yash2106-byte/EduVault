\echo ''
\echo '-------- MEMBER MANAGEMENT ----------'
\echo '1. Register New Member'
\echo '2. Deregister Member'
\echo '3. View All Members'
\echo '4. Search Member by ID'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' mem_choice

SELECT
    :'mem_choice' = '1' AS do_register,
    :'mem_choice' = '2' AS do_deregister,
    :'mem_choice' = '3' AS do_viewall,
    :'mem_choice' = '4' AS do_search,
    :'mem_choice' = '0' AS do_back
\gset

\if :do_register
    \prompt 'Member ID    : ' p_mid
    \prompt 'Name         : ' p_name
    \prompt 'Phone        : ' p_phone
    \prompt 'Email        : ' p_email
    \prompt 'Department   : ' p_dept
    \prompt 'Semester     : ' p_sem
    CALL register_member(:p_mid, :'p_name', :'p_phone',
                         :'p_email', :'p_dept', :p_sem, CURRENT_DATE);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'

\elif :do_deregister
    \prompt 'Member ID to deregister: ' p_mid
    CALL deregister_member(:p_mid);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'

\elif :do_viewall
    SELECT member_id, name, department, semester,
           phone, membership_status
    FROM member ORDER BY member_id;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'

\elif :do_search
    \prompt 'Enter Member ID: ' p_mid
    SELECT member_id, name, phone, email,
           department, semester, membership_status
    FROM member WHERE member_id = :p_mid;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/member_menu.sql'
\endif