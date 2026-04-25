\echo ''
\echo '-------------- REPORTS --------------'
\echo '1. Currently Issued Books'
\echo '2. Overdue Issues with Estimated Fine'
\echo '3. Top 5 Most Borrowed Books'
\echo '4. Members with Pending Fines'
\echo '5. Book Stock Status'
\echo '6. Member Borrowing History'
\echo '7. Purchase Summary by Item Type'
\echo '0. Back to Main Menu'
\echo ''
\prompt 'Enter choice: ' rep_choice

\if :'rep_choice' = '1'
    SELECT i.issue_id, m.name, b.title,
           i.issue_date, i.due_date, i.status
    FROM issue i
    JOIN member m ON i.member_id = m.member_id
    JOIN book   b ON i.book_id   = b.book_id
    WHERE i.status = 'Issued';

\elif :'rep_choice' = '2'
    SELECT i.issue_id, m.name, b.title, i.due_date,
           (CURRENT_DATE - i.due_date)     AS overdue_days,
           (CURRENT_DATE - i.due_date) * 2 AS estimated_fine
    FROM issue i
    JOIN member m ON i.member_id = m.member_id
    JOIN book   b ON i.book_id   = b.book_id
    WHERE i.return_date IS NULL
      AND CURRENT_DATE > i.due_date;

\elif :'rep_choice' = '3'
    SELECT b.title, b.author,
           COUNT(i.issue_id) AS total_issues
    FROM book b
    LEFT JOIN issue i ON b.book_id = i.book_id
    GROUP BY b.book_id, b.title, b.author
    ORDER BY total_issues DESC LIMIT 5;

\elif :'rep_choice' = '4'
    SELECT m.name, m.phone,
           f.fine_amount, f.overdue_days, f.payment_status
    FROM fine f
    JOIN member m ON f.member_id = m.member_id
    WHERE f.payment_status = 'Pending';

\elif :'rep_choice' = '5'
    SELECT book_id, title, stock_quantity,
           available_quantity,
           CASE WHEN available_quantity = 0 THEN 'Out of Stock'
                WHEN available_quantity <= stock_quantity * 0.2
                     THEN 'Low Stock'
                ELSE 'Available'
           END AS stock_status
    FROM book ORDER BY available_quantity;

\elif :'rep_choice' = '6'
    SELECT m.name, m.department,
           COUNT(i.issue_id) AS total_borrowed
    FROM member m
    LEFT JOIN issue i ON m.member_id = i.member_id
    GROUP BY m.member_id, m.name, m.department
    ORDER BY total_borrowed DESC;

\elif :'rep_choice' = '7'
    SELECT item_type,
           COUNT(*)    AS total_purchases,
           SUM(amount) AS total_spent
    FROM purchases
    GROUP BY item_type
    ORDER BY total_spent DESC;

\elif :'rep_choice' = '0'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/menu.sql'

\else
    \echo 'Invalid choice.'
    \i 'C:/Users/YASH/Desktop/dbms project/menu/reports_menu.sql'
\endif