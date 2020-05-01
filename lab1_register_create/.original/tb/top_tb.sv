/***********************************************************************
 * Top level testbench module for UVM Intermediate lab 1 DMA
 ***********************************************************************
 * Copyright 2019 Mentor Graphics Corporation
 * All Rights Reserved Worldwide
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.  See the License for the specific language governing
 * permissions and limitations under the License.
 **********************************************************************/


module top_tb;
  timeunit 1ns; timeprecision 1ns;

  import uvm_pkg::*;      // Import the UVM base class library
  import dma_pkg::*;      // Import the DUT definitions
  import dma_tb_pkg::*;   // Import the UVM testbench classes

  initial begin
    // Start the test, name passed in with 'vsim +UVM_TESTNAME=lab_test_foo ...'
    run_test();
  end

endmodule
