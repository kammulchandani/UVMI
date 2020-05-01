#!/bin/csh -f
#----------------------------------------------------------------------
# Unix script to recursively clean the course lab directories
# For use by course developers
#----------------------------------------------------------------------
# Copyright 2017 Mentor Graphics Corporation
# All Rights Reserved Worldwide
#
# CBS 170714 - Cleanups
#----------------------------------------------------------------------

# Default is quiet mode, which does not echo the directories being cleaned
if ("x$1" == "xquiet") then
  set x_quiet = 1
else
  set x_quiet = 0
endif

set _pwd = $PWD

foreach i (. `find * -type d -print`)
    if (-d $_pwd/$i) then
	if (! ${x_quiet}) echo $_pwd/$i
	cd $_pwd/$i
	touch work
	rm -rf *~ work* transcript *.log vsim.wlf covhtmlreport report.txt desktop.ini certe_dump.xml
    endif
end

cd $_pwd
