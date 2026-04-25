\echo ''
\echo '------------- COMPLAINTS -------------'
\echo '1. Raise New Complaint'
\echo '2. Resolve Complaint'
\echo '3. View All Complaints'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' comp_choice

SELECT
    :'comp_choice' = '1' AS do_raise,
    :'comp_choice' = '2' AS do_resolve,
    :'comp_choice' = '3' AS do_viewall,
    :'comp_choice' = '0' AS do_back
\gset

\if :do_raise
    \prompt 'Member ID   : ' p_mid
    \prompt 'Category (Damaged Book/Missing Item/Fine Dispute/Facility/Other): ' p_cat
    \prompt 'Description : ' p_desc
    CALL raise_complaint(:p_mid, :'p_cat', :'p_desc');
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'

\elif :do_resolve
    \prompt 'Complaint ID : ' p_cid
    \prompt 'Resolution   : ' p_res
    CALL resolve_complaint(:p_cid, :'p_res');
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'

\elif :do_viewall
    SELECT c.complaint_id, m.name AS member,
           c.category, c.complaint_date,
           c.status, c.resolution
    FROM complaint c
    JOIN member m ON c.member_id = m.member_id
    ORDER BY c.complaint_id;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'
\endif