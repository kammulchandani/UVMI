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

`ifndef config_interrupt_vseq_exists
`define config_interrupt_vseq_exists


//
// This virtual sequence does SPI transfers with randomized config
// and tests the interrupt handling
//
class config_interrupt_vseq extends spi_vseq_base;

`uvm_object_utils(config_interrupt_vseq)

logic[31:0] control;

function new(string name = "config_interrupt_test");
  super.new(name);
endfunction

task body();
  // Sequences to be used
  ctrl_go_seq go = ctrl_go_seq::type_id::create("go");
  spi_config_rand_order_seq spi_config = spi_config_rand_order_seq::type_id::create("spi_config");
  tfer_over_by_poll_seq wait_unload = tfer_over_by_poll_seq::type_id::create("wait_unload");
  spi_tfer_seq spi_transfer = spi_tfer_seq::type_id::create("spi_transfer");

  super.body();

  control = 0;

  repeat(10) begin
    spi_config.interrupt_enable = 1;
    spi_config.start(apb_sqr);
    control = spi_config.data;
    go.start(apb_sqr);
    fork
      begin
        m_spi_cfg.wait_for_interrupt;
        wait_unload.start(apb_sqr);
        if(!m_spi_cfg.is_interrupt_cleared()) begin
          `uvm_error("INT_ERROR", "Interrupt not cleared by register read/write");
        end
      end
      begin
        spi_transfer.BITS = control[6:0];
        spi_transfer.rx_edge = control[9];
        spi_transfer.start(spi_sqr);
      end
    join
  end
endtask

endclass: config_interrupt_vseq

`endif
