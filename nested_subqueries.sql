-- nested_subqueries.sql

-- NESTED SUBQUERIES
-- Find the hire date of all employees that work in Sales
select concat(ep.firstname,' ', ep.lastname) AS "Sales People", ew.hiredate
from employeeWork_tbl ew
INNER JOIN employeePersonal_tbl ep ON ep.empid = ew.empid
where ew.deptid = (select deptid from dept_tbl where deptname = 'Sales');

-- Find all products sold by Rock Auto
select ProdDesc AS "Products Sold by Rock Auto" from Product_tbl
where vendorid = (select vendorid from vendor_tbl where vendorname = 'Rock Auto');

-- Find the vendor name that sells 'Chevron 1 Quart 10W-30 Oil'
select vendorname AS "Vendors that sell Chevron Oil" from vendor_tbl where vendorid = (select vendorid from product_tbl 
                                                    where proddesc = 'Chevron 1 Quart 10W-30 Oil');

-- Find the names of the employee or employees making the most and what they are making
select concat(ep.firstname, ' ', ep.lastname) as name, ew.salary AS "Max Salaries"
from employeepersonal_tbl ep, employeework_tbl ew
where ep.empid = ew.empid
and ew.salary = (select max(salary) from employeework_tbl);

-- Find all the names of the employees that work in the Supply Chain department
select concat(firstname, ' ', lastname) as name
from employeepersonal_tbl
where empid in (select empid from employeework_tbl
                where deptid in (select deptid
                                 from dept_tbl
                                 where deptname = 'Supply Chain'));
