-- create the database

CREATE database prosecutions_convictions;

USE prosecutions_convictions;

-- create the tables

CREATE TABLE ethnicity_info(
e_id VARCHAR(3) NOT NULL PRIMARY KEY,
ethnicity_group VARCHAR(70) NOT NULL 
);

CREATE TABLE sex_info(
s_id VARCHAR(2) NOT NULL PRIMARY KEY,
sex_group VARCHAR(6) NOT NULL
);

CREATE TABLE offence_info(
o_id VARCHAR(3) NOT NULL PRIMARY KEY,
offence_group VARCHAR(50) NOT NULL
);

CREATE TABLE police_area_info(
p_id VARCHAR(3) NOT NULL PRIMARY KEY,
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

CREATE TABLE offence_status(
d_id VARCHAR(5) NOT NULL PRIMARY KEY,
offence VARCHAR(3) NOT NULL,
police_area VARCHAR(3) NOT NULL
);

CREATE TABLE prosecution_conviction_status(
d_id VARCHAR(5) NOT NULL,
prosecuted BOOL,
convicted BOOL
);

CREATE TABLE year(
d_id VARCHAR(10) NOT NULL PRIMARY KEY,
offence_year VARCHAR(4),
prosecution_year VARCHAR(4),
conviction_year VARCHAR(4)
);

CREATE TABLE victims(
v_id VARCHAR(10)NOT NULL PRIMARY KEY,
victim_first_name VARCHAR(50) NOT NULL,
victim_last_name VARCHAR(10) NOT NULL,
sex VARCHAR(6) NOT NULL,
age INT NOT NULL,
ethnicity VARCHAR(3) NOT NULL,
d_id VARCHAR(10) NOT NULL
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
(s_id, sex_group )
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


-- SELECT * FROM defendants;
-- SELECT * FROM victims;
-- SELECT * FROM ethnicity_info;
-- SELECT * FROM offence;
-- SELECT * FROM offence_info;
-- SELECT * FROM police_area_info;
-- SELECT * FROM prosecution_conviction_status;
-- SELECT * FROM sex_info;
-- SELECT * FROM year;


-- adding foreign keys to the tables

-- making sex in defendants the foreign key:
ALTER TABLE defendants
ADD CONSTRAINT
FOREIGN KEY (sex)
REFERENCES sex_info (s_id);

-- making ethnicity in defendants the foreign key:
ALTER TABLE defendants 
ADD CONSTRAINT
FOREIGN KEY (ethnicity)
REFERENCES ethnicity_info (e_id);

-- making d_id in victims the foreign key:
ALTER TABLE victims
ADD CONSTRAINT
FOREIGN KEY (d_id)
REFERENCES defendants (d_id);

-- making sex in victims the foreign key:
ALTER TABLE victims
ADD CONSTRAINT
FOREIGN KEY (sex)
REFERENCES sex_info (s_id);

-- making ethnicity in victims the foreign key:
ALTER TABLE victims
ADD CONSTRAINT
FOREIGN KEY (ethnicity)
REFERENCES ethnicity_info (e_id);

-- making d_id in offence_status the foreign key:
ALTER TABLE offence_status
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

-- making d_id in prosecution_conviction_status the foreign key:
ALTER TABLE prosecution_conviction_status
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

-- making d_id in year the foreign key:
ALTER TABLE year
ADD CONSTRAINT 
FOREIGN KEY (d_id) 
REFERENCES defendants (d_id);

-- making offence in offence the foreign key:
ALTER TABLE offence_status
ADD CONSTRAINT
FOREIGN KEY (offence)
REFERENCES offence_info (o_id);

-- however, making police_area in offence the foreign key is NOT successful (despite being logically identical to the previos query) Can't understand why:
ALTER TABLE offence_status
ADD CONSTRAINT 
FOREIGN KEY (police_area) 
REFERENCES police_area_info (p_id);


-- join: Select the first and last names of all of the defendants with their conviction status
SELECT 
def.d_id, def.defendant_first_name, def.defendant_last_name, pros.convicted
FROM
defendants AS def
INNER JOIN
prosecution_conviction_status AS pros
ON def.d_id = pros.d_id;

-- join: Find the name and age of those who where prosecuted ( prosecuted = '1') in 2020 (prosecution_year = '2020')
SELECT def.defendant_first_name, def.defendant_last_name, def.age , pros.prosecuted, y.prosecution_year
FROM 
defendants AS def
JOIN
prosecution_conviction_status AS pros ON def.d_id = pros.d_id
JOIN
year AS y ON y.d_id = def.d_id
WHERE
pros.prosecuted = '1' AND y.prosecution_year = '2020';

-- subquery: Find all the defendants who have known victims
SELECT def.d_id, def.defendant_first_name, def.defendant_last_name
FROM defendants as def
WHERE def.d_id IN
(SELECT
v.d_id
FROM victims as v);

-- subquery: Find the defendants who commited a crime in the police area 'p06' and also are older than the defendant whose last name is 'Adkins'
SELECT def.d_id, def.defendant_last_name, def.age, o.police_area
FROM defendants AS def, offence_status AS o
WHERE def.d_id = o.d_id AND o.police_area = 'p6' AND def.age >
(SELECT def.age
FROM defendants AS def
WHERE def.defendant_last_name = 'Adkins');

-- stored function: to see which defendants are adult and which are not:
DELIMITER //
CREATE FUNCTION is_adult(
    age INT
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE age_group VARCHAR(20);
    IF age >= 18 THEN
        SET age_group = 'YES';
    ELSEIF age < 18 THEN
        SET age_group = 'NO';
    END IF;
    RETURN (age_group);
END//age
DELIMITER ;

select * from prosecutions_convictions.defendants;

SELECT 
    d_id,
    defendant_first_name,
    age,
    is_adult(age)
FROM
    defendants;
    
-- DROP FUNCTION is_adult;

-- to see the stored function: 
-- SHOW FUNCTION STATUS WHERE db = 'prosecutions_convictions';

-- view: Create a view of female defendants that are below 18
CREATE VIEW vw_female_minus18_defs AS
SELECT defendant_first_name, defendant_last_name, age, sex
FROM defendants
WHERE age < 18 AND sex = 's1';

SELECT * FROM vw_female_minus18_defs;
-- DROP VIEW vw_female_minus18_defs;

-- view: Create a view of all Scottish female victims
CREATE VIEW vw_female_scottish_vics AS
SELECT v.victim_first_name, v.victim_last_name
FROM victims as v
JOIN ethnicity_info as ei
ON v.ethnicity = ei.e_id
JOIN sex_info as si
ON v.sex = si.s_id
WHERE ei.ethnicity_group LIKE '%Scottish%' AND si.sex_group = 'female';

SELECT * FROM vw_female_scottish_vics;
-- DROP VIEW vw_female_scottish_vics;

-- view: Create a view of all the Indian female victims who were subject to sexual offences
CREATE VIEW vw_female_indian_sexual_vics AS
SELECT v.victim_first_name, v.victim_last_name
FROM victims as v
JOIN ethnicity_info as ei
ON v.ethnicity = ei.e_id
JOIN sex_info as si
ON v.sex = si.s_id
JOIN offence_status as os
ON v.d_id = os.d_id
JOIN offence_info as oi
ON os.offence = oi.o_id
WHERE ei.ethnicity_group = 'Indian' AND si.sex_group = 'female' AND oi.offence_group LIKE 'Sexual%';

SELECT * FROM vw_female_indian_sexual_vics;
-- DROP VIEW vw_female_indian_sexual_vics;

-- group by: Maximum age of the defendants in each offence category
SELECT MAX(def.age), oi.offence_group
FROM defendants as def
INNER JOIN offence_status as os
ON def.d_id = os.d_id
INNER JOIN offence_info as oi
ON oi.o_id = os.offence
GROUP BY oi.offence_group
ORDER BY MAX(def.age) DESC;

-- group by: Minimum age of female victims in each offence category
SELECT MIN(v.age), oi.offence_group
FROM victims as v
INNER JOIN offence_status as os
ON v.d_id = os.d_id
INNER JOIN offence_info as oi
ON oi.o_id = os.offence
WHERE v.sex = 's1'
GROUP BY oi.offence_group
ORDER BY MIN(v.age) DESC;

-- group by: Count the number of offences in different police areas
SELECT COUNT(os.d_id), pl.police_area_name
FROM offence_status as os
INNER JOIN police_area_info as pl
ON pl.p_id = os.police_area
GROUP BY pl.police_area_name
ORDER BY COUNT(d_id) DESC;          

-- stored procedure: Insert new defendant information in the defendant table:
DELIMITER //

CREATE PROCEDURE insert_new_defendant(
IN d_id VARCHAR(10),
IN defendant_first_name VARCHAR(50),
IN defendant_last_name VARCHAR(50),
IN sex VARCHAR(6),
IN age INT,
IN ethnicity VARCHAR(3))

BEGIN
INSERT INTO defendants(d_id, defendant_first_name, defendant_last_name, sex, age, ethnicity)
VALUES
(d_id, defendant_first_name, defendant_last_name, sex, age, ethnicity);
END//

CALL insert_new_defendant('d0222', 'Sarah', 'Harris', 's1', 22, 'e4');

select * from defendants;

-- to see the stored procedure: 
-- SHOW PROCEDURE STATUS WHERE db = 'prosecutions_convictions';

-- to drop the stored procedure:
-- DROP PROCEDURE insert_new_defendant;

-- to delete the added row:
-- DELETE FROM defendants WHERE d_id = 'd0222';

-- The End :)
