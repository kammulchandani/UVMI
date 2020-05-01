/***********************************************************************
 * Package for all the UVM testbench classes for UVM Intermediate lab 1 DMA
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


package dma_tb_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"
  import dma_pkg::*;		// RTL definitions

  import vreguvm_pkg_uvm::*;

`include "dma_item.svh"
`include "dma_agent_config.svh"
`include "dma_env_config.svh"
`include "dma_driver.svh"
`include "dma_monitor.svh"
`include "dma_agent.svh"
`include "dma_adapter.svh"
`include "dma_env.svh"
`include "dma_seq_base.svh"	// Must be first sequence
`include "dma_seq_check.svh"
`include "dma_seq_exp_cvr.svh"
`include "dma_seq_imp_cvr.svh"
`include "dma_seq_introspect.svh"
`include "dma_seq_rand.svh"
`include "dma_seq_reg.svh"
`include "dma_seq_xfr.svh"
`include "dma_test_base.svh"	// Must be first test
`include "dma_test_reg.svh"
`include "dma_test_xfr.svh"
`include "dma_test_uvm_hw_reset.svh"
`include "dma_test_uvm_seq.svh"
endpackage : dma_tb_pkg
