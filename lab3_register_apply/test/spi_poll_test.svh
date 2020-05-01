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

`ifndef spi_poll_test_exists
`define spi_poll_test_exists

//
// Class Description:
//
// Test class to run the config_polling_vseq virtual sequence
//

class spi_poll_test extends spi_test_base;
`uvm_component_utils(spi_poll_test)

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "spi_poll_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);

endclass: spi_poll_test

function spi_poll_test::new(string name = "spi_poll_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void spi_poll_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase

task spi_poll_test::main_phase(uvm_phase phase);

  config_polling_vseq t_seq = config_polling_vseq::type_id::create("t_seq");
  phase.phase_done.set_drain_time(this, 100);  // delay objection drop 100ns

  phase.raise_objection(this, "Test Started");
  t_seq.init_start(m_apb_cfg.apb_sqr, m_spi_cfg.spi_sqr, null, m_env_cfg );
  phase.drop_objection(this, "Test Finished");

endtask: main_phase

`endif
