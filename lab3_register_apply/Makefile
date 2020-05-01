# Makefile to compile and run the UVM Intermediate Lab 3
#
# First compile the source code
#	make compile
#
# Run with classic Questa GUI
#	make gui
#
# Run in batch, no GUI
#	make batch
#

LABFILES	= .
RTL		= ${LABFILES}/rtl
AGENTS		= ./agents
TIMESCALE	= -timescale 1ns/10ps
ACC		=  +acc=r+/top_tb_rtl

TESTNAME	= spi_reg_test
UVM_SWITCHES	= +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES
TEST_SEED	= 1010
VSIM_ARGS	= -l vsim.log -sv_seed $(TEST_SEED) $(UVM_SWITCHES)
VIS_DEBUG_ARGS = -classdebug -qwavedb=+class=uvmclassfilter.txt+signal+memory=10000,2 


# Simulate with classic Questa GUI
run gui: vopt
	vsim -gui opt $(VSIM_ARGS) -classdebug -uvmcontrol=all,-trlog

# Simulate in batch, no GUI
batch:	vlog vopt
	vsim  -batch opt $(VSIM_ARGS) -do "run -all; quit -f"

vopt:
	vopt $(ACC) top_tb_test top_tb_rtl -o opt

compile vlog: vlib
	vlog +incdir+${RTL}/spi/rtl/verilog ${RTL}/spi/rtl/verilog/*.v +acc
	vlog +incdir+${LABFILES}/${AGENTS}/apb_agent ${LABFILES}/${AGENTS}/apb_agent/apb_agent_pkg.sv
	vlog +incdir+${LABFILES}/${AGENTS}/spi_agent ${LABFILES}/${AGENTS}/spi_agent/spi_agent_pkg.sv
	vlog +incdir+${LABFILES}/uvm_register_model ${LABFILES}/uvm_register_model/spi_reg_pkg.sv
	vlog ${LABFILES}/${AGENTS}/apb_agent/apb_if.sv $(TIMESCALE)
	vlog ${LABFILES}/${AGENTS}/spi_agent/spi_if.sv $(TIMESCALE)
	vlog ${LABFILES}/tb/intr_if.sv $(TIMESCALE)
	vlog +incdir+${LABFILES}/env ${LABFILES}/env/spi_env_pkg.sv
	vlog +incdir+${LABFILES}/sequences ${LABFILES}/sequences/spi_bus_sequence_lib_pkg.sv
	vlog +incdir+${LABFILES}/sequences ${LABFILES}/sequences/spi_sequence_lib_pkg.sv
	vlog +incdir+${LABFILES}/sequences ${LABFILES}/sequences/spi_virtual_seq_lib_pkg.sv
	vlog +incdir+${LABFILES}/test ${LABFILES}/test/spi_test_lib_pkg.sv
	vlog $(TIMESCALE) +incdir+${RTL}/spi/rtl/verilog \
		${LABFILES}/tb/top_tb_rtl.sv ${LABFILES}/tb/top_tb_test.sv
vlib: clean
	vlib work

clean:
	rm -rf work *.vstf *.log transcript vsim.wlf certe_dump.xml *~ */*~ modelsim.ini

##################################################################
# Visualizer targets

vis	: vlib vlog vopt_vis simi
visb	: vlib vlog vopt_vis simb

# Batch simulate to generate Visualizer data
simb:
	vsim opt_vis $(VSIM_ARGS) -batch \
		-do "run 0; uvm traceobjections uvm_test_top 1; run -all; quit -f"

# Start Visualizer interactively during simulation
simi:	vopt_vis
	vsim opt_vis $(VSIM_ARGS) $(VIS_DEBUG_ARGS) -visualizer=design.bin

vsim_vis:	vopt_vis
	vsim opt_vis $(VSIM_ARGS) $(VIS_DEBUG_ARGS) -do "run 0" -classdebug +initmem -sv_seed 1010

# Run Visualizer to post-process simulation results
visualizer:
	visualizer design.bin qwave.db

# Optimize for Visualizer, and generate design database
vopt_vis:	vlog
	vopt $(ACC_GUI) -debug top_tb_test top_tb_rtl -o opt_vis \
		+initmem+0 -linedebug -designfile design.bin 

##################################################################

##################################################################
# The rest of the targets are for the course developer
version:
	vsim -c -version

# Bundle up lab files for publishing
# Assume we are down in the lab 3 directory
dev_tar: dev_reset
	cd .. ; ./bin/tar_labs.csh


# Reset the student lab files to the original state, based on the filtered solution files
dev_reset: clean
	../bin/lab_filter.pl < sequences/bus_sequences/.solution/check_regs_seq.svh   > sequences/bus_sequences/check_regs_seq.svh
	../bin/lab_filter.pl < sequences/top_virtual_seqs/.solution/reg_test_vseq.svh > sequences/top_virtual_seqs/reg_test_vseq.svh
	../bin/lab_filter.pl < test/.solution/spi_reg_test.svh                        > test/spi_reg_test.svh

# Try out the solution files
dev_solution: clean
	cp sequences/bus_sequences/.solution/check_regs_seq.svh   sequences/bus_sequences
	cp sequences/top_virtual_seqs/.solution/reg_test_vseq.svh sequences/top_virtual_seqs
	cp test/.solution/spi_reg_test.svh                        test

echo_var:
	echo $(var) == $($(var))

# Show all targets
#	% make targets
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: targets
targets:
	@$(MAKE) -pRrq -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
