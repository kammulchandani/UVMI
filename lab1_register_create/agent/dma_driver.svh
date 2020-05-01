/***********************************************************************
 * UVM driver class for UVM Intermediate lab 1 DMA
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

class dma_driver extends uvm_driver #(dma_item);
  `uvm_component_utils(dma_driver);
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  dma_agent_config m_dma_cfg;


  virtual function void set_config(input dma_agent_config m_dma_cfg);
    this.m_dma_cfg = m_dma_cfg;
  endfunction


  virtual function void build_phase(uvm_phase phase);
    if (! m_dma_cfg) `uvm_fatal("DRIVER", "dma_agent_config was not set")
  endfunction


  virtual task run_phase(uvm_phase phase);
    dma_item req, rsp;

    m_dma_cfg.dma_if.wait_for_reset(.verbose(1));

    forever begin
      seq_item_port.get_next_item(req);
      // Driver can send a separate response object or shared
      if (m_dma_cfg.provides_responses) begin
	rsp = dma_item::type_id::create("rsp");	// Create response obj
	rsp.set_id_info(req);			// Copy ID info
	rsp.addr = req.addr;			// Copy other fields
	rsp.data = req.data;
	rsp.rnw  = req.rnw;
	m_dma_cfg.dma_if.do_transfer(rsp.addr, rsp.data, rsp.rnw);
	seq_item_port.item_done(rsp);		// Return response obj
      end
      else begin				// Shared transacton obj
	m_dma_cfg.dma_if.do_transfer(req.addr, req.data, req.rnw);
	seq_item_port.item_done();
      end
    end
   endtask

endclass
