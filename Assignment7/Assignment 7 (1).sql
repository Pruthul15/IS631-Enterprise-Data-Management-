-- Pruthul Patel
-- IS631-852
-- Assignment 7: Subqueries

-- Question 1
-- Names of Global Fast Foods staff whose staff type is NOT the same as Bob Miller's
SELECT first_name, last_name, staff_type
FROM f_staffs
WHERE staff_type !=
    (SELECT staff_type
     FROM f_staffs
     WHERE first_name = 'Bob' AND last_name = 'Miller');

-- Question 2
-- Department names that have the same location_id as Seattle
SELECT department_name
FROM departments
WHERE location_id =
    (SELECT location_id
     FROM locations
     WHERE city = 'Seattle');

-- Question 3
-- Staff types with a salary less than ANY Cook staff-type salary
SELECT staff_type, salary
FROM f_staffs
WHERE salary < ANY
    (SELECT salary
     FROM f_staffs
     WHERE staff_type = 'Cook');

-- Question 4
-- Department ID and average salary where avg salary is greater than Ernst's salary
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) >
    (SELECT salary
     FROM employees
     WHERE last_name = 'Ernst');

-- Question 5
-- Department ID and minimum salary, grouped by department,
-- where min salary is greater than the min salary of employees NOT in dept 50
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) >
    (SELECT MIN(salary)
     FROM employees
     WHERE department_id != 50);

-- Question 6
-- Original broken query had 5 errors:
-- Error 1: MIN(salary) was missing from the SELECT list
-- Error 2: WHERE MIN(salary) is invalid (group functions not allowed in WHERE)
-- Error 3: GROUP BY was placed after HAVING instead of before it
-- Error 4: Subquery was missing parentheses
-- Error 5: department_id < 50 should be department_id = 50
-- Corrected query:
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) >
    (SELECT MIN(salary)
     FROM employees
     WHERE department_id = 50);

-- Question 7
-- Which statements are true about the subquery below?
-- SELECT employee_id, last_name FROM employees
-- WHERE salary = (SELECT MIN(salary) FROM employees GROUP BY department_id);
--
-- Answer: Statements b and d are TRUE.
--
-- b) TRUE - The query intends to find employees who earn the same salary
--    as the smallest salary in any department.
--
-- d) TRUE - The query will NOT execute. The subquery uses GROUP BY department_id
--    which returns multiple rows (one per department), but the outer query
--    uses the = operator which only works with a single-row subquery.
--    This causes: ORA-01427: single-row subquery returns more than one row.
--
-- a) FALSE - Group functions like MIN() cannot be used directly in a WHERE clause.
-- c) FALSE - The inner query always executes FIRST, not the outer query.

-- Question 8
-- Pair-wise subquery: employees with same department_id AND manager_id as employee 141
-- Both columns are compared together in one subquery
SELECT last_name, first_name, department_id, manager_id
FROM employees
WHERE (department_id, manager_id) IN
    (SELECT department_id, manager_id
     FROM employees
     WHERE employee_id = 141)
AND employee_id != 141;

-- Question 9
-- Non-pair-wise subquery: employees with same department_id AND manager_id as employee 141
-- Each column is compared separately in its own subquery
SELECT last_name, first_name, department_id, manager_id
FROM employees
WHERE department_id IN
    (SELECT department_id
     FROM employees
     WHERE employee_id = 141)
AND manager_id IN
    (SELECT manager_id
     FROM employees
     WHERE employee_id = 141)
AND employee_id != 141;