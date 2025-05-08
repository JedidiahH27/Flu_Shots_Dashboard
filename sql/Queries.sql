CREATE TABLE immunizations
(
 DATE TIMESTAMP
,PATIENT varchar(100)
,ENCOUNTER varchar(100)
,CODE int
,DESCRIPTION varchar(500)
);

CREATE TABLE patients
(
 Id VARCHAR(100)
,BIRTHDATE date
,DEATHDATE date
,SSN VARCHAR(100)
,DRIVERS VARCHAR(100)
,PASSPORT VARCHAR(100)
,PREFIX VARCHAR(100)
,FIRST VARCHAR(100)
,LAST VARCHAR(100)
,SUFFIX VARCHAR(100)
,MAIDEN VARCHAR(100)
,MARITAL VARCHAR(100)
,RACE VARCHAR(100)
,ETHNICITY VARCHAR(100)
,GENDER VARCHAR(100)
,BIRTHPLACE VARCHAR(100)
,ADDRESS VARCHAR(100)
,CITY VARCHAR(100)
,STATE VARCHAR(100)
,COUNTY VARCHAR(100)
,FIPS INT 
,ZIP INT
,LAT float
,LON float
,HEALTHCARE_EXPENSES float
,HEALTHCARE_COVERAGE float
,INCOME int
,Mrn int
);

WITH active_patients AS (SELECT DISTINCT patient
                         FROM encounters AS e
                         JOIN patients AS pat
                           ON e.patient = pat.id
                         WHERE START BETWEEN '2010-01-01' AND '2012-12-31 23:59'
                           AND pat.deathdate IS NULL
                           AND EXTRACT(MONTH FROM AGE('2022-12-31',pat.birthdate)) >= 6
                        ),

flu_shot_2022 AS (SELECT patient, MIN(date) AS earliest_flu_shot_2022
                  FROM immunizations
                  WHERE code = '5302'
                    AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
                  GROUP BY patient)

SELECT pat.birthdate,
       pat.race,
       pat.county,
       pat.id,
       pat.first,
       pat.last,
       flu.earliest_flu_shot_2022,
       flu.patient,
       CASE WHEN flu.patient IS NOT NULL THEN 1 ELSE 0 END AS flu_shot_2022
FROM patients AS pat
LEFT JOIN flu_shot_022 AS flu
  ON pat.id = flu.patient
WHERE 1=1
  AND pat.id IN (SELECT patient FROM active_patients);
