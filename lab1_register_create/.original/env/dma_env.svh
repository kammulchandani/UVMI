/***********************************************************************
 * UVM environment class for UVM Intermediate lab 1 DMA
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

class dma_env extends uvm_env;
  `uvm_component_utils(dma_env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  dma_agent agt;
  dma_env_config m_dma_cfg;
  dma_adapter adapter;
  uvm_reg_predictor #(dma_item) predictor;

  virtual function void set_config(input dma_env_config env_cfg);
    this.m_dma_cfg = env_cfg;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (! m_dma_cfg) `uvm_fatal("ENV_CFG", "env_cfg was not set")

    agt = dma_agent::type_id::create("agt", this);
    agt.set_config(m_dma_cfg.dma_agt_cfg);

    adapter   = dma_adapter::type_id::create("adapter");
    predictor = new("predictor", this);
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    // Set adapter properties
    adapter.provides_responses   = 0; // Default: shared transaction
    adapter.supports_byte_enable = 0; // Default: does not support byte enables

    // Set map's sequencer and adapter for the top register model
    m_dma_cfg.top_rm.top_map.set_sequencer(m_dma_cfg.dma_agt_cfg.sqr, adapter);

    // Register prediction - explicit (default value)
    m_dma_cfg.top_rm.top_map.set_auto_predict(0);

    // Set the predictor map & adapter
    predictor.map = m_dma_cfg.top_rm.top_map;
    predictor.adapter = adapter;

    // Connect the predictor to the bus agent monitor analysis port
    agt.ap.connect(predictor.bus_in);

    // TBD: Connect the scoreboard and coverage collector - not yet implemented

   endfunction : connect_phase

endclass
