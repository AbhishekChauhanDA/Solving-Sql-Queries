Create database Genral;
use Genral;
CREATE TABLE Employees (
    emp_id INT UNIQUE PRIMARY KEY,
    Name VARCHAR(30),
    dept_id INT,
    salary INT,
    hire_date DATE
);
 insert into employees values( 101, 'John Smith',1,60000,'2018-03-15'),
 (102,'Alice',2,75000,'2019-06-10'),
 (103,'Raj Gupta',1,80000,'2020-01-05'),
 (104,'Ravi Kumar',3,65000,'2021-08-01'),
 (105,'Sara Lee',2,72000,'2022-11-20');
 
 create table Departments ( dept_id int, dept_name text);
 insert into Departments values(1,'Sales'),
 (2,'Marketing'),
 (3,'HR'),
 (4,'Finance');

CREATE TABLE projects (
    project_id INT,
    project_name TEXT,
    dept_id INT,
    start_date DATE,
    end_date DATE
);

insert into projects values(201,'Alpha Campaign',2,'2023-01-01','2023-06-01'),
(202,'HR Portal Revamp',3,'2022-05-01','2022-12-01'),
(203,'Sales Boost Q3',1,'2023-04-01','2023-09-30'),
(204,'Budget Tracker',4,'2023-02-12','2023-11-12' );

CREATE TABLE Timesheets (
    timesheet_id INT,
    emp_id INT,
    project_id INT,
    hours_worked INT,
    entry_date DATE
);

insert into Timesheets values(301,101,203,20,'2023-04-05'),
(302,102,201,15,'2023-01-10'),
(303,103,203,25,'2023-04-06'),
(304,104,202,10,'2022-05-03'),
(305,105,201,18,'2023-01-12');
select * from Timesheets;

-- Select name of employees with a salary greater than 70000

select name, salary from employees where salary >70000;

-- List employees hired after January 1, 2020

select * from employees where hire_date > "2020-01-01";

-- Find the employees working in department id 2
select * from employees where dept_id = 2;

-- Show the name and salary of employeess earning between 60000 and 75000
select name , salary from employees where salary between 60000 and 75000;

-- List all unique Department ids form the employess tables
select distinct Dept_id from employees;

-- Select all employees whose name starts with 'R'.
select * from employees where name like 'R%';

-- List employees names along with their department names.
SELECT 
    e.name, d.dept_name
FROM
    employees e
        JOIN
    departments d ON e.dept_id = d.dept_id;

-- Get the project name and department name for each project.
SELECT 
    p.project_name, d.dept_name
FROM
    departments AS d
        LEFT JOIN
    projects AS p ON d.dept_id = p.dept_id;
-- Show employees name with the project names they have worked on.
select e.name, p.project_name from employees e join projects p on e.dept_id = p.dept_id;

-- List all employee who how worked on more than one project
SELECT 
    e.name, COUNT(t.project_id) AS total_project
FROM
    employees e
        JOIN
    timesheets t ON e.emp_id = t.emp_id
    group by t.emp_id
    having total_project >1;
    
    -- Get the total hours worked by each employee on each project.
SELECT 
    e.name, p.project_name, sum(t.hours_worked) as total_worked
FROM
    employees AS e
        JOIN
    projects AS p ON e.dept_id = p.dept_id
        JOIN
    timesheets AS t ON p.project_id = t.project_id
    group by e.Name,p.project_name;

-- Count the number of employees in each department.
SELECT 
    COUNT(e.emp_id) AS total_employee, d.dept_name
FROM
    employees e
        JOIN
    departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Display departments that have no employee;
select d.dept_name,d.dept_id ,e.emp_id from departments d left join employees e on d.dept_id = e.dept_id 
where e.emp_id is null;

-- Count the number if employees in each department 
select d.dept_name, count(e.emp_id) as total_employe from employees e join departments d on e.dept_id = d.dept_id
group by d.dept_name;

-- Find the highest salary in each department
select d.dept_name, max(e.salary) as highest_salary from employees e join departments d on e.dept_id = d.dept_id
group by d.dept_name;

-- How many days has each employee been in the company.
select name, hire_date, datediff(current_date,hire_date) as total_days from employees;

-- Lsit all projects that started in 2023
select project_name , start_date from projects where year(start_date) = 2023;

-- Find how many timesheets were submitted each month in 2023.
select month(entry_date) as month, count(*) as total_sheets from timesheets 
where year(entry_date)=2023
group by month;

-- Show project name and how many days it lasted
select project_name, start_date, end_date , datediff(end_date,start_date) as durations
from projects
where end_date is not null;

--  Calculate running total of salaries by hire date
select name, hire_date, salary, sum(salary) over(order by hire_date) as running_total_salary
from employees;

-- Find each employees's hours worked and the average of all

select emp_id, sum(hours_worked) as total_hours ,avg(sum(hours_worked))over() as average_hours from timesheets
group by emp_id;

-- How many days has each employee worked in the company?
select name, datediff(current_date(),hire_date) as total_work_time from employees;

-- show all the project that started in january 2023 .
select project_name from projects where start_date >= "2023-01-01" and start_date < "2023-02-14";

-- find the duration of each days
select project_name, datediff(end_date,start_date) as total_durations from projects;

-- Find the employees hired more than three years
 select name, hire_date from employees where hire_date < date_sub(current_date,interval 3 year);
 
 -- List all employee who joined in the same months
  select emp_id, name, month(hire_date)as hire_month from employees order by hire_month;
  
  -- Display all timesheet entires submitted in the last 30 days
  select * from timesheets where entry_date <= date_sub(curdate(),interval 30 day);
  
  -- Count how many employees were hired in each year.
  select year(hire_date)as hire_year, count(*) total_hire from employees group by hire_year;

  -- Find the average duration of  all completed projects.
SELECT 
    ROUND(AVG(DATEDIFF(end_date, start_date)), 2) AS average_durations
FROM
    projects
WHERE
    end_date IS NOT NULL;
    
    -- Assign row numbers to employees ordered by hire date.
    select emp_id, name, hire_date,salary,row_number() over(order by hire_date) as row_num
    from employees;
    
    -- Rank employees based on salary (highest_first).
    select emp_id, name , salary, rank() over(order by salary desc)as total_rank from employees;
    
    -- show each employee's salary and running total salaries.
    select emp_id, name , salary, sum(salary) over( order by hire_date )as running_total from employees;
    
    -- Display total hours worked and compare with average hours across all employee
    
    with total_hours_perEmp as ( 
    select emp_id, sum(hours_worked) as total_work from timesheets
    group by emp_id 
    )
    select emp_id , total_work, round( avg(total_work) over(),2)as toatal_average from total_hours_perEmp;
    
    
    -- Show employee name along with their project names.
SELECT 
    e.Name, p.project_name
FROM
    employees AS e
        JOIN
    projects AS p ON e.dept_id = p.dept_id;
    
    -- List employees along with department name and project name (if working).
SELECT 
    e.Name, p.project_name, d.dept_name
FROM
    employees e
        JOIN
    projects p ON e.dept_id = p.dept_id
        JOIN
    departments d ON p.dept_id = d.dept_id ;
    
    -- Get total hours worked by each employee with their names and department,
SELECT 
    SUM(t.hours_worked) AS total_hours_worked,
    e.Name,
    d.dept_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.dept_id = d.dept_id
        JOIN
    timesheets t ON e.emp_id = t.emp_id
GROUP BY d.dept_name,e.Name;
 
 -- Find the average salary of employees in each department. 
SELECT 
    d.dept_name,round(avg(e.salary),2) AS average_salary
FROM
    employees e
        JOIN
    departments d ON e.dept_id = d.dept_id group by d.dept_name;

-- Count how many employees each department has.
SELECT 
    COUNT(e.emp_id) AS total_emp, d.dept_name
FROM
    employees e
        JOIN
    departments d ON e.dept_id = d.dept_id
GROUP BY dept_name;

-- What is the minimum and maximum salary in each department?
select min(e.salary) as minimum_salary, max(e.salary) as maximum_salary, d.dept_name from employees e
join departments d on e.dept_id = d.dept_id
group by d.dept_name;

-- Find employees whose salary is above the average salary.
select Name,salary from employees where salary > (select avg(salary) from employees);

-- list employees who work on more than 2 projects
SELECT 
    e.emp_id,
    e.Name AS employee_name,
    COUNT(DISTINCT t.project_id) AS total_project
FROM
    employees e
        JOIN
    timesheets t ON e.emp_id = t.emp_id
GROUP BY e.emp_id , e.Name
HAVING COUNT(DISTINCT t.project_id)>2;

-- Find departments with no employees 
SELECT 
    d.dept_id, d.dept_name
FROM
    departments AS d
        LEFT JOIN
    employees AS e ON d.dept_id = e.dept_id
WHERE
    e.emp_id IS NULL;
-- using subquery
SELECT 
    dept_id, dept_name
FROM
    departments
WHERE
    dept_id NOT IN (SELECT DISTINCT
            dept_id
        FROM
            employees);
            
show databases;
use genral;
show tables;
create table abc(sr_no int auto_increment,first_name char, mobile int, primary key(sr_no));
show tables;
select * from abc;
alter table abc
modify first_name varchar(30);
alter table abc
modify mobile numeric;
insert into abc (first_name,mobile) values ("Abhishek",8894619427),
("Aniket",7650040796);
describe abc;
select * from abc;
update abc
set mobile = 7650400766 where first_name = "Aniket";

-- List all employees with their department name.
SELECT 
    e.*, d.dept_name
FROM
    employees e
        JOIN
    departments d ON e.dept_id = d.dept_id;
    
-- Find employees who joined after 2022-01-01.
select * from employees where hire_date > "2022-01-01";
-- Get the total number of employees in each department.
select dept_id,count(*)from employees group by dept_id;

-- Show all projects handled by the "HR" department.
select project_name, dept_id from projects where dept_id=3;
-- Find employees who are not assigned to any project (use LEFT JOIN).
SELECT 
    e.*
FROM
    employees e
        LEFT JOIN
    timesheets t ON e.emp_id = t.emp_id
WHERE
    t.project_id IS NULL;
    
    -- Calculate the total hours worked by each employee across all projects.
    select emp_id,sum(hours_worked)as total_work from timesheets group by emp_id;
    
-- Find employees who worked on more than 2 projects.
SELECT t.emp_id, 
       COUNT(DISTINCT t.project_id) AS project_count,e.name
FROM timesheets t join employees e on e.emp_id=t.emp_id
GROUP BY emp_id;

-- List departments that have no employees.
SELECT 
    e.emp_id as emp_id, d.dept_id, d.dept_name
FROM
    departments d
        left JOIN
    employees e ON e.dept_id = d.dept_id 
    where emp_id  is null;
-- Find the highest-paid employee in each department.
select emp_id, name,salary,dept_name from (
select e.emp_id,e.name,e.salary,d.dept_name,
 Rank() over(partition by e.dept_id order by e.salary desc)as rnk
from employees e join departments d on e.dept_id = d.dept_id)as ranked
where rnk = 1;

-- Find the top 3 employees who logged the most hours overall.
SELECT 
    e.emp_id, e.name, SUM(t.hours_worked) AS most_hours
FROM
    employees e
        JOIN
    timesheets t ON e.emp_id = t.emp_id
GROUP BY e.emp_id , e.name
ORDER BY most_hours DESC
LIMIT 3;
-- Calculate the average salary per department and compare each employee’s salary with the department average.
select e.emp_id,e.name,d.dept_name , e.salary, round(avg(salary) 
over(partition by e.dept_id),2)as average_salary,
e.salary - round(avg(salary)over(partition by e.dept_id),2)as compare_salary
 from employees e join departments d on e.dept_id=d.dept_id;
 
-- Find the department that has the maximum total project hours.
SELECT 
    d.dept_id, d.dept_name, sum(t.hours_worked) AS total_project_hours
FROM
    departments d
        JOIN
    projects p ON d.dept_id = p.dept_id
        JOIN
    timesheets t ON p.project_id = t.project_id
GROUP BY d.dept_id , d.dept_name
order by total_project_hours desc limit 1;

-- Using a window function, rank employees by salary within each department.
 select e.emp_id,e.name,e.salary,d.dept_name, 
 rank() over(partition by e.dept_id order by e.salary desc)as salary_rank
 from employees e join departments d on e.dept_id=d.dept_id;
 