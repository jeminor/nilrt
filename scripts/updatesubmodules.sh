#!/bin/bash

# This script will check all of the repos in source/repos.txt
# and update the commit hashes in the source directory if any
# have changed.  This can then be posted as a PR.

while read repo; do
    echo "Checking repo $repo"
    if cd ../sources/$repo && git checkout `git ls-remote git://github.com/ni/$repo.git nilrt/master/dunfell | cut -f 1` && cd -
    then
	echo "...done with $repo"
    else
	echo "An error occurred on repo $repo!"
	exit 1
    fi
done <../sources/repos.txt

