//
// -------------------------------------------------------------
//    Copyright 2010-2019 Mentor Graphics Corporation
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------

`ifndef reg2apb_adapter_exists
`define reg2apb_adapter_exists

//
class reg2apb_adapter extends uvm_reg_adapter;

  `uvm_object_utils(reg2apb_adapter)

   function new(string name = "reg2apb_adapter");
      super.new(name);
 //     supports_byte_enable = 0;
 //     provides_responses = 1;
   endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_seq_item apb = apb_seq_item::type_id::create("apb");
    apb.addr = rw.addr;
    apb.data = rw.data;
    apb.we = (rw.kind == UVM_READ) ? 0 : 1;
    return apb;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    apb_seq_item apb;
    if (!$cast(apb, bus_item)) begin
      `uvm_fatal("NOT_APB_TYPE","Provided bus_item is wrong type")
    end
    rw.addr = apb.addr;
    rw.data = apb.data;
    rw.kind = apb.we ? UVM_WRITE : UVM_READ;
    rw.status = UVM_IS_OK;
  endfunction

endclass: reg2apb_adapter

`endif
