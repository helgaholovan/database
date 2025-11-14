CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.orders_fact` AS
WITH CTE AS (
    SELECT 
        Order_ID, 
        Customer_ID,
        Book_ID,
        Quantity,
        Total_Amount, 
        ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Order_ID ASC) AS RowNum
    FROM `qwiklabs-gcp-03-fac8baaefb44.a03.orders`
)
SELECT * FROM CTE WHERE RowNum = 1;

DELETE FROM `qwiklabs-gcp-03-fac8baaefb44.a03.orders_fact`
WHERE Order_ID IS NULL 
    OR Customer_ID IS NULL
    OR Book_ID IS NULL
    OR Quantity IS NULL
    OR Total_Amount IS NULL;
   
   
   
   
CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.date` AS
WITH CTE AS (
    SELECT 
        Order_ID, 
        FORMAT_DATE('%m.%Y', DATE(Order_Date)) AS Dat, 
        ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Order_ID ASC) AS RowNum
    FROM `qwiklabs-gcp-03-fac8baaefb44.a03.orders`
)
SELECT * FROM CTE WHERE RowNum = 1 ORDER BY Order_ID;


DELETE FROM `qwiklabs-gcp-03-fac8baaefb44.a03.date`
WHERE Order_ID IS NULL 
   OR Dat IS NULL;
   
   
   
CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.books_n` AS
WITH CTE AS (
    SELECT 
        Book_ID, 
        Title,
        Author,
        Genre,
        ROW_NUMBER() OVER (PARTITION BY Book_ID ORDER BY Book_ID ASC) AS RowNum
    FROM `qwiklabs-gcp-03-fac8baaefb44.a03.books`
)
SELECT * FROM CTE WHERE RowNum = 1 ORDER BY Book_ID;


DELETE FROM `qwiklabs-gcp-03-fac8baaefb44.a03.books_n`
WHERE Book_ID IS NULL 
   OR Title IS NULL
   OR Author IS NULL
   OR Genre IS NULL;
   
   
CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.custom` AS
WITH CTE AS (
    SELECT 
        Customer_ID, 
        Name,
        Phone,
        ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Customer_ID ASC) AS RowNum
    FROM `qwiklabs-gcp-03-fac8baaefb44.a03.customers`
)
SELECT * FROM CTE WHERE RowNum = 1 ORDER BY Customer_ID;


DELETE FROM `qwiklabs-gcp-03-fac8baaefb44.a03.custom`
WHERE Customer_ID IS NULL 
   OR Name IS NULL
   OR Phone IS NULL;
   
   
   
   
   ##############################################
   
   
   
   CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.orders_full` AS
WITH `qwiklabs-gcp-03-fac8baaefb44.a03.legko` AS ( 
  SELECT
    d.Dat,
    o.Customer_ID,
    o.Book_ID,
    SUM(o.Total_Amount) AS total_spent,
    SUM(o.Quantity) AS total_books
  FROM `qwiklabs-gcp-03-fac8baaefb44.a03.orders_fact` AS o
LEFT JOIN `qwiklabs-gcp-03-fac8baaefb44.a03.date` AS d
ON o.Order_ID = d.Order_ID
  GROUP BY d.Dat, o.Customer_ID, o.Book_ID)
SELECT
  Dat,
  ROUND(SUM(total_spent),2) AS total_spent,
  ARRAY_AGG(Customer_ID ORDER BY total_spent DESC LIMIT 1)[SAFE_OFFSET(0)] AS top_customer,
  ARRAY_AGG(Book_ID ORDER BY total_books DESC LIMIT 1)[SAFE_OFFSET(0)] AS top_book,
FROM `qwiklabs-gcp-03-fac8baaefb44.a03.legko`
GROUP BY Dat
ORDER BY Dat;


########################






CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.Report` AS
WITH `qwiklabs-gcp-03-fac8baaefb44.a03.CTE` AS(
  SELECT 
    o.Dat,
    o.total_spent,
    c.Name,
    b.Title,
    o.top_book,
    o.top_customer,
    b.Book_ID,
    c.Customer_ID
FROM `qwiklabs-gcp-03-fac8baaefb44.a03.orders_full` AS o
LEFT JOIN `qwiklabs-gcp-03-fac8baaefb44.a03.books_n` AS b
ON o.top_book = b.Book_ID
LEFT JOIN `qwiklabs-gcp-03-fac8baaefb44.a03.custom` AS c
ON o.top_customer = c.Customer_ID)
SELECT
  Dat,
  total_spent,
  Name,
  Title,
FROM `qwiklabs-gcp-03-fac8baaefb44.a03.CTE`



####################################


CREATE TABLE `qwiklabs-gcp-03-fac8baaefb44.a03.custom_scd2` (
  surrogate_key STRING,
  Customer_ID INT64,
  Name STRING,
  Phone STRING,
  valid_from TIMESTAMP,
  valid_to TIMESTAMP,
  is_current BOOL
);

INSERT INTO `qwiklabs-gcp-03-fac8baaefb44.a03.custom_scd2`
(surrogate_key, Customer_ID, Name, Phone, valid_from, valid_to, is_current)
SELECT
  GENERATE_UUID(),
  Customer_ID,
  Name,
  CAST(Phone AS STRING),
  CURRENT_TIMESTAMP(),
  TIMESTAMP("2030-12-31"),
  TRUE
FROM `qwiklabs-gcp-03-fac8baaefb44.a03.custom`;


MERGE `qwiklabs-gcp-03-fac8baaefb44.a03.custom_scd2` T
USING (
  SELECT 
    Customer_ID,
    Name,
    CAST(Phone AS STRING) AS Phone
  FROM `qwiklabs-gcp-03-fac8baaefb44.a03.custom`
) S
ON T.Customer_ID = S.Customer_ID AND T.is_current = TRUE

WHEN MATCHED AND (T.Name != S.Name OR T.Phone != S.Phone) THEN
  UPDATE SET 
    T.valid_to = CURRENT_TIMESTAMP(),
    T.is_current = FALSE

WHEN NOT MATCHED BY TARGET THEN
  INSERT (surrogate_key, Customer_ID, Name, Phone, valid_from, valid_to, is_current)
  VALUES (
    GENERATE_UUID(),
    S.Customer_ID,
    S.Name,
    S.Phone,
    CURRENT_TIMESTAMP(),
    TIMESTAMP "2030-12-31",
    TRUE
  );
