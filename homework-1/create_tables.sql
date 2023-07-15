-- SQL-команды для создания таблиц
CREATE TABLE customers(
	customer_id varchar(100) PRIMARY KEY,
	company_name varchar(100),
	contact_name varchar(100)
);
CREATE TABLE employees(
	employee_id int PRIMARY KEY,
	first_name varchar(100),
	last_name varchar(100),
	title varchar(100),
	birth_date date,
	notes text
);
CREATE TABLE orders(
	order_id int PRIMARY KEY,
	customer_id varchar(100) REFERENCES customers(customer_id) NOT NULL,
	employee_id int REFERENCES employees(employee_id) NOT NULL,
	order_date date,
	ship_city varchar(100)
);

SELECT * from customers;
SELECT * from employees;
SELECT * from orders;