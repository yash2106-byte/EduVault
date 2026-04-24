-- SHOULD SUCCEED
CALL add_book(106, 'Computer Architecture', 'Morris Mano', 'Education', 'ISBN006', 'Pearson', 6);

-- SHOULD FAIL (duplicate book_id)
CALL add_book(101, 'Some Book', 'Author', 'Education', 'ISBN099', 'Publisher', 3);