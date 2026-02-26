CREATE DATABASE toy_store;
USE toy_store;

-- Data Cleaning
-- 1. Duplicate

-- PRODUCTS duplicates
SELECT 'products' AS table_name, product_id AS key_value, COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING cnt > 1;

-- ORDERS duplicates
SELECT 'orders' AS table_name, order_id AS key_value, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING cnt > 1;

-- ORDER_ITEMS duplicates
SELECT 'order_items' AS table_name, order_item_id AS key_value, COUNT(*) AS cnt
FROM order_items
GROUP BY order_item_id
HAVING cnt > 1;

-- ORDER_REFUNDS duplicates

SELECT 'order_item_refunds' AS table_name, order_item_id AS key_value, COUNT(*) AS cnt
FROM order_item_refunds
GROUP BY order_item_id
HAVING cnt > 1;

-- WEBSITE_SESSIONS duplicates
SELECT 'website_sessions' AS table_name, website_session_id AS key_value, COUNT(*) AS cnt
FROM website_sessions
GROUP BY website_session_id
HAVING cnt > 1;

-- WEBSITE_PAGEVIEWS duplicates
SELECT 'website_pageviews' AS table_name, website_session_id AS key_value, COUNT(*) AS cnt
FROM website_pageviews
GROUP BY website_session_id
HAVING COUNT(*) > 1;

-- Inspect Missing Values

-- PRODUCTS
SELECT *
FROM products
WHERE product_id IS NULL 
   OR created_at IS NULL 
   OR product_name IS NULL;

-- ORDERS
SELECT *
FROM orders
WHERE order_id IS NULL 
   OR created_at IS NULL 
   OR website_session_id IS NULL;

-- ORDER_ITEMS (update column names after DESCRIBE)
SELECT *
FROM order_items
WHERE order_item_id IS NULL 
   OR order_id IS NULL 
   OR product_id IS NULL
   OR cogs_usd IS NULL
   OR price_usd IS NULL;

-- ORDER_ITEM_REFUNDS (update column names after DESCRIBE)
SELECT *
FROM order_item_refunds
WHERE order_item_refund_id IS NULL 
   OR order_item_id IS NULL 
   OR refund_amount_usd IS NULL;

-- WEBSITE_SESSIONS
SELECT *
FROM website_sessions
WHERE website_session_id IS NULL 
   OR created_at IS NULL;

-- WEBSITE_PAGEVIEWS
SELECT *
FROM website_pageviews
WHERE website_pageview_id IS NULL 
   OR website_session_id IS NULL 
   OR created_at IS NULL;
