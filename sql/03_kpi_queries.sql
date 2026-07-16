-- executive KPIs
SELECT
    ROUND(SUM(LineAmount), 0) AS revenue_gbp,
    COUNT(DISTINCT Invoice) AS orders,
    COUNT(DISTINCT CustomerID) AS customers,
    ROUND(SUM(LineAmount) / COUNT(DISTINCT Invoice), 2) AS aov
FROM v_retail_revenue;

-- monthly trend
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS year_month,
    ROUND(SUM(LineAmount), 0) AS revenue,
    COUNT(DISTINCT Invoice) AS orders,
    COUNT(DISTINCT CustomerID) AS customers
FROM v_retail_revenue
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY year_month;

-- top products by orders
SELECT
    Description,
    COUNT(DISTINCT Invoice) AS orders,
    ROUND(SUM(LineAmount), 0) AS revenue
FROM v_retail_revenue
GROUP BY Description
ORDER BY orders DESC
LIMIT 10;

-- top countries by orders
SELECT
    Country,
    COUNT(DISTINCT Invoice) AS orders,
    ROUND(SUM(LineAmount), 0) AS revenue
FROM v_retail_revenue
GROUP BY Country
ORDER BY orders DESC
LIMIT 10;

-- guest vs registered sales mix
SELECT
    CASE WHEN IsGuest = 1 THEN 'Guest' ELSE 'Registered' END AS customer_type,
    COUNT(*) AS lines,
    ROUND(SUM(LineAmount), 0) AS revenue,
    COUNT(DISTINCT Invoice) AS orders
FROM v_retail_revenue
GROUP BY CASE WHEN IsGuest = 1 THEN 'Guest' ELSE 'Registered' END;

-- YoY style: calendar year totals
SELECT
    YEAR(InvoiceDate) AS yr,
    ROUND(SUM(LineAmount), 0) AS revenue,
    COUNT(DISTINCT Invoice) AS orders,
    COUNT(DISTINCT CustomerID) AS customers
FROM v_retail_revenue
GROUP BY YEAR(InvoiceDate)
ORDER BY yr;
