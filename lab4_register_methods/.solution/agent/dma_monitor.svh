/***********************************************************************
 * Monitor class for DMA UVM example
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


class dma_monitor extends uvm_monitor;
   `uvm_component_utils(dma_monitor);
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

  dma_agent_config m_dma_cfg;
  uvm_analysis_port #(dma_item) ap;


  virtual function void set_config(input dma_agent_config m_dma_cfg);
    this.m_dma_cfg = m_dma_cfg;
  endfunction


  virtual function void build_phase(uvm_phase phase);
    if (! m_dma_cfg) `uvm_fatal("MONITOR", "dma_agent_config was not set")
    ap = new("ap", this);
  endfunction


  virtual task run_phase(uvm_phase phase);
    dma_item item;

    // Create, capture, and analyze transactions
    forever begin
      item = dma_item::type_id::create("item");
      m_dma_cfg.dma_if.do_monitor(item.addr, item.data, item.rnw);
      `uvm_info("MONITOR", $sformatf("Received %s [0x%0x] = 0x%0x",
				     (item.rnw?"RD":"WR"), item.addr, item.data), UVM_MEDIUM)
      ap.write(item);
    end
  endtask

endclass
