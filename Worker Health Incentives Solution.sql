SELECT @@VERSION AS 'SQL Server Version Details'
/*Microsoft SQL Server 2022 (RTM-GDR) (KB5040936) - 16.0.1121.4 (X64)
*/
-- Database=work

-- find healthiest employees
SELECT *
FROM Absenteeism_at_work
WHERE social_drinker=0
AND social_smoker=0
AND body_mass_index < 25 
AND
Absenteeism_time_in_hours <
(SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work);

--compensation rate increase for non smokers.
SELECT COUNT(*) as non_smokers
FROM Absenteeism_at_work
WHERE Social_smoker=0;
/*the *BUDGET=$983,221* and *NUMBER OF NON SMOKERS=686* (there are 686 records 'WHERE social_smoker = 0').
This means the HOURLY COMPENSATION RATE for each non smoker can be found
by dividing BUDGET by TOTAL YEARLY EMPLOYEE WORKING HOURS
(8 hours daily x 5 days weekly x 52 weeks = 2080 hours)
TOTAL YEARLY EMPLOYEE WORKING HOURS = (2080 x 686) = 1426880
HOURLY COMPENSATION RATE = (BUDGET/TOTAL YEARLY EMPLOYEE WORKING HOURS) = ($983,221/1426880) = additional $0.68 cents per hour/$1414.4 per year
*/

-- create join tables

SELECT ab.ID,
re.Reason,
Body_mass_index,
CASE WHEN body_mass_index < 18.5 THEN 'Underweight'
	 WHEN body_mass_index between 18.5 and 25 THEN 'Underweight'
	 WHEN body_mass_index between 25   and 30 THEN 'Underweight'
	 WHEN body_mass_index > 30  THEN 'Underweight'
	 Else 'error' END AS bmi_category,
Month_of_absence,
CASE WHEN Month_of_absence IN (12,1,2) THEN 'Winter'
	 WHEN Month_of_absence IN (3,4,5) THEN 'Spring'
	 WHEN Month_of_absence IN (6,7,8) THEN 'Summer'
	 WHEN Month_of_absence IN (9,10,11) THEN 'Fall'
	 Else 'error' END AS Season_Names,
Seasons,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
Pet,
Disciplinary_failure,
Age,
Work_load_Average_day,
Absenteeism_time_in_hours
FROM Absenteeism_at_work ab
LEFT JOIN compensation co
ON ab.ID=co.ID
LEFT JOIN Reasons re
ON ab.Reason_for_absence = re.Number;

-- BUILD DASHBOARD IN POWER BI
select *
from Absenteeism_at_work a
