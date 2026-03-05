# SQL Data Analysis Project – Employee & Project Management

## Project Overview
This project demonstrates SQL data analysis and data cleaning techniques using two relational tables: **EMPLOYEE** and **PROJECT**.  
The dataset intentionally contains messy and inconsistent data to simulate real-world scenarios where analysts must clean and transform data before analysis.

The project focuses on solving common SQL interview and business analysis problems using joins, subqueries, window functions, and aggregation.

---

## Database Schema

### EMPLOYEE Table
| Column | Description |
|------|-------------|
| employee_id | Unique employee identifier (Primary Key) |
| employee_name | Name of the employee |
| employee_dept | Department name |
| employee_salary | Salary of employee |
| joining_date | Employee joining date |
| manager_id | Employee's manager ID |

### PROJECT Table
| Column | Description |
|------|-------------|
| project_id | Unique project identifier (Primary Key) |
| project_name | Project name |
| employee_id | Employee assigned to project |
| project_budget | Budget allocated to project |

---

## Key Features

✔ Handling messy datasets  
✔ SQL joins and subqueries  
✔ Window functions (RANK)  
✔ Data cleaning techniques  
✔ Aggregation and grouping  
✔ Self joins  
✔ Update and delete operations  

---

## SQL Problems Solved

1. Department-wise highest paid employee
2. Employees earning more than department average
3. Second highest salary in company
4. Employees not assigned to any project
5. Total project budget by department
6. Rank employees by salary
7. Employees working on high-budget projects
8. Count of employees earning more than 50,000
9. Employee handling the most projects
10. Update and delete operations
11. Employees earning more than their manager

---

## Data Cleaning Challenges

The dataset intentionally includes:
- inconsistent department names
- NULL values
- extra spaces
- project budgets like "60k" or "unknown"

These were handled using:
- `TRIM()`
- `CAST()`
- `CASE`
- `REGEXP`
- `REPLACE()`

---

## Technologies Used

- SQL
- PostgreSQL
- Data Cleaning Techniques
- Analytical Queries

---

## Learning Outcomes

This project helped strengthen understanding of:

- relational database design
- data transformation
- analytical SQL queries
- handling dirty datasets
- interview-style SQL problems

---

## Future Improvements

- Convert project budgets into standardized numeric format
- Build a Power BI dashboard
- Create Python ETL pipeline using Pandas
