Library Management System Database

1 Project Description
A complete MySQL database solution for managing library operations including:
- Book catalog management
- Member registrations
- Borrowing and returning books
- Reservations and fines
- Staff management
- Event scheduling

2 Database Features
- 14 normalized tables
- Proper relationships (1:1, 1:M, M:M)
- Constraints (PK, FK, NOT NULL, UNIQUE)
- Sample data for demonstration

## Setup Details
1. **Working my schemas out**
   - Used MYSQL Workbench to make the schemas and insert data
   - Used MYSQL to make my EER Diagram


2. **Import the database**:
   ```bash
   mysql -u [username] -p < library_db.sql
