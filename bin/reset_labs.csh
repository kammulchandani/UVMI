#!/bin/csh -f
#----------------------------------------------------------------------
# Unix script to clean and reset the UVM Intermediate lab files
# For use by course developers
#
# Usage:
#	% cd uvmi_labs
#	% ./bin/reset_labs.csh
#----------------------------------------------------------------------
# Copyright 2019 Mentor Graphics Corporation
# All Rights Reserved Worldwide
#
# CBS 190220 - Created
#----------------------------------------------------------------------

# Command to clean all QuestaSim generated files
alias rmq 'touch foo~; rm -rf work transcript *.bak *.log dpiheader.h *.o *stacktrace.* *~ *.wlf certe_dump.xml covhtmlreport'

# Find out what lab directory we are running in: uvm_labs, svv_labs, etc.
set pwd_name = $PWD:t
set labs = "uvmi_labs"
if (${pwd_name} != ${labs}) then
    echo "Error $0 must be run from the ${labs} directory"
    exit
endif

echo
echo "------------------------------------------------------------------"
echo "Resetting labs"
make dev_reset -C lab1_register_create
echo
make dev_reset -C lab2_register_integrate
echo
make dev_reset -C lab3_register_apply
echo
make dev_reset -C lab4_register_methods
