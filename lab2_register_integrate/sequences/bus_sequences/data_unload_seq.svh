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

`ifndef data_unload_seq_exists
`define data_unload_seq_exists

//
// Data unload sequence - reads back the data rx registers
// all of them in a random order
//
class data_unload_seq extends spi_bus_base_seq;

  `uvm_object_utils(data_unload_seq)

  uvm_reg data_regs[];

  function new(string name = "data_unload_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    // Set up the data register handle array
    data_regs = '{spi_rm.rxtx0_reg, spi_rm.rxtx1_reg, spi_rm.rxtx2_reg, spi_rm.rxtx3_reg};
    // Randomize access order
    data_regs.shuffle();
    // Use mirror in order to check that the value read back is as expected
    foreach(data_regs[i]) begin
      data_regs[i].mirror(aok, UVM_CHECK, .parent(this));
    end
  endtask

endclass: data_unload_seq

`endif
