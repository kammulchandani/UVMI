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

`ifndef spi_vseq_base_exists
`define spi_vseq_base_exists

//
// Base class for virtual sequences
//
class spi_vseq_base extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(spi_vseq_base)

  function new(string name = "spi_vseq_base");
    super.new(name);
  endfunction

  // Virtual sequencer handles
  uvm_sequencer #(apb_seq_item) apb_sqr;
  uvm_sequencer #(spi_seq_item) spi_sqr;

  // Handle for env configs to get to interrupt line and sequencer handles
  spi_env_config m_spi_cfg;

  // This set up is required for child sequences to run
  virtual task body();
    `uvm_info("TOP_SEQ", $sformatf("Virtual sequence: %s", get_full_name()), UVM_MEDIUM)
  endtask

  
  virtual task init_start(input uvm_sequencer #(apb_seq_item) apb_sqr,
			  input uvm_sequencer #(spi_seq_item) spi_sqr,
			  input uvm_sequence parent_seq,
			  input spi_env_config s_env_cfg);
    this.apb_sqr = apb_sqr;
    this.spi_sqr = spi_sqr;
    m_spi_cfg = s_env_cfg;
    this.start(apb_sqr, parent_seq);
  endtask

endclass: spi_vseq_base

`endif
