/***********************************************************************
 * UVM sequence class for UVM Intermediate lab 4 DMA
 * This excludes a register from some of the predefined tests
 *
 * Run with the following command, note the first switch:
 * % vsim +dma_connect_seq=dma_seq_include_coverage \
 *        +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=uvm_reg_bit_bash_seq
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

class dma_seq_include_coverage extends dma_seq_base;
  `uvm_object_utils(dma_seq_include_coverage)
  function new(string name="dma_seq_include_coverage");
    super.new(name);
  endfunction

  // This sequence-only method is run during the connect phase by dma_test_uvm_seq
  virtual function void connect(input dma_agent_config m_dma_cfg);
    `uvm_info(get_full_name(), "Include coverage", UVM_MEDIUM)
    void'(m_dma_cfg.dma_rm.set_coverage(UVM_CVR_ALL));		// Enable coverage for all DMA registers
    void'(m_dma_cfg.dma_rm.csr0.set_coverage(UVM_NO_COVERAGE));	// except the CSR
  endfunction

endclass
