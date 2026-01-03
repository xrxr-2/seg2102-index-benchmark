CREATE TABLE online_retail_raw (
    invoiceno     VARCHAR(20),
    stockcode     VARCHAR(20),
    description   TEXT,
    quantity      INTEGER,
    invoicedate   TIMESTAMP,
    unitprice     NUMERIC,
    customerid    VARCHAR(20),
    country       VARCHAR(50)
);
