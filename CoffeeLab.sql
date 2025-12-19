SELECT *
FROM sales_data_orig;

CREATE TABLE sales_data
LIKE sales_data_orig;

SELECT *
FROM sales_data;

INSERT sales_data
SELECT *
FROM sales_data_orig;

WITH duplicate_unit AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Unit) AS row_num
FROM sales_data
)
SELECT * 
FROM duplicate_unit
WHERE row_num = 1;


# Columns we dont need, device name, location, unit, time zone, sku
# rename the first column to just date


ALTER TABLE sales_data
DROP COLUMN `Time Zone`;

ALTER TABLE sales_data
DROP COLUMN `Device Name`;

ALTER TABLE sales_data
DROP COLUMN `Unit`,
DROP COLUMN `LOCATION`,
DROP COLUMN `SKU`;

ALTER TABLE sales_data
RENAME COLUMN `ï»¿Date` TO `Date`;

SELECT *
FROM sales_data;

# Removing the $ from the sales table, and the discounts net sales and tax table

UPDATE sales_data
SET `Gross Sales` = TRIM(LEADING '$' FROM `Gross Sales`);

UPDATE sales_data
SET `Discounts` = TRIM(LEADING '$' FROM `Discounts`),
`Net Sales` = TRIM(LEADING '$' FROM `Net Sales`),
 `Tax` = TRIM(LEADING '$' FROM `Tax`)
;
# I also have to remove the parenthesis and dollar sign from discounts

UPDATE sales_data
SET `Discounts` = TRIM(LEADING '(' FROM `Discounts`),
`Discounts` = TRIM(TRAILING ')' FROM `Discounts`);

UPDATE sales_data
SET `Discounts` = TRIM(LEADING '$' FROM `Discounts`);

SELECT *
FROM sales_data;

UPDATE sales_data
SET Item = TRIM(`Item`);

ALTER TABLE sales_data
MODIFY COLUMN `Gross Sales` DOUBLE,
MODIFY COLUMN `Discounts` DOUBLE,
MODIFY COLUMN `Net Sales` DOUBLE;

ALTER TABLE sales_data
MODIFY COLUMN `Time` TIME;

# Wanted a seperate table containing the average sales price of each item
CREATE TABLE avg_sales AS
SELECT Item,
ROUND(AVG(`GROSS SALES`),2) AS avg_sales_per
FROM sales_data
GROUP BY ITEM;

SELECT *
FROM avg_sales;

SELECT *
FROM sales_data;

ALTER TABLE sales_data
DROP COLUMN `Count`;

# The most popular items and how many they sold
WITH times_sold AS
(
SELECT Item,
COUNT(*) as Sales
FROM sales_data
GROUP BY Item
)
SELECT Item,
Sales,
RANK() OVER(ORDER BY Sales DESC) as popularity_rank
FROM times_sold
ORDER BY popularity_rank;

ALTER TABLE sales_data
ADD COLUMN final_sale DOUBLE;

UPDATE sales_data
SET final_sale = `Net Sales` + `Tax`;

UPDATE sales_data
SET final_sale = `Final Sale`;

ALTER TABLE sales_data
CHANGE COLUMN `Price Point Name` `Size` VARCHAR(255);
ALTER TABLE sales_data
CHANGE COLUMN `final_sale` `Final Sale` DOUBLE;


SELECT *
FROM sales_data
WHERE `Size` = '';

# Most type of products sold
SELECT Category,
COUNT(*) AS types_sold
FROM sales_data
GROUP BY Category
ORDER BY types_sold DESC;


SELECT *
FROM sales_data
WHERE Category = 'specialty drinks' OR Category = 'specialy drinks';


UPDATE sales_data
SET Category = 'specialty drinks'
WHERE Category = 'specialy drinks';


# MOST POPULAR HOURS FOR SALES
SELECT
HOUR(`Time`) AS hour_of_sale,
COUNT(*) AS num_records
FROM sales_data
GROUP BY hour_of_sale
ORDER BY num_records DESC;

SELECT *
FROM sales_data;

ALTER TABLE sales_data
ADD COLUMN Order_id int AUTO_INCREMENT PRIMARY KEY;

