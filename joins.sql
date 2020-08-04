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
	FROM customer_tbl c
	INNER JOIN order_tbl o ON c.customerID = o.customerID
	INNER JOIN orderproduct_tbl op ON o.orderid = op.orderid
	INNER JOIN product_tbl p ON p.productid = op.productid
	Order By c.companyname asc, o.orderid asc; 
	

