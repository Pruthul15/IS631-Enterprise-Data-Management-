-- Pruthul Patel
-- IS631-852
-- Assignment 2

-- Question 1: Customer last name and mailing address
SELECT last_name, address
FROM f_customers;

-- Question 2a: Fix error - missing underscore in first_name
SELECT first_name
FROM f_staffs;

-- Question 2b: Fix error - use || for concatenation
SELECT first_name || ' ' || last_name AS "DJs on Demand Clients"
FROM d_clients;

-- Question 2c: Fix error - DISTINCT spelling and swap table/column
SELECT DISTINCT quantity
FROM f_order_lines;

-- Question 2d: Fix error - add underscore in order_number
SELECT order_number
FROM f_orders;

-- Question 3: D_CDs report with custom headings
SELECT cd_number AS "Inventory Item",
       title AS "CD Title",
       producer AS "Music Producer",
       year AS "Year Purchased"
FROM d_cds;

-- Question 4: Fix Carpe Diem query - correct case and column name
SELECT producer, title
FROM d_cds
WHERE title = 'Carpe Diem';

-- Question 5: Answer is a, b, c, and d (all values <= 5000 are selected)

-- Question 6: Employees born before 1980
SELECT first_name, last_name, birthdate
FROM f_staffs
WHERE birthdate < '01-JAN-1980';

-- Question 7: Partners with no authorized expense amount
SELECT first_name, last_name, auth_expense_amt
FROM d_partners
WHERE auth_expense_amt IS NULL;

-- Question 8: Last names ending in 's'
SELECT last_name AS "Possible Candidates"
FROM employees
WHERE last_name LIKE '%s';

-- Question 9: Answer is c. WHERE quantity IS NULL;

-- Question 10: Songs with type code 77, 12, or 1
SELECT *
FROM d_songs
WHERE type_code IN (77, 12, 1);