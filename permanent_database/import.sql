use beegfs_scratch_statistics_reports;

LOAD DATA INFILE "/packages/temp2.old/lustre_rootdir_report_2019-08-19_with_date.csv"
INTO TABLE rootdir_reports
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n';

/*IGNORE 1 LINES;*/

