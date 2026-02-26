/******************************************************************************************
    E‑COMMERCE ANALYTICS REPORTING SCRIPT
    Author: Sulaimon Sikiru Oladele
    Purpose: Create a unified reporting view and answer key business questions using SQL
******************************************************************************************/

/******************************************************************************************
    1. CREATE REPORTING VIEW
******************************************************************************************/

CREATE OR REPLACE VIEW vw_ecommerce_reporting AS
SELECT
    o.order_id,
    o.created_at AS order_date,
    o.website_session_id,
    o.user_id,
    o.primary_product_id,
    o.items_purchased,
    o.price_usd AS order_revenue_usd,
    o.cogs_usd AS order_cogs_usd,

    s.is_repeat_session,
    s.utm_source,
    s.utm_campaign,
    s.utm_content,
    s.device_type,
    s.http_referer,

    oi.order_item_id,
    oi.product_id,
    p.product_name,
    oi.is_primary_item,
    oi.price_usd AS item_price_usd,
    oi.cogs_usd AS item_cogs_usd,

    r.order_item_refund_id,
    r.refund_amount_usd,
    r.created_at AS refund_date,

    pv.website_pageview_id,
    pv.pageview_url,
    pv.created_at AS pageview_time

FROM orders o
LEFT JOIN website_sessions s 
    ON o.website_session_id = s.website_session_id
LEFT JOIN order_items oi 
    ON o.order_id = oi.order_id
LEFT JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN order_item_refunds r 
    ON oi.order_item_id = r.order_item_id
LEFT JOIN website_pageviews pv
    ON o.website_session_id = pv.website_session_id;


/******************************************************************************************
    2. BUSINESS QUESTIONS & SQL ANSWERS
******************************************************************************************/

/********** Q1: Total revenue by product **********/
SELECT 
    product_name,
    SUM(item_price_usd) AS total_revenue
FROM vw_ecommerce_reporting
GROUP BY product_name
ORDER BY total_revenue DESC;


/********** Q2: Highest revenue by marketing channel **********/
SELECT 
    utm_source AS marketing_channel,
    SUM(order_revenue_usd) AS total_revenue
FROM vw_ecommerce_reporting
GROUP BY utm_source
ORDER BY total_revenue DESC;


/********** Q3: Top 10 best-selling products **********/
SELECT 
    product_name,
    COUNT(order_item_id) AS units_sold
FROM vw_ecommerce_reporting
GROUP BY product_name
ORDER BY units_sold DESC
LIMIT 10;


/********** Q4: Total profit by product **********/
SELECT 
    product_name,
    SUM(item_price_usd - item_cogs_usd) AS total_profit
FROM vw_ecommerce_reporting
GROUP BY product_name
ORDER BY total_profit DESC;


/********** Q5: Monthly revenue trend **********/
SELECT 
    LEFT(order_date, 7) AS year_month,
    SUM(order_revenue_usd) AS monthly_revenue
FROM vw_ecommerce_reporting
GROUP BY LEFT(order_date, 7)
ORDER BY LEFT(order_date, 7);


/********** Q6: Highest profit margin by marketing channel **********/
SELECT 
    utm_source AS marketing_channel,
    SUM(item_price_usd - item_cogs_usd) / SUM(item_price_usd) AS profit_margin
FROM vw_ecommerce_reporting
GROUP BY utm_source
ORDER BY profit_margin DESC;


/********** Q7: Product contribution to total sales **********/
SELECT 
    product_name,
    SUM(item_price_usd) AS total_revenue
FROM vw_ecommerce_reporting
GROUP BY product_name
ORDER BY total_revenue DESC;


/********** Q8: Refund rate by product **********/
SELECT
    product_name,
    COUNT(order_item_refund_id) AS refunded_items,
    COUNT(order_item_id) AS total_items_sold,
    COUNT(order_item_refund_id) / COUNT(order_item_id) AS refund_rate
FROM vw_ecommerce_reporting
GROUP BY product_name
ORDER BY refund_rate DESC;


/********** Q9: Average order value (AOV) by marketing channel **********/
SELECT
    utm_source AS marketing_channel,
    SUM(order_revenue_usd) / COUNT(DISTINCT order_id) AS avg_order_value
FROM vw_ecommerce_reporting
GROUP BY utm_source
ORDER BY avg_order_value DESC;


/********** Q10: Total revenue by repeat vs new customers **********/
SELECT
    is_repeat_session,
    SUM(order_revenue_usd) AS total_revenue
FROM vw_ecommerce_reporting
GROUP BY is_repeat_session
ORDER BY total_revenue DESC;


/********** Q11: Device type performance (revenue by device) **********/
SELECT
    device_type,
    SUM(order_revenue_usd) AS total_revenue
FROM vw_ecommerce_reporting
GROUP BY device_type
ORDER BY total_revenue DESC;
