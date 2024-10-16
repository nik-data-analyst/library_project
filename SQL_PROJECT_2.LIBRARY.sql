select * from books;
select * from branch;
select * from employees;
select * from issue_status;
select * from return_status;
select * from members;


-- PROJECT TASK

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

-- Task 2: Update an Existing Member's Address

update members
set member_address ='125 Main st'
where member_id = 'C101';


-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * from issue_status;


DELETE FROM issue_status
where issued_id = 'IS121'


-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issue_status
where issued_emp_id = 'E101'


-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.


select 
	issued_emp_id,
	COUNT(issued_id) as total_book_issued
from issue_status
group by issued_emp_id
having count (issued_id) > 1

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**


CREATE TABLE  book_count
AS
select 
   b.isbn,
   b.book_title,
   count (ist.issued_id) as no_issued

from books as b 
JOIN
issue_status as ist
on ist.issued_book_isbn = b.isbn
group by 1,2

SELECT * from  book_count

-- Task 7. Retrieve All Books in a Specific Category:

select * from books
where category = 'Classic'

-- Task 8: Find Total Rental Income by Category:

select 
   b.category,
   sum(b.rental_price),
   count(*)
  from books as b 
JOIN
issue_status as ist
on ist.issued_book_isbn = b.isbn
group by 1


-- TASK 9 : List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180DAYS'


--TASK 10 : List Employees with Their Branch Manager's Name and their branch details:

SELECT 
		e1.*,
		b.manager_id,
		e2.emp_name AS manager
 FROM employees as e1
 JOIN
 branch as b
 ON b.branch_id = e1.branch_id
 JOIN
 employees as e2
 on b.manager_id = e2.emp_id


 -- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold, 7USD :


CREATE TABLE books_price_greater_than_7
AS
 SELECT * FROM books
 where rental_price > 7

SELECT * from books_price_greater_than_7


-- Task 12: Retrieve the List of Books Not Yet Returned

 SELECT 
 	DISTINCT ist.issued_book_name
 FROM issue_status as ist
left join 
return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null


-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.

/*
- issued_status == members == books == return_status
- filter book which is returned
- overdue > 30 days
*/

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issue_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1


-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

 SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn
        v_book_name,
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn; 

-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issue_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issue_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;


-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issue_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2




