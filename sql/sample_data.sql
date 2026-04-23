INSERT INTO member VALUES
(1, 'Yash Raj', '0101010101', 'yash@gmail.com', 'CSE', 4, '2024-01-10', 'Active'),
(2, 'Roshan Sahu', '0202020202', 'roshan@gmail.com', 'ECE', 2, '2024-02-15', 'Active'),
(3, 'Glory Mishra', '0303030303', 'glory@gmail.com', 'ME', 6, '2023-08-20', 'Suspended'),
(4, 'Penguines', '0404040404', 'penguines@gmail.com', 'IT', 8, '2022-01-01', 'Active'),
(5, 'Nupur', '0505050505', 'nupur@gmail.com', 'EEE', 6, '2024-03-01', 'Active');


INSERT INTO book VALUES
(101, 'Database Systems', 'YASH', 'Education', 'ISBN001', 'SINGH' ,10, 8),
(102, 'Operating Systems', 'ROSHAN', 'Education', 'ISBN002', 'SAHU', 7, 5),
(103, 'Computer Networks', 'GLORY', 'Education', 'ISBN003', 'MISHRA', 5, 5),
(104, 'Introduction to Python', 'PENGUINE', 'Education', 'ISBN004', 'INCOME TAX', 5, 3),
(105, 'Data Structures and Algorithms', 'NUPUR', 'Education', 'ISBN005', 'MAHAPATRA', 10, 9);


INSERT INTO journals (title, publisher, issue_no, volume_no, publication_date, subject)
VALUES
('AI Research', 'Springer', 12, 5, '2024-03-01', 'Artificial Intelligence'),
('Data Science Journal', 'Elsevier', 8, 3, '2024-02-10', 'Data Science'),
('Python Programming', 'Wiley', 10, 4, '2024-01-01', 'Programming'),
('Java Programming', 'Pearson', 9, 3, '2024-01-01', 'Programming'),
('Web Development', 'McGraw Hill', 11, 5, '2024-01-01', 'Web Development');


INSERT INTO periodicals (title, type, publication_date, publisher)
VALUES
('Science Today', 'Magazine', '2024-03-15', 'Nature Publishing'),
('World News Weekly', 'Newspaper', '2024-03-14', 'Global Media'),
('Technology Today', 'Magazine', '2024-03-15', 'Nature Publishing'),
('Business World', 'Magazine', '2024-03-15', 'Nature Publishing'),
('Health Today', 'Magazine', '2024-03-15', 'Nature Publishing');

INSERT INTO demands (member_id, item_type, title, author, publisher, quantity, demand_date, status)
VALUES
(1, 'Book', 'Database Systems', 'YASH', 'SINGH', 1, '2024-03-01', 'Pending'),
(2, 'Journal', 'AI Research', 'ROSHAN', 'SAHU', 1, '2024-03-02', 'Approved'),
(3, 'Periodical', 'World News Weekly', 'GLORY', 'MISHRA', 1, '2024-03-03', 'Rejected'),
(4, 'Book', 'Introduction to Python', 'PENGUINE', 'INCOME TAX', 1, '2024-03-04', 'Pending'),
(5, 'Journal', 'Data Science Journal', 'NUPUR', 'MAHAPATRA', 1, '2024-03-05', 'Approved');

INSERT INTO purchases (demand_id, item_type, item_id, purchase_date, vendor, quantity, amount)
VALUES
(1, 'Book', 101, '2024-03-02', 'John Doe', 1, 50.00),
(2, 'Journal', 1, '2024-03-03', 'John Doe', 1, 100.00),
(3, 'Periodical', 1, '2024-03-04', 'John Doe', 1, 150.00),
(4, 'Book', 102, '2024-03-05', 'John Doe', 1, 200.00),
(5, 'Journal', 2, '2024-03-06', 'John Doe', 1, 250.00);

-- ISSUE DATES ARE KEPT FROM 2024 BECAUSE IT WILL BE HELP US TO GENERATE THE FINES FOR LATE RETURN
INSERT INTO issue (member_id, book_id, issue_date, due_date, status)
VALUES
(1, 101, '2024-03-03', '2024-03-31', 'Issued'),
(2, 102, '2024-03-04', '2024-03-31', 'Issued');

--Fine, disposal, notice, complaint tables are empty because they will get populated through procedures and triggers we write next.