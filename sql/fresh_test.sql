-- this is the sample of querry which can be used just after resetting your dataset, this querry will check if the database is working as expected or not

--  VERIFICATION SCRIPT — RUN AFTER FRESH SAMPLE DATA INSERT

-- 1. MEMBER (expect 5 rows)
SELECT '--- MEMBER ---' AS check_point;
SELECT member_id, name, department, semester, membership_status
FROM member
ORDER BY member_id;

-- 2. BOOK (expect 5 rows, check stock vs available)
SELECT '--- BOOK ---' AS check_point;
SELECT book_id, title, stock_quantity, available_quantity,
       (stock_quantity - available_quantity) AS currently_issued
FROM book
ORDER BY book_id;

-- 3. JOURNALS (expect 5 rows, IDs should be 1-5)
SELECT '--- JOURNALS ---' AS check_point;
SELECT journal_id, title, publisher, subject
FROM journals
ORDER BY journal_id;

-- 4. PERIODICALS (expect 5 rows, IDs should be 1-5)
SELECT '--- PERIODICALS ---' AS check_point;
SELECT periodical_id, title, type, publisher
FROM periodicals
ORDER BY periodical_id;

-- 5. DEMANDS (expect 5 rows, mix of Pending/Approved/Rejected)
SELECT '--- DEMANDS ---' AS check_point;
SELECT demand_id, member_id, item_type, title, status
FROM demands
ORDER BY demand_id;

-- 6. PURCHASES (expect 5 rows)
SELECT '--- PURCHASES ---' AS check_point;
SELECT purchase_id, demand_id, item_type, item_id, vendor, amount
FROM purchases
ORDER BY purchase_id;

-- 7. ISSUE (expect 2 rows, both Issued, issue_id starts from 1001)
SELECT '--- ISSUE ---' AS check_point;
SELECT issue_id, member_id, book_id, issue_date, due_date, status
FROM issue
ORDER BY issue_id;

-- 8. EMPTY TABLES (all must return 0 rows)
SELECT '--- FINE (expect 0 rows) ---' AS check_point;
SELECT COUNT(*) AS fine_count FROM fine;

SELECT '--- DISPOSAL (expect 0 rows) ---' AS check_point;
SELECT COUNT(*) AS disposal_count FROM disposal;

SELECT '--- NOTICE (expect 0 rows) ---' AS check_point;
SELECT COUNT(*) AS notice_count FROM notice;

SELECT '--- COMPLAINT (expect 0 rows) ---' AS check_point;
SELECT COUNT(*) AS complaint_count FROM complaint;

--  CROSS CHECKS

-- 9. VERIFY ISSUE LINKS TO VALID MEMBERS AND BOOKS
SELECT '--- ISSUE JOIN CHECK ---' AS check_point;
SELECT
    i.issue_id,
    m.name        AS member_name,
    b.title       AS book_title,
    i.issue_date,
    i.due_date,
    i.status,
    (CURRENT_DATE - i.due_date) AS days_overdue
FROM issue i
JOIN member m ON i.member_id = m.member_id
JOIN book   b ON i.book_id   = b.book_id;

-- 10. VERIFY DEMANDS LINK TO VALID MEMBERS
SELECT '--- DEMAND JOIN CHECK ---' AS check_point;
SELECT
    d.demand_id,
    m.name     AS requested_by,
    d.item_type,
    d.title,
    d.status
FROM demands d
JOIN member m ON d.member_id = m.member_id;

-- 11. VERIFY SEQUENCE — issue_seq SHOULD BE AT 1003
--     (1001 and 1002 used, next value is 1003)
SELECT '--- SEQUENCE CHECK ---' AS check_point;
SELECT last_value AS last_used_issue_id,
       last_value + 1 AS next_issue_id
FROM issue_seq;

-- 12. ROW COUNT SUMMARY — QUICK OVERVIEW OF ALL TABLES
SELECT '--- ROW COUNT SUMMARY ---' AS check_point;
SELECT 'member'      AS table_name, COUNT(*) AS rows FROM member
UNION ALL
SELECT 'book',        COUNT(*) FROM book
UNION ALL
SELECT 'journals',    COUNT(*) FROM journals
UNION ALL
SELECT 'periodicals', COUNT(*) FROM periodicals
UNION ALL
SELECT 'demands',     COUNT(*) FROM demands
UNION ALL
SELECT 'purchases',   COUNT(*) FROM purchases
UNION ALL
SELECT 'issue',       COUNT(*) FROM issue
UNION ALL
SELECT 'fine',        COUNT(*) FROM fine
UNION ALL
SELECT 'disposal',    COUNT(*) FROM disposal
UNION ALL
SELECT 'notice',      COUNT(*) FROM notice
UNION ALL
SELECT 'complaint',   COUNT(*) FROM complaint
ORDER BY table_name;

-- Run the above file in the psql terminal to verify the database
-- below is the desired output

--   check_point
-- ----------------
--  --- MEMBER ---
-- (1 row)


--  member_id |     name     | department | semester | membership_status
-- -----------+--------------+------------+----------+-------------------
--          1 | Yash Raj     | CSE        |        4 | Active
--          2 | Roshan Sahu  | ECE        |        2 | Active
--          3 | Glory Mishra | ME         |        6 | Suspended
--          4 | Penguines    | IT         |        8 | Active
--          5 | Nupur        | EEE        |        6 | Active
-- (5 rows)


--  check_point
-- --------------
--  --- BOOK ---
-- (1 row)


--  book_id |             title              | stock_quantity | available_quantity | currently_issued
-- ---------+--------------------------------+----------------+--------------------+------------------
--      101 | Database Systems               |             10 |                  8 |                2
--      102 | Operating Systems              |              7 |                  5 |                2
--      103 | Computer Networks              |              5 |                  5 |                0
--      104 | Introduction to Python         |              5 |                  3 |                2
--      105 | Data Structures and Algorithms |             10 |                  9 |                1
-- (5 rows)


--    check_point
-- ------------------
--  --- JOURNALS ---
-- (1 row)


--  journal_id |        title         |  publisher  |         subject
-- ------------+----------------------+-------------+-------------------------
--           1 | AI Research          | Springer    | Artificial Intelligence
--           2 | Data Science Journal | Elsevier    | Data Science
--           3 | Python Programming   | Wiley       | Programming
--           4 | Java Programming     | Pearson     | Programming
--           5 | Web Development      | McGraw Hill | Web Development
-- (5 rows)


--      check_point
-- ---------------------
--  --- PERIODICALS ---
-- (1 row)


--  periodical_id |       title       |   type    |     publisher
-- ---------------+-------------------+-----------+-------------------
--              1 | Science Today     | Magazine  | Nature Publishing
--              2 | World News Weekly | Newspaper | Global Media
--              3 | Technology Today  | Magazine  | Nature Publishing
--              4 | Business World    | Magazine  | Nature Publishing
--              5 | Health Today      | Magazine  | Nature Publishing
-- (5 rows)


--    check_point
-- -----------------
--  --- DEMANDS ---
-- (1 row)


--  demand_id | member_id | item_type  |         title          |  status
-- -----------+-----------+------------+------------------------+----------
--          1 |         1 | Book       | Database Systems       | Pending
--          2 |         2 | Journal    | AI Research            | Approved
--          3 |         3 | Periodical | World News Weekly      | Rejected
--          4 |         4 | Book       | Introduction to Python | Pending
--          5 |         5 | Journal    | Data Science Journal   | Approved
-- (5 rows)


--     check_point
-- -------------------
--  --- PURCHASES ---
-- (1 row)


--  purchase_id | demand_id | item_type  | item_id |  vendor  | amount
-- -------------+-----------+------------+---------+----------+--------
--            1 |         1 | Book       |     101 | John Doe |  50.00
--            2 |         2 | Journal    |       1 | John Doe | 100.00
--            3 |         3 | Periodical |       1 | John Doe | 150.00
--            4 |         4 | Book       |     102 | John Doe | 200.00
--            5 |         5 | Journal    |       2 | John Doe | 250.00
-- (5 rows)


--   check_point
-- ---------------
--  --- ISSUE ---
-- (1 row)


--  issue_id | member_id | book_id | issue_date |  due_date  | status
-- ----------+-----------+---------+------------+------------+--------
--      1001 |         1 |     101 | 2024-03-03 | 2024-03-31 | Issued
--      1002 |         2 |     102 | 2024-03-04 | 2024-03-31 | Issued
-- (2 rows)


--          check_point
-- ------------------------------
--  --- FINE (expect 0 rows) ---
-- (1 row)


--  fine_count
-- ------------
--           0
-- (1 row)


--            check_point
-- ----------------------------------
--  --- DISPOSAL (expect 0 rows) ---
-- (1 row)


--  disposal_count
-- ----------------
--               0
-- (1 row)


--           check_point
-- --------------------------------
--  --- NOTICE (expect 0 rows) ---
-- (1 row)


--  notice_count
-- --------------
--             0
-- (1 row)


--             check_point
-- -----------------------------------
--  --- COMPLAINT (expect 0 rows) ---
-- (1 row)


--  complaint_count
-- -----------------
--                0
-- (1 row)


--        check_point
-- --------------------------
--  --- ISSUE JOIN CHECK ---
-- (1 row)


--  issue_id | member_name |    book_title     | issue_date |  due_date  | status | days_overdue
-- ----------+-------------+-------------------+------------+------------+--------+--------------
--      1001 | Yash Raj    | Database Systems  | 2024-03-03 | 2024-03-31 | Issued |          755
--      1002 | Roshan Sahu | Operating Systems | 2024-03-04 | 2024-03-31 | Issued |          755
-- (2 rows)


--         check_point
-- ---------------------------
--  --- DEMAND JOIN CHECK ---
-- (1 row)


--  demand_id | requested_by | item_type  |         title          |  status
-- -----------+--------------+------------+------------------------+----------
--          1 | Yash Raj     | Book       | Database Systems       | Pending
--          2 | Roshan Sahu  | Journal    | AI Research            | Approved
--          3 | Glory Mishra | Periodical | World News Weekly      | Rejected
--          4 | Penguines    | Book       | Introduction to Python | Pending
--          5 | Nupur        | Journal    | Data Science Journal   | Approved
-- (5 rows)


--       check_point
-- ------------------------
--  --- SEQUENCE CHECK ---
-- (1 row)


--  last_used_issue_id | next_issue_id
-- --------------------+---------------
--                1002 |          1003
-- (1 row)


--         check_point
-- ---------------------------
--  --- ROW COUNT SUMMARY ---
-- (1 row)


--  table_name  | rows
-- -------------+------
--  book        |    5
--  complaint   |    0
--  demands     |    5
--  disposal    |    0
--  fine        |    0
--  issue       |    2
--  journals    |    5
--  member      |    5
--  notice      |    0
--  periodicals |    5
--  purchases   |    5
-- (11 rows)

