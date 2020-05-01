This is the complete solution to lab2 and lab3. These files are
duplicated in the lab2 and lab3 directories.

To run the solution using the Questa GUI, open Questa in the spi_solution
directory and run the compile.do and run.do files.

compile.do
  Deletes any existing work directories, create a new work directory,
  and compiles the complete design.

run.do
  Assumes that a work directory exists, and that the design is completely
  compiled. It runs the spi_reg_test. Or, if used with the test name as an
  argument, it will run any test in the test class package.
    vsim> do run_sim.do spi_interrupt_test
