-- Library Management System Project 2 -- 

-- creating branch table 

create table branch
			(	branch_id VARCHAR(10) PRIMARY KEY,	
				manager_id	VARCHAR (10),
				branch_address	VARCHAR (35),
				contact_no VARCHAR (10)
			);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(25);


DROP TABLE IF EXISTS employees;
create table employees
		 (	 emp_id VARCHAR(10) PRIMARY KEY,
			 emp_name VARCHAR(25),	
			 position VARCHAR (25),
			 salary	INT,
			 branch_id VARCHAR (25) --FK
		 );


DROP TABLE IF EXISTS books;
CREATE TABLE books
			(isbn 	VARCHAR(20) PRIMARY KEY,
			 book_title	VARCHAR(55),
			 category	VARCHAR (10),
			 rental_price  FLOAT,
			 status	VARCHAR(10),
			 author	VARCHAR(20),
			 publisher VARCHAR(25)
			);

-- ALTER TABLE books
-- ALTER COLUMN category TYPE VARCHAR (25);

DROP TABLE members;
CREATE TABLE members
			(member_id VARCHAR(10)PRIMARY KEY,	
			 member_name VARCHAR(20),
			 member_address	 VARCHAR(30),
			 reg_date DATE
			);


DROP TABLE IF EXISTS issued_status;
CREATE TABLE issue_status
 			(issued_id VARCHAR(10) PRIMARY KEY,	
			 issued_member_id VARCHAR(10), -- FK
			 issued_book_name VARCHAR(55), 
			 issued_date DATE, 
			 issued_book_isbn VARCHAR(25), --FK
			 issued_emp_id VARCHAR(10) --FK
			);


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
			(return_id VARCHAR(20) PRIMARY KEY,
			 issued_id VARCHAR(20),
			 return_book_name VARCHAR(10),
			 return_date DATE,
			 return_book_isbn VARCHAR(10)
			 );

-- FOREIGN KEY
ALTER TABLE issue_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issue_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issue_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issue_status
FOREIGN KEY (issued_id)
REFERENCES issue_status(issued_id);

 