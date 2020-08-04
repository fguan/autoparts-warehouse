--dcl.sql

--Grant privileges on tables and views
--To check privileges that have been set use the command \dp or \z
--That command will show you all privileges in the database

--To get more grandular use \dp orderproduct_vew, for an example.

--Examples
--\dp, \z - They do the same thing, shows privileges for  the entire database.
--\dp orderproduct_vew to show only privileges for that view.

grant all privileges on customer_tbl to fguan;
grant all privileges on shipper_tbl to fguan;
grant all privileges on vendor_tbl to fguan;
grant all privileges on product_tbl to fguan;
grant all privileges on dept_tbl to fguan;
grant all privileges on employeePersonal_tbl to fguan;
grant all privileges on employeeWork_tbl to fguan;
grant all privileges on order_tbl to fguan;
grant all privileges on orderproduct_tbl to fguan;
grant all privileges on salaryhistory_tbl to fguan;
grant all privileges on inventory_tbl to fguan;

--Grant privileges to views
grant select on orderproduct_vew to FGUAN;
grant select on customerorder_vew to FGUAN;
grant select on productvendor_vew to FGUAN;
grant select on ordershipper_vew to FGUAN;
grant select on employee_vew to FGUAN;
grant select on recentOrders_vew to FGUAN;
grant select on customers_vew to FGUAN;
grant select on products_vew to FGUAN;
grant select on products_from_order_vew to FGUAN;
