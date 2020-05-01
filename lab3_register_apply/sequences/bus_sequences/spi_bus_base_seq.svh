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
//

`ifndef spi_bus_base_seq_exists
`define spi_bus_base_seq_exists

//
// Base class that used by all the other sequences in the package.
// Gets the handle to the register model - spi_rm
// Contains the data & status fields used by most register access methods
//
class spi_bus_base_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(spi_bus_base_seq)

  // SPI Register model:
  spi_reg_block spi_rm;
  // SPI env configuration object (containing a register model handle)
  spi_env_config m_env_cfg;

  // Properties used by the various register access methods:
  rand uvm_reg_data_t data; // For passing data
  uvm_status_e aok;         // Returning access status

  function new(string name = "spi_bus_base_seq");
    super.new(name);
  endfunction

  // Common functionality:
  // Getting a handle to the register model
  virtual task body();
    if(!uvm_config_db #(spi_env_config)::get(null, get_full_name(), "spi_env_config", m_env_cfg)) begin
      `uvm_fatal("body", "Could not find spi_env_config")
    end
    spi_rm = m_env_cfg.spi_rm;
  endtask

endclass: spi_bus_base_seq

`endif
