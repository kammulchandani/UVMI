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

`ifndef slave_select_seq_exists
`define slave_select_seq_exists

// Slave Select setup sequence
//
// Random values set for slave select
//
class slave_select_seq extends spi_bus_base_seq;

  `uvm_object_utils(slave_select_seq)

  function new(string name = "slave_select_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    if(!spi_rm.ss_reg.randomize() with {cs.value != 8'h0;}) begin
      `uvm_fatal("body", "Randomization failure for ss_reg")
    end
    spi_rm.update(aok, .path(UVM_FRONTDOOR), .parent(this));
  endtask

endclass: slave_select_seq

`endif
