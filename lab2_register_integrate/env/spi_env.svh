//------------------------------------------------------------
//   Copyright 2010-2019 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------

`ifndef spi_env_exists
`define spi_env_exists

//
// Class Description:
//
// SPI environment class. This can contain both SPI and APB agents.
//
class spi_env extends uvm_env;
  `uvm_component_utils(spi_env)

  //------------------------------------------
  // Data Members
  //------------------------------------------
  apb_agent m_apb_agent;
  spi_agent m_spi_agent;
  spi_env_config m_env_cfg;
  spi_reg_functional_coverage m_func_cov_monitor;
  spi_scoreboard m_scoreboard;

  // LAB 2 ASSIGNMENT, STEP 3c: Declare adapter & predictor handles
  // 1) Declare the following handles:
  // a) "adapter" of the type: reg2apb_adapter
  // b) "predictor" of the type: uvm_reg_predictor #(apb_seq_item)
  // c) "spi_rm" for the register model
  // (Lab continues below)
  //****** INSERT LAB CODE HERE
  
  // Register layering adapter:
  reg2apb_adapter                     adapter;

  // Register predictor:
  uvm_reg_predictor  #(apb_seq_item)  predictor; 

  //Local register model handle 
  spi_reg_block                       spi_rm;

  //**********END LAB INSERT***************


  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "spi_env", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : spi_env

function spi_env::new(string name = "spi_env", uvm_component parent = null);
  super.new(name, parent);
endfunction


function void spi_env::build_phase(uvm_phase phase);
  if(!uvm_config_db #(spi_env_config)::get(this, "", "spi_env_config", m_env_cfg)) begin
    `uvm_fatal("build_phase", "Failed to find spi_env_config")
  end
  spi_rm        = m_env_cfg.spi_rm;

  if(m_env_cfg.has_apb_agent) begin
    uvm_config_db #(apb_agent_config)::set(this, "m_apb_agent*", "apb_agent_config", m_env_cfg.m_apb_agent_cfg);
    m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);

    // LAB 2 ASSIGNMENT, STEP 3c: Create adapter & predictor
    // Build the register model predictor and adapter objects, and get rm handle
    // 1) Create the predictor and adapter objects based on the above declarations
    // 2) Set the local register model handle from the handle in the env config object
    // (Lab continues below)
    //****** INSERT LAB CODE HERE
    
    adapter       = reg2apb_adapter::type_id::create("adapter",this);
    predictor     = uvm_reg_predictor #(apb_seq_item)::type_id::create("predictor", this);
    //**********END LAB INSERT***************

  end
  if(m_env_cfg.has_spi_agent) begin
    uvm_config_db #(spi_agent_config)::set(this, "m_spi_agent*", "spi_agent_config", m_env_cfg.m_spi_agent_cfg);
    m_spi_agent = spi_agent::type_id::create("m_spi_agent", this);
  end
  if(m_env_cfg.has_spi_functional_coverage) begin
    m_func_cov_monitor = spi_reg_functional_coverage::type_id::create("m_func_cov_monitor", this);
  end
  if(m_env_cfg.has_spi_scoreboard) begin
    m_scoreboard = spi_scoreboard::type_id::create("m_scoreboard", this);
  end
endfunction:build_phase


function void spi_env::connect_phase(uvm_phase phase);
  //
  // Register sequencer layering code
  // This uses the default values for provides_responses and byte enable
  //
  // Only set up register sequencer layering if the top level
  if(spi_rm.get_parent() == null) begin
    // set up map sequencer and adapter handles using set_sequencer() method
    spi_rm.apb_map.set_sequencer(.sequencer(m_apb_agent.m_sqr), .adapter(adapter));
  end


  // LAB 2 ASSIGNMENT, STEP 3c: Register prediction
  // Set the model, adapter and predictor properties.  The sequencer is set above.
  // 1) Disable the register model's implicit-prediction
  //    In the spi_rm's APB map, call set_auto_predict with the default value of 0
  // 2) Set the map in the predictor to the default_map in spi_rm
  // 3) In the predictor, set the adapter handle to the local adapter
  // 4) Connect the predictor to the agent's analysis port, ap
  //    The apb_agent is the initiator, and the predictor.bus_in is the target
  //****** INSERT LAB CODE HERE
  
  // Set the predictor map:
  predictor.map         = spi_rm.apb_map;

  // Set the predictor adapter:
  predictor.adapter     = adapter ; 

  // Default is Explicit Prediction, not implicit (auto)
  spi_rm.apb_map.set_auto_predict(0); 

  // Connect the predictor to the bus agent monitor analysis port
  m_apb_agent.ap.connect(predictor.bus_in);
  
  //**********END LAB INSERT***************


  if(m_env_cfg.has_spi_functional_coverage) begin
    m_apb_agent.ap.connect(m_func_cov_monitor.analysis_export);
    m_func_cov_monitor.spi_rm = spi_rm;
  end
  if(m_env_cfg.has_spi_scoreboard) begin
    m_spi_agent.ap.connect(m_scoreboard.spi.analysis_export);
    m_scoreboard.spi_rm = spi_rm;
  end
  // Set up the agent sequencers as resources:
endfunction: connect_phase

`endif
