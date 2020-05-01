//------------------------------------------------------------
//   Copyright 2010-2019 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------
//
// This package contains the sequences targetting the bus
// interface of the SPI block - Not all are used by the test cases
//
// It uses the UVM register model
//

`ifndef check_regs_seq_exists
`define check_regs_seq_exists

//
// This is a register sequence to check the reset values
// Then it writes random data to each of the registers
// and reads back to check that it matches
//
class check_regs_seq extends spi_bus_base_seq;

  `uvm_object_utils(check_regs_seq)

  function new(string name = "check_regs_seq");
    super.new(name);
  endfunction

  uvm_reg spi_regs[$];
  uvm_reg_data_t ref_data;

  virtual task body();
    int errors;

    //****** LAB 3 ASSIGNMENT, Step 3c: Call the base class body() method
    //****** INSERT LAB CODE HERE
    // BEGIN SOLUTION
    super.body();
    // END SOLUTION

    //**********END LAB INSERT***************


    //****** LAB 3 ASSIGNMENT, Step 3d: Call the get_registers(spi_regs)
    //       method with the spi_rm handle to fill the spi_regs list.
    //****** INSERT LAB CODE HERE
    // BEGIN SOLUTION
    spi_rm.get_registers(spi_regs);
    // END SOLUTION

    //**********END LAB INSERT***************

    // Set errors to 0
    errors = 0;

    // Walk thru the registers in a random order and read back the reset values
    spi_regs.shuffle();
    foreach (spi_regs[i]) begin
      ref_data = spi_regs[i].get_reset();
      spi_regs[i].read(aok, data, .parent(this));
      if (ref_data != data) begin
	`uvm_error("REG_TEST_SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
	errors++;
      end
    end

    // Write random data into every register and check the value read back, repeated 10 times
    repeat (10) begin
      spi_regs.shuffle();
      foreach (spi_regs[i]) begin
	if (!this.randomize()) begin
          `uvm_fatal("body", "randomization error")
	end
	if (spi_regs[i].get_name() == "ctrl") begin
          data[8] = 0;
	end
	spi_regs[i].write(aok, data, .parent(this));
      end
      spi_regs.shuffle();

      // LAB 3 ASSIGNMENT, Step 3g:  For each register in the DUT:
      //       *  Get the register model desired value, and store in the property: ref_data
      //       *  Read the value from the DUT, and store in the property: data
      //       An example of this is shown above.
      //       NOTE: There is already an 'end' to a foreach loop in the following code.
      //****** INSERT LAB CODE HERE
      // BEGIN SOLUTION
      foreach (spi_regs[i]) begin
	ref_data = spi_regs[i].get();
	spi_regs[i].read(aok, data, .parent(this));
      // END SOLUTION

      //**********END LAB INSERT***************

        if (ref_data != data) begin
          `uvm_error("REG_TEST_SEQ:", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
	  errors++;
        end

      end  // end to the foreach loop added as part of the lab exercise
    end  // repeat (10) loop

    // Repeat with back door accesses
    repeat (10) begin
      spi_regs.shuffle();
      foreach (spi_regs[i]) begin
	if (!this.randomize()) begin
	  `uvm_fatal("body", "randomization error")
	end
	if (spi_regs[i].get_name() == "ctrl") begin
	  data[8] = 0;
	end
	spi_regs[i].poke(aok, data, .parent(this));
      end
      spi_regs.shuffle();
      foreach (spi_regs[i]) begin
	ref_data = spi_regs[i].get();
	spi_regs[i].peek(aok, data, .parent(this));
	if (ref_data[31:0] != data[31:0]) begin
	  `uvm_error("REG_TEST_SEQ:", $sformatf("poke/peek: Read error for %s: Expected: %0h Actual: %0h", spi_regs[i].get_name(), ref_data, data))
	  errors++;
	end
	spi_regs[i].read(aok, data, .parent(this));
      end

    end

    if (errors == 0) begin
      `uvm_info("** UVM TEST PASSED **", "Register read-back path OK - no errors", UVM_LOW)
    end

  endtask: body

endclass: check_regs_seq

`endif
