/***********************************************************************
 * Register sequence for a simple DMA transfer.  UVM Intermediate lab 1
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_xfr
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_xfr ...
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


class dma_seq_xfr extends dma_seq_base;
  `uvm_object_utils(dma_seq_xfr)
  function new(string name="dma_seq_xfr");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t csr,
      size = 8,
      src = 'h10,
      dst = 'h20,
      mem[DMA_MEM_SIZE_WORD];

    m_dma_cfg.wait_for_reset();

    // Initialize mem[i] = i for a big chunk, probably too much
    for (int addr=0; addr < (src + dst + size); addr = addr + 2) begin
      top_rm.mem0.write(.status(aok), 
		    .offset(addr/BYTES_PER_WORD), 
		    .value(addr), 
		    .parent(this), 
		    .path(UVM_BACKDOOR));
//      top_rm.mem0.write(aok, addr/BYTES_PER_WORD, addr, .parent(this));
      mem[addr/BYTES_PER_WORD] = addr;
    end 

    dma_rm.size0.write(aok, size, .parent(this));
    dma_rm.src0.write(aok,  src,  .parent(this));
    dma_rm.dst0.write(aok,  dst,  .parent(this));
    dma_rm.csr0.write(aok,  1<<DMA_CSR_GO, .parent(this));

    repeat (size + 2) begin
      dma_rm.csr0.read(aok, csr, .parent(this));
      if (csr[DMA_CSR_DONE])
	break;
    end

    // Check final CSR value
    if (csr != 1<<DMA_CSR_DONE)
      `uvm_error("CSR", $sformatf("Unexpected CSR value at end of xfer 0x%0x", csr))

    // Check final memory value
    for (int addr=0; addr < size; addr = addr + 2) begin
      uvm_reg_data_t r;      
      top_rm.mem0.read(.status(aok), 
		   .offset((dst + addr)/BYTES_PER_WORD), 
		   .value(r), 
		   .parent(this), 
		   .path(UVM_BACKDOOR));
      if (mem[(src + addr)/BYTES_PER_WORD] != r)
	`uvm_error("MEM", $sformatf("Memory mismatch @addr=0x%0x, expecting 0x%0x, actual 0x%0x",
				    addr, mem[src + addr/BYTES_PER_WORD], r))
    end 
    

  endtask

endclass : dma_seq_xfr
