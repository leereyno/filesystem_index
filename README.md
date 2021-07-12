# Overview

A database and related tools to index a file system.

This code is currently in use within the Agave cluster environment at [ASU Research Computing](https://cores.research.asu.edu/research-computing/about)

As this code currently exists (2021-07-11) it will only work within the Agave cluster environment.

This git repository has been created to track the clean up and refactoring of this code to be useful in other environments.

# How-To

This process will index the BeeGFS filesystem and create a database from which 
usage reports can be extracted.

1) Log in to service-0-1

This is the RC generic MySQL database server.

2) Recreate the database

The database that this process uses is over 20GB in size, which makes it too
large to maintain as a database with history. That is to say, you can generate 
a report using the results from the current run, but you can't ask the database 
for info from past runs.  Save any reports you generate if you want to be able 
to do a comparison over time.

So the first step is to clobber the existing database.

    cd /packages/7x/sysadmin/beegfs_scratch_statistics/temporary_database

    ./create_database.sh

3) Log in to cg1-1

This node has been set aside for compiling programs for Agave and work such 
as this.  It is not part of the cluster.

4) Launch the extraction process

On cg1-1, do the following:

    cd /packages/7x/sysadmin/beegfs_scratch_statistics/scripts

    ./launch_all_extractions.sh

The extraction process uses a swarm of screen sessions to extract all of the
file information for every BeeGFS directory. Each directory gets its own 
screen session.  When the extraction process for a directory completes, that 
screen session will end.  This makes it easy to see whether the process has 
completed by using the following command:

    screen -ls

You can expect this process to take several hours as the scratch directories 
for some customers will contain many files.  The bottleneck for the extraction 
is how many files there are to look at, not how much space those files consume.

Once there are no screen sessions running, then the extraction has completed, 
and we're ready to move on to the next step.

5) Import the results into the database

Now we are going to import all of the extractions into the mysql database.

On cg1-1, do the following:

    cd /packages/7x/sysadmin/beegfs_scratch_statistics/scripts

    ./import_all_extractions.sh

This will start spewing out a lot of stuff to the screen, reporting on how long 
it takes to import the extracted data for each directory under /scratch.  It 
will start with the quickest imports first and move on to the slower imports as 
it progresses.  The entire process can take an hour or so to complete.

6) Add indexes to the database

The speed of importing the results in step 5 would have been a lot slower if
the database was indexing the fields that searches are run against.  Now that
the database has been populated, we'll be adding indexes to these fields to
make searching the database faster.

On service-0-1, do the following:

    cd /packages/7x/sysadmin/beegfs_scratch_statistics/temporary_database

    ./add_indexes.sh

This is going to take a while, at least two hours.

7) Run some reports

At this point we can begin running reports.

On service-0-1, do the following:

    cd /packages/7x/sysadmin/beegfs_scratch_statistics/scripts

    ./generate_and_upload_reports.sh

This will generate the two main reports that we get from this process and
upload them to the business intelligence dropbox folder.

8) Add our report to the permanent database





