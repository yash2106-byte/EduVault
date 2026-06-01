\if :do_raise
    \prompt 'Member ID  : ' p_mid
    \prompt 'Item Type (Book/Journal/Periodical): ' p_type
    \prompt 'Title      : ' p_title
    \prompt 'Author     : ' p_author
    \prompt 'Publisher  : ' p_pub
    \prompt 'Quantity   : ' p_qty
    CALL raise_demand(:p_mid, :'p_type', :'p_title',
                      :'p_author', :'p_pub', :p_qty);
    \ir demand_menu.sql

\elif :do_approve
    \prompt 'Demand ID : ' p_did
    \prompt 'Vendor    : ' p_vendor
    \prompt 'Amount    : ' p_amount
    CALL approve_demand(:p_did, :'p_vendor', :p_amount);
    \ir demand_menu.sql

\elif :do_viewall
    SELECT d.demand_id, m.name AS member, d.item_type,
           d.title, d.quantity, d.demand_date, d.status
    FROM demands d
    JOIN member m ON d.member_id = m.member_id
    ORDER BY d.demand_id;
    \ir demand_menu.sql

\elif :do_back
    \ir ../sql/menu.sql

\else
    \echo 'Invalid choice.'
    \ir demand_menu.sql
\endif