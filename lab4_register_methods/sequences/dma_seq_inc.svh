/***********************************************************************
 * Register sequence for an incrementing register.  UVM Intermediate lab 1
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_inc
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_inc ...
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


class dma_seq_inc extends dma_seq_base;
  `uvm_object_utils(dma_seq_inc)
  function new(string name="dma_seq_inc");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t dut, mirror, desire;

    m_dma_cfg.wait_for_reset();

    read_all_values(0);

    `uvm_info(get_type_name(), "write 5", UVM_MEDIUM)
    dma_rm.inc0.write(aok,  5, .parent(this));
    read_all_values(5);
    read_all_values(6);
    read_all_values(7, UVM_BACKDOOR);
    read_all_values(8);

    `uvm_info(get_type_name(), "write FFFD", UVM_MEDIUM)
    dma_rm.inc0.write(aok,  16'hFFFD, .parent(this));
    read_all_values('hFFFD);
    read_all_values('hFFFE, UVM_BACKDOOR);
    read_all_values('hFFFF);
    read_all_values('h0);
  endtask


  // Has the side effect of reading the register, which causes it to increment
  virtual task read_all_values(input uvm_reg_data_t exp,
			       input uvm_path_e path=UVM_FRONTDOOR);
    uvm_status_e aok;
    uvm_reg_data_t act, mirror, desire;
    DMA_DATA_T exp1;		// Only 16 bits as it is incremented

    $display("\nPerforming a %s read", path.name());
    // Read the value from the DUT, either front- or back-door
    // This has the side effect of incrementint after the read
    dma_rm.inc0.read(aok, act, path, .parent(this));
    if (exp !== act)
      `uvm_error("INC", $sformatf("Expected 0x%0x != actual 0x%0x", exp, act))

    // Compare the mirror value
    exp1 = exp + 1;
    mirror = dma_rm.inc0.get_mirrored_value();
    if (exp1 !== mirror)
      `uvm_error("INC", $sformatf("Expected+1 0x%0x != mirror 0x%0x", exp1, act))

    // Compare the desired value
    desire = dma_rm.inc0.get();
    if (exp1 !== desire)
      `uvm_error("INC", $sformatf("Expected+1 0x%0x != desire 0x%0x", exp1, act))

    
    `uvm_info("INC", $sformatf("Expect=0x%0x, actual read=%0x, mirror=%0x, desire=%0x (%s)",
			      exp, act, mirror, desire, path.name()), UVM_MEDIUM)
  endtask
endclass : dma_seq_inc
