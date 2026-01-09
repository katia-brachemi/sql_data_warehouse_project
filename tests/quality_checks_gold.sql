
/* 
================================================================================================
Quality Checks
================================================================================================
Script Purpose:
This script validates the integrity and consistency of the 'gold' Layer. 
It performs checks such as:
 1. Data Quality Checks:
    - Detect duplicates and nulls in source data
    - Validate integration of attributes (e.g., gender consistency between CRM and ERP)
    - Confirm foreign key integrity between fact and dimension tables
 2. Dimension Creation:
    - Surrogate keys generated via ROW_NUMBER() for uniqueness
    - Columns renamed to business-friendly names and grouped logically
    - Enrichment with additional attributes from ERP sources
 3. Fact Table Creation:
    - Sales transactions linked to customer and product dimensions
    - Columns renamed for clarity and easy analysis

Run this script after loading the silver layer.
================================================================================================
*/


-- ==========================================================================
--                      Checking 'gold.dim_customers'
-- ==========================================================================

-- Step 1: Check For Nulls or Duplicates 
SELECT cst_id, COUNT(*) 
FROM
(
SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON		ci.cst_key = la.cid
) AS t 
GROUP BY cst_id
HAVING COUNT(*) > 1;                

-- Step 2: Data Integration between gen and cst_gndr

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON		ci.cst_key = la.cid
ORDER BY 1,2;
-- Result : 
-- After encountering contradictions in the values, we consulted the engineering team.
-- The confirmed master source of Customer Data is the CRM system,
-- as it provides the most accurate records.

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info
	     ELSE COALESCE(ca.gen, 'n/a')               -- Returns the actual value of ca.gen (if it exists), or 'n/a' if it’s NULL.
    END AS new_gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON		ci.cst_key = la.cid
ORDER BY 1,2;

-- Step 3: Rename columns to friendly names and group logically

SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key, 
	                                                    
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country, -- Changed its' position
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
	     ELSE COALESCE(ca.gen, 'n/a')  
    END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON		ci.cst_key = la.cid;


-- =================================================================================
--                             Checking 'gold.dim_products'
-- =================================================================================

-- ============================================================ 
-- Data Quality Check (duplicates, current data)
-- ============================================================
-- Step 1: Check for duplicates 
SELECT prd_key, COUNT(*) FROM (
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id

-- Step 2: Target only current data
WHERE prd_end_dt IS NULL            
) t 
GROUP BY prd_key
HAVING COUNT (*) > 1;

-- ============================================================ 
-- Create Dimension gold.dim_products
-- ============================================================
SELECT
-- Step 3: Surrogate key: sort rows by start date and product key
	ROW_NUMBER () OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
-- Step 4:Rename technical columns to business-friendly names
pn.prd_id          AS product_id,
pn.prd_key         AS product_number,
pn.prd_nm          AS product_name,
-- Step 5: Dimension enrichment: add category attributes
pn.cat_id          AS category_id,
pc.cat             AS category,
pc.subcat          AS subcategory,
pc.maintenance,
-- Step 6: Financial and descriptive attributes
pn.prd_cost        AS cost,
pn.prd_line        AS product_line,
pn.prd_start_dt    AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;          


-- =====================================================================================
--                    Checking 'gold.fact_sales'
-- =====================================================================================

-- Step 1: Foreign key Integrity Checks
-- Check if all dimension tables can successfully join the fact

-- Check Customer Dimension
SELECT*
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL      -- Sales records with no matching customer in the dimension

-- Check Product Dimension
SELECT*
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL    -- Sales records with no matching product in the dimension  


-- Step 2: Rename columns to friendly names and group logically
SELECT
sd.sls_ord_num			AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt			AS order_date,
sd.sls_ship_dt			AS shipping_date,
sd.sls_due_dt			  AS due_date,
sd.sls_sales			  AS sales_amount,
sd.sls_quantity			AS quantity,
sd.sls_price			  AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id;


