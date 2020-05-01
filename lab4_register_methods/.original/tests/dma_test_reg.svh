/***********************************************************************
 * UVM test that runs the register sequence for UVM Intermediate lab 1 DMA
 *
 * Run with:
 * % make TESTNAME=dma_test_reg
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_reg ...
 *
 * Better yet, use the parameterized test: dma_test_uvm_seq
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


class dma_test_reg extends dma_test_base;
  `uvm_component_utils(dma_test_reg)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    // Build the base components and register model
    super.build_phase(phase);
  endfunction


  virtual task run_phase(uvm_phase phase);
    dma_seq_reg seq;
    seq = dma_seq_reg::type_id::create("seq");
    phase.raise_objection(this, get_full_name());
    seq.init_start(dma_agt_cfg);
    phase.drop_objection(this, get_full_name());
  endtask

endclass