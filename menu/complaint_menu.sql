\echo ''
\echo '------------- COMPLAINTS -------------'
\echo '1. Raise New Complaint'
\echo '2. Resolve Complaint'
\echo '3. View All Complaints'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' comp_choice

\if :'comp_choice' = '1'
    \prompt 'Member ID   : ' p_mid
    \prompt 'Category (Damaged Book/Missing Item/Fine Dispute/Facility/Other): ' p_cat
    \prompt 'Description : ' p_desc
    CALL raise_complaint(:p_mid, :'p_cat', :'p_desc');

\elif :'comp_choice' = '2'
    \prompt 'Complaint ID : ' p_cid
    \prompt 'Resolution   : ' p_res
    CALL resolve_complaint(:p_cid, :'p_res');

\elif :'comp_choice' = '3'
    SELECT c.complaint_id, m.name AS member,
           c.category, c.complaint_date,
           c.status, c.resolution
    FROM complaint c
    JOIN member m ON c.member_id = m.member_id
    ORDER BY c.complaint_id;

\elif :'comp_choice' = '0'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/complaint_menu.sql'
\endif