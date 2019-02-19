cd $HOME/repository
cat << EOF > ./nexusimport.sh
#!/bin/bash

# copy and run this script to the root of the repository directory containing files
# this script attempts to exclude uploading itself explicitly so the script name is important
# Get command line params
while getopts ":r:u:p:" opt; do
  case \$opt in
    r) REPO_URL="\$OPTARG"
    ;;
    u) USERNAME="\$OPTARG"
    ;;
    p) PASSWORD="\$OPTARG"
    ;;
  esac
done

find . -type f \\
 -not -path './mavenimport\.sh*' \\
 -not -path '*/\.*' \\
 -not -path '*/\^archetype\-catalog\.xml*' \\
 -not -path '*/\^maven\-metadata\-local*\.xml' \\
 -not -path '*/\^maven\-metadata\-deployment*\.xml' | \\
 sed "s|^\./||" | \\
 xargs -t -I '{}' curl -s -S -u "\$USERNAME:\$PASSWORD" -X PUT -T {} \${REPO_URL}/{} ;
EOF

