📘 Data Catalog – Gold Layer 

1. gold.dim_customers 

Purpose: Contains customer profiles with demographic attributes and geographic 	     
         context. 

Columns: 

| Column Name     |    Data Type     |     Description                                                                             |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| customer_key    | INT              | Internal surrogate key that uniquely identifies each customer entry in the dimension table. |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| customer_id     |  INT             | Number automatically given to each customer by the system.                                  |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| customer_number |  NVARCHAR(50)    | Customer code (letters/numbers) used for tracking and reference.                            |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| first_name      |   NVARCHAR(50)   | Recorded given name of the customer.                                                        |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| last_name       | NVARCHAR(50)     | Recorded family name or surname of the customer.                                            |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| country         | NVARCHAR(50)     | Customer’s country of residence(e.g., ‘Germany’).                                           |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| marital_status  |  NVARCHAR(50)    | Declared marital status (e.g., “Single,” “Married”).                                        |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| gender          | NVARCHAR(50)     | Reported gender of the customer(e.g., ‘Male’, ‘Female’, ‘n / a’).                           |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| birth_date      | DATE             | Customer’s date of birth stored in YYYY-MM-DD format (e.g., 1988-07-01).                    |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
| create_date     | DATE             | Timestamp marking when the customer record was first created in the system.                 |
|:----------------|:----------------:|--------------------------------------------------------------------------------------------:|
 
