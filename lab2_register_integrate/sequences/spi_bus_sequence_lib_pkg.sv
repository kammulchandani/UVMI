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
// This package contains the sequences targetting the bus
// interface of the SPI block - Not all are used by the test cases
//
// It uses the UVM register model
//
package spi_bus_sequence_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import spi_env_pkg::*;
import spi_reg_pkg::*;

typedef class spi_bus_base_seq;
typedef class data_load_seq;
typedef class data_unload_seq;
typedef class div_load_seq;
typedef class ctrl_set_seq;
typedef class ctrl_go_seq;
typedef class slave_select_seq;
typedef class slave_unselect_seq;
typedef class tfer_over_by_poll_seq;
typedef class spi_config_seq;
typedef class spi_config_rand_order_seq;
typedef class check_regs_seq;

`include "./bus_sequences/spi_bus_base_seq.svh"
`include "./bus_sequences/data_load_seq.svh"
`include "./bus_sequences/data_unload_seq.svh"
`include "./bus_sequences/div_load_seq.svh"
`include "./bus_sequences/ctrl_set_seq.svh"
`include "./bus_sequences/ctrl_go_seq.svh"
`include "./bus_sequences/slave_select_seq.svh"
`include "./bus_sequences/slave_unselect_seq.svh"
`include "./bus_sequences/tfer_over_by_poll_seq.svh"
`include "./bus_sequences/spi_config_seq.svh"
`include "./bus_sequences/spi_config_rand_order_seq.svh"
`include "./bus_sequences/check_regs_seq.svh"

endpackage: spi_bus_sequence_lib_pkg
