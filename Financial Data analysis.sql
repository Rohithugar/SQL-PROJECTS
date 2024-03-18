CREATE DATABASE PROJECTS;
USE PROJECTS;
SELECT * FROM financial_data;

-- Top 5 Companies by Market Capitalization
SELECT company_name, mar_cap_crore
FROM financial_data
ORDER BY mar_cap_crore DESC
LIMIT 5;

-- Companies with Market Cap over 1000 Crores
SELECT company_name, mar_cap_crore
FROM financial_data
WHERE mar_cap_crore > 1000;

-- Average Quarterly Sales
SELECT AVG(Sales_Qtr_Crore) AS Qtr_sales
FROM financial_data;

-- Market Cap to Sales Ratio:
SELECT Company_name,
	   ROUND((mar_cap_crore / sales_qtr_crore),2) AS Market_cap_sales_ratio
FROM financial_data;

-- Companies with Market Cap below Average
SELECT Company_name, Mar_Cap_Crore
FROM financial_data
WHERE Mar_Cap_Crore < 
	(SELECT AVG(Mar_cap_crore)
    FROM financial_data);
    
-- Companies with Highest Quarterly Sales   
SELECT Company_name, sales_qtr_crore
FROM financial_data
ORDER BY  sales_qtr_crore DESC
LIMIT 1;

-- Market Cap Distribution
SELECT
	CASE 
		WHEN Mar_Cap_Crore BETWEEN 0 AND 10000 THEN '0-10000'
		WHEN Mar_Cap_Crore BETWEEN 10000 AND 50000 THEN '10000-50000'
        WHEN Mar_Cap_Crore BETWEEN 50000 AND 100000 THEN '50000-100000'
        WHEN Mar_Cap_Crore BETWEEN 100000 AND 500000 THEN '100000-500000'
        ELSE 'ABOVE 500000'
	END AS Mar_Cap_range,
    COUNT(*) AS num_companies
FROM financial_data
GROUP BY 
	CASE
		WHEN Mar_Cap_Crore BETWEEN 0 AND 10000 THEN '0-10000'
		WHEN Mar_Cap_Crore BETWEEN 10000 AND 50000 THEN '10000-50000'
        WHEN Mar_Cap_Crore BETWEEN 50000 AND 100000 THEN '50000-100000'
        WHEN Mar_Cap_Crore BETWEEN 100000 AND 500000 THEN '100000-500000'
        ELSE 'ABOVE 500000'
	END;

