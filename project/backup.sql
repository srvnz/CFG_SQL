
USE prosecutions_convictions;

LOAD DATA INFILE '/Users/sarvenaz/MySQL/project/data/mix.csv'
INTO TABLE mix
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE mix(
Mix1 INT,
Mix2 INT
);


-- secure--file-path-priv problem
-- identify the directory specified from which the import happens:
 
SHOW VARIABLES LIKE "secure_file_priv";
SELECT @@secure_file_priv;
SHOW VARIABLES LIKE "secure_auth";




LOAD DATA INFILE "/data/def.csv"
INTO TABLE defendant
COLUMNS TERMINATED BY ',';

LOAD DATA INFILE '/Users/sarvenaz/MySQL/project/data/def2.csv'
INTO TABLE defendant
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
(d_id, defendant_first_name, defendant_middle_name, defendant_last_name, gender)
SET defendant_middle_name = NULLIF(@vdefendant_middle_name,'')
;

-- loading failed, so I edited the secure-file-priv path in the "my.cnf" file. 

SHOW VARIABLES LIKE "secure_file_priv";

set @@secure_file_priv = '';

mysql --help

---


-- create the database

CREATE database prosecution_convictions;

USE prosecution_convictions;

-- create the tables

CREATE TABLE ethnicity_info(
e_id VARCHAR(3) NOT NULL,
ethnicity_group VARCHAR(70) NOT NULL
);

CREATE TABLE sex_info(
s_id VARCHAR(2) NOT NULL,
sex_name VARCHAR(6) NOT NULL
);

CREATE TABLE offence_info(
o_id VARCHAR(3) NOT NULL,
offence_group VARCHAR(50) NOT NULL
);

CREATE TABLE police_area_info(
p_id VARCHAR(3) NOT NULL,
police_area_name VARCHAR(50) NOT NULL
);

CREATE TABLE defendants(
d_id VARCHAR(5) NOT NULL PRIMARY KEY,
defendant_first_name VARCHAR(50) NOT NULL,
defendant_last_name VARCHAR(50) NOT NULL,
sex VARCHAR(3) NOT NULL,
age INTEGER NOT NULL,
ethnicity VARCHAR(3) NOT NULL
);

CREATE TABLE offence(
d_id VARCHAR(5) NOT NULL,
offence VARCHAR(3) NOT NULL,
police_area VARCHAR(3) NOT NULL
);

CREATE TABLE prosecution_conviction_status(
d_id VARCHAR(5) NOT NULL,
prosecuted BOOL,
convicted BOOL
);

CREATE TABLE year(
d_id VARCHAR(10) NOT NULL,
offence_year VARCHAR(4),
prosecution_year VARCHAR(4),
conviction_year VARCHAR(4)
);

-- populate the tables

INSERT INTO ethnicity_info
(e_id, ethnicity_group)
VALUES
('e1', 'English / Welsh / Scottish / Northern Irish / British'),
('e2', 'Irish'),
('e3', 'Gypsy or Irish Traveller'),
('e4', 'Any other White background'),
('e5', 'White and Black Caribbean'),
('e6', 'White and Black African'),
('e7', 'White and Asian'),
('e8', 'Any other Mixed / Multiple ethnic background'),
('e9', 'Indian'),
('e10', 'Pakistani'),
('e11', 'Bangladeshi'),
('e12', 'Chinese'),
('e13', 'Any other Asian background'),
('e14', 'African'),
('e15', 'Caribbean'),
('e16', 'Any other Black / African / Caribbean background'),
('e17', 'Arab'),
('e18', 'Any other ethnic group');

INSERT INTO sex_info
(s_id, sex_name)
VALUES
('s1', 'female'),
('s2', 'male');

INSERT INTO offence_info
(o_id, offence_group)
VALUES
('o1', 'Criminal damage and arson'),
('o2', 'Drug offences'),
('o3', 'Fraud Offences'),
('o4', 'Miscellaneous crimes against society'),
('o5', 'Possession of weapons'),
('o6', 'Public order offences'),
('o7', 'Robbery'),
('o8', 'Sexual offences'),
('o9', 'Theft Offences'),
('o10', 'Violence against the person');

INSERT INTO police_area_info
(p_id, police_area_name)
VALUES
('p01', 'Avon and Somerset'),
('p02', 'Bedfordshire'),
('p03', 'Cambridgeshire'),
('p04', 'Cheshire'),
('p05', 'City of London'),
('p06', 'Cleveland'),
('p07', 'Cumbria'),
('p08', 'Derbyshire'),
('p09', 'Devon and Cornwall'),
('p10', 'Dorset'),
('p11', 'Durham'),
('p12', 'Dyfed-Powys'),
('p13', 'Essex'),
('p14', 'Gloucestershire'),
('p15', 'Greater Manchester'),
('p16', 'Gwent'),
('p17', 'Hampshire'),
('p18', 'Hertfordshire'),
('p19', 'Humberside'),
('p20', 'Kent'),
('p21', 'Lancashire'),
('p22', 'Leicestershire'),
('p23', 'Lincolnshire'),
('p24', 'Merseyside'),
('p25', 'Metropolitan Police'),
('p26', 'Norfolk'),
('p27', 'North Wales'),
('p28', 'North Yorkshire'),
('p29', 'Northamptonshire'),
('p30', 'Northumbria'),
('p31', 'Nottinghamshire'),
('p32', 'South Wales'),
('p33', 'South Yorkshire'),
('p34', 'Staffordshire'),
('p35', 'Suffolk'),
('p36', 'Surrey'),
('p37', 'Sussex'),
('p38', 'Thames Valley'),
('p39', 'Warwickshire'),
('p40', 'West Mercia'),
('p41', 'West Midlands'),
('p42', 'West Yorkshire'),
('p43', 'Wiltshire');

-- 

SELECT * FROM defendants;
SELECT * FROM ethnicity_info;
SELECT * FROM offence;
SELECT * FROM offence_info;
SELECT * FROM police_area_info;
SELECT * FROM prosecution_conviction_status;
SELECT * FROM sex_info;
SELECT * FROM year;


-- adding foreign keys to the tables

ALTER TABLE offence
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

ALTER TABLE prosecution_conviction_status
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

ALTER TABLE year
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

-- join: The first and last names of the defendants with their conviction status

SELECT 
def.d_id,
def.defendant_first_name,
def.defendant_last_name,
prof.convicted
FROM
defendants AS def
INNER JOIN
prosecution_conviction_status AS pros
ON
def.d_id = pros.d_id

-- join: 

-- subquery

SELECT DISTINCT
def.defendant_last_name, def.age, y.conviction_year
FROM
defentants
INNER JOIN
year AS y
ON
def.d_id = y.d_id
INNER JOIN
prosecution_conviction_status AS pros
ON
y.d_id = pros.d_id
WHERE
y.conviction_year = '2020';

SELECT
def.defendant_last_name, def.age, pros.prosecuted
FROM
defendants AS def
WHERE
def.d_id IN (SELECT pros.d_id FROM prosecution_conviction_status AS pros WHERE pros.prosecuted = '1');

SELECT def.defendant_last_name, y.prosecution_year
FROM defendants AS def
WHERE d_id IN (SELECT d_id
			   FROM year as y
			   WHERE y.prosecution_year = '2020');
               
               
-- Find the name and age of those who where prosecuted ( prosecuted = '1') in 2020 (prosecution_year = '2020')

SELECT def.defendant_last_name, def.defendant_first_name, def.age, pros.prosecuted, y.prosecution_year
FROM 
defendants AS def
JOIN
prosecution_conviction_status AS pros ON def.d_id = pros.d_id
JOIN
year AS y ON y.d_id = def.d_id
WHERE
pros.prosecuted = '1' AND y.prosecution_year = '2020';



--- mohem:

-- stored procedure:
DELIMITER//
CREATE PROCEDURE select_all_convicted_below_25(
BEGIN
SELECT 
def.d_id, def.defendant_first_name, def.defendant_last_name, pros.convicted
FROM
defendants AS def
INNER JOIN
prosecution_conviction_status AS pros
ON def.d_id = pros.d_id
WHERE pros.convicted = '1' AND def.age < 25
END//



SELECT def.d_id, def.age, def.defendant_first_name, def.defendant_last_name
FROM defendants AS def
INNER JOIN prosecution_conviction_status as pros
ON def.d_id = pros.d_id
WHERE pro.convicted = '1' AND def.age < 25
GO;

EXEC select_all_convicted_below_25;



-- Change Delimiter
DELIMITER //
-- Create Stored Procedure
CREATE PROCEDURE InsertConvictionStatus(
IN d_id VARCHAR(10), 
IN convicted BOOL)
BEGIN

INSERT INTO prosecution_conviction_status(convicted)
VALUES (convicted);

END//
-- Change Delimiter again
DELIMITER ;

CALL InsertConvictionStatus ('d0001', '1');


SELECT *
FROM prosecution_conviction_status;

-- DROP PROCEDURE InsertConvictionStatus;





               
               
               ---- 
               
               
               -- subquery:

SELECT 






SELECT  d.defendant_first_name, d.defendant_last_name, d.age, d.d_id
FROM defendants AS d
WHERE v.d_id IN (SELECT
v.d_id
FROM victims AS v
WHERE v.age < d.age);

SELECT v.victim_first_name, v.victim_last_name, v.sex, v.age, d.defendant_first_name, d.defendant_last_name, d.age
FROM victims AS v, defendants AS d
WHERE v.sex = 's1' AND d.sex = 's1' OR
(SELECT v.police_area
FROM victims as v
WHERE v.offence = 'p%');
