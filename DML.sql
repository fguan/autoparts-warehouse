-- DML statements
-- Find all orders made after Jan 1, 2020
select * from order_tbl where orderdate > '2020-01-01';

-- Find names of all customers that are based in FL
select companyname AS "Customers In Florida" from customer_tbl where State = 'FL';

-- Find names of all vendors that are based in FL
select vendorname AS "Vendors in Florida" from vendor_tbl where (address).state = 'FL';

-- Find the address and city of the vendor 'Rock Auto'
select vendorname,(address).street, (address).city from vendor_tbl where vendorname = 'Rock Auto';

-- Find the personal phone number of employee Michael Jones
select firstname, lastname, phone from employeepersonal_tbl where firstname = 'Michael' and lastname = 'Jones';

-- Find the retail price of a 4 pack of spark plugs
select proddesc, retailprice from product_tbl where proddesc = 'Spark Plugs - 4 pack';




-- JOINS
-- Find the inventory of each product
select i.productid, p.proddesc, i.quantity AS "Qunatity in Inventory" from inventory_tbl i, product_tbl p
where i.productID = p.productID;

-- Find the salary of employee whose name is Adam Jackson
select p.firstname, p.lastname, salary from employeeWork_tbl w, employeePersonal_tbl p
where w.empid = p.empid
and p.firstname = 'Adam' and p.lastname = 'Jackson';

-- Find all orderids shipped by the USPS
select s.shippername AS "Orders Shipped By", orderid from shipper_tbl s, order_tbl o
where s.shipid = o.shipid
and s.shippername = 'USPS';

-- Find all products ordered by Freds Auto Parts
select c.companyname AS "Ordered By", p.proddesc from customer_tbl c, order_tbl o, orderproduct_tbl op, product_tbl p
where c.customerid = o.customerid and o.orderid = op.orderid and op.productid = p.productid
and c.companyname = 'Freds Auto Parts';

-- Find the average salary of everyone in the Sales department
select round(avg(ew.salary),2) AS "Average Salary in Sales" from employeework_tbl ew, dept_tbl d
where ew.deptid = d.deptid
and deptname = 'Sales';

-- Find the number of orders placed by 'ATJ Enterprises'
select c.companyname AS "Orders By", count(1) from customer_tbl c, order_tbl o
where c.customerid = o.customerid and c.companyname = 'ATJ Enterprises'
group by c.companyname;


--List of employees sorted by deptartment
select ep.firstname, ep.lastname, d.deptname, ew.hiredate
FROM employeepersonal_tbl ep 
	INNER JOIN employeework_tbl ew ON ep.empid = ew.empid
	INNER JOIN dept_tbl d ON ew.deptID = d.deptID
Order By deptname asc;

--A Query to display the products ordered by customerID, then by OrderID
--It also calculates the PRICE column showing the price for that customer based on the customer type.
select c.companyname AS "Company", o.orderid AS "Order #", op.productID AS "Product #", p.proddesc AS "Product Description",
		CASE
		WHEN c.customertype = 'G' THEN p.retailprice
		WHEN c.customertype = 'J' THEN (p.dealerprice * .80)
		WHEN c.customertype = 'D' THEN p.dealerprice
		END AS "Price", 
	op.quantity AS "Quantity"
	FROM customer_tbl c INNER JOIN order_tbl o ON c.customerID = o.customerID
						INNER JOIN orderproduct_tbl op ON o.orderid = op.orderid
						INNER JOIN product_tbl p ON p.productid = op.productid
	Order By c.companyname asc, o.orderid asc; 
	
------------------------------------------------- END ADDED ------------------------------------



-- NESTED SUBQUERIES
-- Find the hire date of all employees that work in Sales
select concat(ep.firstname,' ', ep.lastname) AS "Sales People", ew.hiredate from employeeWork_tbl ew Inner Join employeePersonal_tbl ep
	ON ep.empid = ew.empid
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
