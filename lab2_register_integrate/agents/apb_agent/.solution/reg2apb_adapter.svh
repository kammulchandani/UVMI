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

    // LAB 2 ASSIGNMENT, STEP 3b: Translate struct to item
    // 1) Create the method that translates uvm_reg_bus_op structs to
    // apb_seq_item objects
    // a) Declare apb of type apb_seq_item and create an object
    // b) If rw.kind == UVM_READ, set apb.we to 0, otherwise 1
    // c) Copy the rw.data and addr to the apb object
    // d) Return the apb handle
    //****** INSERT LAB CODE HERE
//BEGIN SOLUTION

    // Declare an apb_seq_item handle, apb, and create an object
    apb_seq_item apb;
    apb = apb_seq_item::type_id::create("apb");

    // Set the we flag
    apb.we = (rw.kind == UVM_READ) ? 0 : 1;

    // Copy the addr and data properties from rw to apb
    apb.addr = rw.addr;
    apb.data = rw.data;
    return apb;
//END SOLUTION

    //**********END LAB INSERT***************

  endfunction: reg2bus


  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    // LAB 2 ASSIGNMENT, STEP 3b: Translate item to struct
    // Create the method that translates apb_seq_item objects
    // to uvm_reg_bus_op structs
    // a) Declare a handle apb of type apb_seq_item
    // b) Cast bus_item to apb and give a uvm_fatal() if this fails
    // c) If apb.we is true, set the rw.kind to UVM_WRITE, otherwise UVM_READ
    // d) Copy the apb.addr and data variables in the rw struct to apb.
    // e) Put the status UVM_IS_OK into the status field in rw
    //****** INSERT LAB CODE HERE
//BEGIN SOLUTION
    apb_seq_item apb;

    // Cast the incoming handle to apb type
    if (!$cast(apb, bus_item)) begin
      `uvm_fatal("NOT_APB_TYPE","Provided bus_item is wrong type")
    end

    // Set the kind field
    rw.kind = apb.we ? UVM_WRITE : UVM_READ;

    // Copy the addr and data properties from apb to rw
    rw.addr = apb.addr;
    rw.data = apb.data;

    // Set the struct status
    rw.status = UVM_IS_OK;

//END SOLUTION
    //**********END LAB INSERT***************

  endfunction: bus2reg

endclass: reg2apb_adapter

`endif
