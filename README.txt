read the description.docx to understand the data and business model

in order to have data to process, you have two choises

1 - unzip data generation.rar and execute python script
2 - unzip datasets.rar to have ready datasets

in order to create data wharehouse system, open exec files folder and execute files by following order:

order of files to be executed:
1 - carsales_schemas.sql // creates all schemas needed in database
2 - SA_CARSALES_1.sql // business source 1 data load
3 - SA_CARSALES_2.sql // business source 2 data load
4 - BL_CL_carsales.sql // deduplication 
5 - BL_CL_logs.sql // creates mandatory logging functionality to keep track of updates 
6 - BL_3NF_carsales.sql // creates procedures for managing BL_3NF 
7 - BL_DM_carsales.sql // creates procedures for managing BL_DM 
8 - carsales_mother_script.sql // executes all procedures to create or update data and its structure

please check the BL_CL.load_proc_log after finishing all steps

Power_BI folders contains:
Power_BI_Report_App.pbix  power bi file in which there is a report application.
BI_report.docx file in which report application is explained 


following folders contain sql files which can be used by DEVOPS engineer in order to have modular structure of project:
. BL_3NF
. BL_DM
. BL_CL
. SA_CARSALES_1
. SA_CARSALES_2

* note that you don't need to execute this files manually because files of exec files folder does the same thing but fastly.
