/***********************************************************************
 * UVM test class that runs a UVM register sequence,
 * specified on the command line for UVM Intermediate lab 1
 *
 * Run the predefined UVM hw_reset sequence:
 * % vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=uvm_reg_hw_reset_seq  ...
 *
 * Run the lab dma_seq_xfr sequence:
 * % vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_xfr  ...
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


class dma_test_uvm_seq extends dma_test_base;
  `uvm_component_utils(dma_test_uvm_seq)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  string argval, switch_name = "+uvm_seq=";

  virtual function void build_phase(uvm_phase phase);
    // Fetch the sequence name from the command line
    if (uvm_cmdline_proc.get_arg_value(switch_name, argval)) begin
      `uvm_info(get_type_name(), {"Running sequence ", argval}, UVM_MEDIUM)
    end
    else begin
      `uvm_fatal("NOSEQ", {"No sequence named with command line switch ", switch_name})
    end
  endfunction


  virtual task run_phase(uvm_phase phase);
    dma_seq_base seq_base;
    uvm_reg_sequence #(uvm_sequence #(uvm_reg_item)) seq;  // Base sequence handle
    uvm_factory m_factory = uvm_factory::get();            // Factory handle

    $cast(seq, m_factory.create_object_by_name(argval, "", "seq") );
    if (seq == null)
      `uvm_fatal("NOSEQ", {"Unable to create sequence ", argval})


    phase.raise_objection(this, get_full_name());
    seq.model = dma_rm;		// Specific to predefined UVM register sequences

    // Run DMA sequences with init_start(), and UVM sequences with just start()
    if ($cast(seq_base, seq)) begin
      seq_base.init_start(dma_agt_cfg);
    end
    else
      seq.start(null);
    phase.drop_objection(this, get_full_name());
  endtask

endclass
