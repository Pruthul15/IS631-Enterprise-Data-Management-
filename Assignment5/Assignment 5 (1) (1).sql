-- Pruthul Patel
-- IS631-852
-- Assignment 5:

-- Question 1
-- Rewrite using GROUP BY instead of SELECT DISTINCT MAX
SELECT MAX(song_id)
FROM d_track_listings
WHERE track IN (1, 2, 3)
GROUP BY track;

-- Question 2
-- Return both the maximum and minimum average salary grouped by department
SELECT MAX(AVG(salary)) AS "Highest Avg Salary",
       MIN(AVG(salary)) AS "Lowest Avg Salary"
FROM employees
GROUP BY department_id;

-- Question 3
-- Return the average of the maximum salaries in each department
SELECT AVG(MAX(salary)) AS "Avg of Max Salaries"
FROM employees
GROUP BY department_id;

-- Question 4
-- Combine employees and job_history into one output, suppress duplicates (UNION)
SELECT employee_id, job_id, hire_date, department_id
FROM employees
UNION
SELECT employee_id, job_id, start_date, department_id
FROM job_history;

-- Question 5
-- Same as Question 4 but do NOT suppress duplicates (UNION ALL)
SELECT employee_id, job_id, hire_date, department_id
FROM employees
UNION ALL
SELECT employee_id, job_id, start_date, department_id
FROM job_history
ORDER BY employee_id;

-- Question 6
-- List employees who have NOT changed jobs (not found in job_history)
SELECT employee_id, last_name, job_id
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id
    FROM job_history
);

-- Question 7
-- List employees who HAVE changed their jobs at least once
SELECT employee_id, last_name, job_id
FROM employees
WHERE employee_id IN (
    SELECT employee_id
    FROM job_history
);

-- Question 8
-- Total salary per manager and job_id with subtotals and grand total (ROLLUP)
SELECT manager_id, job_id, SUM(salary) AS "Total Salary"
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY ROLLUP(manager_id, job_id);

-- Question 9
-- Same as Question 8 but also include subtotal per job_id across all managers (CUBE)
SELECT manager_id, job_id, SUM(salary) AS "Total Salary"
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY CUBE(manager_id, job_id);