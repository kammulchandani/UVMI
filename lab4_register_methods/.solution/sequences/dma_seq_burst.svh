/***********************************************************************
 * Register sequence for burst read / writes.  UVM Intermediate lab 4
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_burst
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_burst ...
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

class dma_seq_burst extends dma_seq_base;
  `uvm_object_utils(dma_seq_burst)
  function new(string name="dma_seq_burst");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t wdata[], rdata[];  // Dynamic array to receive values
    uvm_reg_data_t w, r;
    
    m_dma_cfg.wait_for_reset();

    w = 16'h5A5A;
    top_rm.mem0.write(aok, 32'h8, w);
    top_rm.mem0.read(aok, 32'h8, r);
    `uvm_info(get_full_name(), $sformatf("mem[8] r=%0x w=%0x", r, w), UVM_MEDIUM)

    // Fill the array with 6 words
    wdata = '{16'hF0F0, 16'hF1F1, 16'hF2F2, 16'hF3F3, 16'hF4F4, 16'hF5F5};

    // Burst write all 6 addresses, starting at 1000
    top_rm.mem0.burst_write(aok, 32'h10, wdata);

    // ... Later in the sequence
    rdata = new[4];
    // Burst read from 4 addresses into the array
    top_rm.mem0.burst_read(aok, 32'h10, rdata);
    foreach (rdata[i]) begin
      if (rdata[i] != wdata[i]) begin
	`uvm_error(get_full_name(), $sformatf("Burst write[0x%0x]=0x%0x, != read 0x%0x", i, rdata[i], wdata[i]))
      end
    end

    // ... Later in the sequence
    rdata = new[4];
    // Burst read from 4 addresses into the array
    top_rm.mem0.burst_read(aok, 32'h14, rdata);
    foreach (rdata[i]) begin
      `uvm_info(get_full_name(), $sformatf("%0d: r=%0x w=%0x", i, rdata[i], wdata[i]), UVM_MEDIUM)
    end
  endtask

endclass : dma_seq_burst
