drop trigger salary_changes_trigger on employeeWork_tbl;
drop trigger inventory_update_trigger on orderproduct_tbl;

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


--This trigger calls the salary_change() function.
create trigger salary_changes_trigger
AFTER INSERT OR UPDATE
ON employeeWork_tbl
FOR EACH ROW
EXECUTE PROCEDURE salary_change();
	
--This trigger calls the inventory_change() function when INSERTING an order.
CREATE TRIGGER inventory_update_trigger
AFTER INSERT
ON orderproduct_tbl
FOR EACH ROW
EXECUTE PROCEDURE inventory_change();
