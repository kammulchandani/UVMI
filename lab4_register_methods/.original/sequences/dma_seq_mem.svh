/***********************************************************************
 * Register sequence for memory read / writes.  UVM Intermediate lab 4
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_mem
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_mem ...
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

class dma_seq_mem extends dma_seq_base;
  `uvm_object_utils(dma_seq_mem)
  function new(string name="dma_seq_mem");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t wdata[], rdata[];  // Dynamic array to receive values
    uvm_reg_data_t w, r, randy[DMA_MEM_SIZE_WORD];

    m_dma_cfg.wait_for_reset();

    // Start with some simple operations
    w = 16'h5A5A;
    top_rm.mem0.write(aok, 32'h8, w);
    top_rm.mem0.read(aok, 32'h8, r);
    `uvm_info(get_full_name(), $sformatf("mem[8] r=%0x w=%0x", r, w), UVM_MEDIUM)

    // Fill the write dynamic array with 6 words
    wdata = '{16'hF0F0, 16'hF1F1, 16'hF2F2, 16'hF3F3, 16'hF4F4, 16'hF5F5};

    // Burst write 6 values, starting at offset 0x1000
    top_rm.mem0.burst_write(aok, 32'h1000, wdata);

    // ... Later in the sequence
    rdata = new[4];
    // Burst read 4 locations into the array
    top_rm.mem0.burst_read(aok, 32'h1000, rdata);
    foreach (rdata[i]) begin
      if (rdata[i] != wdata[i]) begin
	`uvm_error(get_full_name(), $sformatf("Burst write[0x%0x]=0x%0x, != read 0x%0x", i, rdata[i], wdata[i]))
      end
    end

    // ... Later in the sequence
    rdata = new[4];
    // Burst read from 4 addresses into the array
    top_rm.mem0.burst_read(aok, 32'h14, rdata);
    foreach (rdata[i]) begin
      `uvm_info(get_full_name(), $sformatf("%0d: r=%0x w=%0x", i, rdata[i], wdata[i]), UVM_MEDIUM)
    end


    // Explore the boundaries, first with legal element
    w = 'hBEEF;
    top_rm.mem0.write(aok, DMA_MEM_SIZE_WORD-1, w, .parent(this));
    top_rm.mem0.read (aok, DMA_MEM_SIZE_WORD-1, r, .parent(this));
    if (r != w)
      `uvm_error("BOUNDS", $sformatf("Mismatch: Wrote 0x%0d to offset 0x%0x (%0d.), read back 0x%0x", w, DMA_MEM_SIZE_WORD-1, DMA_MEM_SIZE_WORD-1, r))


    // Go beyond the end of memory
    `uvm_info("!EXPECT_UVM_ERROR!", "!!!WRITE PAST END OF MEMORY - SHOULD CAUSE UVM_ERROR!!!\n\n", UVM_MEDIUM)
    top_rm.mem0.write(aok, DMA_MEM_SIZE_WORD, w, .parent(this));

    `uvm_info("!EXPECT_UVM_ERROR!", "!!!READ PAST END OF MEMORY - SHOULD CAUSE UVM_ERROR!!!\n\n", UVM_MEDIUM)
    top_rm.mem0.read (aok, DMA_MEM_SIZE_WORD, r, .parent(this));


    // Fill the memory with random values, then read back and check
    foreach (randy[i]) begin
      randy[i] = $urandom_range(DMA_MEM_SIZE_WORD-1);
      top_rm.mem0.write(aok, i, randy[i], .parent(this));
    end
    foreach (randy[i]) begin
      top_rm.mem0.read(aok, i, r, .parent(this));
      if (r != randy[i]) begin
	`uvm_error("RandMem", $sformatf("Wrote 0x%0d to offset 0x%0x (%0d.), read back 0x%0x",
				       randy[i], i, i, r))
      end
    end

  endtask

endclass : dma_seq_mem
