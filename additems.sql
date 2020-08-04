#!/bin/bash
echo "This is for ordering the products in your new order in the OrderProducts table"
echo "What is the order number?"
read orderID
echo "What is the product number?"
read productID
echo "What is the quantity you are ordering?"
read quantity
dbname="ajarrett3"
psql $dbname $username << EOF
insert into orderproduct_tbl
values
($orderID,'$productID',$quantity);
EOF