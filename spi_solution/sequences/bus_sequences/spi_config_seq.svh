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

`ifndef spi_config_seq_exists
`define spi_config_seq_exists

//
// Sequence to configure the SPI randomly
//
class spi_config_seq extends spi_bus_base_seq;
  `uvm_object_utils(spi_config_seq)

  function new(string name = "spi_config_seq");
    super.new(name);
  endfunction

  bit interrupt_enable;

  virtual task body();
    super.body();

    // Randomize the register model to get a new config
    // Constraining the generated value within ranges
    if(!spi_rm.randomize() with {spi_rm.ctrl_reg.go_bsy.value == 0;
				 spi_rm.ctrl_reg.ie.value == interrupt_enable;
				 spi_rm.ss_reg.cs.value != 0;
				 spi_rm.ctrl_reg.char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};
				 spi_rm.divider_reg.ratio.value inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};
				 }) begin
      `uvm_fatal("body", "spi_rm randomization failure")
    end
    // This will write the generated values to the HW registers
    spi_rm.update(aok, .path(UVM_FRONTDOOR), .parent(this));
    data = spi_rm.ctrl_reg.get();
  endtask

endclass: spi_config_seq

`endif
