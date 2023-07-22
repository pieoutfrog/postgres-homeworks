-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_unit_price CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_discontinued CHECK (discontinued IN (0, 1));

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
CREATE TABLE discontinued_products
AS
SELECT *
FROM products
WHERE discontinued = 1;


-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.
#Создаю столбец product_status, указывающий статус товара, где TRUE - в продаже, FALSE - нет
ALTER TABLE order_details
ADD COLUMN product_status BOOLEAN DEFAULT TRUE;

#Удаляю ограничения внешнего ключа order_details_product_id_fkey таблицы order_details
ALTER TABLE order_details
DROP CONSTRAINT order_details_product_id_fkey;

#Создаю новое ограничение внешнего ключа с именем order_details_product_id_fkey для таблицы order_details
ALTER TABLE order_details
ADD CONSTRAINT order_details_product_id_fkey
FOREIGN KEY (product_id, product_status)
REFERENCES products (product_id, product_status);

#обновляю таблицу, где 1 - это "в продаже", 0 - нет
UPDATE order_details
SET product_status = 1
WHERE product_status = TRUE;

UPDATE order_details
SET product_status = 0
WHERE product_status = FALSE;


#удаляю столбец, т.к. он больше не требуется
ALTER TABLE products
DROP COLUMN discontinued;
