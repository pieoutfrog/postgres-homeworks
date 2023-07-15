"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import csv

conn = psycopg2.connect(
    host='localhost',
    database='north',
    user='postgres',
    password='9000'
)
try:
    with conn:
        with conn.cursor() as cur:
            """Здесь использую очень короткий и оперативный метод"""
            with open('/home/alisa/PycharmProjects/postgres-homeworks/homework-1/north_data/customers_data.csv',
                      "r") as f:
                next(f)
                cur.copy_from(f, 'customers', sep=",")
                conn.commit()
            """Здесь пришлось использовать более ёмкий, т.к. в столбце notes используются запятые,
            не знала, какой сепаратор подабрать"""
            with open('/home/alisa/PycharmProjects/postgres-homeworks/homework-1/north_data/employees_data.csv',
                      "r") as f:
                next(f)
                reader = csv.reader(f)
                for row in reader:
                    employee_id, first_name, last_name, title, birth_date, notes = row
                    query = f"INSERT INTO employees (employee_id, first_name, last_name, title, birth_date, notes) " \
                            f"VALUES ('{employee_id}', '{first_name}', '{last_name}', '{title}', '{birth_date}', '{notes}')"
                    cur.execute(query)
                conn.commit()
            """Тут опять подошел простой метод"""
            with open('/home/alisa/PycharmProjects/postgres-homeworks/homework-1/north_data/orders_data.csv', "r") as f:
                next(f)
                cur.copy_from(f, 'orders', sep=",")
                conn.commit()

finally:
    conn.close()
