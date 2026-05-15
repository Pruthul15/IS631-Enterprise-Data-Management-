-- Pruthul Patel
-- IS631-852
-- Assignment 3: Helper Functions

-- Question 1: Round and truncate today's date
SELECT ROUND(SYSDATE, 'MONTH') AS "Rounded to Month",
       ROUND(SYSDATE, 'YEAR') AS "Rounded to Year",
       TRUNC(SYSDATE, 'MONTH') AS "Truncated to Month",
       TRUNC(SYSDATE, 'YEAR') AS "Truncated to Year"
FROM dual;

-- Question 2: Find position of H in the string
SELECT INSTR('Being part of the Honors College gives you a lot of opportunities', 'H') AS "Position of H"
FROM dual;

-- Question 3: Order date and order total with $ padding
SELECT order_date,
       LPAD(order_total, 10, '$') AS TOTAL
FROM f_orders;

-- Question 4: Employees by month of hire date using substitution variable
SELECT *
FROM employees
WHERE TO_CHAR(hire_date, 'MON') = UPPER('&month');

-- Question 5: Years between Bob Miller's birthday and today
SELECT first_name, last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, birthdate) / 12) AS "Years"
FROM f_staffs
WHERE first_name = 'Bob' AND last_name = 'Miller';