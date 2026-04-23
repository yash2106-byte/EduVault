CREATE TABLE member (
    member_id         INT PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    phone             VARCHAR(15) UNIQUE NOT NULL,        -- NOT USEING INT OR BIGINT BECAUSE NUMBER START WITH ZERO AND + SIGN
    email             VARCHAR(100) UNIQUE NOT NULL,
    department        VARCHAR(50),
    semester          INT CHECK (semester BETWEEN 1 AND 8),
    membership_date   DATE NOT NULL,
    membership_status VARCHAR(20) DEFAULT 'Active'
    CHECK (membership_status IN ('Active', 'Expired', 'Suspended', 'Deregistered')) -- THIS WILL CHECK IF THE STUDENT IS ELIGIBLE FOR BORROWING BOOKS OR NOT.
);

CREATE TABLE book (
    book_id            INT PRIMARY KEY,
    title              VARCHAR(100) NOT NULL,
    author             VARCHAR(100) NOT NULL,
    category           VARCHAR(50),
    isbn               VARCHAR(20) UNIQUE, --THIS WILL STORE International Standard Book Number OF THAT PARTICULAR BOOK SO THAT WE CAN FIND THAT BOOK OUTSIDE THIS DATABSE ALSO
    publisher          VARCHAR(100),
    stock_quantity     INT NOT NULL CHECK (stock_quantity >= 0),
    available_quantity INT NOT NULL CHECK (available_quantity >= 0)  
);

CREATE TABLE journals (
    journal_id       SERIAL PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    publisher        VARCHAR(100),
    issue_no         INT,
    volume_no        INT,
    publication_date DATE,
    subject          VARCHAR(100)
);

CREATE TABLE periodicals (
    periodical_id    SERIAL PRIMARY KEY,
    title            VARCHAR(200),
    type             VARCHAR(50) CHECK (type IN ('Magazine', 'Newspaper', 'Newsletter')),
    publication_date DATE,
    publisher        VARCHAR(100)
);

CREATE TABLE demands (
    demand_id     SERIAL PRIMARY KEY, -- THIS WILL INCREASE ON ITS OWN
    member_id     INT REFERENCES member(member_id),
    item_type     VARCHAR(20) NOT NULL
    CHECK (item_type IN ('Book', 'Journal', 'Periodical')),
    title         VARCHAR(200) NOT NULL,
    author        VARCHAR(100),
    publisher     VARCHAR(100),
    quantity      INT DEFAULT 1 CHECK (quantity > 0),
    demand_date   DATE NOT NULL DEFAULT CURRENT_DATE,
    status        VARCHAR(20) DEFAULT 'Pending'
    CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Purchased'))
);

CREATE TABLE purchases (
    purchase_id   SERIAL PRIMARY KEY,
    demand_id     INT REFERENCES demands(demand_id),
    item_type     VARCHAR(20) CHECK (item_type IN ('Book', 'Journal', 'Periodical')),
    item_id       INT,           --ID OF THE BOOK OR WHATEVER WE PURCHASED
    purchase_date DATE DEFAULT CURRENT_DATE,
    vendor        VARCHAR(100),
    quantity      INT DEFAULT 1,
    amount        DECIMAL(10, 2) CHECK (amount >= 0)
);

CREATE SEQUENCE issue_seq START WITH 1001 INCREMENT BY 1; -- OUR FIRST ISSUE SEQ WILL BE 1001 AND THEN IT GOES ON

CREATE TABLE issue (
    issue_id     INT DEFAULT NEXTVAL('issue_seq') PRIMARY KEY,
    member_id    INT NOT NULL REFERENCES member(member_id),
    book_id      INT NOT NULL REFERENCES book(book_id),
    issue_date   DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date     DATE NOT NULL,
    return_date  DATE,
    status       VARCHAR(20) DEFAULT 'Issued'
    CHECK (status IN ('Issued', 'Returned', 'Overdue', 'Lost'))
);

CREATE INDEX idx_issue_member ON issue(member_id);
CREATE INDEX idx_issue_book   ON issue(book_id);

CREATE TABLE fine (
    fine_id        SERIAL PRIMARY KEY,
    issue_id       INT NOT NULL REFERENCES issue(issue_id),
    member_id      INT NOT NULL REFERENCES member(member_id),
    overdue_days   INT NOT NULL DEFAULT 0 CHECK (overdue_days >= 0),
    fine_amount    DECIMAL(8, 2) NOT NULL CHECK (fine_amount >= 0),
    payment_status VARCHAR(20) DEFAULT 'Pending'
    CHECK (payment_status IN ('Pending', 'Paid', 'Waived')),
    payment_date   DATE
);

CREATE TABLE disposal (
    disposal_id   SERIAL PRIMARY KEY,
    item_type     VARCHAR(20) CHECK (item_type IN ('Book', 'Journal', 'Periodical')),
    item_id       INT NOT NULL,
    quantity      INT DEFAULT 1 CHECK (quantity > 0),
    disposal_date DATE DEFAULT CURRENT_DATE,
    reason        VARCHAR(50)
    CHECK (reason IN ('Damaged', 'Lost', 'Obsolete', 'Worn Out')),
    remarks       TEXT
);

CREATE TABLE notice (
    notice_id    SERIAL PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    content      TEXT NOT NULL,
    notice_type  VARCHAR(30) DEFAULT 'General'
    CHECK (notice_type IN ('General', 'Holiday', 'Event', 'Rule', 'Urgent')),
    posted_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    expiry_date  DATE,
    status       VARCHAR(20) DEFAULT 'Active'
    CHECK (status IN ('Active', 'Expired'))
);

CREATE TABLE complaint (
    complaint_id   SERIAL PRIMARY KEY,
    member_id      INT NOT NULL REFERENCES member(member_id),
    category       VARCHAR(50)
    CHECK (category IN ('Damaged Book', 'Missing Item',
                        'Fine Dispute', 'Facility', 'Other')),
    description    TEXT NOT NULL,
    complaint_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status         VARCHAR(20) DEFAULT 'Open'
    CHECK (status IN ('Open', 'In Progress', 'Resolved', 'Closed')),
    resolution     TEXT,
    resolved_date  DATE
);

