#!/bin/bash
echo "This shows recent order numbers, customer info, and product info"
echo "Use this information to create your order using the script called placerorder.sql"
dbname="ajarrett3"
psql $dbname $username << EOF
select * from recentorders_vew;
select * from customers_vew;
select * from products_vew;
EOF