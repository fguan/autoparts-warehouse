-- Transactions

-- committed transaction
BEGIN;
insert into customer_tbl values (140,'J','FXJ Enterprises','Frank','Guan','456 Main Street','Roseville','CA','95661','916-256-9876');
COMMIT;

-- transaction rolled back (because of duplicate id)
BEGIN;
insert into customer_tbl values (140,'J','FXJ Enterprises','Frank','Guan','456 Main Street','Roseville','CA','95661','916-256-9876');
COMMIT;

-- transaction rolled back to savepoint
BEGIN;
insert into customer_tbl values (151,'J','FXTJ2 Enterprises','James','Smith','456 Main Street','Roseville','CA','95661','916-256-9877');
SAVEPOINT SP1;
insert into customer_tbl values (161,'J','FXTJ3 Enterprises','James','Smith','456 Main Street','Roseville','CA','95661','916-256-9878');
ROLLBACK TO SAVEPOINT SP1;
insert into customer_tbl values (171,'J','FXTJ4 Enterprises','James','Smith','456 Main Street','Roseville','CA','95661','916-256-9879');
COMMIT;

-- Transaction should have inserted customerid 151 and 171, but not 161
select * from customer_tbl;
