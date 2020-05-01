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

`ifndef apb_monitor_exists
`define apb_monitor_exists

//
// Class Description:
//
// Monitor class for the APB agent
//
class apb_monitor extends uvm_component;
  `uvm_component_utils(apb_monitor);

  // Virtual Interface
  virtual apb_if APB;

  //------------------------------------------
  // Data Members set by the apb agent based on the apb_agent_config
  //------------------------------------------
  int apb_index = 0; // Which PSEL line is this monitor connected to
  //------------------------------------------
  // Component Members
  //------------------------------------------
  uvm_analysis_port #(apb_seq_item) ap;

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:

  extern function new(string name = "apb_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass: apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task apb_monitor::run_phase(uvm_phase phase);
  apb_seq_item txn;

  forever begin
    // Detect the protocol event on the TBAI virtual interface
    APB.monitor_apb(apb_index, txn);

    // apb_if creates new transaction every time, no need to clone    
    if (txn != null) begin
      ap.write(txn);
    end
  end
endtask: run_phase

function void apb_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase

`endif
