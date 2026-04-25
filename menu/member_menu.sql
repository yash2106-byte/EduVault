\echo ''
\echo '-------- MEMBER MANAGEMENT ----------'
\echo '1. Register New Member'
\echo '2. Deregister Member'
\echo '3. View All Members'
\echo '4. Search Member by ID'
\echo '0. Back'
\echo ''

\prompt 'Enter choice: ' mem_choice

\if :mem_choice = '1'
    \prompt 'Member ID    : ' p_mid
    \prompt 'Name         : ' p_name
    \prompt 'Phone        : ' p_phone
    \prompt 'Email        : ' p_email
    \prompt 'Department   : ' p_dept
    \prompt 'Semester     : ' p_sem
    CALL register_member(:p_mid, :'p_name', :'p_phone', :'p_email', :'p_dept', :p_sem, CURRENT_DATE);

\elif :mem_choice = '2'
    \prompt 'Member ID to deregister: ' p_mid
    CALL deregister_member(:p_mid);

\elif :mem_choice = '3'
    SELECT member_id, name, department, semester, phone, membership_status
    FROM member ORDER BY member_id;

\elif :mem_choice = '4'
    \prompt 'Enter Member ID: ' p_mid
    SELECT member_id, name, phone, email, department, semester,
           membership_date, membership_status
    FROM member WHERE member_id = :p_mid;

\elif :mem_choice = '0'
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
\endif