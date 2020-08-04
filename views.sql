-- views.sql

-- VIEWS
-- Employee View
create or replace view employee_vew as
select ep.empid, ep.ssn, ep.firstname, ep.lastname, ew.deptid, d.deptname, ew.hiredate, ew.salary 
from employeework_tbl ew, employeepersonal_tbl ep, dept_tbl d
where ew.empid = ep.empid and ew.deptid = d.deptid;

-- OrderShipper View
create or replace view ordershipper_vew as
select o.orderid, o.customerid, o.orderdate, o.shipid, o.shipdate, o.fulfilledbyid, s.shippername
from order_tbl o, shipper_tbl s
where o.shipid = s.shipid;

-- ProductVendor View
create or replace view productvendor_vew as
select p.productid, p.proddesc, p.dealerprice, p.retailprice, p.cost, p.vendorid, v.vendorname, v.contactperson 
from product_tbl p, vendor_tbl v
where p.vendorid = v.vendorid;

-- customerorder View
create or replace view customerorder_vew as
select c.customerid, c.companyname, c.contactfname, c.contactlname, o.orderid, o.orderdate, o.shipdate, o.fulfilledbyid
from customer_tbl c, order_tbl o
where c.customerid = o.customerid;

-- orderproduct view
create or replace view orderproduct_vew as
select o.orderid, o.orderdate, o.shipdate, o.fulfilledbyid, op.quantity, p.proddesc, p.dealerprice, p.retailprice, p.cost 
from order_tbl o, orderproduct_tbl op, product_tbl p
where o.orderid = op.orderid and op.productid = p.productid;

--Displays a query of data showing the orders for each company sorted by Company Name then by Order Date.
create or replace view customer_orders_vew ("Company", "Order ID", "Product ID", "Quantity", "Order Date", "Ship Date") AS
select c.companyname, o.orderid, op.productid, op.quantity, o.orderdate, o.shipdate
FROM customer_tbl c 
INNER JOIN order_tbl o ON c.customerid = o.customerid
INNER JOIN orderproduct_tbl op ON o.orderid = op.orderid
ORDER BY c.companyname asc, o.orderdate asc;

-- To use the view above and filter on orderID you would use the following syntax:
-- Select * from customer_orders_vew WHERE "Order ID" = 601
-- That is an example how to use the Custom Column Names.

-- Displays the 2 most recent order numbers
-- Use "select * from recentOrders_vew; to invoke the view
create or replace view recentOrders_vew AS
select orderId  AS "Most Recent 5 Order Numbers", customerID,orderdate
from order_tbl
order by orderid desc
limit 5;

create or replace view customers_vew AS
select customerID, companyname from customer_tbl;

create or replace view products_vew AS
select p.productID, p.proddesc, i.quantity AS "Quantity on Hand"
from product_tbl p, inventory_tbl i
WHERE p.productID = i.productID;

create or replace view products_from_order_vew AS
select op.productid, p.proddesc, op.quantity
From orderproduct_tbl op, product_tbl p, order_tbl o
Where o.orderid = op.orderID AND p.productID = op.productID
AND o.orderid = 640;
