-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT customers.company_name AS customer_company, CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id AND customers.city = 'London'
INNER JOIN employees ON orders.employee_id = employees.employee_id AND employees.city = 'London'
INNER JOIN shippers ON orders.ship_via = shippers.shipper_id AND shippers.company_name = 'United Package';

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT 
    products.product_name, 
    products.units_in_stock, 
    suppliers.contact_name, 
    suppliers.phone
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
INNER JOIN categories ON products.category_id = categories.category_id
WHERE 
    products.discontinued = 0 AND 
    products.units_in_stock < 25 AND 
    categories.category_name IN ('Dairy Products', 'Condiments')
ORDER BY products.units_in_stock ASC;

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT customers.company_name FROM customers
WHERE customers.customer_id NOT IN (
        SELECT orders.customer_id 
        FROM orders
    );

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products
WHERE product_id IN (
  SELECT product_id
  FROM order_details
  WHERE quantity = 10
)
ORDER BY product_id;
ТАКЖЕ можно использовать запрос:
SELECT DISTINCT products.product_id, products.product_name
FROM products
INNER JOIN order_details ON products.product_id = order_details.product_id
WHERE products.product_id IN (
  SELECT product_id
  FROM order_details
  WHERE quantity = 10
)
ORDER BY products.product_id;
!!!Первый запрос использует подзапрос, чтобы выбрать product_id из таблицы order_details, где количество заказанных единиц равно 10. 
Затем он выбирает имена продуктов (product_name), которые имеют соответствующие product_id в таблице products.
Этот запрос сортирует результаты по product_id.
    
!!!Второй запрос использует оператор INNER JOIN, чтобы объединить таблицы products и order_details по product_id. 
Затем он выбирает уникальные имена продуктов (product_name), которые имеют соответствующие product_id в таблице order_details. 
Этот запрос также сортирует результаты по products.product_id.
