📘 **# Data Catalog – Gold Layer**

1. **gold.dim_customers** 

● **Purpose**: Contains customer profiles with demographic attributes and geographic context. 

● **Columns**: 

| Column Name     | Data Type     | Description                                                                                 |
|:----------------|:-------------:|---------------------------------------------------------------------------------------------|
| customer_key    | INT           | Internal surrogate key that uniquely identifies each customer entry in the dimension table. |
| customer_id     | INT           | Number automatically given to each customer by the system.                                  |
| customer_number | NVARCHAR(50)  | Customer code (letters/numbers) used for tracking and reference.                            |
| first_name      | NVARCHAR(50)  | Recorded given name of the customer.                                                        |
| last_name       | NVARCHAR(50)  | Recorded family name or surname of the customer.                                            |
| country         | NVARCHAR(50)  | Customer’s country of residence (e.g., ‘Germany’).                                          |
| marital_status  | NVARCHAR(50)  | Declared marital status (e.g., “Single,” “Married”).                                        |
| gender          | NVARCHAR(50)  | Reported gender of the customer (e.g., ‘Male’, ‘Female’, ‘n/a’).                            |
| birth_date      | DATE          | Customer’s date of birth stored in YYYY-MM-DD format (e.g., 1988-07-01).                    |
| create_date     | DATE          | Timestamp marking when the customer record was first created in the system.                 |





2. **gold.dim_products**
   
● **Purpose**: Contains information about products and their attributes.

● **Columns**: 

| Column Name     | Data Type     | Description                                                                                 |
|:----------------|:-------------:|---------------------------------------------------------------------------------------------|
| product_key     | INT           | Internal surrogate key that uniquely identifies each product entry in the dimension table.  |
| product_id      | INT           | Number automatically given to each product by the system for tracking and referencing.      |
| product_number  | NVARCHAR(50)  | Product code (letters/numbers) used for categorization or inventory.                        |
| product_name    | NVARCHAR(50)  | Full product name including type, color, and size for easy identification.                  |
| category_id     | NVARCHAR(50)  | Unique code linking each product to its top-level category.                                 |
| category        | NVARCHAR(50)  | Broad classification used to group similar products (e.g., Bikes, Accessories).             |
| subcategory     | NVARCHAR(50)  | Specific product type within the main category (e.g., Helmets, Tires).                      |
| maintenance     | NVARCHAR(50)  | Indicates if the product needs regular upkeep (e.g., 'Yes', 'No').                          |
| cost            | INT           | Base price of the product in standard currency units.                                       |
| product_line    | NVARCHAR(50)  | Series or collection the product belongs to (e.g., Road, Mountain).                         |
| start_date      | DATE          | Launch date when the product became available for sale or use.                              |





3. **gold.fact_sales**
   
● **Purpose**: Records sales order transactions for business reporting and performance analysis.

● **Columns**: 

| Column Name     | Data Type     | Description                                                                                 |
|:----------------|:-------------:|---------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | Alphanumeric code that uniquely identifies each sales order.                                |
| product_key     | INT           | Foreign key linking the order to the product dimension.                                     |
| customer_key    | INT           | Foreign key linking the order to the customer dimension.                                    |
| order_date      | DATE          | Date the order was placed.                                                                  | 
| shipping _date  | DATE          | Date the order was shipped to the customer.                                                 |
| due_date        | DATE          | Date payment was due for the order.                                                         |
| sales_amount    | INT           | Total value of the sale for this line item, in whole currency units.                        |
| quantity        | INT           | Number of units ordered for the product line.                                               | 
| price           | INT           | Unit price of the product for this line item, in whole currency units.                      |
 
