#!/usr/bin/perl -w
#----------------------------------------------------------------------
# Perl script for UVMI lab files
#
# ** Not currently used **
#
# In the generated vreguvm_pkg_uvm.sv package, extend register classes
# from imp_cvr_reg instead of uvm_reg:
# - After the import uvm_pkg, add include "imp_cvr_reg.svh"
# For use by course developers
#
# Run with:
# ../bin/imp_cvr.pl < vreguvm_pkg_uvm.sv > _vreguvm_pkg_uvm.sv
# mv _vreguvm_pkg_uvm.sv vreguvm_pkg_uvm.sv
#
#----------------------------------------------------------------------
# Copyright 2019 Mentor Graphics Corporation
# All Rights Reserved Worldwide
#
# CBS 191111 - Created
#----------------------------------------------------------------------
#
# Solution code is surrounded by:
#	//BEGIN SOLUTION
#	remove this
#	//END SOLUTION

use strict;
use warnings;

# Look for starting expression
print "// Modified by $0\n//\n";
while ( <> ) {  # <> reads from STDIN
#    print STDERR "$state $_";
    if (m/import uvm_pkg/) {
	print $_;
	print "   include \"imp_cvr_reg.svh\";"
    }
    else {
	print $_;
    }

} # while
