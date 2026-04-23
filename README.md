## 📌 Overview

EduVault is a menu-driven CLI application that combines two academic projects into one production-quality system. It demonstrates real-world database design using advanced PostgreSQL features alongside a clean Python application layer.

---

## ✨ Features

### 📚 Student Module
- Add, view, update, and delete student records
- Unique student IDs via PostgreSQL sequences

### 📖 Library Module
- Issue and return books with timestamped records
- View all issued/returned book history per student

### 📝 Examination Module
- Store and retrieve subject-wise marks
- Auto-calculate grades using PostgreSQL triggers

### 💰 Account Module
- Record fee details and payments
- View fee status (paid / balance remaining)

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.x |
| Database | PostgreSQL |
| DB Connector | psycopg2 |
| Interface | Menu-driven CLI |

---

## 🗃️ Database Schema

### Students
```sql
student_id  SERIAL PRIMARY KEY
name        VARCHAR(100)
age         INTEGER
course      VARCHAR(100)
```

### Library
```sql
book_id     SERIAL PRIMARY KEY
student_id  INTEGER REFERENCES students(student_id)
book_name   VARCHAR(200)
issue_date  DATE
return_date DATE
```

### Examination
```sql
exam_id     SERIAL PRIMARY KEY
student_id  INTEGER REFERENCES students(student_id)
subject     VARCHAR(100)
marks       NUMERIC(5,2)
grade       CHAR(2)
```

### Account
```sql
account_id  SERIAL PRIMARY KEY
student_id  INTEGER REFERENCES students(student_id)
total_fee   NUMERIC(10,2)
paid_fee    NUMERIC(10,2)
balance     NUMERIC(10,2) GENERATED ALWAYS AS (total_fee - paid_fee) STORED
```

---

## ⚙️ Advanced PostgreSQL Concepts Used

| Concept | Usage |
|---|---|
| **Triggers** | Auto-calculate grade when marks are inserted/updated |
| **Stored Procedures** | Fee payment processing |
| **Sequences** | Auto-increment student, book, exam IDs |
| **Constraints** | NOT NULL, FOREIGN KEY, CHECK constraints |
| **Indices** | On student_id across all tables for fast lookups |
| **Views** | Student dashboard summary view |
| **Cursors** | Used in report generation procedures |

---

## 📁 Project Structure

```
eduvault/
│
├── README.md
│
├── docs/
│   ├── er_diagram.png          # Entity-Relationship Diagram
│   └── schema.md               # Relational schema details
│
├── sql/
│   ├── ddl.sql                 # CREATE TABLE statements
│   ├── triggers.sql            # Grade auto-calculation trigger
│   ├── procedures.sql          # Stored procedures
│   └── sample_data.sql         # Seed data for testing
│
├── src/
│   ├── main.py                 # Entry point & main menu
│   ├── db.py                   # PostgreSQL connection handler
│   ├── student.py              # Student module
│   ├── library.py              # Library module
│   ├── examination.py          # Examination module
│   └── accounts.py             # Accounts module
│
└── screenshots/
    └── *.png                   # Sample output screenshots
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- PostgreSQL 13+
- psycopg2 library

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/eduvault.git
cd eduvault

# 2. Install dependencies
pip install psycopg2-binary

# 3. Set up the database
psql -U postgres -c "CREATE DATABASE eduvault;"
psql -U postgres -d eduvault -f sql/ddl.sql
psql -U postgres -d eduvault -f sql/triggers.sql
psql -U postgres -d eduvault -f sql/procedures.sql

# 4. Configure DB connection
# Edit src/db.py with your PostgreSQL credentials

# 5. Run the application
python src/main.py
```

---

## 📸 Sample Output

```
========================================
     EDUVAULT — STUDENT PORTAL
========================================
1. Student Management
2. Library Management
3. Examination Records
4. Fee & Accounts
5. Exit
========================================
Enter your choice:
```

*(Screenshots in /screenshots folder)*

---

## 📄 Project Report Contents

- [x] Problem Statement
- [x] ER Diagram and Relational Schema
- [x] DDL with Constraints
- [x] Menu and Sub-menu Layouts
- [x] Program Code
- [x] Sample Outputs
