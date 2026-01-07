/* 
================================================================================================
Quality Checks
================================================================================================

Script Purpose:
This script validates the integrity and consistency of tables in the 'silver' schema. 
It performs checks such as:
   1. Detects nulls or duplicate values in primary keys
   2. Identifies unwanted spaces in text fields
   3. Verifies standardized categorical values 
      (gender, marital status, product line, country codes)
   4. Flags invalid or missing numeric values (negative costs, nulls)
   5. Ensures valid date ranges and correct date ordering
   6. Confirms consistency between sales, quantity, and price
   7. Highlights out-of-range or future birthdates
   8. Validates country codes and other reference data

   Run this script after loading the silver layer to confirm that data is clean, standardized, 
   and analytics-ready in the gold layer for business intelligence and machine learning.
   ================================================================================================
*/


-- ===========================================================
--                     CRM Tables
-- ===========================================================

-- ===========================================================
-- Checking 'silver.crm_cust_info'
-- ===========================================================

-- Step 1: Check For Nulls or Duplicates in Primary key
-- Ensure that each customer ID is unique and NOT NULL

SELECT 
	cst_id, 
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT (*)> 1 OR cst_id IS NULL ;


-- Step 2: Check for Unwanted Spaces in customer names
-- Detects trailing spaces that can cause mismatches
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Step 3: Check for Unwanted Spaces in customer key
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- ===========================================================
-- Checking 'silver.crm_prd_info'
-- ===========================================================

-- Step 1: Check for unwanted spaces in product names 
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


        -- Data Standardization and Consistency --
-- Step 2: Review distinct gender values for customers
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Step 3: Review distinct product line values 
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Step 4: Validate product costs 
-- Ensures costs are positive and not null SELECT prd_cost
SELECT prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL ;


-- Step 5: Check for Invalid Date Orders
-- -- Ensures product end dates are always after start dates
SELECT*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ===========================================================
-- Checking 'silver.crm_sales_details'
-- ===========================================================

  -- Step 1: Check for Invalid Dates
  -- Ensures order dates are 8-digit valid values and not zero 
	SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
	FROM silver.crm_sales_details
	WHERE sls_order_dt <= 0 
	OR LEN(sls_order_dt) != 8;


-- Step 2: Validate shipping dates 
-- Ensures shipping dates are valid and correctly formatted
SELECT
	NULLIF(sls_ship_dt, 0) AS sls_ship_dt
	FROM silver.crm_sales_details
	WHERE sls_ship_dt <= 0 
	OR LEN(sls_ship_dt) != 8;


-- Step 3: Validate date order logic 
-- Ensures orders occur before shipping and due dates
	SELECT*
	FROM silver.crm_sales_details
	WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


-- Step 4: Validate sales consistency
-- Check Data Consistency : Between Sales, Quantity and Price
-- Ensures Sales = Quantity × Price, with no nulls or negative values

	SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity ,
	sls_price AS old_sls_price,

	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales!= sls_quantity *ABS (sls_price)
		 THEN sls_quantity* ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,

	CASE WHEN sls_price IS NULL OR sls_price <= 0 
		 THEN sls_sales / NULLIF(sls_quantity,0)
		 ELSE sls_price
	END AS sls_price
	FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity* sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	OR sls_sales<= 0 OR sls_quantity <= 0 OR sls_price <= 0 
	ORDER BY sls_sales,sls_quantity,sls_price;


-- ===========================================================
--                     ERP Tables
-- ===========================================================


-- ===========================================================
-- Cheking 'silver.erp_cust_az12'
-- ===========================================================
-- Step 1: Identify out-of-range birthdates
-- Ensures birthdates are realistic (not before 1924 or after today)
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE() 


    -- Data Standardization And Consistency --
-- Step 2: Review distinct gender values
SELECT DISTINCT
gen
FROM silver.erp_cust_az12;

-- ===========================================================
-- Cheking 'silver.erp_loc_a101'
-- ===========================================================
   -- Data Sttandardization And Consistency --
-- Step 1: Review distinct country values
--Confirms country codes/names are consistent
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;


-- ===========================================================
-- Cheking 'silver.erp_px_cat_g1v2'
-- ===========================================================


--Step 1: Review distinct IDs 
SELECT DISTINCT id FROM silver.erp_px_cat_g1v2;
SELECT* FROM silver.erp_px_cat_g1v2;

-- Step 2: Check For Nulls or Duplicates in Primary key
SELECT 
	prd_id, 
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT (*)> 1 OR prd_id IS NULL ;

-- Step 3: Check for Unwanted Spaces in category
SELECT*
FROM silver.erp_px_cat_g1v2
WHERE cat!= TRIM(cat);

-- Step 4: Check for Unwanted Spaces in subcategory
SELECT*
FROM silver.erp_px_cat_g1v2
WHERE subcat!= TRIM(subcat);

-- Step 5: Check for Unwanted Spaces in maintenance
SELECT*
FROM silver.erp_px_cat_g1v2
WHERE maintenance!= TRIM(maintenance);



   -- Data Standadization And Consistency
-- Step 6: Review distinct values
SELECT DISTINCT
cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM silver.erp_px_cat_g1v2;


