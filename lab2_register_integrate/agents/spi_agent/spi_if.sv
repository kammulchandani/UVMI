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
// Interface: spi_if
//
// Note signal bundle only
interface spi_if;
  import uvm_pkg::*;
  import spi_agent_pkg::spi_seq_item;



  logic clk;
  logic[7:0] cs;
  logic miso;
  logic mosi;

  //Methods for the monitor and driver

  //  Monitor methods.

  task automatic wait_cs_not_x(); 
    while(cs === 8'hxx) begin
      #1;
    end
  endtask: wait_cs_not_x

  task automatic monitor_spi(output spi_seq_item item); 
    // spi_seq_item item;
    int n;
    int p;

    item = spi_seq_item::type_id::create("item");

    while(cs === 8'hff) begin
      @(SPI.cs);
    end
    n = 0;
    p = 0;
    item.nedge_mosi = 0;
    item.pedge_mosi = 0;
    item.nedge_miso = 0;
    item.pedge_miso = 0;
    item.cs = cs;

    fork
      begin
        while(cs != 8'hff) begin
          @(clk);
          if(clk == 1) begin
            item.nedge_mosi[p] = mosi;
            item.nedge_miso[p] = miso;
            p++;
          end
          else begin
            item.pedge_mosi[n] = mosi;

            item.pedge_miso[n] = miso;
            n++;
          end
        end
      end
      begin
        @(clk);
        @(cs);
      end
    join_any
    disable fork;
  endtask: monitor_spi

  // Driver methods

  task automatic wait_initialize();
    miso <= 1; 
    while(cs === 8'hxx) begin
      #1;
    end
  endtask: wait_initialize

  task automatic send_txn(input spi_seq_item req); 
   int no_bits;
   while (cs == 8'hff) begin
      @(cs);
    end
    uvm_report_info("SPI_DRV_RUN:", $sformatf("Starting transmission: %0h RX_NEG State %b, no of bits %0d", req.spi_data, req.RX_NEG, req.no_bits), UVM_MEDIUM);
    no_bits = req.no_bits;
    if (no_bits == 0) begin
      no_bits = 128;
    end
    miso <= req.spi_data[0];
    for (int i = 1; i < no_bits-1; i++) begin
      if (req.RX_NEG == 1) begin
        @(posedge clk);
      end
      else begin
        @(negedge clk);
      end
      miso <= req.spi_data[i];
      if (cs == 8'hff) begin
        break;
      end
    end

  endtask: send_txn


endinterface: spi_if
