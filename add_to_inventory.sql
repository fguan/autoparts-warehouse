-- Transaction Script
\prompt 'Enter the orderID here: ' oid
\prompt 'Enter the productID here: ' pid
\prompt 'Enter the quantity here: ' q
begin transaction;
insert into orderproduct_tbl values (:oid,:'pid',:q);
commit;

