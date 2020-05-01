/***********************************************************************
 * Agent configuration class for UVM Intermediate lab 1 DMA
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

class dma_agent_config extends uvm_object;
  `uvm_object_utils(dma_agent_config)
  function new(string name="dma_agent_config");
    super.new(name);
  endfunction

  uvm_sequencer #(dma_item) sqr;	// Agent-level sequencer
  virtual dma_ifc dma_if;		// Virtual interface
  top_block top_rm;			// Register model for top block
  dma_block dma_rm;			// Register model for DMA block
  bit provides_responses = 0;		// 1=driver provides separate response
  uvm_active_passive_enum active;	// Is the agent active or passive?

  virtual function void init_config(input virtual dma_ifc dma_if,
				    input top_block top_rm,
				    input uvm_active_passive_enum active = UVM_ACTIVE,
				    input bit provides_responses=0);
    this.dma_if = dma_if;
    this.top_rm = top_rm;
    this.dma_rm = top_rm.dma_rm;
    this.active = active;
  endfunction


  // Block until reset is released. 
  // The operation is performed by a BFM/interface task.
  virtual task wait_for_reset(input bit verbose=0);
    static bit reset_complete = 0;
    if (dma_if == null)
      `uvm_fatal("NOIFC", $sformatf("dma_if not set in %m"))
    if (!reset_complete) begin
      dma_if.wait_for_reset(verbose);
      reset_complete = 1;
    end
  endtask

endclass : dma_agent_config
