/***********************************************************************
 * Sequence to try various introspecion methods, UVM Intermediate lab 4
 * Tries various values, does not exercise the DMA engine
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_introspect
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_introspect ...
 ***********************************************************************
 * Copyright 2019 Mentor Graphics Corporation
 * All Rights Reserved Worldwide
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.  See the License for the specific language governing
 * permissions and limitations under the License.
 **********************************************************************/


class dma_seq_introspect extends dma_seq_base;
  `uvm_object_utils(dma_seq_introspect)
  function new(string name="dma_seq_introspect");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t exp, act;
    uvm_reg rq[$];

    dma_rm.get_registers(rq);
    print_reg_names(rq, "Raw queue of registers");

    // Next few blocks of code are trying some operations, nothing useful
    rq.reverse();
    print_reg_names(rq, "Reversed");

    rq.shuffle();
    print_reg_names(rq, "Shuffled");

    rq.sort(idx) with ( idx.get_name());
    print_reg_names(rq, "Registers sorted by name");

    rq.sort(idx) with ( idx.get_address());
    print_reg_names(rq, "Registers sorted by address");

    // Try writing random values to all regs, then reading back, 5 times
    repeat (5) begin
      // Randomize the register model values and write back to device
      if (!dma_rm.randomize() with {csr0.go.value == 0; }) 
	`uvm_fatal("FAIL", "dma_rm.randomize")
      dma_rm.update(aok);

      // Read the registers back and check their values
      foreach (rq[i]) begin
	$display("Checking %s", rq[i].get_name());
	void'(rq[i].predict(rq[i].get()));	// Fetch mirror (expected) value
	rq[i].mirror(aok, UVM_CHECK);		// Read actual value into mirror & check
      end
    end

  endtask


  function void print_reg_names(input uvm_reg q[$],
				input string prefix="");
    string s;
    foreach (q[i]) begin
      s = {s, " ", q[i].get_name()};
    end
    `uvm_info(prefix, s, UVM_MEDIUM)
  endfunction
endclass
