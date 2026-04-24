-- SHOULD SUCCEED
CALL issue_book(4, 103, CURRENT_DATE + 14);

-- SHOULD FAIL (member 3 is Suspended)
CALL issue_book(3, 104, CURRENT_DATE + 14);

-- SHOULD FAIL (member 1 already has book 101)
CALL issue_book(1, 101, CURRENT_DATE + 14);