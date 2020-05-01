# Makefile to compile and run the UVM Intermediate Lab 1
#
# Run with Visualizer GUI:
#	make vis
#
# Run with classic Questa GUI
#	make gui
#
# Run batch, no GUI (default)
#	make batch
#
# Run with a different test (like the built-in UVM reg reset sequence)
#	make batch TESTNAME=dma_test_uvm_hw_reset
#
# Specify extra simulation argments
#	make SIM=args
#
# Run a sequence (dma_seq_rand) that does not have an associated test
#	make batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_xfr
#
# Run a UVM predefined sequence
#	make batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=uvm_reg_hw_reset_seq

AGENT           = ./agent
ENV             = ./env
RTL             = ./rtl
SEQ             = ./sequences
TB              = ./tb
TESTS           = ./tests
INCDIR          = +incdir+$(AGENT)+$(ENV)+$(SEQ)+$(RTL)+$(SEQ)+$(TB)+$(TESTS)
VLOG_SW         = $(INCDIR) +define+UVM_REPORT_DISABLE_FILE_LINE
PKG_SRC		= $(RTL)/dma_pkg.sv $(TB)/dma_tb_pkg.sv
TB_SRC          = $(TB)/top_tb.sv
RTL_SRC 	= $(RTL)/top_hdl.sv $(RTL)/dma_ctrl.sv $(RTL)/dma_ifc.sv
IMP_PKG		= $(TB)/imp_cvr_reg_pkg.sv
INC_PKG		= $(TB)/inc_reg_pkg.sv
DMA_CSV		= dma_blocks.csv         dma_mem.csv dma_maps.csv dma_regs.csv
IMP_CSV         = dma_blocks_imp_cvr.csv dma_mem.csv dma_maps.csv dma_regs_imp_cvr.csv
INC_CSV         = dma_blocks_inc.csv     dma_mem.csv dma_maps.csv dma_regs_inc.csv

VREGUVM		= vreguvm_pkg_uvm.sv

TESTNAME       = dma_test_uvm_seq
SIM            = +uvm_seq=uvm_reg_hw_reset_seq
ifdef UVM_DEBUG
	UVM_DEBUG_SWITCHES = +UVM_OBJECTION_TRACE #+UVM_PHASE_TRACE
else
	UVM_DEBUG_SWITCHES =
endif
UVM_SWITCHES	= $(UVM_DEBUG_SWITCHES) +UVM_TESTNAME=$(TESTNAME) +UVM_NO_RELNOTES

TEST_SEED	= 1010
VIS_DEBUG_ARGS = -classdebug -qwavedb=+class=uvmclassfilter.txt+signal+memory=10000,2 -do "register_dma.tcl"
VSIM_ARGS      = -l vsim.log -sv_seed $(TEST_SEED) $(UVM_SWITCHES) $(SIM)
ACC_REG	       =  +acc=r+/top_hdl/dma0
ACC_GUI	       =  +acc

VSIM_TEST_SEQ  = vsim -batch opt_batch +UVM_TESTNAME=dma_test_uvm_seq -do "run -all; quit -f"

##################################################################
# Generic targets

# Simulate in batch, no GUI
batch:	vopt_batch
	vsim -batch opt_batch $(VSIM_ARGS) -do "run -all; quit -f"

# Register Assistant - compile register definition
vreg $(VREGUVM)	: $(DMA_CSV)
	vreguvm -csvin $(DMA_CSV) -block top_block

vlib: clean
	vlib work

# Compile all SystemVerilog source code
vlog:	$(VREGUVM) $(PKG_SRC) $(TB_SRC) $(RTL_SRC)
	vlog \
		$(VLOG_SW) $(IMP_PKG) $(INC_PKG) $(VREGUVM) $(PKG_SRC) $(TB_SRC) $(RTL_SRC)

# Optimize for batch - still need PLI access for the register layer backdoor
vopt_batch:	vlog
	vopt $(ACC_REG) top_tb top_hdl -o opt_batch


##################################################################
# Lab 4 targets
# All build both batch and GUI targets for debugging

# Quirky register for inc register
inc:
	make vreg DMA_CSV="$(INC_CSV)" vopt_batch
	make gui TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_inc

# Implicit sampling for functional coverage
imp_cvr: $(IMP_CSV)
	make vreg DMA_CSV="$(IMP_CSV)"
	make gui TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_imp_cvr

dma_blocks_imp_cvr.csv dma_regs_imp_cvr.csv:
	cp .solution/dma_*imp_cvr.csv .

# Explicit sampling for functional coverage
exp_cvr:
	make gui TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_exp_cvr

clean:
	rm -rf work design.bin qwave.db *.vstf *.log transcript vsim.wlf .visualizer ${HOME}/.visualizer certe_dump.xml *~ */*~ $(VREGUVM) $(VREGUVM_SAMPLE) uvm128 modelsim.ini


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
	vopt $(ACC_GUI) -debug top_tb top_hdl -o opt_vis \
		+initmem+0 -linedebug -designfile design.bin

##################################################################
# Classic GUI targets

# Simulate with classic GUI
gui:	vopt_gui
	vsim -gui opt_gui $(VSIM_ARGS)

# Optimize for classic GUI
vopt_gui:	vlog
	vopt $(ACC_GUI) \
		top_tb top_hdl -o opt_gui


##################################################################
# Compile and run with 128 bit data in the classic Questa GUI
# Not yet successful due to DPI issue

gui_128:	vopt_128
	vsim -gui opt_gui $(VSIM_ARGS) -work uvm128

vopt_128:	vlog_128
	vopt $(ACC_REG) top_tb top_hdl -o opt_gui -work uvm128

vlog_128:	 $(VREGUVM) $(PKG_SRC) $(TB_SRC) $(RTL_SRC) uvm128
	vlog \
		-work ./uvm128 +incdir+. +incdir+$(QUESTA_HOME)/verilog_src/uvm-1.1d/src \
		$(INCDIR) $(VREGUVM) $(PKG_SRC) $(TB_SRC) $(RTL_SRC)

uvm128:
	vlog -work ./uvm128 \
		+define+REG_DATA_WIDTH=128 \
		+incdir+$(QUESTA_HOME)/verilog_src/uvm-1.1d/src \
		$(QUESTA_HOME)/verilog_src/uvm-1.1d/src/uvm_pkg.sv
	vmap mtiUvm ./uvm128



##################################################################
# The rest of the targets are for the course developer
version:
	vsim -c -version
	which visualizer

# Bundle up lab files for publishing
# Assume we are down in the lab 1 directory
dev_tar: dev_reset
	cd .. ; ./bin/tar_labs.csh

# Reset the lab to the original state
dev_reset: clean
	rm -f *.csv
	cp -r .original/dma_*.csv .
	cp .original/rtl/dma_ctrl.sv rtl
	cp .original/tb/inc_reg_pkg.sv tb

dev_solution: clean
	cp -r .solution/dma_*.csv .

# Explicit sampling requires .original CSV files
dev_exp_cvr:
	make dev_reset batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_exp_cvr

# Implicit sampling, requires .solution imp_cvr CSV files
dev_imp_cvr:
	make dev_solution vreg DMA_CSV="$(IMP_CSV)"
	make batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_imp_cvr

# Quirky register for inc register
dev_inc:
	make vreg DMA_CSV="$(INC_CSV)" vopt_gui
	make batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_inc

# Run all sequences exclusive for lab 4
dev_test_all: dev_imp_cvr dev_exp_cvr
# Sequences other than coverage or predefined
	make batch TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_introspect
	$(VSIM_TEST_SEQ) +uvm_seq=dma_seq_mem
# Run the predefined sequences
	$(VSIM_TEST_SEQ) +uvm_seq=uvm_reg_hw_reset_seq
	$(VSIM_TEST_SEQ) +uvm_seq=uvm_reg_mem_hdl_paths_seq
	$(VSIM_TEST_SEQ) +uvm_seq=uvm_reg_bit_bash_seq
	$(VSIM_TEST_SEQ) +uvm_seq=uvm_mem_walk_seq
	$(VSIM_TEST_SEQ) +uvm_seq=uvm_reg_mem_access_seq
#	$(VSIM_TEST_SEQ) +uvm_seq=uvm_reg_shared_access_seq
#	$(VSIM_TEST_SEQ) +uvm_seq=uvm_mem_shared_access_seq

echo_var:
	echo $(var) == $($(var))

# Show all targets
#	% make targets
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: targets
targets:
	@$(MAKE) -pRrq -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
