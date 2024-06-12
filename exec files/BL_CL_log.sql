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


-- procedure for logging 
CREATE OR REPLACE PROCEDURE BL_CL.prc_load_log(
    IN procedure_name varchar(50),
    IN schema_name varchar(50),
    IN table_name varchar(50),
    IN rows_affected INT
)
LANGUAGE plpgsql
AS $$
DECLARE status varchar(50);
BEGIN
	
	IF rows_affected > 0 THEN status := 'successed';
	ELSE status := 'failed'	;
	END IF;

    INSERT INTO BL_CL.LOAD_PROC_LOG (procedure_name, schema_name, affected_table, rows_affected, status)
    VALUES (procedure_name, schema_name, table_name, rows_affected, status);
   RETURN ;
END;
$$;
