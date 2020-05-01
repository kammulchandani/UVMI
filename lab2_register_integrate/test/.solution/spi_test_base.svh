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

`ifndef spi_test_base_exists
`define spi_test_base_exists

//
// Class Description:
//
// Base test class for SPI tests
//
class spi_test_base extends uvm_test;
  `uvm_component_utils(spi_test_base)

  //------------------------------------------
  // Data Members
  //------------------------------------------

  //------------------------------------------
  // Component Members
  //------------------------------------------
  // The environment class
  spi_env m_env;
  // Configuration objects
  spi_env_config m_env_cfg;
  apb_agent_config m_apb_cfg;
  spi_agent_config m_spi_cfg;
  // Register model

  // LAB 2 ASSIGNMENT, STEP 3a: Declare the register model
  // Declare the handle spi_rm for the register model top block class
  // Check the register model for class name
  // (Lab continues below)
  //****** INSERT LAB CODE HERE
//BEGIN SOLUTION
  spi_reg_block spi_rm;
//END SOLUTION

  //**********END LAB INSERT***************



  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function void configure_apb_agent(apb_agent_config cfg);
  // Standard UVM Methods:
  extern function new(string name = "spi_test_base", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);

endclass: spi_test_base

function spi_test_base::new(string name = "spi_test_base", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void spi_test_base::build_phase(uvm_phase phase);
  // env configuration
  m_env_cfg = spi_env_config::type_id::create("m_env_cfg");

  // Register model initialization

  // LAB 2 ASSIGNMENT, STEP 3b: Build the register model
  // 1) Enable all types of coverage available in the register model by calling
  //    the static method include_coverage("*", UVM_CVR_ALL) in the uvm_reg class.
  // 2) Create the register model. Does the constructor have one argument or two?
  // 3) Build & configure the register model.
  // 4) Add a handle to the environment config object. Check spi_env_config for
  // the handle name.
  //****** INSERT LAB CODE HERE
//BEGIN SOLUTION
  // Enable all types of coverage available in the register model
  uvm_reg::include_coverage("*", UVM_CVR_ALL);

  // Create the register model:
  spi_rm = spi_reg_block::type_id::create("spi_rm");

  // Build and configure the register model
  spi_rm.build();

  // Assign a handle to the register model in the env config object
  m_env_cfg.spi_rm = spi_rm;

//END SOLUTION

  //**********END LAB INSERT***************


  // APB configuration
  m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg");
  configure_apb_agent(m_apb_cfg);
  if(!uvm_config_db #(virtual apb_if)::get(this, "", "APB_vif", m_apb_cfg.APB)) begin
    `uvm_fatal("RESOURCE_ERROR", "APB virtual interface not found")
  end
  m_env_cfg.m_apb_agent_cfg = m_apb_cfg;

  // The SPI does not have a configure method
  m_spi_cfg = spi_agent_config::type_id::create("m_spi_cfg");
  if(!uvm_config_db #(virtual spi_if)::get(this, "", "SPI_vif", m_spi_cfg.SPI)) begin
    `uvm_fatal("RESOURCE_ERROR", "SPI virtual interface not found")
  end
  m_spi_cfg.has_functional_coverage = 0;
  m_env_cfg.m_spi_agent_cfg = m_spi_cfg;

  // Insert the interrupt virtual interface into the env_config:
  if(!uvm_config_db #(virtual intr_if)::get(this, "", "INTR_vif", m_env_cfg.INTR)) begin
    `uvm_fatal("RESOURCE_ERROR", "INTR virtual interface not found")
  end

  // Set the spi env config object in the DB and config object
  uvm_config_db #(spi_env_config)::set(this, "*", "spi_env_config", m_env_cfg);
  m_env = spi_env::type_id::create("m_env", this);
endfunction: build_phase


//
// Convenience function to configure the apb agent
//
// This can be overloaded by extensions to this test base class
function void spi_test_base::configure_apb_agent(apb_agent_config cfg);
  cfg.active = UVM_ACTIVE;
  cfg.has_functional_coverage = 0;
  cfg.has_scoreboard = 0;
  // SPI is on select line 0 for address range 0-18h
  cfg.no_select_lines = 1;
  cfg.start_address[0] = 32'h0;
  cfg.range[0] = 32'h18;
endfunction: configure_apb_agent
`endif
