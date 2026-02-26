# 🧸 Toy Store Sales Analytics Project  
**Author:** Sulaimon Sikiru Oladele  
**Tools:** SQL, Power BI  

---

# TABLE OF CONTENTS
1.	Executive Summary
2.	Project Objectives 
3.	Data Sources
4.	Exploratory Data Analysis (EDA)
5.	SQL Analysis
6.	Power BI Dashboard
7.	DAX Measures
8.	Insights and Interpretation
9.	Recommendations
10.	Conclusion
11.	Appendix: Full SQL Queries

---

# 📌 Executive Summary
This Toy Store Sales Analytics project delivers a comprehensive end‑to‑end analysis of retail performance using SQL for data extraction, transformation, and aggregation, and Power BI for interactive visualization and business intelligence reporting. The project was designed to replicate a real‑world analytics workflow, beginning with raw transactional data and ending with a fully automated, insight‑driven dashboard suitable for strategic decision‑making by business stakeholders.

The analysis focuses on understanding revenue generation, profitability, customer behavior, product performance, and digital engagement patterns across multiple channels and device categories. By integrating SQL‑based data engineering with Power BI’s visualization capabilities, the project transforms raw sales records into a clean, analysis‑ready dataset that supports accurate reporting and actionable insights.

The dataset includes detailed order‑level and item‑level information such as order IDs, product categories, device types, store names, revenue, profit, and pageview interactions. SQL was used to clean inconsistencies, remove duplicates, standardize date formats, and create aggregated metrics that form the foundation of the dashboard. This ensures that all insights are built on reliable, validated data.

The analysis reveals several key performance patterns. Revenue and order volume are concentrated in March and April, with April outperforming March across all major KPIs. Desktop users generate significantly higher revenue than mobile users, suggesting stronger conversion rates on larger screens. Among store channels, gsearch emerges as the dominant revenue driver, indicating strong performance from paid search or organic search traffic. Product category analysis shows clear differences in customer purchasing behavior, with certain categories consistently outperforming others in quantity sold.

Profitability analysis shows a healthy margin, with £30.5K profit generated from £49.99K in revenue. This margin reflects efficient cost management and strong product pricing strategy. The store processed over 72,000 orders, demonstrating high customer engagement and operational scale. These findings highlight opportunities to optimize marketing spend, enhance mobile user experience, and strengthen inventory planning for high‑performing categories.

The Power BI dashboard consolidates all KPIs into a single, intuitive interface. It includes KPI cards for revenue, profit, orders, and quantity sold; visual breakdowns of revenue by store, month, and device category; and category‑level performance insights. The dashboard’s clean layout and consistent theme make it suitable for portfolio presentation, stakeholder reporting, and interview demonstrations.

Overall, this project showcases advanced SQL querying, data cleaning, and transformation skills, combined with professional‑grade Power BI dashboard design. It demonstrates the ability to translate raw data into meaningful insights that support strategic decisions in marketing, product management, and customer engagement. The final deliverable is a polished, portfolio‑ready analytics solution that reflects industry‑standard best practices in data analysis and business intelligence.


---

## 🎯 Business Objectives

1. Calculate total revenue
2. Calculate total quantity sold
3. Compute total profit
4. Identify top-performing marketing channel
5. Analyze monthly revenue trends
6. Determine total number of orders
7. Analyze revenue by device type
8. Identify top-selling products
9. Measure refund rate by product
10. Compare repeat vs new customer revenue
11. Calculate Average Order Value (AOV)

---

## 🗂 Dataset Structure

Main tables used:

- orders
- order_items
- products
- website_sessions
- order_item_refunds
- website_pageviews

---

## 🧮 Key SQL Concepts Used

- JOINs
- GROUP BY
- Aggregations (SUM, COUNT)
- Views
- Calculated fields
- Profit margin calculation
- Refund rate calculation

---

## 📊 Dashboard Features


<img width="1016" height="563" alt="image" src="https://github.com/user-attachments/assets/8fe8ea63-6d74-47f4-b044-4383455d50c5" />

### DAX Measures

Total Quantity Sold = SUM('Sales'[Quantity])

Total Revenue = SUM('Sales'[order_revenue])

Total Profit = SUM('Sales'[order_item_revenue]) - SUM('Sales'[cost])

Total Orders = DISTINCTCOUNT('Sales'[order_id])

- Total Revenue KPI
- Total Profit KPI
- Total Orders KPI
- Total Quantity Sold KPI
- Revenue by Marketing Channel
- Revenue by Device Type
- Monthly Revenue Trend
- Top-Selling Products
- Refund Rate Analysis

---

## 📈 Key Insights

- gsearch is the highest revenue-generating channel
- Desktop users generate more revenue than mobile
- April outperformed March in revenue
- Strong overall profit margins
- High order volume indicates strong customer engagement

---

## 💡 Recommendations

- Increase investment in high-performing marketing channels
- Improve mobile conversion optimization
- Monitor refund-heavy products
- Track monthly revenue growth consistently

---

## 📌 Conclusion

This project demonstrates the use of SQL and Power BI to generate business insights from raw transactional data. It is designed as a professional analytics portfolio project.

---

## Appendix (Full SQL Queries)

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



    2. BUSINESS QUESTIONS & SQL ANSWERS
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


