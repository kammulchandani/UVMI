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


`ifndef reg_test_vseq_exists
`define reg_test_vseq_exists

//
// Register test:
//
// Checks the reset values
// Does a randomized read/write bit test using the front door
// Repeats the read/write bit test using the back door (not necessary, but as an illustration)
//
class reg_test_vseq extends spi_vseq_base;
  `uvm_object_utils(reg_test_vseq)

  function new(string name = "reg_test_vseq");
    super.new(name);
  endfunction

  virtual task body();
    check_regs_seq reg_seq = check_regs_seq::type_id::create("reg_seq");

    super.body();
    reg_seq.start(apb_sqr);
  endtask

endclass: reg_test_vseq
`endif
