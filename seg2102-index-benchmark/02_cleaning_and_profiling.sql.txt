-- Create cleaned benchmark base table
CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail_raw
WHERE invoiceno NOT LIKE 'C%'
  AND quantity > 0
  AND unitprice > 0;

-- Validate cleaning
SELECT COUNT(*) FROM online_retail_clean;

SELECT COUNT(*) FROM online_retail_clean WHERE invoiceno LIKE 'C%';
SELECT COUNT(*) FROM online_retail_clean WHERE quantity <= 0;
SELECT COUNT(*) FROM online_retail_clean WHERE unitprice <= 0;

-- Number of distinct StockCodes
SELECT COUNT(DISTINCT stockcode)
FROM online_retail_clean;
