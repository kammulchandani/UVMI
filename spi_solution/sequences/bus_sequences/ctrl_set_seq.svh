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

`ifndef ctrl_set_seq_exists
`define ctrl_set_seq_exists

//
// Ctrl set sequence - loads one control params
//                     but does not set the go bit
//
class ctrl_set_seq extends spi_bus_base_seq;

  `uvm_object_utils(ctrl_set_seq)

  function new(string name = "ctrl_set_seq");
    super.new(name);
  endfunction

  // Controls whether interrupts are enabled or not
  bit int_enable = 0;

  virtual task body();
    super.body();
    // Constrain to interesting data length values
    if(!spi_rm.ctrl_reg.randomize() with {char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};}) begin
      `uvm_fatal("body", "Control register randomization failed")
    end
    // Set up interrupt enable
    spi_rm.ctrl_reg.ie.set(int_enable);
    // Don't set the go_bsy bit
    spi_rm.ctrl_reg.go_bsy.set(0);
    // Write the new value to the control register
    spi_rm.ctrl_reg.update(aok, .path(UVM_FRONTDOOR), .parent(this));
    // Get a copy of the register value for the SPI agent
    data = spi_rm.ctrl_reg.get();
  endtask

endclass: ctrl_set_seq

`endif
