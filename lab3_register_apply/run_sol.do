# Tests are spi_reg_test and spi_interrupt_test
# Should be first argument.

quietly set nargs $argc
#echo $argc

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
vlog +incdir+$env(LABFILES)/$env(AGENTS)/apb_agent $env(LABFILES)/$env(AGENTS)/apb_agent/apb_agent_pkg.sv
vlog +incdir+$env(LABFILES)/$env(AGENTS)/spi_agent $env(LABFILES)/$env(AGENTS)/spi_agent/spi_agent_pkg.sv
vlog +incdir+$env(LABFILES)/uvm_register_model $env(LABFILES)/uvm_register_model/spi_reg_pkg.sv
vlog $env(LABFILES)/$env(AGENTS)/apb_agent/apb_if.sv -timescale 1ns/10ps
vlog $env(LABFILES)/$env(AGENTS)/spi_agent/spi_if.sv -timescale 1ns/10ps
vlog $env(LABFILES)/tb/intr_if.sv -timescale 1ns/10ps
vlog +incdir+$env(LABFILES)/env $env(LABFILES)/env/spi_env_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_bus_sequence_lib_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_sequence_lib_pkg.sv
vlog +incdir+$env(LABFILES)/sequences $env(LABFILES)/sequences/spi_virtual_seq_lib_pkg.sv
vlog +incdir+$env(LABFILES)/test $env(LABFILES)/test/spi_test_lib_pkg.sv
vlog -timescale 1ns/10ps +incdir+$env(RTL)/spi/rtl/verilog $env(LABFILES)/tb/top_tb_rtl.sv $env(LABFILES)/tb/top_tb_test.sv

quietly set default_test "spi_reg_test"
quietly set avail_test_msg "            Available tests are spi_reg_test, spi_interrupt_test, spi_poll_test"

if {$nargs == 0} {
    echo "Info: run.do: No test name specified, running default $default_test"
    echo $avail_test_msg
    vsim -voptargs=+acc +UVM_TESTNAME=spi_reg_test +UVM_NO_RELNOTES -classdebug -uvmcontrol=all,-trlog top_tb_test top_tb_rtl
}


# tests possible are spi_reg_test  spi_interrupt_test spi_poll_test
if {$nargs > 0} {
    echo "Running test $1"
    vsim -voptargs=+acc +UVM_TESTNAME=$1 +UVM_NO_RELNOTES -classdebug -uvmcontrol=all,-trlog top_tb_test top_tb_rtl
}

onfinish stop

run -all
#exit