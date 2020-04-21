--Base Requirements
-- 1. Get all customers and their addresses.
SELECT * FROM "customers" JOIN "addresses" ON "customers".id = "addresses".customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT "orders".id as "order_id", "line_items".quantity, "products".description FROM "orders" JOIN "line_items" on "orders".id = "line_items".order_id
JOIN "products" ON "line_items".product_id = "products".id;

-- 3. Which warehouses have cheetos?
SELECT "products".description, "warehouse".warehouse FROM "products" JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id WHERE "products".description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT "products".description, "warehouse".warehouse FROM "products" JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id WHERE "products".description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT count("orders".id) as "number_of_orders", "customers".first_name, "customers".last_name, "customers".id FROM "orders" 
JOIN "addresses" ON "orders".address_id = "addresses".id
JOIN "customers" ON "addresses".customer_id = "customers".id GROUP BY "customers".id;

-- 6. How many customers do we have?
SELECT count(*) as "number_of_customers" FROM "customers";

-- 7. How many products do we carry?
SELECT count(*) as "number_of_products" FROM "products";

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT sum("warehouse_product".on_hand) as "on_hand_quantity", "products".description FROM "products" 
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id WHERE "products".description = 'diet pepsi' GROUP BY "products".description;

--Stretch Requirements
-- 9. How much was the total cost for each order?
SELECT sum("products".unit_price * "line_items".quantity) as "total_order_cost", "orders".id as "order_id" FROM "products" 
JOIN "line_items" ON "products".id = "line_items".product_id
JOIN "orders" ON "line_items".order_id = "orders".id GROUP BY "orders".id;

-- 10. How much has each customer spent in total?
SELECT sum("products".unit_price * "line_items".quantity) as "total_order_cost","customers".first_name, "customers".last_name, "customers".id 
FROM "products" JOIN "line_items" ON "products".id = "line_items".product_id
JOIN "orders" ON "line_items".order_id = "orders".id
JOIN "addresses" ON "orders".address_id = "addresses".id
JOIN "customers" ON "addresses".customer_id = "customers".id GROUP BY "customers".id;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT "customers".*, COALESCE(sum("products".unit_price * "line_items".quantity),0) as "total_order_cost"
FROM "customers" LEFT JOIN "addresses" ON "customers".id = "addresses".customer_id 
LEFT JOIN "orders" ON "orders".address_id = "addresses".id
LEFT JOIN "line_items" ON "line_items".order_id = "orders".id
LEFT JOIN "products"  ON "products".id = "line_items".product_id
GROUP BY "customers".id;

--or
SELECT COALESCE(sum("products".unit_price * "line_items".quantity), 0) as "total_order_cost","customers".first_name, "customers".last_name, "customers".id 
FROM "products" JOIN "line_items" ON "products".id = "line_items".product_id
JOIN "orders" ON "line_items".order_id = "orders".id
JOIN "addresses" ON "orders".address_id = "addresses".id
FULL JOIN "customers" ON "addresses".customer_id = "customers".id GROUP BY "customers".id;

--or
SELECT COALESCE(sum("products".unit_price * "line_items".quantity), 0) as "total_order_cost","customers".first_name, "customers".last_name, "customers".id 
FROM "products" JOIN "line_items" ON "products".id = "line_items".product_id
JOIN "orders" ON "line_items".order_id = "orders".id
JOIN "addresses" ON "orders".address_id = "addresses".id
RIGHT JOIN "customers" ON "addresses".customer_id = "customers".id GROUP BY "customers".id;