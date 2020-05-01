/***********************************************************************
 * UVM sequence base class for UVM Intermediate lab 1 DMA
 * You never simulate this sequence
 * Extends uvm_reg_sequence so it is compatible with the predefined sequences
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

class dma_seq_base extends uvm_reg_sequence;
  `uvm_object_utils(dma_seq_base)
  function new(string name="dma_seq_base");
    super.new(name);
  endfunction

  dma_agent_config m_dma_cfg;   // Configuration for DMA agent
  top_block top_rm;	    // Top register model handle
  dma_block dma_rm;	    // Register model handle for DMA block

  // Initialize sequences and start them - shared by all sequence classes
  virtual task init_start(input dma_agent_config m_dma_cfg);
    if (m_dma_cfg == null)
      `uvm_fatal(get_type_name(), "Null handle passed to init_start")
    this.m_dma_cfg = m_dma_cfg;
    this.top_rm = m_dma_cfg.top_rm;
    this.dma_rm = m_dma_cfg.dma_rm;
    this.start(null);
  endtask


  //////////////////////////////////////////////////////////////////
  // The following methods let you run code during a phase, without
  // having to create a new test. Just extend this class, add your
  // code to a method below, and run the test dma_test_uvm_seq.
  // % vsim +UVM_TESTNAME=dma_test_uvm_seq \
  //          +dma_connect_seq=dma_seq_my_connect

  // Empty method that can be run during the build_phase
  virtual function void build(input dma_agent_config m_dma_cfg);
  endfunction

  // Empty method that can be run during the connect_phase
  virtual function void connect(input dma_agent_config m_dma_cfg);
  endfunction

endclass
