/***********************************************************************
 * UVM test class that runs the predefined UVM HW reset sequence 
 * for UVM Intermediate lab 1
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_hw_reset
 * This resolves to:
 * % vsim +UVM_TESTNAME=dma_test_uvm_hw_reset ...
 *
 * The problem with this test is that you don't want to make a separate
 * test for every sequence in the library. See tests/dma_test_uvm_seq.svh
 * for a better approach.
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


class dma_test_uvm_hw_reset extends dma_test_base;
  `uvm_component_utils(dma_test_uvm_hw_reset)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    // Build the base components and register model
    super.build_phase(phase);
  endfunction


  virtual task run_phase(uvm_phase phase);
    string argval;
    uvm_reg_hw_reset_seq seq;

    seq = uvm_reg_hw_reset_seq::type_id::create("seq");
    phase.raise_objection(this, get_full_name());
    seq.model = dma_rm;
    seq.start(null);
    phase.drop_objection(this, get_full_name());
  endtask

endclass
