#!/bin/bash

set -x

#time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`rootdir_and_path\` (\`rootdir\`,\`path\`);"

time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`rootdir\` (\`rootdir\`);"
time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`ownername\` (\`ownername\`);"
#time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`groupname\` (\`groupname\`);"
time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`lastaccess\` (\`lastaccess\`);"
time mysql beegfs_scratch_statistics -Be "ALTER TABLE \`statistics\` ADD INDEX \`lastmodify\` (\`lastmodify\`);"

