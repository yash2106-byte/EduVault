-- Load schema
\i sql/schema.sql

-- Load procedures
\i procedures/member.sql
\i procedures/issue_book.sql
\i procedures/fine.sql
\i procedures/book.sql

-- Load triggers
\i triggers/issue_book_triggers.sql
\i triggers/fine_trigger.sql

-- Load sample data
\i sql/sample_data.sql