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

`ifndef div_load_seq_exists
`define div_load_seq_exists

//
// Div load sequence - loads one of the target
//                     divisor values
//
class div_load_seq extends spi_bus_base_seq;

  `uvm_object_utils(div_load_seq)

  function new(string name = "div_load_seq");
    super.new(name);
  endfunction

  // Interesting divisor values:
  constraint div_values {data[15:0] inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};}

  virtual task body();
    super.body();
    // Randomize the local data value
    if(!this.randomize()) begin
      `uvm_fatal("body", "Randomization error for this")
    end
    // Write to the divider register
    spi_rm.divider_reg.write(aok, data, .parent(this));
  endtask

endclass: div_load_seq

`endif
