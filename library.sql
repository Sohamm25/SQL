
-- Create Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Country VARCHAR(100)
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(100),
    PublishedYear INT,
    AvailableCopies INT DEFAULT 1,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE SET NULL
);

-- Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    RegisteredDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions Table (Borrowing/Lending)
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    BookID INT,
    BorrowDate DATE DEFAULT (CURRENT_DATE),
    ReturnDate DATE,
    Status ENUM('Borrowed', 'Returned') DEFAULT 'Borrowed',
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
);

-- Insert Sample Data
INSERT INTO Authors (Name, Country) VALUES 
('J.K. Rowling', 'UK'),
('George Orwell', 'UK'),
('J.R.R. Tolkien', 'South Africa');

INSERT INTO Books (Title, AuthorID, Genre, PublishedYear, AvailableCopies) VALUES 
('Harry Potter and the Philosopher\'s Stone', 1, 'Fantasy', 1997, 5),
('1984', 2, 'Dystopian', 1949, 3),
('The Lord of the Rings', 3, 'Fantasy', 1954, 4);

INSERT INTO Users (Name, Email, Phone) VALUES 
('Soham Pawar', 'soham@example.com', '9876543210'),
('John Doe', 'johndoe@example.com', '9123456789');

-- Borrow a Book
INSERT INTO Transactions (UserID, BookID) VALUES (1, 1);

-- Return a Book
UPDATE Transactions 
SET ReturnDate = CURDATE(), Status = 'Returned' 
WHERE UserID = 1 AND BookID = 1 AND Status = 'Borrowed';

-- View Available Books
SELECT Title, AvailableCopies FROM Books WHERE AvailableCopies > 0;

-- Check Borrowed Books
SELECT U.Name AS UserName, B.Title AS BookTitle, T.BorrowDate, T.Status
FROM Transactions T
JOIN Users U ON T.UserID = U.UserID
JOIN Books B ON T.BookID = B.BookID
WHERE T.Status = 'Borrowed';

