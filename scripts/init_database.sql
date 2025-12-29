/*
===========================================================
 Script: DataWarehouse Setup
===========================================================

Purpose:
   - Create a new database named 'DataWarehouse'
   - Define three schema layers (bronze, silver, gold)
     following the medallion architecture pattern:
       * Bronze: raw, unprocessed data
       * Silver: cleaned and standardized data
       * Gold: curated, business-ready data

 Notes:
   - Run this script in the 'master' database context
   - Each GO statement marks the end of a batch
===========================================================
*/


-- Create Database 'DataWarehouse'
USE master;
GO -- end batch

  CREATE DATABASE DataWarehouse;
GO 

  Use DataWarehouse;
GO

 -- Create Schemas
  CREATE SCHEMA bronze;
GO 

CREATE SCHEMA silver;
GO 

CREATE SCHEMA gold;
GO
