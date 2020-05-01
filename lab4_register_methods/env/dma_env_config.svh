/***********************************************************************
 * Environment configuration class for UVM Intermediate lab 1 DMA
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


class dma_env_config extends uvm_object;
  `uvm_object_utils(dma_env_config)
  function new(string name="dma_env_config");
    super.new(name);
  endfunction

  dma_agent_config dma_agt_cfg;	    // Agent-level config object
  top_block top_rm;		    // Top register model handle
  dma_block dma_rm;		    // DMA register model

  virtual function void init_config(input dma_agent_config dma_agt_cfg,
				    input top_block top_rm,
				    input dma_block dma_rm);
    this.dma_agt_cfg = dma_agt_cfg;
    this.top_rm = top_rm;
    this.dma_rm = dma_rm;
  endfunction

endclass
