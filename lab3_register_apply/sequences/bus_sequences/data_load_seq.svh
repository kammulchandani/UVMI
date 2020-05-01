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

`ifndef data_load_seq_exists
`define data_load_seq_exists

//
// Data load sequence:
//
// load all rxtx locations with
// random data in a random order
//
class data_load_seq extends spi_bus_base_seq;

  `uvm_object_utils(data_load_seq)

  function new(string name = "data_load_seq");
    super.new(name);
  endfunction

  uvm_reg data_regs[]; // Array of registers


  virtual task body();
    super.body();
    // Set up the data register handle array
    data_regs = '{spi_rm.rxtx0_reg, spi_rm.rxtx1_reg, spi_rm.rxtx2_reg, spi_rm.rxtx3_reg};
    // Randomize order
    data_regs.shuffle();
    foreach(data_regs[i]) begin
      // Randomize register content and then update
      if(!data_regs[i].randomize()) begin
	`uvm_fatal("body", $sformatf("Randomization error for data_regs[%0d]", i))
      end
      data_regs[i].update(aok, .path(UVM_FRONTDOOR), .parent(this));
    end

  endtask

endclass: data_load_seq

`endif
