/***********************************************************************
 * UVM sequence item class for UVM Intermediate lab 1 DMA
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

class dma_item extends uvm_sequence_item;
  function new(string name="dma_item");
    super.new(name);
  endfunction

  rand uvm_reg_addr_t addr;
  rand uvm_reg_data_t data;
  rand bit rnw;

  // This transaction is so simple, just use field macros, instead of do_*() methods
  `uvm_object_utils_begin(dma_item)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(rnw,  UVM_ALL_ON)
  `uvm_object_utils_end
endclass
