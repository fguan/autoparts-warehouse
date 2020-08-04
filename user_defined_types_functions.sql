-- USER DEFINED TYPES
drop type if exists fulladdress cascade;
drop table if exists vendor_tbl cascade;

create type fulladdress as (
	Street text,
	City text,
	State char(2),
	Zip varchar(10)
);

create table vendor_tbl (
	VendorID int PRIMARY Key,
	VendorName text UNIQUE NOT NULL,
	ContactPerson text,
	address fulladdress,
	Phone varchar(20)
);

-- ProductVendor View
create or replace view productvendor_vew as
select p.productid, p.proddesc, p.dealerprice, p.retailprice, p.cost, p.vendorid, v.vendorname, v.contactperson 
from product_tbl p, vendor_tbl v
where p.vendorid = v.vendorid;

-- DML statements for UDTs
insert into vendor_tbl values
(200,'Brakes Unlimited Inc.','Fred Jones',('485 Front Street','Tampa','FL','33624'),'813-985-8745'),
(210,'Mufflers Unlimited Inc.','Billy Smith',('12 Second Street','Sandusky','OH','44870'),'419-625-8736'),
(230,'Rock Auto','Bill Jones',('12 Front Street','Tampa','FL','33624'),'614-985-8745'),
(240,'Auto Parts International','Barney Rubble',('1 First Street','Bedrock','CA','91548'),NULL),
(250,'Cheveron Oil Co.','Frank Franks',('485 Frank Street','Tampa','FL','33624'),'614-985-8888');


-- Find names of all vendors that are based in FL
select vendorname AS "Vendors in Florida" from vendor_tbl where (address).state = 'FL';

-- Find the address and city of the vendor 'Rock Auto'
select vendorname,(address).street, (address).city from vendor_tbl where vendorname = 'Rock Auto';



-- USER DEFINED FUNCTIONS

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

--This function will display all the products ordered from a given order#
create or replace function products_from_order(ordernum int, out productID varchar(9), out proddesc text, out quantity int)
RETURNS SETOF record AS
$$
select op.productid, p.proddesc, op.quantity
	From orderproduct_tbl op, product_tbl p, order_tbl o
	Where o.orderid = op.orderID AND p.productID = op.productID
	AND op.orderid = ordernum;
$$
LANGUAGE SQL;

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
------------------------

-- DML statements to invoke UDF
select * from customer_order(100);
select * from products_from_order(600);
