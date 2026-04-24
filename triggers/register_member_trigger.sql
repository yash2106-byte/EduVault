-- SHOULD SUCCEED
CALL register_member(6, 'Aryan Das', '0606060606', 'aryan@gmail.com', 'CSE', 3, CURRENT_DATE);

-- SHOULD FAIL (duplicate ID)
CALL register_member(1, 'Test User', '0707070707', 'test@gmail.com', 'IT', 2, CURRENT_DATE);

-- SHOULD FAIL (duplicate phone)
CALL register_member(7, 'Test User', '0101010101', 'newtest@gmail.com', 'IT', 2, CURRENT_DATE);