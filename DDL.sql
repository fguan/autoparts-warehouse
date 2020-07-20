-- Allen Jarrett and Frank Guan

-- Script for Final Project Database Design - Database Definition Language
-- Primary Keys and Unique contraints automatically become indexed

drop trigger if exists salary_changes_trigger ON employeework_tbl;
drop function if exists salary_change() cascade;
drop function if exists customer_order(int) cascade;
drop view if exists employee_vew;
drop view if exists ordershipper_vew;
drop view if exists productvendor_vew;
drop view if exists customerorder_vew;
drop view if exists orderproduct_vew;
drop view if exists customer_orders_vew;
drop table if exists orderproduct_tbl cascade;
drop table if exists order_tbl cascade;
drop table if exists inventory_tbl cascade;
drop table if exists product_tbl cascade;
drop table if exists vendor_tbl cascade;
drop type if exists fulladdress cascade;
drop table if exists shipper_tbl cascade;
drop table if exists salaryhistory_tbl cascade;
drop table if exists employeeWork_tbl cascade;
drop table if exists customer_tbl cascade;
drop table if exists dept_tbl cascade;
drop table if exists employeePersonal_tbl cascade;

create type fulladdress as (
	Street text,
	City text,
	State char(2),
	Zip varchar(10)
);

create table customer_tbl(
	CustomerID int PRIMARY Key,
	CustomerType char(1) NOT NULL,
	CompanyName text NOT NULL,
	ContactFName text NOT NULL,
	ContactLName text NOT Null,
	Address text,
	City text,
	State char(2),
	Zip varchar(9),
	Phone varchar(20)
);

create index CompanyName_idx ON customer_tbl (CompanyName);

create table shipper_tbl (
	ShipID int PRIMARY KEY,
	ShipperName text UNIQUE NOT NULL,
	AccountNumber text UNIQUE NOT NULL,
	Phone varchar(20),
	ShipperURL text
);


create table vendor_tbl (
	VendorID int PRIMARY Key,
	VendorName text UNIQUE NOT NULL,
	ContactPerson text,
	address fulladdress,
	Phone varchar(20)
);

create table product_tbl (
	ProductID varchar(9) PRIMARY KEY,
	ProdDesc text NOT NULL,
	DealerPrice numeric(8,2),
	RetailPrice numeric(8,2),
	Cost numeric(8,2),
	VendorID int references vendor_tbl NOT NULL
);

create index ProdDesc_idx ON product_tbl (ProdDesc);

-- Adding the table inventory_tbl to database
create table inventory_tbl(
ProductID varchar(9) references product_tbl unique, 
Quantity int
);
create index inventory_prodID_idx ON inventory_tbl (productid);

create table dept_tbl (
	DeptID int PRIMARY KEY,
	DeptName text UNIQUE
);

create table employeePersonal_tbl (
	EmpID int PRIMARY Key,
	SSN char(11) UNIQUE NOT NULL,
	FirstName text NOT NULL,
	LastName text NOT NULL,
	Address text,
	City text,
	State char(2),
	Zip varchar(10),
	Phone varchar(20),
	DOBirth date
);

create index LastName_idx ON employeePersonal_tbl(LastName);

create table employeeWork_tbl (
	EmpID int references employeePersonal_tbl UNIQUE NOT NULL,
	DeptID int references dept_tbl NOT NULL,
	HireDate date NOT NULL,
	ReleasedDate date,
	Salary numeric(8,2) NOT NULL
);

create index HireDate_idx ON employeeWork_tbl (HireDate);

create table order_tbl(
	OrderID int PRIMARY Key,
	CustomerID int references customer_tbl NOT NULL,
	OrderDate date NOT NULL,
	ShipID int,
	ShipDate date,
	FulfilledByID int references employeePersonal_tbl
);

create index OrderDate_idx ON order_tbl (OrderDate);
create index CustomerID_idx ON order_tbl (CustomerID);

create table orderproduct_tbl (
	OrderID int references order_tbl NOT NULL,
	ProductID varchar(9) references product_tbl NOT NULL,
	Quantity int NOT NULL,
	PRIMARY KEY (OrderID, ProductID)
);

create table salaryhistory_tbl(
	datechanged timestamp default now(),
	Usermakingchange text default session_user,
	Oldsalary numeric(8,2),
	Newsalary numeric(8,2),
	Empid int references employeework_tbl(empid)
);

-- VIEWS
-- Employee View of Sales Dept
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


--------------------------------------------------- Functions -----------------------------------------------------
--This function will document the salary change for any employee or when a new employee is added
CREATE OR REPLACE FUNCTION salary_change()
	RETURNS trigger AS
$BODY$
BEGIN 
	if tg_op = 'UPDATE' then		
		IF NEW.salary <> OLD.salary THEN
			INSERT INTO salaryhistory_tbl(oldsalary,newsalary,empid)
			VALUES (OLD.salary, NEW.salary, OLD.empid);
		END IF;
	elsif tg_op = 'INSERT' then
		INSERT INTO salaryhistory_tbl(oldsalary,newsalary,empid)
        	VALUES(NULL,NEW.salary, NEW.empid);
	end if;
	RETURN NEW;

END;
$BODY$
LANGUAGE PLPGSQL;

-- This function allows the user to call the function to see the order history of a specific customer. 
-- They must know the customerID to use this function.
-- To use the function at the command line use the following:
-- select * from customer_order(100);
CREATE OR REPLACE FUNCTION customer_order(custid int, OUT companyname text, OUT orderid int, OUT productid varchar(9), OUT quantity int)
RETURNS SETOF record AS
$$
SELECT c.companyname, o.orderid, op.productid, op.quantity
   FROM customer_tbl c, order_tbl o, orderproduct_tbl op
      WHERE c.customerid = o.customerid AND o.orderid = op.orderid
	  AND c.customerid = custid
   ORDER BY orderdate asc;
$$
LANGUAGE sql;

--This function will decrease the inventory of a product as it is ordered.
CREATE OR REPLACE FUNCTION inventory_change()
	RETURNS trigger AS
$BODY$
BEGIN
	UPDATE inventory_tbl
		SET quantity = quantity - NEW.quantity
		WHERE productid = NEW.productid;
	RETURN NEW;
END;
$BODY$
LANGUAGE PLPGSQL;

------------------------------------------------Triggers ---------------------------------------------------------
--This trigger calls the salary_change() function.
create trigger salary_changes_trigger
	AFTER INSERT OR UPDATE
	ON employeeWork_tbl
	FOR EACH ROW
	EXECUTE PROCEDURE salary_change();
	
--This trigger calls the inventory_change() function when INSERTING an order.
CREATE TRIGGER inventory_update_trigger
AFTER INSERT
ON orderproduct_tbl
FOR EACH ROW
EXECUTE PROCEDURE inventory_change();

