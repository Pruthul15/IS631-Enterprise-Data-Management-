-- -----------------------------------------------
-- Name:   Pruthul
-- Course: IS631-852 Database Systems
-- Assignment 4 - Joins
-- -----------------------------------------------

-- Question 1
-- Join locations and departments using location_id, limit to location 1400
SELECT location_id, city, department_id, department_name
FROM locations JOIN departments USING (location_id)
WHERE location_id = 1400;

-- Question 2
-- Join d_play_list_items, d_track_listings, and d_cds using JOIN USING
SELECT song_id, cd_number, title, comments
FROM d_play_list_items
JOIN d_track_listings USING (song_id)
JOIN d_cds USING (cd_number);

-- Question 3
-- City, department name, location_id, department_id for depts 10, 20, 30 in Seattle
SELECT city, department_name, location_id, department_id
FROM locations JOIN departments USING (location_id)
WHERE department_id IN (10, 20, 30)
AND city = 'Seattle';

-- Question 4
-- Location_id, city, department name for all Canadian locations using JOIN ON
SELECT l.location_id, l.city, d.department_name
FROM locations l JOIN departments d
ON (l.location_id = d.location_id)
WHERE l.country_id = 'CA';

-- Question 5
-- Manager ID, department ID, department name, first name, last name
-- for employees in departments 80, 90, 110, 190
SELECT e.manager_id, e.department_id, d.department_name,
       e.first_name, e.last_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
WHERE e.department_id IN (80, 90, 110, 190);

-- Question 6
-- First name, last name, event date, description for all clients
-- including clients with no events scheduled (LEFT OUTER JOIN)
SELECT c.first_name, c.last_name, e.event_date, e.description
FROM d_clients c LEFT OUTER JOIN d_events e
ON (c.client_number = e.client_number);

-- Question 7
-- First name, last name, department name for all employees
-- including those not assigned to a department (LEFT OUTER JOIN)
SELECT e.first_name, e.last_name, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON (e.department_id = d.department_id);

-- Question 8
-- The statement below is wrong because PRIOR is on the wrong side.
-- CONNECT BY PRIOR manager_id = employee_id goes bottom-up (child to parent).
-- But START WITH last_name = 'King' starts at the top of the tree,
-- so we need to go top-down. The correct syntax should be:
-- CONNECT BY PRIOR employee_id = manager_id
SELECT last_name, department_id, salary
FROM employees
START WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id;

-- Question 9
-- Organization chart for entire employee table
-- Each level indented 2 dashes (-) instead of spaces
SELECT LPAD(last_name, LENGTH(last_name) + (LEVEL * 2) - 2, '-') AS "Org Chart"
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;