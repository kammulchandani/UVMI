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

`ifndef spi_monitor_exists
`define spi_monitor_exists

//
// Class Description:
//
// SPI monitor class
//
class spi_monitor extends uvm_component;
  `uvm_component_utils(spi_monitor);

  // Virtual Interface
  virtual spi_if SPI;

  //------------------------------------------
  // Data Members
  //------------------------------------------

  //------------------------------------------
  // Component Members
  //------------------------------------------
  uvm_analysis_port #(spi_seq_item) ap;

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:

  extern function new(string name = "spi_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass: spi_monitor

function spi_monitor::new(string name = "spi_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task spi_monitor::run_phase(uvm_phase phase);
  spi_seq_item txn_item;
  int n;
  int p;


  // do not start until cs is initialased.
  SPI.wait_cs_not_x();
  
  forever begin
    //txn_item = spi_seq_item::type_id::create("item");
    // pass transaction to interface method
    SPI.monitor_spi(txn_item);
    `uvm_info("MON_TXN", txn_item.convert2string(),UVM_DEBUG);
    ap.write(txn_item);
  end
endtask: run_phase

function void spi_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase

`endif
