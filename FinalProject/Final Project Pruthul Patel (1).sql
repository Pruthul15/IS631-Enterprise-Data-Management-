-- ============================================================
-- IS 631 Database Systems - Term Project
-- Spring 2026
-- Name: Pruthul Patel
-- ============================================================

-- ============================================================
-- CLEAN SLATE: DROP EXISTING OBJECTS
-- ============================================================
DROP TABLE star_billings CASCADE CONSTRAINTS;
DROP TABLE rental_history CASCADE CONSTRAINTS;
DROP TABLE media CASCADE CONSTRAINTS;
DROP TABLE actors CASCADE CONSTRAINTS;
DROP TABLE movies CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;

DROP SEQUENCE customer_id_seq;
DROP SEQUENCE title_id_seq;
DROP SEQUENCE media_id_seq;
DROP SEQUENCE actor_id_seq;

DROP VIEW title_unavail;
DROP SYNONYM tu;

-- ============================================================
-- STEP 1: CREATE TABLES
-- ============================================================

-- Table: CUSTOMERS
CREATE TABLE customers
(customer_id  NUMBER(10)    CONSTRAINT customers_customer_id_pk  PRIMARY KEY,
 last_name    VARCHAR2(25)  CONSTRAINT customers_last_name_nn    NOT NULL,
 first_name   VARCHAR2(25)  CONSTRAINT customers_first_name_nn   NOT NULL,
 home_phone   VARCHAR2(12)  CONSTRAINT customers_home_phone_nn   NOT NULL,
 address      VARCHAR2(100) CONSTRAINT customers_address_nn      NOT NULL,
 city         VARCHAR2(30)  CONSTRAINT customers_city_nn         NOT NULL,
 state        VARCHAR2(2)   CONSTRAINT customers_state_nn        NOT NULL,
 email        VARCHAR2(25),
 cell_phone   VARCHAR2(12));

DESC customers;

-- Table: MOVIES
CREATE TABLE movies
(title_id     NUMBER(10)    CONSTRAINT movies_title_id_pk     PRIMARY KEY,
 title        VARCHAR2(60)  CONSTRAINT movies_title_nn        NOT NULL,
 description  VARCHAR2(400) CONSTRAINT movies_description_nn  NOT NULL,
 rating       VARCHAR2(4)   CONSTRAINT movies_rating_ck       CHECK (rating IN ('G','PG','R','PG13')),
 category     VARCHAR2(20)  CONSTRAINT movies_category_nn     NOT NULL
                            CONSTRAINT movies_category_ck     CHECK (category IN ('DRAMA','COMEDY','ACTION','CHILD','SCIFI','DOCUMENTARY')),
 release_date DATE          CONSTRAINT movies_release_date_nn  NOT NULL);

DESC movies;

-- Table: MEDIA
CREATE TABLE media
(media_id  NUMBER(10)  CONSTRAINT media_media_id_pk  PRIMARY KEY,
 format    VARCHAR2(3) CONSTRAINT media_format_nn     NOT NULL
                       CONSTRAINT media_format_ck     CHECK (format IN ('DVD','VHS')),
 title_id  NUMBER(10)  CONSTRAINT media_title_id_nn   NOT NULL
                       CONSTRAINT media_title_id_fk   REFERENCES movies(title_id));

DESC media;

-- Table: ACTORS
CREATE TABLE actors
(actor_id   NUMBER(10)   CONSTRAINT actors_actor_id_pk    PRIMARY KEY,
 stage_name VARCHAR2(40) CONSTRAINT actors_stage_name_nn  NOT NULL,
 first_name VARCHAR2(25) CONSTRAINT actors_first_name_nn  NOT NULL,
 last_name  VARCHAR2(25) CONSTRAINT actors_last_name_nn   NOT NULL,
 birth_date DATE         CONSTRAINT actors_birth_date_nn  NOT NULL);

DESC actors;

-- Table: STAR_BILLINGS
CREATE TABLE star_billings
(actor_id  NUMBER(10)   CONSTRAINT star_billings_actor_id_nn  NOT NULL
                        CONSTRAINT star_billings_actor_id_fk  REFERENCES actors(actor_id),
 title_id  NUMBER(10)   CONSTRAINT star_billings_title_id_nn  NOT NULL
                        CONSTRAINT star_billings_title_id_fk  REFERENCES movies(title_id),
 comments  VARCHAR2(40),
 CONSTRAINT star_billings_actor_title_pk PRIMARY KEY (actor_id, title_id));

DESC star_billings;

-- Table: RENTAL_HISTORY
CREATE TABLE rental_history
(media_id     NUMBER(10)  CONSTRAINT rental_history_media_id_nn     NOT NULL
                          CONSTRAINT rental_history_media_id_fk     REFERENCES media(media_id),
 rental_date  DATE        DEFAULT SYSDATE
                          CONSTRAINT rental_history_rental_date_nn  NOT NULL,
 customer_id  NUMBER(10)  CONSTRAINT rental_history_customer_id_nn  NOT NULL
                          CONSTRAINT rental_history_customer_id_fk  REFERENCES customers(customer_id),
 return_date  DATE,
 CONSTRAINT rental_history_media_date_pk PRIMARY KEY (media_id, rental_date));

DESC rental_history;

-- ============================================================
-- STEP 2: CONSTRAINT DATA DICTIONARY QUERIES (single-line)
-- ============================================================
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'CUSTOMERS';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'MOVIES';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'MEDIA';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'ACTORS';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'STAR_BILLINGS';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'RENTAL_HISTORY';

-- ============================================================
-- STEP 3: CREATE VIEW - TITLE_UNAVAIL
-- ============================================================
CREATE OR REPLACE VIEW title_unavail
AS SELECT m.title, rh.media_id
FROM movies m
JOIN media med ON med.title_id = m.title_id
JOIN rental_history rh ON rh.media_id = med.media_id
WHERE rh.return_date IS NULL
WITH READ ONLY;

-- ============================================================
-- STEP 4: CREATE SEQUENCES
-- ============================================================
CREATE SEQUENCE customer_id_seq INCREMENT BY 1 START WITH 101 NOCACHE NOCYCLE;
CREATE SEQUENCE title_id_seq    INCREMENT BY 1 START WITH 1   NOCACHE NOCYCLE;
CREATE SEQUENCE media_id_seq    INCREMENT BY 1 START WITH 92  NOCACHE NOCYCLE;
CREATE SEQUENCE actor_id_seq    INCREMENT BY 1 START WITH 1001 NOCACHE NOCYCLE;

-- Sequence data dictionary query (single-line)
SELECT sequence_name, min_value, max_value, increment_by, last_number FROM user_sequences;

-- ============================================================
-- STEP 5: INSERT DATA
-- ============================================================

-- CUSTOMERS (6 rows, sequence for PK)
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Palombo', 'Lisa', '716-270-2669', '123 Main St', 'Buffalo', 'NY', 'palombo@ecc.edu', '716-555-1212');
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Smith', 'John', '212-555-1234', '456 Park Ave', 'New York', 'NY', 'jsmith@email.com', '212-555-5678');
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Johnson', 'Mary', '718-555-2345', '789 Broadway', 'Brooklyn', 'NY', 'mjohnson@email.com', '718-555-6789');
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Williams', 'James', '516-555-3456', '321 Oak St', 'Hempstead', 'NY', 'jwilliams@email.com', '516-555-7890');
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Brown', 'Patricia', '914-555-4567', '654 Elm St', 'Yonkers', 'NY', 'pbrown@email.com', '914-555-8901');
INSERT INTO customers (customer_id, last_name, first_name, home_phone, address, city, state, email, cell_phone) VALUES (customer_id_seq.NEXTVAL, 'Davis', 'Robert', '631-555-5678', '987 Pine St', 'Islip', 'NY', 'rdavis@email.com', '631-555-9012');

SELECT * FROM customers;

-- MOVIES (6 rows, sequence for PK)
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'Remember the Titans', 'The true story of a newly appointed African-American coach and his high school team on their first season as a racially integrated unit.', 'PG', 'DRAMA', '29-SEP-2000');
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'The Lion King', 'A young lion prince is cast out of his pride by his cruel uncle, who claims he killed his own father.', 'G', 'CHILD', '24-JUN-1994');
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'Die Hard', 'A New York police officer tries to save his wife and several others taken hostage by German terrorists during a Christmas party.', 'R', 'ACTION', '20-JUL-1988');
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'Ace Ventura', 'A quirky detective who specializes in finding animals goes on a mission to find the missing mascot of the Miami Dolphins football team.', 'PG13', 'COMEDY', '04-FEB-1994');
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanitys survival on a new planet.', 'PG13', 'SCIFI', '07-NOV-2014');
INSERT INTO movies (title_id, title, description, rating, category, release_date) VALUES (title_id_seq.NEXTVAL, 'March of the Penguins', 'A look at the annual journey of Emperor penguins as they march to their traditional breeding grounds in Antarctica.', 'G', 'DOCUMENTARY', '24-JUN-2005');

SELECT * FROM movies;

-- MEDIA (6 rows, sequence for PK)
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'DVD', 1);
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'VHS', 1);
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'DVD', 2);
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'DVD', 3);
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'VHS', 4);
INSERT INTO media (media_id, format, title_id) VALUES (media_id_seq.NEXTVAL, 'DVD', 5);

SELECT * FROM media;

-- ACTORS (4 rows, sequence for PK)
INSERT INTO actors (actor_id, stage_name, first_name, last_name, birth_date) VALUES (actor_id_seq.NEXTVAL, 'Brad Pitt', 'William', 'Pitt', '18-DEC-1963');
INSERT INTO actors (actor_id, stage_name, first_name, last_name, birth_date) VALUES (actor_id_seq.NEXTVAL, 'Denzel Washington', 'Denzel', 'Washington', '28-DEC-1954');
INSERT INTO actors (actor_id, stage_name, first_name, last_name, birth_date) VALUES (actor_id_seq.NEXTVAL, 'Jim Carrey', 'James', 'Carrey', '17-JAN-1962');
INSERT INTO actors (actor_id, stage_name, first_name, last_name, birth_date) VALUES (actor_id_seq.NEXTVAL, 'Matthew McConaughey', 'Matthew', 'McConaughey', '04-NOV-1969');

SELECT * FROM actors;

-- STAR_BILLINGS (4 rows)
INSERT INTO star_billings (actor_id, title_id, comments) VALUES (1001, 2, 'Romantic Lead');
INSERT INTO star_billings (actor_id, title_id, comments) VALUES (1002, 1, 'Lead Actor');
INSERT INTO star_billings (actor_id, title_id, comments) VALUES (1003, 4, 'Lead Actor');
INSERT INTO star_billings (actor_id, title_id, comments) VALUES (1004, 5, 'Lead Actor');

SELECT * FROM star_billings;

-- RENTAL_HISTORY (4 rows)
INSERT INTO rental_history (media_id, rental_date, customer_id, return_date) VALUES (92, '19-SEP-2010', 101, '20-SEP-2010');
INSERT INTO rental_history (media_id, rental_date, customer_id, return_date) VALUES (93, '20-SEP-2010', 102, NULL);
INSERT INTO rental_history (media_id, rental_date, customer_id, return_date) VALUES (94, '21-SEP-2010', 103, NULL);
INSERT INTO rental_history (media_id, rental_date, customer_id, return_date) VALUES (95, '22-SEP-2010', 104, '25-SEP-2010');

SELECT * FROM rental_history;

-- SELECT * from view (after data added)
SELECT * FROM title_unavail;

-- ============================================================
-- STEP 6: CREATE INDEX ON CUSTOMERS.LAST_NAME
-- ============================================================
CREATE INDEX customers_last_name_idx ON customers(last_name);

-- Index data dictionary query (single-line)
SELECT DISTINCT ic.index_name, ic.column_name, ic.column_position, id.uniqueness FROM user_indexes id, user_ind_columns ic WHERE id.table_name = ic.table_name AND ic.table_name = 'CUSTOMERS';

-- ============================================================
-- STEP 7: CREATE SYNONYM TU FOR TITLE_UNAVAIL
-- ============================================================
CREATE SYNONYM tu FOR title_unavail;

-- Synonym data dictionary query
SELECT * FROM user_synonyms;

-- SELECT * from synonym
SELECT * FROM tu;
