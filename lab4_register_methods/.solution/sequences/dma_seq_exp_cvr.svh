/***********************************************************************
 * Register sequence to boost coverage with explicit sampling. 
 * For UVM Intermediate lab 4
 * 
 * Run this with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_exp_cvr
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


class dma_seq_exp_cvr extends dma_seq_base;
  `uvm_object_utils(dma_seq_exp_cvr)
  function new(string name="dma_seq_exp_cvr");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;

    void'(dma_rm.set_coverage(UVM_CVR_ALL)); // Enable coverage for all DMA registers
    void'(dma_rm.csr0.set_coverage(UVM_NO_COVERAGE)); // except the CSR

    m_dma_cfg.wait_for_reset();

    // Write N values to size, src, dst.
    // They = 0 after reset, so start from largest value and end at lowest
    for (int i=32'hFFFF; i>0; i=i-(32'h1_0000/64)) begin
      `uvm_info(get_type_name(), $sformatf("Writing 0x%0x/%0d. to size0, src0, dst0", i, i), UVM_MEDIUM)

      // Frontdoor writes to three primary registers
      dma_rm.size0.write(aok, i, .parent(this));
      dma_rm.src0.write(aok,  i, .parent(this));
      dma_rm.dst0.write(aok,  i, .parent(this));
      dma_rm.inc0.write(aok,  i, .parent(this));

      // Backdoor writes to three primary registers
      // dma_rm.size0.write(aok, i, UVM_BACKDOOR, .parent(this));
      // dma_rm.src0.write(aok,  i, UVM_BACKDOOR, .parent(this));
      // dma_rm.dst0.write(aok,  i, UVM_BACKDOOR, .parent(this));
      // dma_rm.inc0.write(aok,  i, UVM_BACKDOOR, .parent(this));

      // Set + update for three primary registers
      // dma_rm.size0.set(i);
      // dma_rm.src0.set(i);
      // dma_rm.dst0.set(i);
      // dma_rm.inc0.set(i);
      // dma_rm.update(aok, UVM_FRONTDOOR);	// Update via frontdoor
//      dma_rm.update(aok, UVM_BACKDOOR);	// Update via backdoor

      // Explicitly sample the values.
      // This eventually calls sample_values() in the register classes: cg_vals.sample()
      dma_rm.sample_values();
    end

  endtask

endclass : dma_seq_exp_cvr
