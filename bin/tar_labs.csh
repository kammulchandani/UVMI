#!/bin/csh -f
#----------------------------------------------------------------------
# Unix script to create tar file of UVMI course files and release
# For use by course developers
#
# Clean up lab directories and create a tar file
# The tar file name has a date stamp such as 170214
# The tar files is put in .., and a copy in ~/WinLinShare
#
# Usage:
#   Cleanup and make tar file with student and instructor lab files
#	./tar_labs.csh
#----------------------------------------------------------------------
# Copyright 2017-2019 Mentor Graphics Corporation
# All Rights Reserved Worldwide
#
# CBS 190425 Updated for UVM Intermediate
# CBS 170714 Cleanups
#----------------------------------------------------------------------

# Find out what lab directory we are running in: uvm_labs, svv_labs, etc.
set labs = $PWD:t
set target = `date +"${labs}_%y%m%d.tar"`

if (! -e ./bin) then
    echo "ERROR, there is no ./bin directory. Please run this in the labs directory"
    exit
endif

echo
echo "------------------------------------------------------------------"
echo "Reset and clean lab directories, and create tar file for $labs"
./bin/reset_labs.csh
./bin/clean.csh quiet

# Use -h to get any links to files in ./bin
echo
echo "------------------------------------------------------------------"
cd ..
tar cfh ${target} ${labs}
cd ${labs}

echo "Created ../${target}"

# This is a shared directory between Linux and Windows (has to be set up)
# Alternative is ~/Destop
set dir = "~/WinLinShare"

# If there is a proper destination directory, put a copy there for drag & drop
if (-d ${dir} ) then
    cp ../${target} ${dir}
    echo "Created ${dir}/${target}"
else
   echo "Error: No ${dir} directory"
endif

# echo "Before releasing the labs, run ./bin/run_all_tests.csh"
