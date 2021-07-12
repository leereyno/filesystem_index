drop database if exists `beegfs_scratch_statistics_reports`;

create database beegfs_scratch_statistics_reports;

use beegfs_scratch_statistics_reports;

drop table if exists rootdir_reports;

CREATE TABLE `rootdir_reports` (

    `CHECKDATE` date NOT NULL DEFAULT '1980-01-01',
    `DIRECTORY` varchar(50) NOT NULL DEFAULT '',
	`USER_ASURITE` varchar(20) NOT NULL DEFAULT '',
    `USER_FULL_NAME` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_ASURITE` varchar(20) NOT NULL DEFAULT '',
    `SPONSOR_FULL_NAME` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_DEPARTMENT` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_COLLEGE` varchar(250) NOT NULL DEFAULT '',
    `TOTAL_FILES` bigint(20) unsigned DEFAULT NULL,
    `TOTAL_GB` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_30` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_30` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_60` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_60` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_90` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_90` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_120` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_120` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_30` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_30` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_60` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_60` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_90` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_90` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_120` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_120` bigint(20) unsigned DEFAULT NULL

) ENGINE=InnoDB character set = utf8;

drop table if exists ownername_reports;

CREATE TABLE `ownername_reports` (

    `CHECKDATE` date NOT NULL DEFAULT '1980-01-01',
    `USER_ASURITE` varchar(20) NOT NULL DEFAULT '',
    `USER_FULL_NAME` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_ASURITE` varchar(20) NOT NULL DEFAULT '',
    `SPONSOR_FULL_NAME` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_DEPARTMENT` varchar(250) NOT NULL DEFAULT '',
    `SPONSOR_COLLEGE` varchar(250) NOT NULL DEFAULT '',
    `TOTAL_FILES` bigint(20) unsigned DEFAULT NULL,
    `TOTAL_GB` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_30` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_30` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_60` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_60` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_90` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_90` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_ACCESS_LT_120` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_ACCESS_LT_120` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_30` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_30` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_60` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_60` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_90` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_90` bigint(20) unsigned DEFAULT NULL,
    `FILES_LAST_MODIFIED_LT_120` bigint(20) unsigned DEFAULT NULL,
    `GB_LAST_MODIFIED_LT_120` bigint(20) unsigned DEFAULT NULL

) ENGINE=InnoDB character set = utf8;

