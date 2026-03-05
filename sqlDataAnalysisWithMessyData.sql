create table employee(
	employee_id int primary key,
	employee_name varchar(100),
	employee_dept varchar(100),
	employee_salary decimal(10,2),
	joining_date varchar(50)
);

create table project(
	project_id int primary key,
	project_name varchar(100),
	employee_id int,
	project_budget varchar(50),
	foreign key(employee_id) references employee(employee_id)
);

INSERT INTO EMPLOYEE VALUES
(1, 'John Smith', 'IT', 75000, '2021-03-15'),
(2, '   Maria Lopez', 'finance', 68000, '15/04/2020'),
(3, 'David Chen', 'HR ', 72000, '2019-11-01'),
(4, 'Aisha Khan', 'IT', NULL, '2022-07-19'),
(5, 'robert brown', 'Finance', 81000, '2020/08/22'),
(6, 'Emily Davis', 'it', 69000, 'March 5 2021'),
(7, 'Michael Johnson', 'Marketing', 73000, '2021-13-01'),
(8, 'Sara Wilson ', 'HR', 67000, '2018-09-30'),
(9, '  Daniel Garcia', 'marketing', 72000, '07-12-2020'),
(10, 'Priya Patel', NULL, 76000, '2021-06-10');

INSERT INTO PROJECT VALUES
(101, 'AI Chatbot', 1, '50000'),
(102, ' Data Migration ', 2, '45000'),
(103, 'Payroll System', 3, NULL),
(104, 'Website Redesign', 4, '60k'),
(105, 'Mobile App', 5, '70000'),
(106, 'AI analytics', 6, '55000 '),
(107, 'Cloud Migration', 7, '80000'),
(108, 'Marketing Dashboard', 8, ' 40000'),
(109, 'Recruitment Portal', 3, '35000'),
(110, 'Customer Insights', 9, 'unknown');

select * from employee;

select * from project;

-- Remove extra spaces:
select trim(employee_name) from employee;

-- Standardize department names:
select upper(trim(employee_dept)) from employee;

-- Get only numeric values of project budget
select trim(project_budget) as cleaned_budget
from project
where project_budget not like '%k%'
and project_budget != 'Unknown';

-- 1. Department-Wise Highest Paid Employee
SELECT e.employee_id, e.employee_name, e.employee_dept, e.employee_salary
FROM EMPLOYEE e
WHERE e.employee_salary = (
    SELECT MAX(employee_salary)
    FROM EMPLOYEE
    WHERE upper(trim(employee_dept)) = upper(trim(e.employee_dept))
);

--2. Employees Earning More Than Department Average
--Display employees whose salary is greater than the average salary of their own department.
SELECT employee_id, employee_name, employee_dept, employee_salary
FROM EMPLOYEE e
WHERE employee_salary > (
    SELECT AVG(employee_salary)
    FROM EMPLOYEE
    WHERE upper(trim(employee_dept)) = upper(trim(e.employee_dept))
);

--3️. Second Highest Salary in the Company
--Find the second highest salary from EMPLOYEE table.
SELECT MAX(employee_salary) AS second_highest_salary
FROM EMPLOYEE
WHERE employee_salary < (
    SELECT MAX(employee_salary) FROM EMPLOYEE
);

--4️. Employees Who Are Not Assigned to Any Project
--Display employees who do not have any project assigned.
--(Hint: LEFT JOIN or NOT EXISTS)
SELECT e.employee_id, e.employee_name
FROM EMPLOYEE e
LEFT JOIN PROJECT p
ON e.employee_id = p.employee_id
WHERE p.employee_id IS NULL;

--5️. Total Project Budget Department-wise
--Display department name and total project budget handled by that department.
SELECT 
    upper(trim(e.employee_dept)),
    SUM(
        CASE 
            WHEN project_budget ~ '^[0-9]+$' 
            THEN CAST(project_budget AS NUMERIC)
            WHEN project_budget ~ '^[0-9]+k$'
            THEN CAST(REPLACE(project_budget,'k','000') AS NUMERIC)
            ELSE 0
        END
    ) AS total_budget
FROM EMPLOYEE e
JOIN PROJECT p
ON e.employee_id = p.employee_id
GROUP BY upper(trim(e.employee_dept));

--6️. Rank Employees by Salary (Descending)
--Display employee name, department, salary, and their rank based on salary (highest salary = rank 1).
SELECT employee_name,
       employee_dept,
       employee_salary,
       RANK() OVER (ORDER BY employee_salary DESC) AS salary_rank
FROM EMPLOYEE;

--7️. Employees Working on Projects with Budget Greater Than Average Budget
--Display employees who are assigned to projects where project_budget is greater than the average project budget.
SELECT DISTINCT e.employee_id, e.employee_name
FROM EMPLOYEE e
JOIN PROJECT p
ON e.employee_id = p.employee_id
WHERE
CASE
    WHEN p.project_budget ~ '^[0-9]+$'
        THEN CAST(p.project_budget AS NUMERIC)
    WHEN p.project_budget ~ '^[0-9]+k$'
        THEN CAST(REPLACE(p.project_budget,'k','000') AS NUMERIC)
    ELSE NULL
END
>
(
    SELECT AVG(
        CASE
            WHEN project_budget ~ '^[0-9]+$'
                THEN CAST(project_budget AS NUMERIC)
            WHEN project_budget ~ '^[0-9]+k$'
                THEN CAST(REPLACE(project_budget,'k','000') AS NUMERIC)
            ELSE NULL
        END
    )
    FROM PROJECT
);

	  
--8️. Count of Employees in Each Department Having Salary Above 50,000
--Display department name and number of employees earning more than 50,000.
SELECT upper(trim(employee_dept)),
       COUNT(*) AS employee_count
FROM EMPLOYEE
WHERE employee_salary > 50000
GROUP BY upper(trim(employee_dept));

--9️. Employee with Maximum Number of Projects
--Find the employee who is assigned to the highest number of projects.
SELECT e.employee_id, e.employee_name, COUNT(p.project_id) AS project_count
FROM EMPLOYEE e
JOIN PROJECT p
ON e.employee_id = p.employee_id
GROUP BY e.employee_id, e.employee_name
ORDER BY project_count DESC
LIMIT 1;

--10. Update and Delete Operations (Constraint Check)
--a) Increase salary by 10% for employees working in IT department.
UPDATE EMPLOYEE
SET employee_salary = employee_salary * 1.10
WHERE upper(trim(employee_dept)) = 'IT';
select * from employee WHERE upper(trim(employee_dept)) = 'IT';

--b) Delete employees who are not assigned to any project.
DELETE FROM EMPLOYEE
WHERE employee_id NOT IN (
    SELECT DISTINCT employee_id
    FROM PROJECT
);
select * from employee;

--Find employees whose salary is greater than their manager’s salary (Assume manager_id column exists in EMPLOYEE table).
ALTER TABLE EMPLOYEE
ADD COLUMN manager_id INT;
UPDATE EMPLOYEE SET manager_id = 3 WHERE employee_id = 1;
UPDATE EMPLOYEE SET manager_id = 3 WHERE employee_id = 2;
UPDATE EMPLOYEE SET manager_id = 5 WHERE employee_id = 4;
UPDATE EMPLOYEE SET manager_id = 5 WHERE employee_id = 6;
UPDATE EMPLOYEE SET manager_id = 1 WHERE employee_id = 7;
UPDATE EMPLOYEE SET manager_id = 1 WHERE employee_id = 8;

SELECT e.employee_name AS employee,
       m.employee_name AS manager,
       e.employee_salary,
       m.employee_salary AS manager_salary
FROM EMPLOYEE e
JOIN EMPLOYEE m
ON e.manager_id = m.employee_id
WHERE e.employee_salary > m.employee_salary;