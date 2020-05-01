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

quietly setenv SOLUTION ../spi_solution
quietly setenv RTL $env(SOLUTION)/rtl
quietly setenv AGENTS ./agents

vlog +incdir+$env(RTL)/spi/rtl/verilog $env(RTL)/spi/rtl/verilog/*.v +acc
vlog +incdir+$env(SOLUTION)/$env(AGENTS)/apb_agent $env(SOLUTION)/$env(AGENTS)/apb_agent/apb_agent_pkg.sv
vlog +incdir+$env(SOLUTION)/$env(AGENTS)/spi_agent $env(SOLUTION)/$env(AGENTS)/spi_agent/spi_agent_pkg.sv
vlog +incdir+$env(SOLUTION)/uvm_register_model $env(SOLUTION)/uvm_register_model/spi_reg_pkg.sv
vlog $env(SOLUTION)/$env(AGENTS)/apb_agent/apb_if.sv -timescale 1ns/10ps
vlog $env(SOLUTION)/$env(AGENTS)/spi_agent/spi_if.sv -timescale 1ns/10ps
vlog $env(SOLUTION)/tb/intr_if.sv -timescale 1ns/10ps
vlog +incdir+$env(SOLUTION)/env $env(SOLUTION)/env/spi_env_pkg.sv
vlog +incdir+$env(SOLUTION)/sequences $env(SOLUTION)/sequences/spi_bus_sequence_lib_pkg.sv
vlog +incdir+$env(SOLUTION)/sequences $env(SOLUTION)/sequences/spi_sequence_lib_pkg.sv
vlog +incdir+$env(SOLUTION)/sequences $env(SOLUTION)/sequences/spi_virtual_seq_lib_pkg.sv
vlog +incdir+$env(SOLUTION)/test $env(SOLUTION)/test/spi_test_lib_pkg.sv
vlog -timescale 1ns/10ps +incdir+$env(RTL)/spi/rtl/verilog $env(SOLUTION)/tb/top_tb_rtl.sv $env(SOLUTION)/tb/top_tb_test.sv

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