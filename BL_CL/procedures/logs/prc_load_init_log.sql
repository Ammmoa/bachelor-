CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_log()
LANGUAGE plpgsql
AS $$
BEGIN
	-- create log table
	CREATE TABLE IF NOT EXISTS BL_CL.LOAD_PROC_LOG(
	execution_time timestamp DEFAULT now(),
	procedure_name varchar(50),
	schema_name varchar(50),
	affected_table varchar(50),
	rows_affected int DEFAULT 0,
	status varchar(50)
	);
	
   RETURN ;
END;
$$;