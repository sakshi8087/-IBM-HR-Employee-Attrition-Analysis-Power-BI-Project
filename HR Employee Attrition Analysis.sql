SELECT TOP (1000) [Age]
      ,[Attrition]
      ,[BusinessTravel]
      ,[DailyRate]
      ,[Department]
      ,[DistanceFromHome]
      ,[Education]
      ,[EducationField]
      ,[EmployeeCount]
      ,[EmployeeNumber]
      ,[EnvironmentSatisfaction]
      ,[Gender]
      ,[HourlyRate]
      ,[JobInvolvement]
      ,[JobLevel]
      ,[JobRole]
      ,[JobSatisfaction]
      ,[MaritalStatus]
      ,[MonthlyIncome]
      ,[MonthlyRate]
      ,[NumCompaniesWorked]
      ,[Over18]
      ,[OverTime]
      ,[PercentSalaryHike]
      ,[PerformanceRating]
      ,[RelationshipSatisfaction]
      ,[StandardHours]
      ,[StockOptionLevel]
      ,[TotalWorkingYears]
      ,[TrainingTimesLastYear]
      ,[WorkLifeBalance]
      ,[YearsAtCompany]
      ,[YearsInCurrentRole]
      ,[YearsSinceLastPromotion]
      ,[YearsWithCurrManager]
  FROM [HR Employee Attrition ].[dbo].['IBM HR Employee Attrition Data$']



  

--1. Data Quality Checks — Start Here
--How many total employee records are in the dataset?

select count(*) as Total_Employees_records from ['IBM HR Employee Attrition Data$'];

--How many unique Employee IDs are there?

select distinct employeenumber from ['IBM HR Employee Attrition Data$'];

--Are there any duplicate Employee IDs?

select employeeNumber, count(*) as no_of_ids from ['IBM HR Employee Attrition Data$']
group by EmployeeNumber
having count(*) > 1;

--Which columns contain NULL values?


--What are the distinct values in each categorical column?
select distinct education from ['IBM HR Employee Attrition Data$'];
select distinct attrition from ['IBM HR Employee Attrition Data$'];
select distinct department from ['IBM HR Employee Attrition Data$'];
select distinct educationfield from ['IBM HR Employee Attrition Data$'];
select distinct Gender from ['IBM HR Employee Attrition Data$'];
select distinct Jobrole from ['IBM HR Employee Attrition Data$'];
select distinct MaritalStatus from ['IBM HR Employee Attrition Data$'];
select distinct overtime from ['IBM HR Employee Attrition Data$'];
select distinct businesstravel  from ['IBM HR Employee Attrition Data$'];

--What are the minimum, maximum, and average values for numerical columns such as Age, MonthlyIncome, TotalWorkingYears, and YearsAtCompany?
select min(age) as age, max(age) as age, round(avg(age),2) as age from ['IBM HR Employee Attrition Data$'];

select min(MonthlyIncome) as Monthlyincome, max(Monthlyincome) as Monthlyincome, round(avg(monthlyIncome),2) as Monthlyincome from ['IBM HR Employee Attrition Data$'];

select min(TotalWorkingYears) as TotalWorkingYears, max(TotalWorkingYears) as TotalWorkingYears, round(avg(TotalWorkingYears),2) as TotalWorkingYears from ['IBM HR Employee Attrition Data$'];

select min(YearsAtCompany) as YearsAtCompany, max(YearsAtCompany) as YearsAtCompany, round(avg(YearsAtCompany),2) as YearsAtCompany from ['IBM HR Employee Attrition Data$'];

--Are there any employees with invalid or unusual values, such as negative income, zero age, or inconsistent years of experience?

select distinct YearsAtCompany from ['IBM HR Employee Attrition Data$'];

--Does the Attrition column contain only Yes and No?
select distinct attrition from ['IBM HR Employee Attrition Data$'];

--Are there any duplicate employee records based on multiple employee attributes?


--2. Basic Workforce Analysis — 6
--Total employees by Department.

select department, count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
group by department
order by total_Emp DESC;


--Total employees by Job Role.

select Jobrole, count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
group by Jobrole
order by total_Emp DESC;


--Employee distribution by Gender.

select Gender, count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
group by Gender
order by total_Emp DESC;

--Employee distribution by Business Travel.
select BusinessTravel, count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
group by BusinessTravel
order by total_Emp DESC;

--Employee distribution by Education Field.

select educationField, count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
group by educationField
order by total_Emp DESC;

--3. Attrition Analysis — 8
--Calculate total employees who left.
select count(employeeNumber) as total_Emp from ['IBM HR Employee Attrition Data$']
where attrition='Yes';


--Calculate overall Attrition Rate.

select round(count(*)* 100.0 / (select count(*) from ['IBM HR Employee Attrition Data$']),2) as attrition_rate
from ['IBM HR Employee Attrition Data$']
where OverTime='No';

--Attrition count and rate by Department.

select department, count(*) as attrition_count
from ['IBM HR Employee Attrition Data$']
where attrition='Yes'
group by department;


select department,
       count(*) as total_Emp,
       sum(case when attrition='Yes' then 1 else 0 end) as Attrition_count,
       round(  sum(case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) ,2) attrition_rate
from ['IBM HR Employee Attrition Data$']
group by department;

--Attrition count and rate by Job Role.

select jobrole, count(*) as attrition_count
from ['IBM HR Employee Attrition Data$']
where attrition='Yes'
group by jobrole;

--Attrition rate by Gender.
select gender, round(count(*) * 100.0 / (select count(*) from ['IBM HR Employee Attrition Data$']),2) as attrition_rate
from ['IBM HR Employee Attrition Data$']
where Attrition='Yes'
group by gender;

--Attrition rate by Age Group.
select  
case when age < 25 then '<25'
     when age between 25 and 34 then '25-34'
     when age between 35 and 44 then '35-44'
     when age between 45 and 54 then '45-54'
     else '55+'
end as age_group,
count(*) as total_Emp,
sum(case when attrition='Yes' then 1 else 0 end) as attrition_count,
round(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate
from ['IBM HR Employee Attrition Data$']
group by CASE 
        WHEN Age < 25 THEN '<25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
  order by age_group ASC;
--Attrition rate by Business Travel.
SELECT 
    BusinessTravel,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate

FROM ['IBM HR Employee Attrition Data$']

GROUP BY BusinessTravel;
--Attrition rate by Marital Status.
SELECT 
    MaritalStatus,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate

FROM ['IBM HR Employee Attrition Data$']

GROUP BY MaritalStatus;

--4. Salary & Experience — 6
--Average Monthly Income for employees who left vs stayed.

select attrition, round(avg(monthlyIncome),2)
from ['IBM HR Employee Attrition Data$']
group by Attrition;

--Attrition rate by Salary Band.
select min(MonthlyIncome) as Monthlyincome, max(Monthlyincome) as Monthlyincome, round(avg(monthlyIncome),2) as Monthlyincome from ['IBM HR Employee Attrition Data$'];

select   CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low Salary'
        WHEN MonthlyIncome < 15000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS Salary_Band,
    count(*) as emp_count,
    sum(case when attrition='Yes' then 1 else 0 end) as atrrition_count,
    round(sum(case when attrition='Yes' then 1 else 0 end)* 100.0 / count(*) ,2) as attrition_rate
from ['IBM HR Employee Attrition Data$']
group by  CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low Salary'
        WHEN MonthlyIncome < 15000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END;



--Average salary by Department.

select department, avg(monthlyIncome) as avg_salary
from  ['IBM HR Employee Attrition Data$']
group by Department;
--Attrition rate by YearsAtCompany group.

select min(YearsAtCompany) as YearsAtCompany_min, max(YearsAtCompany) as YearsAtCompany_Max, round(avg(YearsAtCompany),2) as YearsAtCompany_AVG from ['IBM HR Employee Attrition Data$'];
create view vw_years_at_company as
select 
       case when YearsAtCompany between 0 and 2 then '0-2 Years'
            when YearsAtCompany between 3 and 5 then  '3-5 Years'
            when YearsAtCompany between 6 and 10 then '6-10 years'
            when YearsAtCompany between 11 and 20 then '11-20 years'
            else '21+ years'
       end as Tenure_Group,
        count(*) as emp_count,
    sum(case when attrition='Yes' then 1 else 0 end) as atrrition_count,
    round(sum(case when attrition='Yes' then 1 else 0 end)* 100.0 / count(*) ,2) as attrition_rate
from ['IBM HR Employee Attrition Data$']
group by 
case when YearsAtCompany between 0 and 2 then '0-2 Years'
            when YearsAtCompany between 3 and 5 then  '3-5 Years'
            when YearsAtCompany between 6 and 10 then '6-10 years'
            when YearsAtCompany between 11 and 20 then '11-20 years'
            else '21+ years'
       end
  order by Tenure_Group ASC;

--Attrition rate by TotalWorkingYears group.

select min(TotalWorkingYears) as TotalWorkingYears_min, max(TotalWorkingYears) as TotalWorkingYears_Max, round(avg(TotalWorkingYears),2) as TotalWorkingYears_AVG from ['IBM HR Employee Attrition Data$'];



--Find employees earning below their Job Role's average salary.
with cte as (
select jobrole, avg(MonthlyIncome) as avg_salary  from ['IBM HR Employee Attrition Data$'] group by JobRole
)

select h.employeeNumber, h.jobrole, h.MonthlyIncome, c.avg_salary from ['IBM HR Employee Attrition Data$'] h
JOIN cte c 
ON h.JobRole=c.JobRole
where h.MonthlyIncome < c.AVG_salary;
--5. Work Environment — 5
--Attrition rate by Job Satisfaction.
SELECT 
    JobSatisfaction,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate

FROM ['IBM HR Employee Attrition Data$']

GROUP BY JobSatisfaction
order by JobSatisfaction ASC;
--Attrition rate by Environment Satisfaction.

SELECT 
    EnvironmentSatisfaction,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate

FROM ['IBM HR Employee Attrition Data$']

GROUP BY EnvironmentSatisfaction
order by EnvironmentSatisfaction ASC;

--Attrition rate by Work-Life Balance.
SELECT 
    WorkLifeBalance,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate

FROM ['IBM HR Employee Attrition Data$']

GROUP BY WorkLifeBalance
order by WorkLifeBalance ASC;

--Attrition rate for Overtime vs non-Overtime employees.

SELECT 
    OverTime,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count_YES,

    
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_count_NO, 
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate_YES,

      ROUND(
        SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate_No


FROM ['IBM HR Employee Attrition Data$']

GROUP BY OverTime;

--Attrition rate by Job Role + Overtime.



SELECT 
    OverTime,
    Jobrole,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count_YES,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Attrition_Rate


FROM ['IBM HR Employee Attrition Data$']

GROUP BY jobrole, OverTime;

--6. Advanced SQL — 6
--Using a CTE, compare each department's attrition rate with overall attrition.

with cte  as (select department, count(*) as total_emp, sum(case when attrition='Yes' then 1 else 0 end) as attrition_count,
round( SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2) as dep_attrition_rate
from ['IBM HR Employee Attrition Data$']
group by department 
), overall_attrition as (

select round ( SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2) as overall_attrition_rate
from ['IBM HR Employee Attrition Data$']
)

select d.department, d.total_emp, d.dep_attrition_rate, d.attrition_count,
    o.overall_attrition_rate, round(d.dep_attrition_rate - o.overall_attrition_rate, 2) as diff_from_overall
from cte d
cross JOIN overall_attrition o;


--Rank employees by salary within each Department.

select EmployeeNumber, Department, monthlyIncome, rank() over(partition by department order by monthlyIncome DESC) as rnk
from ['IBM HR Employee Attrition Data$'];

--Rank Job Roles by attrition rate.

with jobrole_attrition as (select jobrole, round(sum(case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) ,2) as attrition_rate
from ['IBM HR Employee Attrition Data$']
group by jobrole)

select *, rank() over(order by attrition_rate DESC) as attrition_rnk
from jobrole_attrition;

--Find top 3 highest-paid employees in each Department.

with emp_rnk as (select department, employeeNumber, MonthlyIncome, rank() over(partition by department order by monthlyIncome DESC) as rnk
from ['IBM HR Employee Attrition Data$'])
select * from emp_rnk where rnk <=3;

--Find Job Roles with above-average attrition and below-average salary.
with sal_Avg as (  SELECT
        JobRole,
        AVG(MonthlyIncome) AS Avg_Salary,
        ROUND(
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
        ) AS Attrition_Rate
    FROM ['IBM HR Employee Attrition Data$']
    GROUP BY JobRole),
overall_stats as 
(select avg(monthlyIncome) as overall_avg_sal,
round(sum( case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) , 2) as Overall_attrition_rate
from ['IBM HR Employee Attrition Data$']
)

select s.JobRole,
       round(s.avg_salary,2) as avg_sal,
       s.Attrition_Rate,
       round(o.overall_avg_sal,2) as overall_avg_sal,
       o.Overall_attrition_rate

from sal_Avg s
CROSS JOIN overall_stats o
where s.Attrition_Rate > o.Overall_attrition_rate
AND s.Avg_Salary < o.overall_avg_sal;


--Identify employee segments with high attrition + low satisfaction + overtime.

select EmployeeNumber,
       age,
       Department,
       JobRole,
       MonthlyIncome,
       OverTime,
       Attrition
from ['IBM HR Employee Attrition Data$']
where Attrition='YES'
AND JobSatisfaction <=2
AND OverTime ='Yes';

select round(count(*) * 100.0 / (select count(*) from ['IBM HR Employee Attrition Data$'] where Attrition='Yes'),2) as rate
from ['IBM HR Employee Attrition Data$']
where Attrition='YES'
AND JobSatisfaction <=2;

--Create a view containing Employee ID, Age, Gender, Department, Job Role, Monthly Income, YearsAtCompany, Overtime, Job Satisfaction, and Attrition.

CREATE VIEW vw_emp_summary AS

select EmployeeNumber,
       age,
       Department,
       Gender,
       JobRole,
       MonthlyIncome,
       YearsAtCompany,
       OverTime,
       JobSatisfaction,
       Attrition
from ['IBM HR Employee Attrition Data$'];


--Create a view showing Department-wise Employee Count, Attrition Count, and Attrition Rate.
create view vw_departmentwise_data AS

select department,
       count(*) as Employee_count,
       sum(case when attrition='Yes' then 1 else 0 end) as Atrrition_count,
       round(sum(case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) ,2) as Attrition_Rate
from ['IBM HR Employee Attrition Data$']
group by Department;


select * from vw_departmentwise_data;

--Create a view showing Job Role-wise Employee Count, Attrition Count, Average Income, and Attrition Rate.

create view vw_jobrole_data AS
select jobrole,
       count(*) as Employee_count,
sum(case when attrition='Yes' then 1 else 0 end) as Atrrition_count,
       round(sum(case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) ,2) as Attrition_Rate,
round(avg(monthlyIncome),2) as Avg_Income
from ['IBM HR Employee Attrition Data$']
group by JobRole;

select * from vw_jobrole_data;


CREATE VIEW vw_EmployeeAgeGroup AS
SELECT 
    CASE 
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS AgeGroup
FROM ['IBM HR Employee Attrition Data$'];

--Create a view showing Age Group-wise Employee Count, Attrition Count, and Attrition Rate.

Create View vw_ageGroup_data As
select case when age < 25 then '<25'
     when age between 25 and 34 then '25-34'
     when age between 35 and 44 then '35-44'
     when age between 45 and 54 then '45-54'
     else '55+'
end as age_group,
sum(case when attrition='Yes' then 1 else 0 end) as Atrrition_count,
       round(sum(case when attrition='Yes' then 1 else 0 end) * 100.0 / count(*) ,2) as Attrition_Rate
from ['IBM HR Employee Attrition Data$']
group by case when age < 25 then '<25'
     when age between 25 and 34 then '25-34'
     when age between 35 and 44 then '35-44'
     when age between 45 and 54 then '45-54'
     else '55+'
end;



       

