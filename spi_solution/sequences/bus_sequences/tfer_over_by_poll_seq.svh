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

`ifndef tfer_over_by_poll_seq_exists
`define tfer_over_by_poll_seq_exists

//
// Transfer complete by polling sequence
//
// Does successive reads from the control register
// to determine when the transfer has completed
//
class tfer_over_by_poll_seq extends spi_bus_base_seq;
  `uvm_object_utils(tfer_over_by_poll_seq)

  function new(string name = "tfer_over_by_poll_seq");
    super.new(name);
  endfunction

  virtual task body();
    data_unload_seq empty_buffer;
    slave_unselect_seq ss_deselect;

    super.body();

    // Poll the GO_BSY bit in the control register
    while(spi_rm.ctrl_reg.go_bsy.value[0] == 1) begin
      spi_rm.ctrl_reg.read(aok, data, .parent(this));
    end
    ss_deselect = slave_unselect_seq::type_id::create("ss_deselect");
    ss_deselect.start(get_sequencer());
    empty_buffer = data_unload_seq::type_id::create("empty_buffer");
    empty_buffer.start(get_sequencer());
  endtask

endclass: tfer_over_by_poll_seq

`endif
