/***********************************************************************
 * DMA Design Under Test for UVM Intermediate lab 1 DMA
 * Has registers and memory
 * DMA engine does word aligned transfers. not byte aligned
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


module dma_ctrl(dma_ifc dma_if);

  import dma_pkg::*;

  DMA_DATA_T
    inc0,			// Incrementing register
    src0,			// Source address
    dst0,			// Destination address
    size0,			// Size of transfer in words (not bytes)
    csr0,			// Command-status register
    mem0[DMA_MEM_SIZE_WORD],	// Memory
    src_int, dst_int,		// Source and destination addresses (internal)
    countdown;			// Countdown of transfers left (internal)

  always @(posedge dma_if.clk or negedge dma_if.rstn)
    begin
      if (! dma_if.rstn) begin
	// Reset all registers (not memory)
	inc0  <= '0;
	csr0  <= '0;
	size0 <= '0;
	src0  <= '1; // Reset bug!
	dst0  <= '0;
	src_int <= '0;
	dst_int <= '0;
	countdown <= '0;
      end
      else if (dma_if.valid) begin
	if (dma_if.rnw) begin
	  // Read a register
	  case (dma_if.addr)
	    DMA_INC_ADDR:  
	      begin  // Increment after read
		dma_if.data <= inc0; 
		inc0 <= inc0 + 1; 
	      end
	    DMA_SRC_ADDR:  dma_if.data <= src0;
	    DMA_DST_ADDR:  dma_if.data <= dst0;
	    DMA_SIZE_ADDR: dma_if.data <= size0;
	    DMA_CSR_ADDR:  dma_if.data <= csr0;
	    default:
	      begin
		if (dma_if.addr inside {[0:DMA_MEM_SIZE_BYTE]})
		  dma_if.data <= mem0[dma_if.addr/2];
		else
		  $error("%m write: out of bounds address 0x%0x", dma_if.addr);
	      end
	  endcase // case (dma_if.addr)
	end
	else begin
	  // Write to a register
	  case (dma_if.addr)
	    DMA_INC_ADDR:  inc0  <= dma_if.data;
	    DMA_SRC_ADDR:  src0  <= dma_if.data;
	    DMA_DST_ADDR:  dst0  <= dma_if.data;
	    DMA_SIZE_ADDR: size0 <= dma_if.data;
	    DMA_CSR_ADDR:  csr0  <= dma_if.data;
	    default:
	      begin
		if (dma_if.addr inside {[0:DMA_MEM_SIZE_BYTE]})
		  mem0[dma_if.addr/2] <= dma_if.data;
		else
		  $error("%m read: out of bounds address 0x%0x", dma_if.addr);
	      end
	  endcase // case (dma_if.addr)
	end
      end // if (rst) else
    end  // always


  /*******************************************************************
   Simple DMA state machine
   Performs mem-mem transfer here, not with a bus transfer
   If src0 or dst0 pointer goes past the end of memory, error!
   */
  typedef enum int {IDLE_D, COUNT_D} DMA_STATE_T;
  DMA_STATE_T state, next_state;

  always @(negedge dma_if.clk or negedge dma_if.rstn) begin
    if (! dma_if.rstn) begin
      next_state = IDLE_D;
    end
    else begin
      next_state = IDLE_D;
      case (state)

	IDLE_D: begin
	  // Go bit => start a transaction
	  if (csr0[DMA_CSR_GO]) begin
	    csr0[DMA_CSR_GO] <= '0;

	    // Skip zero-lenth transfers
	    if (size0 == '0) begin
	      csr0[DMA_CSR_DONE] <= '1;
	      csr0[DMA_CSR_BUSY] <= '0;
	      next_state = IDLE_D;
	    end
	    else begin
	      // Everything checks out, initialize internal regs
	      // Note that countdown does not start until the next cycle
	      countdown <= '0;
	      src_int <= src0;
	      dst_int <= dst0;
	      next_state = COUNT_D;
	    end
	  end // GO
	end // IDLE_D

	COUNT_D: begin
	  if (countdown == size0) begin
	    // It's the final countdown!
	    csr0[DMA_CSR_DONE] <= '1;
	    csr0[DMA_CSR_BUSY] <= '0;
	    next_state = IDLE_D;
	  end
	  else if ((dst_int >= DMA_MEM_SIZE_BYTE) || (src_int >= DMA_MEM_SIZE_BYTE)) begin
	    // Stop before doing an out of bounds access
	    csr0[DMA_CSR_ERROR] <= '1;
	    csr0[DMA_CSR_BUSY]  <= '0;
	    next_state = IDLE_D;
	  end

	  else begin
	    // Only perform word-aligned transfers, ignore the bytey-bit
	    mem0[dst_int/BYTES_PER_WORD] <= mem0[src_int/BYTES_PER_WORD];
	    dst_int   <= dst_int + BYTES_PER_WORD;
	    src_int   <= src_int + BYTES_PER_WORD;
	    countdown <= countdown + BYTES_PER_WORD;
	    next_state = COUNT_D;
	  end
	end // COUNT_D

	default:
	  $fatal("Unrecognized DMA state=0x%x", state);
      endcase // state
    end // if rst

    state = next_state;
  end // always

endmodule : dma_ctrl
