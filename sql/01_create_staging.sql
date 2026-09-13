-- Staging for Online Retail II (both Excel years combined)
-- MySQL / ANSI-friendly

CREATE TABLE IF NOT EXISTS stg_retail_raw (
    Invoice       VARCHAR(20),
    StockCode     VARCHAR(20),
    Description   VARCHAR(255),
    Quantity      INT,
    InvoiceDate   DATETIME,
    Price         DECIMAL(12,4),
    CustomerID    INT NULL,
    Country       VARCHAR(60)
);

CREATE OR REPLACE VIEW v_retail_revenue AS
SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    CustomerID,
    Country,
    Quantity * Price AS LineAmount,
    CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END AS IsGuest
FROM stg_retail_raw
WHERE Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
  AND Description IS NOT NULL
  AND StockCode NOT IN ('POST', 'DOT', 'M', 'D', 'AMAZONFEE', 'BANK CHARGES', 'CRUK');

CREATE OR REPLACE VIEW v_dim_product AS
SELECT DISTINCT
    StockCode,
    Description
FROM v_retail_revenue;

CREATE OR REPLACE VIEW v_dim_geography AS
SELECT DISTINCT
    Country
FROM stg_retail_raw;
