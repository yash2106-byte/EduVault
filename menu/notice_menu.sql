\echo ''
\echo '------ NOTICES AND ANNOUNCEMENTS -----'
\echo '1. Post New Notice'
\echo '2. View Active Notices'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' not_choice

SELECT
    :'not_choice' = '1' AS do_post,
    :'not_choice' = '2' AS do_viewall,
    :'not_choice' = '0' AS do_back
\gset

\if :do_post
    \prompt 'Title      : ' p_title
    \prompt 'Content    : ' p_content
    \prompt 'Type (General/Holiday/Event/Rule/Urgent): ' p_type
    \prompt 'Expiry Date (YYYY-MM-DD or press Enter to skip): ' p_exp
    CALL add_notice(:'p_title', :'p_content', :'p_type',
                    NULLIF(:'p_exp', '')::DATE);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/notice_menu.sql'

\elif :do_viewall
    SELECT notice_id, title, notice_type,
           posted_date, expiry_date, status
    FROM notice
    WHERE status = 'Active'
    ORDER BY posted_date DESC;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/notice_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/notice_menu.sql'
\endif