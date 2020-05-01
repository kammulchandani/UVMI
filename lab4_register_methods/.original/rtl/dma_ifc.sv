/***********************************************************************
 * Signal interface and bus functional model for UVM Intermediate lab 1 DMA
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


interface dma_ifc;

  timeunit 1ns/1ns;

  import dma_pkg::*;

  //////////////////////////////////////////////////////////////////
  // Bus signals
  DMA_ADDR_T addr;
  DMA_DATA_T data;
  logic rnw, valid;


  //////////////////////////////////////////////////////////////////
  // Clock & reset logic
  logic clk, rstn;
  initial begin
    #5ns rstn = 0;
    #20ns rstn = 1;
  end

  initial begin
    clk <= 0;
    forever #10ns
      clk = !clk;
  end

  always @(negedge rstn) begin
    addr <= 0;
    data <= 0;
    valid <= 0;
    rnw <= 0;
  end

  // BFM task that should be called at the start of every top-level sequence, or driver
  task automatic wait_for_reset(input bit verbose);
    @(posedge clk);
    wait (rstn === 1);
    @(posedge clk);
    if (verbose)
      $display("@%t: %m completed", $realtime); // Probably called by driver
    else
      #0ns; // Wait for reset to end in that driver thread
  endtask


  //////////////////////////////////////////////////////////////////
  // Send out a transaction
  task automatic do_transfer(input DMA_ADDR_T taddr,
			     inout DMA_DATA_T tdata,
			     input bit trnw);
    // Wait for reset to complete
    wait (rstn === 1);

    if (trnw) begin
	$display("@%t: %m read addr=0x%0x %s", $realtime, taddr, addr2str[taddr]);
	@(negedge clk);
	rnw <= trnw;
	addr <= taddr;
	valid <= 1;
	@(negedge clk);
	tdata = data;
	valid <= 0;
	$display("@%t: %m read data=0x%x", $realtime, tdata);
      end
    else begin
	$display("@%t: %m write addr=0x%0x %s, data=0x%x", $realtime, taddr, addr2str[taddr], tdata);
	@(negedge clk);
	rnw <= trnw;
	addr <= taddr;
	data <= tdata;
	valid <= 1;
	@(negedge clk);
	valid <= 0;
      end
  endtask : do_transfer



  //////////////////////////////////////////////////////////////////
  // Wait for a transaction, from the RTL point of view
  task automatic do_monitor(output DMA_ADDR_T taddr,
			    output DMA_DATA_T tdata,
			    output bit trnw);
    // Wait for reset to complete
    wait (rstn === 1);

    // Wait for valid transaction
    do @(posedge clk);
    while (valid !==1);

    #1ns; // Delay to get the latest values from the DUT
    taddr = addr;
    trnw = rnw;
    tdata = data; // Sample outgoing write data
   endtask : do_monitor

endinterface : dma_ifc
