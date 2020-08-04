#!/bin/bash
echo "This is for placing a new order in the Order table"
echo "What is the order number?"
read orderID
echo "What is the customer number?"
read customerID
echo "What is the order date?"
read date
echo "Employee number assigned to fullfill the order - 500 or 510?"
read pullingorder
dbname="ajarrett3"
psql $dbname $username << EOF
insert into order_tbl
values
($orderID,'$customerID',$date,Null,Null,$pullingorder);
EOF
