--  REPORTS — LIBRARY PORTAL
--  File: sql/reports.sql


-- REPORT 1 — ALL CURRENTLY ISSUED BOOKS (NOT YET RETURNED)
-- Concepts: JOIN, WHERE
SELECT
    i.issue_id,
    m.name          AS member_name,
    m.department,
    b.title         AS book_title,
    i.issue_date,
    i.due_date,
    (CURRENT_DATE - i.due_date) AS days_overdue
FROM issue i
JOIN member m ON i.member_id = m.member_id
JOIN book   b ON i.book_id   = b.book_id
WHERE i.status = 'Issued'
ORDER BY days_overdue DESC;


-- REPORT 2 — TOP 5 MOST BORROWED BOOKS
-- Concepts: GROUP BY, COUNT, ORDER BY, LIMIT
SELECT
    b.book_id,
    b.title,
    b.author,
    COUNT(i.issue_id)   AS total_issues,
    b.stock_quantity,
    b.available_quantity
FROM book b
LEFT JOIN issue i ON b.book_id = i.book_id
GROUP BY b.book_id, b.title, b.author,
         b.stock_quantity, b.available_quantity
ORDER BY total_issues DESC
LIMIT 5;


-- REPORT 3 — MEMBERS WITH PENDING FINES
-- Concepts: NESTED QUERY, JOIN
SELECT
    m.member_id,
    m.name,
    m.department,
    m.phone,
    f.fine_id,
    f.overdue_days,
    f.fine_amount,
    f.payment_status
FROM member m
JOIN fine f ON m.member_id = f.member_id
WHERE f.payment_status = 'Pending'
  AND m.member_id IN (
        SELECT DISTINCT member_id
        FROM fine
        WHERE payment_status = 'Pending'
  )
ORDER BY f.fine_amount DESC;


-- REPORT 4 — OVERDUE ISSUES (DUE DATE ALREADY PASSED)
-- Concepts: DATE comparison, JOIN
SELECT
    i.issue_id,
    m.name              AS member_name,
    m.phone,
    b.title             AS book_title,
    i.due_date,
    CURRENT_DATE        AS today,
    (CURRENT_DATE - i.due_date)        AS overdue_days,
    (CURRENT_DATE - i.due_date) * 2    AS estimated_fine
FROM issue i
JOIN member m ON i.member_id = m.member_id
JOIN book   b ON i.book_id   = b.book_id
WHERE i.return_date IS NULL
  AND CURRENT_DATE > i.due_date
ORDER BY overdue_days DESC;


-- REPORT 5 — PURCHASE SUMMARY BY ITEM TYPE
-- Concepts: GROUP BY, SUM, COUNT, aggregate
SELECT
    item_type,
    COUNT(*)            AS total_purchases,
    SUM(quantity)       AS total_quantity,
    SUM(amount)         AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM purchases
GROUP BY item_type
ORDER BY total_amount DESC;


-- REPORT 6 — COMPLAINT STATUS SUMMARY
-- Concepts: GROUP BY, COUNT
SELECT
    status,
    COUNT(*)   AS total_complaints,
    STRING_AGG(DISTINCT category, ', ') AS categories_involved
FROM complaint
GROUP BY status
ORDER BY total_complaints DESC;


-- REPORT 7 — BOOK STOCK STATUS
-- Concepts: CASE, aggregate
SELECT
    book_id,
    title,
    author,
    stock_quantity,
    available_quantity,
    (stock_quantity - available_quantity) AS currently_issued,
    CASE
        WHEN available_quantity = 0             THEN 'Out of Stock'
        WHEN available_quantity <= stock_quantity * 0.2 THEN 'Low Stock'
        ELSE                                         'Available'
    END AS stock_status
FROM book
ORDER BY available_quantity ASC;


-- REPORT 8 — MEMBER BORROWING HISTORY (NESTED QUERY)
-- Concepts: nested query, LEFT JOIN, aggregates
SELECT
    m.member_id,
    m.name,
    m.department,
    m.membership_status,
    (SELECT COUNT(*) FROM issue i
     WHERE i.member_id = m.member_id)              AS total_books_borrowed,
    (SELECT COUNT(*) FROM issue i
     WHERE i.member_id = m.member_id
     AND i.status = 'Issued')                      AS currently_holding,
    (SELECT COALESCE(SUM(f.fine_amount), 0)
     FROM fine f
     WHERE f.member_id = m.member_id
     AND f.payment_status = 'Pending')             AS pending_fine_amount
FROM member m
ORDER BY total_books_borrowed DESC;


-- REPORT 9 — DEMANDS SUMMARY BY STATUS
-- Concepts: GROUP BY, COUNT
SELECT
    status,
    COUNT(*)    AS total_demands,
    STRING_AGG(DISTINCT item_type, ', ') AS item_types
FROM demands
GROUP BY status
ORDER BY total_demands DESC;


-- REPORT 10 — ACTIVE NOTICES
-- Concepts: WHERE, DATE filter
SELECT
    notice_id,
    title,
    notice_type,
    posted_date,
    expiry_date,
    CASE
        WHEN expiry_date IS NULL        THEN 'No expiry'
        WHEN expiry_date >= CURRENT_DATE THEN 'Valid'
        ELSE                                 'Expired'
    END AS validity
FROM notice
WHERE status = 'Active'
ORDER BY posted_date DESC;