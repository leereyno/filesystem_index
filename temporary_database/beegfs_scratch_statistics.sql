drop database if exists beegfs_scratch_statistics;

create database beegfs_scratch_statistics;

use beegfs_scratch_statistics;

drop table if exists statistics;

CREATE TABLE `statistics` (
  `checkdate` date NOT NULL DEFAULT '1980-01-01',
  `rootdir` varchar(30) NOT NULL DEFAULT '',
  `path` varchar(250) NOT NULL DEFAULT '',
  `filetype` tinytext,
  `uid` int(11) DEFAULT NULL,
  `gid` int(11) DEFAULT NULL,
  `ownername` varchar(20) DEFAULT NULL,
  `groupname` varchar(20) DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `lastaccess` datetime default NULL,
  `lastmodify` datetime default NULL,
  `lastchange` datetime default NULL
) ENGINE=InnoDB character set = utf8;

/*
  PRIMARY KEY (`checkdate`,`rootdir`,`path`),
  KEY `checkdate` (`checkdate`),
  KEY `rootdir` (`rootdir`),
  KEY `ownername` (`ownername`),
  KEY `groupname` (`groupname`)
*/

