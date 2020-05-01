/***********************************************************************
 * Register sequence to boost coverage with implicit sampling.
 * For UVM Intermediate lab 4
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_imp_cvr
 * This depends on having new columns in dma_regs.csv and dma_blocks.csv
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


class dma_seq_imp_cvr extends dma_seq_base;
  `uvm_object_utils(dma_seq_imp_cvr)
  function new(string name="dma_seq_imp_cvr");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;

    void'(dma_rm.set_coverage(UVM_CVR_ALL)); // Enable coverage for all DMA registers
    void'(dma_rm.csr0.set_coverage(UVM_NO_COVERAGE)); // except the CSR

    m_dma_cfg.wait_for_reset();

    // Write N values to size, src, dst
    for (int i=0; i<16'hFFFF; i=i+(32'h1_0000/64)) begin
      `uvm_info(get_type_name(), $sformatf("Writing 0x%0x %0d. to size0, src0, dst0", i, i), UVM_MEDIUM)

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
      // dma_rm.update(aok, UVM_FRONTDOOR); // Issues
      // dma_rm.update(aok, UVM_BACKDOOR);

      // DON'T sample the values - this is IMPLICIT coverage
      // dma_rm.sample_values();
    end

    // One final write so final loop value is sampled
    dma_rm.size0.write(aok, 0, .parent(this));
  endtask

endclass : dma_seq_imp_cvr
