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
//

`ifndef ctrl_go_seq_exists
`define ctrl_go_seq_exists

//
// Ctrl go sequence - sets the transfer in motion
//                    uses previously set control value
//
class ctrl_go_seq extends spi_bus_base_seq;

  `uvm_object_utils(ctrl_go_seq)

  function new(string name = "ctrl_go_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    // Set the go_bsy bit and go!
    spi_rm.ctrl_reg.go_bsy.set(1);
    spi_rm.ctrl_reg.update(aok, .path(UVM_FRONTDOOR), .parent(this));
  endtask

endclass: ctrl_go_seq

`endif
