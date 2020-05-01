# Script to compile lab 3 files for the UVM Intermediate course
# No arguments to this do file

if {[file exists work] } {
file delete -force work
vlib work
} else {
vlib work
}

onbreak resume

quietly setenv LABFILES .
quietly setenv RTL $env(LABFILES)/rtl
quietly setenv AGENTS ./agents

vlog +incdir+$env(RTL)/spi/rtl/verilog $env(RTL)/spi/rtl/verilog/*.v +acc
#vlog +incdir+$env(LABFILES)/$env(AGENTS)/apb_agent $env(LABFILES)/$env(AGENTS)/apb_agent/apb_agent_pkg.sv
vlog +incdir+$env(LABFILES)/$env(AGENTS)/apb_agent $env(LABFILES)/$env(AGENTS)/apb_agent/apb_agent_pkg.sv
vlog +incdir+$env(LABFILES)/$env(AGENTS)/spi_agent $env(LABFILES)/$env(AGENTS)/spi_agent/spi_agent_pkg.sv
vlog +incdir+$env(LABFILES)/uvm_register_model $env(LABFILES)/uvm_register_model/spi_reg_pkg.sv
vlog $env(LABFILES)/$env(AGENTS)/apb_agent/apb_if.sv -timescale 1ns/10ps
vlog $env(LABFILES)/$env(AGENTS)/spi_agent/spi_if.sv -timescale 1ns/10ps
vlog $env(LABFILES)/tb/intr_if.sv -timescale 1ns/10ps
#vlog +incdir+$env(LABFILES)/env $env(LABFILES)/env/spi_env_pkg.sv
vlog +incdir+$env(LABFILES)/env $env(LABFILES)/env/spi_env_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_bus_sequence_lib_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_sequence_lib_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_virtual_seq_lib_pkg.sv
#vlog +incdir+$env(LABFILES)/test $env(LABFILES)/test/spi_test_lib_pkg.sv
vlog +incdir+$env(LABFILES)/test $env(LABFILES)/test/spi_test_lib_pkg.sv
vlog -timescale 1ns/10ps +incdir+$env(RTL)/spi/rtl/verilog $env(LABFILES)/tb/top_tb_rtl.sv $env(LABFILES)/tb/top_tb_test.sv
