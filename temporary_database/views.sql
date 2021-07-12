use beegfs_scratch_statistics;

drop view if exists usage_by_ownername;
drop view if exists usage_by_groupname;
drop view if exists usage_by_rootdir;

create view usage_by_ownername as select distinct ownername,count(path) as filecount ,format(sum(size),0) as filesum from statistics group by ownername order by sum(size) desc;
create view usage_by_groupname as select distinct groupname,count(path) as filefount ,format(sum(size),0) as filesum from statistics group by groupname order by sum(size) desc;

create view usage_by_rootdir as select distinct rootdir,count(path) as filecount ,format(sum(size),0) as filesum from statistics group by rootdir order by sum(size) desc;
