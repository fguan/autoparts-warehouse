-- transaction rolled back to savepoint
BEGIN;
insert into customer_tbl values (150,'J','Auto Enterprises','Andrew','Motley','456 Main Street','Roseville','CA','95661','916-256-9877');
SAVEPOINT SP1;
insert into customer_tbl values (160,'J','Trucker Enterprises','Horace','Grant','456 Main Street','Roseville','CA','95661','916-256-9878');
ROLLBACK TO SAVEPOINT SP1;
insert into customer_tbl values (170,'J','Motorcycle Enterprises','Frank','Guan','456 Main Street','Roseville','CA','95661','916-256-9879');
COMMIT;
