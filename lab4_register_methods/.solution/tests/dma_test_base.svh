/***********************************************************************
 * UVM base test class for UVM Intermediate lab 1 DMA
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


class dma_test_base extends uvm_test;
  `uvm_component_utils(dma_test_base)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  top_block top_rm;	    // Top register model
  dma_block dma_rm;	    // DMA register model
  dma_env env;
  dma_env_config env_cfg;
  dma_agent_config dma_agt_cfg;
  virtual dma_ifc dma_if;


  // Build the register model, env component, and the env & agent config objects
  virtual function void build_phase(uvm_phase phase);
    if (! uvm_config_db#(virtual dma_ifc)::get(this, "", "dma_if", dma_if))
      `uvm_fatal("NO_IFC", "No dma_ifc interface found")

    // Register model setup
    // Build top_rm - top_block, and dma_rm - dma_block
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    top_rm = top_block::type_id::create("top_rm");
    top_rm.build();
    dma_rm = top_rm.dma_rm;

    // Agent config object
    dma_agt_cfg = dma_agent_config::type_id::create("dma_agt_cfg");
    dma_agt_cfg.init_config(.dma_if(dma_if),
			    .top_rm(top_rm),
			    .provides_responses(0));

    // Environment config object
    env = dma_env::type_id::create("env", this);
    env_cfg = dma_env_config::type_id::create("env_cfg");
    env_cfg.init_config(dma_agt_cfg, top_rm, dma_rm);
    env.set_config(env_cfg);
  endfunction

endclass
