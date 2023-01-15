/* Maketing Campaign Analysis
Goals: 
1) validate data by ensuring that data is in the right format, that nulls or outliers are handled, and
data is accurate and consistent
2) identify the factors that significantly relate to number of web purchases
3) Determine which marketing campaign is most successful
4) determins which products are performing the best
5) determine which channels are underperforming
6) determine what the average customer looks like */

/* section 00: import data
Intially, only 2216 out of 2240 rows imported. after researching online, I found that the issue could be 
that mysql is having trouble importing empty strings, and the problem could be fixed by importing the 
data as varchar. Because the import wizard offers only a few data types, I used CREATE TABLE, labeling 
which fields were nullable and setting field type to VARCHAR(45) for most columns. Then I used import 
wizard, and all 2240 rows were imported.
*/

CREATE SCHEMA `marketing` ;

CREATE TABLE `marketing`.`marketing_data` (
  `ID` INT NOT NULL,
  `Year_Birth` VARCHAR(45) NULL,
  `Education` TINYTEXT NULL,
  `Marital_Status` TINYTEXT NULL,
  `Income` VARCHAR(45) NULL,
  `Kidhome` VARCHAR(45) NULL,
  `Teenhome` VARCHAR(45) NULL,
  `Dt_Customer` DATE NULL,
  `Recency` VARCHAR(45) NULL,
  `marketing_datacol` VARCHAR(45) NULL,
  `MntWines` VARCHAR(45) NULL,
  `marketing_datacol1` VARCHAR(45) NULL,
  `MntFruits` VARCHAR(45) NULL,
  `MntMeatProducts` VARCHAR(45) NULL,
  `MntFishProducts` VARCHAR(45) NULL,
  `MntSweetProducts` VARCHAR(45) NULL,
  `MntGoldProds` VARCHAR(45) NULL,
  `NumDealsPurchases` VARCHAR(45) NULL,
  `NumWebPurchases` VARCHAR(45) NULL,
  `NumCatalogPurchases` VARCHAR(45) NULL,
  `NumStorePurchases` VARCHAR(45) NULL,
  `NumWebVisitsMonth` VARCHAR(45) NULL,
  `AcceptedCmp3` VARCHAR(45) NULL,
  `AcceptedCmp4` VARCHAR(45) NULL,
  `AcceptedCmp5` VARCHAR(45) NULL,
  `AcceptedCmp1` VARCHAR(45) NULL,
  `AcceptedCmp2` VARCHAR(45) NULL,
  `Response` VARCHAR(45) NULL,
  `Complain` VARCHAR(45) NULL,
  `Country` TINYTEXT NULL,
  PRIMARY KEY (`ID`));

/* section 01: data validation
ensuring all data was imported as the correct data type and identifying any nulls or outliers
*/

SELECT 
    COUNT(*)
FROM
    marketing.marketing_data;

SELECT 
    *
FROM
    marketing.marketing_data
ORDER BY Dt_Customer DESC;

SELECT 
    *
FROM
    marketing.marketing_data
ORDER BY income ASC;

SELECT 
    COUNT(*)
FROM
    marketing.marketing_data
WHERE
    income IS NULL;

/* discrovered some null values in the income column. these null values represent about 1% of the dataset 
(24/2240 = .0107). The rows could either be deleted, filled with plausible values such as average income, 
or ignored during calculations. Losing 1% of the rows shouldn't affect the analysis, but because the rest 
of the rows outside the income field have valid values, I will not delete the rows. Instead I will replace
the null values with the average income 

additionally the income field is being read as a string instead of a number, so I'll use the cast function*/

SELECT 
    AVG(cast(income as SIGNED)) AS avg_income, STD(cast(income as SIGNED)) AS std_income
FROM
    marketing.marketing_data;
    
/* outliers are greater than or less than 3 standard deviations from the mean. in this case: 
52247.2514 + 3*25167.396174162965 = 127749.439922
52247.2514 - 3*25167.396174162965 = -23254.9371225
Since there are no negative values for income we can focus on the first case */

/* remove outliers, calculate un-skewed mean, and update null values with mean income */

select count(*)
from marketing.marketing_data
where cast(income as SIGNED) > 127749.439922;

delete from marketing.marketing_data where cast(income as SIGNED) > 127749.439922;

SELECT 
    AVG(cast(income as SIGNED)) AS avg_income
FROM
    marketing.marketing_data;
    
update marketing.marketing_data
set income = 51634
where income is null;

select * from marketing.marketing_data where income is null;

/* section 02: identify the factors that significantly relate to number of web purchases */

SELECT 
    education, COUNT(NumWebPurchases) AS num_web_purchases
FROM
    marketing.marketing_data
GROUP BY education
ORDER BY num_web_purchases ASC;

SELECT 
    marital_status, COUNT(NumWebPurchases) AS num_web_purchases
FROM
    marketing.marketing_data
GROUP BY marital_status
ORDER BY num_web_purchases ASC;

SELECT 
    Kidhome, COUNT(NumWebPurchases) AS num_web_purchases
FROM
    marketing.marketing_data
GROUP BY Kidhome
ORDER BY num_web_purchases ASC;

SELECT 
    teenhome, COUNT(NumWebPurchases) AS num_web_purchases
FROM
    marketing.marketing_data
GROUP BY teenhome
ORDER BY num_web_purchases ASC;

SELECT 
    Country, COUNT(NumWebPurchases) AS num_web_purchases
FROM
    marketing.marketing_data
GROUP BY Country
ORDER BY num_web_purchases ASC;

/*break down income into 4 quartiles using NTILE and subqurty to determine effect of income 
on web purchases.*/

SELECT 
    income_quartile,
    MAX(CAST(income AS SIGNED)) AS quartile_break
FROM
    (SELECT
    cast(income as SIGNED) as income,
    NTILE(4) OVER (ORDER BY cast(income as SIGNED)) AS income_quartile
    FROM marketing.marketing_data) AS quartiles
WHERE income_quartile IN (1,2,3,4)
GROUP BY income_quartile;
