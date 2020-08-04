# Autoparts Warehouse

Autoparts warehouse is a crud application built to represent what an autoparts warehouse would use at their terminal computers.  It is a menu where employees can lookup, add, edit orders and update their parts inventory automatically via a database backend.  Backend is PostgreSQL. Frontend is created in Bash script.

---

The BASH frontend is the main entry point to test out the functionality
to the backend database that has been created. SQL scripts can also be run
individually in PSQL if desired.  Below are directions to do either. 

---

Here are steps to run Bash frontend:
1.  Unzip files to a single directory
2.  chmod u+x menu.sh
3.  Run menu.sh by using command "./menu.sh"

---

(Optional, but recommended) Steps to run Bash frontend without PostgreSQL
password:
1.  Create a .pgpass file in your linux home directory as mentioned here:

https://wiki.postgresql.org/wiki/Pgpass

2.  In the .pgpass file, enter the following on the first line

> localhost:5432:`database`:`username`:`password`

For example: 
> localhost:5432:fguan:fguan:`password`

---

Here are steps to run SQL without Bash frontend:
1.  Type 'psql' to enter PostgreSQL client
2.  Type command "\i <sqlfile>"
