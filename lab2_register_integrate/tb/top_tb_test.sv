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

module top_tb_test;

`include "timescale.v"

import uvm_pkg::*;
import spi_test_lib_pkg::*;


// UVM initial block:
// Put virtual interfaces into the resource db & run_test()
initial begin
  uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "APB_vif", top_tb_rtl.APB);
  uvm_config_db #(virtual spi_if)::set(null, "uvm_test_top", "SPI_vif", top_tb_rtl.SPI);
  uvm_config_db #(virtual intr_if)::set(null, "uvm_test_top", "INTR_vif", top_tb_rtl.INTR);
  run_test();
end

endmodule: top_tb_test
