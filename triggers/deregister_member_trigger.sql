-- SHOULD SUCCEED (member 5, no issues or fines)
CALL deregister_member(5);

-- SHOULD FAIL (member 1 has an active issue)
CALL deregister_member(1);

SELECT * FROM member;