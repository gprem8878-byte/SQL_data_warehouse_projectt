/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
      This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

Note:
    The BULK INSERT paths point to 'C:\sql\dwh_project\01_datasets\'.
    Change them to the folder where you saved the datasets.
===============================================================================
*/
-- FULL LOAD
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		print'============================================================';
		print'                    Loading bronze layer                   ';
		print'============================================================';

		print'------------------------------------------------------------';
		print'                  Loading CRM Tables                        ';
		print'------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		print'>> Inserting data into :  bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\cust_info.csv'
		WITH(
			fIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';

		SET @start_time = GETDATE();
		print'>> Truncating table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		print'>> Inserting data into :  bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';

		
		print'>> Truncating table: bronze.crm_sales_details';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		print'>> Inserting data into :  bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';


		print'------------------------------------------------------------';
		print'                    Loading ERP Tables                      ';
		print'------------------------------------------------------------';

		print'>> Truncating table: bronze.erp_cust_az12 ';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		print'>> Inserting data into :  bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\cust_az12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';


		print'>> Truncating table: bronze.erp_loc_a101 ';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		print'>> Inserting data into :  bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';


		print'>> Truncating table: bronze.erp_px_cat_g1v2 ';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		print'>> Inserting data into :  bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		print'>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------------------------';
		SET @batch_end_time = GETDATE();

		print'===================================================================='
		print'            Loading Bronze layer is completed                       ';
		print'Total Load Duration: '+ CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)AS NVARCHAR) + ' seconds';
		print'=====================================================================';
	END TRY
	BEGIN CATCH
		print'=============================================================';
		print'       ERROR OCCURED DURING LOADING BRONZE LAYER             ';
		print'Error Messgae ' + ERROR_MESSAGE();
		print'Error Message ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		print'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
		print'=============================================================';
	END CATCH
END





-- Track ETL Duration 
-- HELPS to identify bottlenecks, optimize performance,monitor trends,detect issues
