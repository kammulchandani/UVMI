/***********************************************************************
 * UVM agent class for UVM Intermediate lab 1 DMA
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

class dma_agent extends uvm_agent;
  `uvm_component_utils(dma_agent)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  dma_driver drv;
  dma_monitor mon;
  uvm_sequencer #(dma_item) sqr;
  dma_agent_config m_dma_cfg;
  uvm_analysis_port #(dma_item) ap;


  virtual function void set_config(input dma_agent_config m_dma_cfg);
    this.m_dma_cfg = m_dma_cfg;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (! m_dma_cfg) `uvm_fatal("DMA_AGENT", "No dma_agent_config set")

    ap = new("ap", this);
    mon = dma_monitor::type_id::create("mon", this);
    mon.set_config(m_dma_cfg);

    // Active agents have drivers and sequencers
    if (m_dma_cfg.active == UVM_ACTIVE) begin
      drv = dma_driver::type_id::create("drv", this);
      sqr = new("sqr", this);
      drv.set_config(m_dma_cfg);
      m_dma_cfg.sqr = sqr;
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    // Connect the sequencer and driver TLM port
    if (m_dma_cfg.active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end

    // Connect the monitor TLM analysis port to the outside world
    mon.ap.connect(ap);
  endfunction


endclass
