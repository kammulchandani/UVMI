# Script to run a specified test for the UVM Intermediate course
# Assumes that the compile was successful
# Specify desired test name as the first argument.

quietly set nargs $argc

onbreak resume

quietly set default_test "spi_reg_test"
quietly set avail_test_msg "            Available tests are spi_reg_test, spi_interrupt_test, spi_poll_test"

if {$nargs == 0} {
    echo "Info: run.do: No test name specified, running default $default_test"
    echo $avail_test_msg
    vsim -voptargs=+acc +UVM_TESTNAME=$default_test +UVM_NO_RELNOTES -classdebug -uvmcontrol=all,-trlog top_tb_test top_tb_rtl
}


# tests possible are spi_reg_test  spi_interrupt_test spi_poll_test
if {$nargs > 0} {
    echo "Running test $1"
    vsim -voptargs=+acc +UVM_TESTNAME=$1 +UVM_NO_RELNOTES -classdebug -uvmcontrol=all,-trlog top_tb_test top_tb_rtl
}

onfinish stop

run -all
#exit