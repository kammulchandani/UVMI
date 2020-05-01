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

  typedef uvm_reg_sequence #(uvm_sequence #(uvm_reg_item)) uvm_reg_seq_t;


  virtual function void build_phase(uvm_phase phase);
    uvm_reg_seq_t seq;
    dma_seq_base dma_seq;

    // Create the configuration
    super.build_phase(phase);

    // Optionally, run a build_phase DMA virtual sequence
    seq = get_arg_seq("+dma_build_seq=", "build_phase", 0);
    if (seq && $cast(dma_seq, seq)) begin
      dma_seq.build(dma_agt_cfg);
    end
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    uvm_reg_seq_t seq;
    dma_seq_base dma_seq;

    // Optionally, run a connect_phase DMA virtual sequence
    seq = get_arg_seq("+dma_connect_seq=", "connect_phase", 0);
    if (seq && $cast(dma_seq, seq)) begin
      dma_seq.connect(dma_agt_cfg);
    end
  endfunction


  virtual task run_phase(uvm_phase phase);
    uvm_reg_seq_t seq;  // Base sequence handle
    dma_seq_base dma_seq;

    seq = get_arg_seq("+uvm_seq=", "run_phase");

    phase.raise_objection(this, get_full_name());

    // Run DMA sequences with init_start(), and UVM sequences with just start()
    if ($cast(dma_seq, seq)) begin
      dma_seq.init_start(dma_agt_cfg);
    end
    else begin
      seq.model = dma_rm;		// Specific to predefined UVM register sequences
      seq.start(null);
    end
    phase.drop_objection(this, get_full_name());
  endtask


  // Function to get a sequence from a command line switch, and construct it
  virtual function uvm_reg_seq_t get_arg_seq(input string switch_name,
					     input string phase_name,
					     input bit required=1);
    string argval;
    static uvm_factory m_factory = uvm_factory::get();            // Factory handle

    // Fetch the sequence name from the command line
    if (uvm_cmdline_proc.get_arg_value(switch_name, argval)) begin
      `uvm_info(get_type_name(), {"Running ", phase_name, " sequence ", argval}, UVM_MEDIUM)
    end
    else begin
      if (required) begin
	`uvm_fatal("NOSEQ", {"No sequence named with command line switch ", switch_name})
      end
      else 
	return null;
    end

    // Create the named sequence
    if (! $cast(get_arg_seq, m_factory.create_object_by_name(argval, "", "seq")) || (get_arg_seq == null))
      `uvm_fatal("NOSEQ", {"Unable to create sequence ", argval})
  endfunction : get_arg_seq


endclass
