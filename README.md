# 📚 EduVault — PostgreSQL Based Library Management System
### Overview

EduVault is a menu-driven Library Management System built entirely using PostgreSQL and operated through the psql CLI, without relying on a separate backend framework or web application.

The project demonstrates how database systems can function as complete application layers by combining relational schema design, stored procedures, triggers, constraints, and interactive SQL scripting.

### Demo

<p align="center">
  <img src="./assets/eduvault-demo.gif" alt="EduVault Demo" width="900"/>
</p>
A quick walkthrough of EduVault running through the PostgreSQL CLI interface.


This system automates core library operations such as member management, book issue/return, overdue fine calculation, demand handling, notices, complaints, and reporting.

### Problem Statement
---
Traditional library systems require efficient management of books, members, issue-return transactions, overdue penalties, and administrative workflows.

This project aims to design a database-centric library management platform where business logic is handled directly inside PostgreSQL using stored procedures, triggers, and constraints instead of an external application server.

---

## ✨ Features

### 👤 Member Management

* Register new members
* Deregister members with validation checks
* Search and view member details
* Manage membership status

### 📖 Book Management

* Add books to inventory
* Search and view books
* Track stock quantity
* Monitor book availability

### 🔄 Issue & Return Management

* Issue books with eligibility validation
* Return books seamlessly
* Automatic stock updates
* Prevent duplicate book issuance

### 💰 Fine Management

* Automatic overdue fine calculation
* Fine payment workflow
* Track pending fines

### 📦 Demand & Purchase System

* Raise acquisition demands
* Approve purchase requests
* Track purchases
* Automatic stock updates after purchase

### 📢 Notice Management

* Post library announcements
* Expiry-based notice handling
* Multiple notice categories

### 🛠 Complaint Handling

* Raise complaints
* Track complaint resolution
* Manage complaint lifecycle

### 📊 Reports & Analytics

* Issued books report
* Overdue books analysis
* Top borrowed books report
* Purchase summaries
* Pending fines report
* Stock availability insights


---

## 🛠 Tech Stack

| Technology         | Purpose                                  |
| ------------------ | ---------------------------------------- |
| **PostgreSQL**     | Database engine                          |
| **PL/pgSQL**       | Business logic implementation            |
| **psql CLI**       | Interactive command-line interface       |
| **SQL Triggers**   | Automation and event handling            |
| **SQL Procedures** | Workflow and business process management |

---
System Architecture

The application follows a database-driven architecture where PostgreSQL acts as both the data layer and application logic layer.

## Repository layout

```
dbms project/
├─ sql/
│  ├─ schema.sql        # Tables, constraints, indexes, sequences
│  ├─ sample_data.sql   # Seed data for quick testing
│  ├─ reports.sql       # Standalone report queries
│  ├─ reset.sql         # TRUNCATE all tables (development reset)
│  └─ menu.sql          # Main entry menu (psql-driven UI)
├─ procedures/
│  ├─ member.sql        # register_member + related member logic
│  ├─ add_book.sql
│  ├─ issue_book.sql
│  ├─ return_book.sql
│  ├─ calculate_fine.sql  # function returning fine amount
│  ├─ pay_fine.sql
│  └─ ...               # demands/notices/complaints procedures
├─ triggers/
│  ├─ issue_book_triggers.sql
│  ├─ return_book_triggers.sql
│  └─ add_book_triggers.sql
└─ menu/
   ├─ member_menu.sql
   ├─ book_menu.sql
   ├─ issue_menu.sql
   ├─ demand_menu.sql
   ├─ fine_menu.sql
   ├─ notice_menu.sql
   ├─ complaint_menu.sql
   └─ reports_menu.sql
```

---

## Getting started (Windows)

### Prerequisites
- PostgreSQL installed (Server + `psql` client)
- A PostgreSQL role/user you can log in with (e.g. `postgres`)

### Create a database

From PowerShell:

```powershell
psql -U postgres -c "CREATE DATABASE library_portal;"
```

### Bootstrap schema, procedures, triggers, and sample data

Run the following from the repo root (`C:\Users\YASH\Desktop\dbms project`):

```powershell
# 1) Create tables + constraints + indexes + sequences
psql -U postgres -d library_portal -f "sql/schema.sql"

# 2) Load procedures/functions
psql -U postgres -d library_portal -f "procedures/member.sql"
psql -U postgres -d library_portal -f "procedures/add_book.sql"
psql -U postgres -d library_portal -f "procedures/issue_book.sql"
psql -U postgres -d library_portal -f "procedures/return_book.sql"
psql -U postgres -d library_portal -f "procedures/calculate_fine.sql"
psql -U postgres -d library_portal -f "procedures/pay_fine.sql"
psql -U postgres -d library_portal -f "procedures/demands_notices_complaints.sql"

# 3) Load triggers
psql -U postgres -d library_portal -f "triggers/issue_book_triggers.sql"
psql -U postgres -d library_portal -f "triggers/return_book_triggers.sql"
psql -U postgres -d library_portal -f "triggers/add_book_triggers.sql"

# 4) Seed test data (optional but recommended)
psql -U postgres -d library_portal -f "sql/sample_data.sql"
```

> Note: If you add more procedures later, include them in this bootstrap list (or create a single `sql/bootstrap.sql` that `\i` includes everything).

---

## Running the interactive menu (psql UI)

Start the main menu:

```powershell
psql -U postgres -d library_portal -f "sql/menu.sql"
```

You’ll see:
- Member Management
- Book Management
- Issue and Return
- Demands and Purchases
- Fines
- Notices and Announcements
- Complaints
- Reports

### Important note about paths inside `sql/menu.sql`
Your current `sql/menu.sql` uses **absolute Windows paths** (for example `C:/Users/YASH/Desktop/dbms project/menu/...`).
That works on your machine but will break for other users or if the folder is moved.

**Recommended production-style approach**:
- Prefer **relative includes** (e.g. `\i '../menu/member_menu.sql'`) and run `psql` from a consistent working directory (repo root).

---

## Database design (high level)

### Main entities
- **`member`**: library members with eligibility status (`Active`, `Suspended`, etc.)
- **`book`**: inventory + availability counters (`stock_quantity`, `available_quantity`)
- **`issue`**: issue transactions including due dates and status (`Issued`, `Returned`, `Overdue`, `Lost`)
- **`fine`**: computed overdue fines with payment status (`Pending`, `Paid`, `Waived`)

### Supporting entities
- **`demands`** and **`purchases`**: acquisition workflow
- **`journals`** and **`periodicals`**: non-book library items
- **`notice`**: announcements
- **`complaint`**: issue tracking & resolution
- **`disposal`**: disposal log for damaged/obsolete/lost items

---

## Business rules & automation

### Issuing a book
- **Eligibility**: member must exist and be `Active`
- **Availability**: book must have `available_quantity > 0`
- **Stock adjustment**: availability decreases on issue

These are enforced both by:
- **Stored procedure**: `issue_book(member_id, book_id, due_date)`
- **Triggers** (defensive checks + auto-updates): see `triggers/issue_book_triggers.sql`

### Returning a book
- Marks issue as `Returned`, sets `return_date`
- Increases `available_quantity`
- Calculates and records fine if overdue (if not already present)

Implemented via:
- `return_book(issue_id)` in `procedures/return_book.sql`
- `calculate_fine(issue_id)` in `procedures/calculate_fine.sql`

---

## Reports

You can run reports in two ways:
- **From the UI**: `menu/reports_menu.sql`
- **Direct SQL**: `sql/reports.sql`

Examples included:
- currently issued books
- overdue issues + estimated fine
- top borrowed books
- members with pending fines
- book stock status
- purchase summary by item type
- complaints summary

---

## Operations (reset / dev workflow)

### Reset all tables (development only)
This will delete data from all tables:

```powershell
psql -U postgres -d library_portal -f "sql/reset.sql"
```

Then optionally reseed:

```powershell
psql -U postgres -d library_portal -f "sql/sample_data.sql"
```

---

## Troubleshooting

- **`psql` not found**: add PostgreSQL `bin/` to PATH (or use “SQL Shell (psql)” installed with PostgreSQL).
- **Permission denied / auth errors**: verify `pg_hba.conf` settings and that your role can connect to the database.
- **Menus fail after moving the folder**: update the absolute paths inside `sql/menu.sql` (or convert to relative includes as recommended above).

---

## Quality checklist (industry-style)
- **Reproducible setup**: schema + procedures + triggers + seed data scripts
- **Integrity-first modeling**: FK constraints + status checks + numeric validation
- **Auditable workflows**: issue history, fine records, complaint lifecycle
- **Operational scripts**: reset and reports

---

## License

Add a license if you plan to publish this repository publicly (MIT/Apache-2.0 are common defaults for student projects).
