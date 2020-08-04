--dclrevoke.sql

--Grant privileges on tables and views
--To check privileges that have been set use the command \dp or \z
--That command will show you all privileges in the database

--To get more grandular use \dp orderproduct_vew, for an example.

--Examples
--\dp, \z - They do the same thing, shows privileges for  the entire database.
--\dp orderproduct_vew to show only privileges for that view.


revoke all privileges on table salaryhistory_tbl from FGUAN cascade;
revoke select on orderproduct_vew from FGUAN cascade;
revoke select on customerorder_vew from FGUAN cascade;
revoke select on productvendor_vew from FGUAN cascade;
revoke select on ordershipper_vew from FGUAN cascade;
revoke select on employee_vew from FGUAN cascade;
revoke select on recentOrders_vew from FGUAN cascade;
revoke select on customers_vew from FGUAN cascade;
revoke select on products_vew from FGUAN cascade;
revoke select on products_from_order_vew from FGUAN cascade;
