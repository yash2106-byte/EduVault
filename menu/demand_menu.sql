\echo ''
\echo '------- DEMANDS AND PURCHASES --------'
\echo '1. Raise New Demand'
\echo '2. Approve Demand'
\echo '3. View All Demands'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' dem_choice

SELECT
    :'dem_choice' = '1' AS do_raise,
    :'dem_choice' = '2' AS do_approve,
    :'dem_choice' = '3' AS do_viewall,
    :'dem_choice' = '0' AS do_back
\gset

\if :do_raise
    \prompt 'Member ID  : ' p_mid
    \prompt 'Item Type (Book/Journal/Periodical): ' p_type
    \prompt 'Title      : ' p_title
    \prompt 'Author     : ' p_author
    \prompt 'Publisher  : ' p_pub
    \prompt 'Quantity   : ' p_qty
    CALL raise_demand(:p_mid, :'p_type', :'p_title',
                      :'p_author', :'p_pub', :p_qty);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/demand_menu.sql'

\elif :do_approve
    \prompt 'Demand ID : ' p_did
    \prompt 'Vendor    : ' p_vendor
    \prompt 'Amount    : ' p_amount
    CALL approve_demand(:p_did, :'p_vendor', :p_amount);
    \i 'C:/Users/YASH/Desktop/dbms project/menu/demand_menu.sql'

\elif :do_viewall
    SELECT d.demand_id, m.name AS member, d.item_type,
           d.title, d.quantity, d.demand_date, d.status
    FROM demands d
    JOIN member m ON d.member_id = m.member_id
    ORDER BY d.demand_id;
    \i 'C:/Users/YASH/Desktop/dbms project/menu/demand_menu.sql'

\elif :do_back
    \i 'C:/Users/YASH/Desktop/dbms project/sql/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/demand_menu.sql'
\endif