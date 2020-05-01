/***********************************************************************
 * UVM Register Adapter for UVM Intermediate lab 1 DMA
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

class dma_adapter extends uvm_reg_adapter;
  `uvm_object_utils(dma_adapter)
  function new(string name = "dma_adapter");
    super.new(name);
  endfunction

  // Convert from a UVM reg struct to a DMA sequence item
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    dma_item item;
    item = dma_item::type_id::create("item");
    item.rnw  = (rw.kind == UVM_READ) || (rw.kind == UVM_BURST_READ);
    item.addr = rw.addr;
    item.data = rw.data;
    return item;
  endfunction

  // Convert from a DMA sequence item to a UVM reg struct
  virtual function void bus2reg(input uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    dma_item item;

    if (!$cast(item, bus_item)) begin
      `uvm_fatal("NOT_ITEM_TYPE","Provided bus_item is wrong type")
    end
    rw.kind = item.rnw ? UVM_READ : UVM_WRITE;
    rw.addr = item.addr;
    rw.data = item.data;
    rw.status = UVM_IS_OK;
  endfunction

endclass : dma_adapter
