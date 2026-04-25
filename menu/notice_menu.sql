\echo ''
\echo '------ NOTICES AND ANNOUNCEMENTS -----'
\echo '1. Post New Notice'
\echo '2. View Active Notices'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' not_choice

\if :'not_choice' = '1'
    \prompt 'Title      : ' p_title
    \prompt 'Content    : ' p_content
    \prompt 'Type (General/Holiday/Event/Rule/Urgent): ' p_type
    \prompt 'Expiry Date (YYYY-MM-DD or press Enter to skip): ' p_exp
    CALL add_notice(:'p_title', :'p_content', :'p_type',
                    NULLIF(:'p_exp', '')::DATE);

\elif :'not_choice' = '2'
    SELECT notice_id, title, notice_type,
           posted_date, expiry_date, status
    FROM notice
    WHERE status = 'Active'
    ORDER BY posted_date DESC;

\elif :'not_choice' = '0'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/notice_menu.sql'
\endif