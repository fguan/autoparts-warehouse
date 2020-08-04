#!/bin/bash

# set this at beginning of demo
echo "What database would you like to connect to?"
read dbname
dbname="$dbname"

place_order() {
    echo "This is for placing a new order in the Order table"
    echo "What is the order number?"
    read orderID
    echo "What is the customer number?"
    read customerID
    echo "What is the order date?"
    read date
    echo "Employee number assigned to fullfill the order - 500 or 510?"
    read pullingorder
    psql -d $dbname -c "insert into order_tbl values
    ($orderID,$customerID,'$date',NULL,NULL,$pullingorder);"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

view_product_table() {
    echo "This will show you the details of each product we sell"
    psql -d $dbname -c "select * from product_tbl;"

    read -p "Press enter to RETURN to the MAIN MENU"		
}

view_complete_inventory() {
    echo "This will display the inventory of all products"
    psql -d $dbname -c "select i.productid, p.proddesc, i.quantity 
							from inventory_tbl i, product_tbl p
							where p.productID = i.productID;"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

add_item() {
    echo "This is for adding the products in your new order to the OrderProducts table"
    echo "What is the order number you created?"
    read orderID
    echo "What is the product number?"
    read productID
    echo "What is the quantity you are ordering?"
    read quantity
    psql -d $dbname -c "insert into orderproduct_tbl values
    	($orderID,'$productID',$quantity);"
	
    read -p "Press enter to RETURN to the MAIN MENU"	
}

lookup_order() {
    echo "This is for looking up an order"
    echo "What is the order number?"
    read orderID
    psql -d $dbname -c "select * from order_tbl where orderid = $orderID;"
    
    read -p "Press enter to RETURN to the MAIN MENU"	
}

view_products_from_order() {
    echo "This is for looking up an order"
    echo "What is the order number?"
    read orderID
    psql -d $dbname -c "select * from products_from_order($orderID);" 

	read -p "Press enter to RETURN to the MAIN MENU"	
}

lookup_employee() {
    echo "This is for looking up an employee"
    echo "What is the employee first name?"
    read firstname
    echo "What is the employee last name?"
    read lastname
    psql -d $dbname -c "select * 
    	from employeepersonal_tbl ep, employeework_tbl ew 
	where ep.empid = ew.empid 
	and ep.firstname='$firstname' 
	and ep.lastname='$lastname';"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

lookup_inventory_for_product() {
    echo "This is for looking up inventory for a product"
    echo "What is the product id?"
    read productID
    psql -d $dbname -c "select * from inventory_tbl where productid = '$productID';"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

lookup_customer_orders() {
    echo "This will run a function that will show the orders of a specific customer"
    echo "You need to know the CustomerID."
    echo "What is the customerID number"
    read id
    psql -d $dbname -c "select * from customer_order($id);"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

recent_order_info() {
    echo "This shows recent order numbers, customer info, and product info"
    echo "Use this information to create your order using the script called placerorder.sql"
    psql -d $dbname -c "\i recent_order_info.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

show_orderproduct_table_details() {
    echo "This shows the details of the orderproduct_tbl"
    psql -d $dbname -c "\d orderproduct_tbl"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_simple_join() {
    echo "The following is code for an example simple join."
    echo "
    	  select i.productid, p.proddesc, i.quantity AS Quantity_in_Inventory 
          from inventory_tbl i, product_tbl p
	  where i.productID = p.productID;"
    echo ""
	
    read -p "Press enter to view the results"
	
    psql -d $dbname -c "select i.productid, p.proddesc, i.quantity AS Quantity_in_Inventory 
	from inventory_tbl i, product_tbl p
	where i.productID = p.productID;"
	
    read -p "Press enter to RETURN to the MAIN MENU"
}

example_inner_join() {
    echo "The following is code for an example inner join."
    echo "
    	  select ep.firstname, ep.lastname, d.deptname, ew.hiredate
          FROM employeepersonal_tbl ep 
	  INNER JOIN employeework_tbl ew ON ep.empid = ew.empid
	  INNER JOIN dept_tbl d ON ew.deptID = d.deptID
	  Order By deptname asc;"
    echo ""
	
    read -p "Press enter to view the results"
	
    psql -d $dbname -c "select ep.firstname, ep.lastname, d.deptname, ew.hiredate
			FROM employeepersonal_tbl ep 
			INNER JOIN employeework_tbl ew ON ep.empid = ew.empid
		        INNER JOIN dept_tbl d ON ew.deptID = d.deptID
			Order By deptname asc;"
	
    read -p "Press enter to RETURN to the MAIN MENU"
}

example_left_join() {
    echo "The following is code for an example left join."
    echo "
    	  select ep.firstname, ep.lastname, ew.deptID, ew.hiredate
	  FROM employeepersonal_tbl ep 
	  LEFT OUTER JOIN employeework_tbl ew ON ep.empid = ew.empid
	  Order by ep.lastname asc;"
    echo ""
    
    read -p "Press enter to view the results"
	
    psql -d $dbname -c "select ep.firstname, ep.lastname, ew.deptID, ew.hiredate
		FROM employeepersonal_tbl ep 
		LEFT OUTER JOIN employeework_tbl ew ON ep.empid = ew.empid
		Order by ep.lastname asc;"
		
    read -p "Press enter to RETURN to the MAIN MENU"
}

example_full_outer_join() {
    echo "The following is code for an example full outer join."
    echo "
    	  select ep.firstname, ep.lastname, ew.deptID, ew.hiredate
	  FROM employeepersonal_tbl ep 
	  FULL OUTER JOIN employeework_tbl ew ON ep.empid = ew.empid
	  Order by ep.lastname asc;"
    echo ""
    
    read -p "Press enter to view the results"
	
    psql -d $dbname -c "select ep.firstname, ep.lastname, ew.deptID, ew.hiredate
     		FROM employeepersonal_tbl ep 
		FULL OUTER JOIN employeework_tbl ew ON ep.empid = ew.empid
		Order by ep.lastname asc;"
		
    echo "****************************************"
    echo " No difference than the LEFT OUTER JOIN."
    echo "****************************************"
	
    read -p "Press enter to RETURN to the MAIN MENU"
}

example_views() {
    echo "The following VIEW is to show EMPLOYEES and the WORK related information."
    echo "
          create or replace view employee_vew AS
	  select ep.empid, ep.ssn, ep.firstname, ep.lastname,
	         ew.deptid, d.deptname, ew.hiredate, ew.salary 
	  from employeework_tbl ew, employeepersonal_tbl ep, dept_tbl d
	  where ew.empid = ep.empid and ew.deptid = d.deptid;"
    echo ""
    
    read -p "Press enter to view the results"
    psql -d $dbname -c "select * from employee_vew;"
	
    echo "The following VIEW is to show ORDER/SHIPPER information"
    echo "
          create or replace view ordershipper_vew as
	  select o.orderid, o.customerid, o.orderdate, o.shipid,
		 o.shipdate, o.fulfilledbyid, s.shippername
	  from order_tbl o, shipper_tbl s
	  where o.shipid = s.shipid;"
    echo ""
    
    read -p "Press enter to view the results"			
    psql -d $dbname -c "select * from ordershipper_vew;"
    
    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_user_defined_type() {
    echo "The following is the code for our user defined type (UDT)"
    echo "
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
          );"

    read -p "Press enter to continue" 

    echo "
          -- Find names of all vendors that are based in FL
          select vendorname from vendor_tbl where (address).state = 'FL';"
    echo ""

    psql -d $dbname -c "select vendorname from vendor_tbl where (address).state = 'FL';"
    
    read -p "Press enter to continue"

    echo "
          -- Find the address and city of the vendor 'Rock Auto'
          select vendorname,(address).street, (address).city 
          from vendor_tbl where vendorname = 'Rock Auto';"
    echo ""
    psql -d $dbname -c "select vendorname,(address).street, (address).city 
          from vendor_tbl where vendorname = 'Rock Auto';"
			
    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_user_defined_function() {
    echo "This function allows the user to call the function to see the order history of a specific customer. 
	They must know the customerID to use this function.
	To use the function at the command line use the following:
	select * from customer_order(100);

		CREATE OR REPLACE FUNCTION customer_order(custid int, OUT companyname text, 
			OUT orderid int, OUT productid varchar(9), OUT quantity int)
		RETURNS SETOF record AS
		$$
		SELECT c.companyname, o.orderid, op.productid, op.quantity
		   FROM customer_tbl c, order_tbl o, orderproduct_tbl op
			  WHERE c.customerid = o.customerid AND o.orderid = op.orderid
			  AND c.customerid = custid
		   ORDER BY orderdate asc;
		$$
		LANGUAGE sql;"
    echo ""
    read -p "Press enter to view the results"	
    psql -d $dbname -c "select * from customer_order(120);" 
    
    read -p "Press enter to RETURN to the MAIN MENU"	
	
}


example_nested_subqueries() {
    echo "Find all the names of the employees that work in the Supply Chain department"
    echo "
          select concat(firstname, ' ', lastname) as name
    	  from employeepersonal_tbl
	  where empid in (select empid from employeework_tbl
			  where deptid in (select deptid
					   from dept_tbl
					   where deptname = 'Supply Chain'));"
    read -p "Press enter to view the results"
    
    psql -d $dbname -c "select concat(firstname, ' ', lastname) as name
	from employeepersonal_tbl
	where empid in (select empid from employeework_tbl
					where deptid in (select deptid
					from dept_tbl
					where deptname = 'Supply Chain'));"

    read -p "Press enter to RETURN to the MAIN MENU"								   
	
}

run_dml_script() {
    echo "This runs our DML Script"
    psql -d $dbname -c "\i dml.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_add_item_with_transaction() {
    echo "This will add an item to an order where a transaction has been started"
    psql -d $dbname -c "\i add_to_inventory.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_transaction_with_savepoint() {
    echo "This will be an example of using a transaction with savepoint"

    read -p "Press enter to continue"

    echo "These are the transactions that we will be executing:"
    echo ""
    echo "BEGIN;
insert into customer_tbl values (150,'J','Auto Enterprises','Andrew','Motley','456 Main Street','Roseville','CA','95661','916-256-9877');
SAVEPOINT SP1;
insert into customer_tbl values (160,'J','Trucker Enterprises','Horace','Grant','456 Main Street','Roseville','CA','95661','916-256-9878');
ROLLBACK TO SAVEPOINT SP1;
insert into customer_tbl values (170,'J','Motorcycle Enterprises','Frank','Guan','456 Main Street','Roseville','CA','95661','916-256-9879');
COMMIT;"
    echo ""

    read -p "Press enter to continue"

    psql -d $dbname -f "transactions_savepoint_block.sql"

    read -p "Press enter to continue"

    echo "** This should show that customerid 150 and 170 were inserted, but not customerid 160 **"
    echo ""

    psql -d $dbname -c "select * from customer_tbl;"
	
    read -p "Press enter to RETURN to the MAIN MENU"	
}

example_trigger_salary_history() {
    echo "This will execute a set of SQL statements to demo salary history"
    echo "This is the original state of the salary history table."
    psql -d $dbname -c "select * from salaryhistory_tbl;"

    read -p "Press enter to continue"

    echo "Which empid to update salary for?"
    read empid
    echo "What's the new salary?"
    read newsalary

    psql -d $dbname -c "update employeework_tbl set salary = $newsalary where empid = $empid"

    read -p "Press enter to continue"

    echo "This will show the new salary in the employeework_tbl"
    psql -d $dbname -c "select empid, salary from employeework_tbl where empid = $empid"

    read -p "Press enter to continue"

    echo "This will show the new salary in the salaryhistory_tbl"
    psql -d $dbname -c "select * from salaryhistory_tbl"
	
    read -p "Press enter to RETURN to the MAIN MENU"
    
}

example_trigger_inventory() {
    echo "This will demonstrate our trigger that will launch the function for"
    echo "reducing the inventory of an item after it has been ordered."
    echo "This will place an order first using orderID of 640"
    psql -d $dbname -c "insert into order_tbl values
    (640,110,'2020-07-18',NULL,NULL,510);"	
	
    echo "This shows the inventory before any item is added to the order."
    psql -d $dbname -c "select * from inventory_tbl;"	
    read -p "Press enter to continue"

    echo "Adding item DP-223, quantity of 1"
    psql -d $dbname -c "insert into orderproduct_tbl values
    	(640,'DP-223',1);"
		
    echo "This shows the inventory after the item was added to the order."
    psql -d $dbname -c "select * from inventory_tbl;"	

    read -p "Press enter to RETURN to the MAIN MENU"	
	
}

initialize_tables() {
    echo "This resets all database objects"
    psql -d $dbname -c "\i ddl.sql"
}

insert_initial_data() {
    echo "Inserts data into the NEWLY created tables"
    psql -d $dbname -c "\i insertdata.sql"
}

grant_privileges() {
    echo "This will grant privileges to project partner"
    psql -d $dbname -c "\i dcl.sql"

}

revoke_privileges() {
    echo "This will revoke privileges from project partner"
    psql -d $dbname -c "\i dclrevoke.sql"
}

add_column() {
    echo "This will alter the orderproduct_tbl to ADD the PRICE column"
    echo ""
    echo "alter table orderproduct_tbl"
    echo "add column price numeric(8,2);"
    psql -d $dbname -c "alter table orderproduct_tbl
    	     		add column price numeric(8,2);"	
					
    read -p "Press enter to view the changes"
	
    echo "This shows the details of the orderproduct_tbl"
    psql -d $dbname -c "\d orderproduct_tbl"
	
    read -p "Press enter to RETURN to the MAIN MENU"
}

drop_column() {
    echo "This will alter the orderproduct_tbl to DROP the PRICE column"
    echo ""
    echo "alter table orderproduct_tbl"
    echo "drop column price;"
    psql -d $dbname -c "alter table orderproduct_tbl
			drop column price;"
			
    read -p "Press enter to view the changes"
	
    echo "This shows the details of the orderproduct_tbl"
    psql -d $dbname -c "\d orderproduct_tbl"
	
    read -p "Press enter to RETURN to the MAIN MENU"
}

run_all_joins_script() {
    echo "This runs our Joins Script"
    psql -d $dbname -f "joins.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_views_script() {
    echo "This runs our Views Script"
    psql -d $dbname -f "views.sql"

	read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_nested_subqueries_script() {
    echo "This runs our Nested Subqueries Script"
    psql -d $dbname -f "nested_subqueries.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_user_defined_script() {
    echo "This runs our User Defined Types and Functions Script"
    psql -d $dbname -f "user_defined_types_functions.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_transactions_script() {
    echo "This runs our Transactions Script"
    psql -d $dbname -f "transactions.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_triggers_script() {
    echo "This runs our Triggers Script"
    psql -d $dbname -f "triggers.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

run_all_select_from_views_script() {
    echo "This runs selects against all views"
    psql -d $dbname -f "views-select.sql"

    read -p "Press enter to RETURN to the MAIN MENU"	
}

while :
do
    echo "-------------------------------------"
    echo "Please choose an option: "
    echo "  1)    View all products"
    echo "  2)    View a complete inventory"
    echo "  3)    View Recent Order information (Includes product, order, and customer info)"
    echo "  4)    Place an order"
    echo "  5)    Add item to order placed"
    echo "  6)    View products in Order"
    echo "  7)    Lookup an order"
    echo "  8)    Lookup inventory for product"
    echo "  9)    Lookup all orders from A customer"
    echo "  10)   Lookup an employee"
    echo "  100)  Show OrderProduct Table Details"
    echo "  101)  Example: alter table 1, Add Column to orderproduct_tbl"
    echo "  102)  Example: alter table 2, Drop Column from orderproduct_tl"
    echo "  103)  Example: simple join"
    echo "  104)  Example: inner join"
    echo "  105)  Example: left outer join"
    echo "  106)  Example: full outer join"
    echo "  107)  Example: views"
    echo "  108)  Example: nested subqueries"
    echo "  109)  Example: user defined type"
    echo "  110)  Example: user defined function"
    echo "  111)  Example: add item with transaction"
    echo "  112)  Example: transaction with savepoint"
    echo "  113)  Example: trigger for salary history"
    echo "  114)  Example: trigger for inventory"
    echo "  1000) Initialize tables"
    echo "  1001) Insert initial data"
    echo "  1002) Grant privileges"
    echo "  1003) Revoke privileges"
    echo "  1004) Run our DML script"
    echo "  1005) Run all joins script"
    echo "  1006) Run all views script"
    echo "  1007) Run all nested subqueries script"
    echo "  1008) Run all user_defined script"
    echo "  1009) Run all transactions script"
    echo "  1010) Run all triggers script"
    echo "  1011) Run all select from views script"
    echo "  q)    EXIT"
    
    read n
    case $n in
	1) view_product_table ;;
	2) view_complete_inventory ;;
	3) recent_order_info ;;
	4) place_order ;;
	5) add_item ;;
	6) view_products_from_order ;;
	7) lookup_order ;;
	8) lookup_inventory_for_product ;;
	9) lookup_customer_orders ;;
	10) lookup_employee ;;
	100) show_orderproduct_table_details ;;
	101) add_column ;;
	102) drop_column ;;
	103) example_simple_join ;;
	104) example_inner_join ;;
	105) example_left_join ;;
	106) example_full_outer_join ;;
	107) example_views ;;
	108) example_nested_subqueries ;;
	109) example_user_defined_type ;;
	110) example_user_defined_function ;;
	111) example_add_item_with_transaction ;;
	112) example_transaction_with_savepoint ;;
	113) example_trigger_salary_history ;;
	114) example_trigger_inventory ;;
	1000) initialize_tables ;;
	1001) insert_initial_data ;;
	1002) grant_privileges ;;
	1003) revoke_privileges ;;
	1004) run_dml_script ;;
	1005) run_all_joins_script ;;
	1006) run_all_views_script ;;
	1007) run_all_nested_subqueries_script ;;
	1008) run_all_user_defined_script ;;
	1009) run_all_transactions_script ;;
	1010) run_all_triggers_script ;;
	1011) run_all_select_from_views_script ;;
	q) exit ;;
	*) echo "Invalid option";;
    esac
done
