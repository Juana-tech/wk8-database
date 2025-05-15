  -- Create new database 
  CREATE DATABASE LibraryManagementSystem;

  USE LibraryManagementSystem;

  -- Create members table
  CREATE TABLE Members (
      member_id INT AUTO_INCREMENT PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL,
      phone VARCHAR(20),
      address VARCHAR(200),
      date_of_birth DATE,
      membership_date DATE NOT NULL,
      membership_expiry DATE NOT NULL,
      status ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
      CHECK (membership_expiry > membership_date)
  );

 -- Create authors table
  CREATE TABLE Authors (
      author_id INT AUTO_INCREMENT PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      birth_year YEAR,
      nationality VARCHAR(50)
  );

  -- Create publishers table
  CREATE TABLE Publishers (
      publisher_id INT AUTO_INCREMENT PRIMARY KEY,
      publisher_name VARCHAR(100) NOT NULL UNIQUE,
      address VARCHAR(200),
      phone VARCHAR(20),
      email VARCHAR(100)
  );

  -- Create categories table
  CREATE TABLE Categories (
      category_id INT AUTO_INCREMENT PRIMARY KEY,
      category_name VARCHAR(50) NOT NULL UNIQUE
  );

  -- Create books table
  CREATE TABLE Books (
      book_id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(200) NOT NULL,
      publisher_id INT,
      publication_year YEAR,
      page_count INT,
      FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL
  );

  -- Create bookauthors table
  CREATE TABLE BookAuthors (
      book_id INT NOT NULL,
      author_id INT NOT NULL,
      PRIMARY KEY (book_id, author_id),
      FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
      FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
  );

  -- Create bookcategories table
  CREATE TABLE BookCategories (
      book_id INT NOT NULL,
      category_id INT NOT NULL,
      PRIMARY KEY (book_id, category_id),
      FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
      FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
  );

  -- Create bookcopies table
  CREATE TABLE BookCopies (
      copy_id INT AUTO_INCREMENT PRIMARY KEY,
      book_id INT NOT NULL,
      acquisition_date DATE NOT NULL,
      status ENUM('Available', 'Checked Out', 'Reserved', 'Lost', 'Damaged', 'In Repair') DEFAULT 'Available',
      FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
  );

  -- Create borrowing table
  CREATE TABLE Borrowings (
      borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
      copy_id INT NOT NULL,
      member_id INT NOT NULL,
      checkout_date DATETIME NOT NULL,
      due_date DATE NOT NULL,
      return_date DATETIME,
      status ENUM('Checked Out', 'Returned', 'Overdue', 'Lost') DEFAULT 'Checked Out',
      late_fee DECIMAL(10,2) DEFAULT 0.00,
      FOREIGN KEY (copy_id) REFERENCES BookCopies(copy_id) ON DELETE CASCADE,
      FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
      CHECK (due_date > DATE(checkout_date)),
      CHECK (return_date IS NULL OR return_date >= checkout_date)
  );

  -- Create reservations table
  CREATE TABLE Reservations (
      reservation_id INT AUTO_INCREMENT PRIMARY KEY,
      book_id INT NOT NULL,
      member_id INT NOT NULL,
      reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      expiry_date DATETIME NOT NULL,
      status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Pending',
      FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
      FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
      UNIQUE (book_id, member_id, status),
      CHECK (expiry_date > reservation_date)
  );

  -- Create fines table
  CREATE TABLE Fines (
      fine_id INT AUTO_INCREMENT PRIMARY KEY,
      member_id INT NOT NULL,
      borrowing_id INT,
      amount DECIMAL(10,2) NOT NULL,
      issue_date DATE NOT NULL,
      payment_date DATE,
      status ENUM('Outstanding', 'Paid', 'Waived') DEFAULT 'Outstanding',
      FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
      FOREIGN KEY (borrowing_id) REFERENCES Borrowings(borrowing_id) ON DELETE SET NULL,
      CHECK (amount > 0),
      CHECK (payment_date IS NULL OR payment_date >= issue_date)
  );

  -- Create staff table
  CREATE TABLE Staff (
      staff_id INT AUTO_INCREMENT PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL,
      phone VARCHAR(20),
      address VARCHAR(200),
      position VARCHAR(50) NOT NULL,
      salary DECIMAL(10,2),
      status ENUM('Active', 'On Leave', 'Terminated') DEFAULT 'Active'
  );

-- Create libraryevent table
  CREATE TABLE LibraryEvents (
      event_id INT AUTO_INCREMENT PRIMARY KEY,
      event_name VARCHAR(100) NOT NULL,
      description TEXT,
      event_date DATETIME NOT NULL,
      duration_minutes INT,
      location VARCHAR(100) NOT NULL,
      max_attendees INT
  );

  -- Create eventregistration table
  CREATE TABLE EventRegistrations (
      registration_id INT AUTO_INCREMENT PRIMARY KEY,
      event_id INT NOT NULL,
      member_id INT NOT NULL,
      attendance_status ENUM('Registered', 'Attended', 'No Show') DEFAULT 'Registered',
      FOREIGN KEY (event_id) REFERENCES LibraryEvents(event_id) ON DELETE CASCADE,
      FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
      UNIQUE (event_id, member_id)
  );

 -- Insert into Members table
  INSERT INTO Members (first_name, last_name, email, phone, address, date_of_birth, membership_date, membership_expiry, status)
  VALUES
  ('John', 'Smith', 'johnsmith21@gmail.com', '0756219043', '123 Main Street, Nairobi', '2005-07-15', '2023-01-10', '2024-01-10', 'Active'),
  ('Emily', 'Johnson', 'emilyj02@gmail.com', '0113546000', '456 Ocean Drive, Mombasa', '1990-11-22', '2023-02-15', '2024-02-15', 'Suspended'),
  ('Michael', 'Williams', 'michaelw94@gmail.com', '0765009722', '789 Lake View, Kisumu', '2000-03-30', '2023-03-20', '2024-03-20', 'Active'),
  ('Sarah', 'Brown', 'sarahb@gmail.com', '0792023511', '214 University Road, Eldoret', '1998-09-05', '2023-04-25', '2024-04-25', 'Suspended'),
  ('David', 'Jones', 'davidj08@gmail.com', '0722334567', '567 Nakuru Road, Nakuru', '1982-12-18', '2023-05-30', '2024-05-30', 'Active');

  -- Insert data into Authors table
  INSERT INTO Authors (first_name, last_name, birth_year, nationality)
  VALUES
  ('George', 'Orwell', 1903, 'British'),
  ('Robert', 'Greene', 1990, 'American'),
  ('James', 'Clear', 1986, 'American'),
  ('J.K.', 'Rowling', 1965, 'British'),
  ('Stephen', 'King', 1947, 'American');

  -- Insert data into Publishers table
  INSERT INTO Publishers (publisher_name, address, phone, email)
  VALUES
  ('Penguin Books', '123 Publishing Ave, London', '555-0201', 'info@penguin.com'),
  ('HarperCollins', '456 Book St, New York', '555-0202', 'contact@harpercollins.com'),
  ('Simon & Schuster', '789 Read Blvd, Chicago', '555-0203', 'support@simonandschuster.com');

  -- Insert data into Categories table
  INSERT INTO Categories (category_name)
  VALUES
  ('Fiction'),
  ('Non-Fiction'),
  ('Science Fiction'),
  ('Romance'),
  ('Horror'),
  ('Classic Literature');

  -- Insert data into Books table
  INSERT INTO Books (title, publisher_id, publication_year, page_count)
  VALUES
  ('1984', 1, 1949, 328),
  ('The 48 Laws of Power', 1, 1998, 480),
  ('Atomic Habits', 2, 2018, 320),
  ('Harry Potter and the Philosopher''s Stone', 3, 1997, 223),
  ('The Shining', 2, 1977, 447);

  -- Check the author IDs
  SELECT author_id, first_name, last_name FROM Authors;

  -- Check the book IDs
  SELECT book_id, title FROM Books;

  -- Insert data into BookCategories table
  INSERT INTO BookCategories (book_id, category_id)
  VALUES
  (1, 1), (1, 3), (1, 6),
  (2, 1), (2, 4), (2, 6),
  (3, 1), (3, 6),
  (4, 1),
  (5, 1), (5, 5);

  -- Insert data into BookCopies table
  INSERT INTO BookCopies (book_id, acquisition_date, status)
  VALUES
  (1, '2020-01-15', 'Available'),
  (1, '2020-01-15', 'Reserved'),
  (2, '2019-05-20', 'Available'),
  (3, '2021-03-10', 'Checked Out'),
  (4, '2022-07-05', 'Available'),
  (4, '2022-07-05', 'Lost'),
  (5, '2021-11-30', 'In Repair');

  -- Insert data into Borrowings table
  INSERT INTO Borrowings (copy_id, member_id, checkout_date, due_date, return_date, status, late_fee)
  VALUES
  (4, 3, '2023-06-01', '2023-06-15', NULL, 'Checked Out', 0.00),
  (1, 2, '2023-05-20', '2023-06-03', '2023-06-02', 'Returned', 0.00),
  (3, 1, '2023-05-25', '2023-06-08', NULL, 'Overdue', 5.50),
  (6, 5, '2023-06-05', '2023-06-19', NULL, 'Checked Out', 0.00);

  -- Insert data into Reservations table
  INSERT INTO Reservations (book_id, member_id, reservation_date, expiry_date, status)
  VALUES
  (2, 4, '2023-06-10', '2023-06-17', 'Pending'),
  (5, 2, '2023-06-08', '2023-06-15', 'Pending');

  -- Insert data into Fines table
  INSERT INTO Fines (member_id, borrowing_id, amount, issue_date, payment_date, status)
  VALUES
  (1, 3, 500.50, '2023-06-09', NULL, 'Outstanding'),
  (3, 1, 350.00, '2023-06-16', '2023-06-18', 'Paid');

  -- Insert data into Staff table
  INSERT INTO Staff (first_name, last_name, email, phone, address, position, salary, status)
  VALUES
  ('Robert', 'Wilson', 'rwilson22@library.org', '0102678544', '45 Riverside, Nairobi', 'Librarian', 45000.00, 'Active'),
  ('Jennifer', 'Davis', 'j.davis@library.org', '0765775431', 'Section58, Nakuru', 'Assistant Librarian', 38000.00, 'Active'),
  ('Thomas', 'Miller', 't.miller@library.org', '0755239088', 'Milimani Estate, Kisumu', 'IT Specialist', 42000.00, 'Active');

 -- Insert data into LibraryEvents table
  INSERT INTO LibraryEvents (event_name, description, event_date, duration_minutes, location, max_attendees)
  VALUES
  ('Summer Reading Kickoff', 'Join us to start our summer reading program!', '2023-06-21', 120, 'Main Hall', 50),
  ('Author Talk: Local Writers', 'Meet and hear from local published authors', '2023-07-12', 90, 'Conference Room', 30),
  ('Children''s Story Hour', 'Weekly story reading for children ages 3-8', '2023-06-14', 60, 'Children''s Area', 20);

  -- Insert data into EventRegistrations table
  INSERT INTO EventRegistrations (event_id, member_id, attendance_status)
  VALUES
  (1, 1, 'Registered'),
  (1, 2, 'Registered'),
  (1, 5, 'Registered'),
  (2, 3, 'Registered'),
  (3, 2, 'Registered'),
  (3, 4, 'Registered');

  SELECT * FROM authors WHERE author_id IN (1, 2, 3, 4, 5);

  -- Insert data into BookAuthors table
  INSERT INTO BookAuthors (book_id, author_id)
  VALUES
  (1, 11),
  (2, 12),
  (3, 13),
  (4, 14),
  (5, 15);

  -- Create indexes for better performance
  CREATE INDEX idx_books_title ON Books(title);
  CREATE INDEX idx_members_email ON Members(email);
  CREATE INDEX idx_borrowings_member ON Borrowings(member_id);
  CREATE INDEX idx_borrowings_due_date ON Borrowings(due_date);
  CREATE INDEX idx_bookcopies_status ON BookCopies(status);
  CREATE INDEX idx_reservations_status ON Reservations(status);























