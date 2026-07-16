-- raw volume
SELECT COUNT(*) AS raw_rows FROM stg_retail_raw;

-- null profile
SELECT
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS null_description,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS null_customer,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS nonpositive_qty,
    SUM(CASE WHEN Price <= 0 THEN 1 ELSE 0 END) AS nonpositive_price,
    SUM(CASE WHEN Invoice LIKE 'C%' THEN 1 ELSE 0 END) AS cancel_rows
FROM stg_retail_raw;

-- fee / postage codes mixed into merchandise
SELECT StockCode, COUNT(*) AS n
FROM stg_retail_raw
WHERE StockCode IN ('POST', 'DOT', 'M', 'D', 'AMAZONFEE', 'BANK CHARGES', 'CRUK')
GROUP BY StockCode
ORDER BY n DESC;

-- duplicate lines
SELECT COUNT(*) AS dup_groups
FROM (
    SELECT Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country, COUNT(*) AS c
    FROM stg_retail_raw
    GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country
    HAVING COUNT(*) > 1
) d;

-- revenue view vs raw
SELECT
    (SELECT COUNT(*) FROM stg_retail_raw) AS raw_rows,
    (SELECT COUNT(*) FROM v_retail_revenue) AS revenue_rows;
