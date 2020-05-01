/***********************************************************************
 * Simple register sequence for UVM Intermediate lab 1 DMA
 * Tries various values, does not exercise the DMA engine
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_reg
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_reg ...
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


class dma_seq_reg extends dma_seq_base;
  `uvm_object_utils(dma_seq_reg)
  function new(string name="dma_seq_reg");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t exp, act;

    /////////////////////////////////////////////////////////////////////////////
    // W/R csr0 register front door
    // Since size0 is still 0, the DMA engine won't do anything
    exp = 1<<DMA_CSR_DONE;
    act = 'x;

    `uvm_info("REG", "csr0.write/read front door", UVM_MEDIUM)
    dma_rm.csr0.write(aok, 1<<DMA_CSR_GO, .parent(this));
    dma_rm.csr0.read(aok, act, .parent(this));

    if (exp === act) begin
      `uvm_info("SUCCESS_REG", "Simple WR/RD passed for csr0!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Simple WR/RD failed for csr0: expected data=0x%x, actual=0x%0x", exp, act))
    end


    ////////////////////////////////////////////////////////////////////
    // Skip this section as there is no field access in the DUT
    // // Try WO/RO fields
    // `uvm_info("REG", "Try reading a WO field: csr0.go", UVM_MEDIUM)
    // dma_rm.csr0.go.read(aok, act, .parent(this), .path(UVM_FRONTDOOR));

    // // Clear all fields before write - this is OK
    // dma_rm.csr0.write(aok, 0, .parent(this), .path(UVM_FRONTDOOR));

    // `uvm_info("REG", "Before writing a RO field: csr0.busy", UVM_MEDIUM)
    // dma_rm.csr0.busy.write(aok, 1, .parent(this), .path(UVM_FRONTDOOR));


    /////////////////////////////////////////////////////////////////////////////
    `uvm_info("REG", "size0.write/read frontdoor", UVM_MEDIUM)
    exp = 9;
    act = 'x;

    dma_rm.size0.write(aok, exp, .parent(this));
    dma_rm.size0.read(aok, act, .parent(this));

    if (exp === act) begin
      `uvm_info("SUCCESS_REG", "Simple WR/RD passed for size0!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Simple WR/RD failed for size0: expected data=0x%x, actual=0x%0x", exp, act))
    end


    /////////////////////////////////////////////////////////////////////////////
    `uvm_info("REG", "dst0.write/read front door", UVM_MEDIUM)
    exp = 777;
    act = 'x;

    dma_rm.dst0.write(aok, exp, .parent(this), .path(UVM_FRONTDOOR));
    dma_rm.dst0.read(aok, act, .parent(this), .path(UVM_FRONTDOOR));

    if (exp === act) begin
      `uvm_info("SUCCESS_REG", "Simple WR/RD passed for dst0 front door!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Simple WR/RD failed for dst0 front door: expected data=0x%x, actual=0x%0x", exp, act))
    end


    /////////////////////////////////////////////////////////////////////////////
    `uvm_info("REG", "dst0.write/read back door", UVM_MEDIUM)
    exp = 999;
    act = 'x;

    dma_rm.dst0.write(aok, exp, .parent(this), .path(UVM_BACKDOOR));
    dma_rm.dst0.read(aok, act, .parent(this), .path(UVM_BACKDOOR));

    if (exp === act) begin
      `uvm_info("SUCCESS_REG", "Simple WR/RD passed for dst0 back door!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Simple WR/RD failed for dst0 back door: expected data=0x%x, actual=0x%0x", exp, act))
    end



    /////////////////////////////////////////////////////////////////////////////
    `uvm_info("MEM", "mem0[5].write/read back door", UVM_MEDIUM)
    exp = 'hBEEF;
    act = 'x;

    top_rm.mem0.write(aok, 5, exp, UVM_BACKDOOR, .parent(this));
    top_rm.mem0.read(aok,  5, act, UVM_BACKDOOR, .parent(this));

    if (exp === act) begin
      `uvm_info("SUCCESS_MEM", "Simple WR/RD passed for mem[5]!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("MEM", $sformatf("Simple WR/RD failed for mem[5]: expected data=0x%x, actual=0x%0x", exp, act))
    end



    /////////////////////////////////////////////////////////////////////////////
    // Remember - backdoor ops take 0 simulation time
    `uvm_info("MEM", "mem0[4].write/read front door", UVM_MEDIUM)
    exp = 'hDEAD;
    act = 'x;

    top_rm.mem0.write(aok, 4, exp, .parent(this));
    top_rm.mem0.read(aok, 4, act, .parent(this));

    if (exp === act) begin
      `uvm_info("SUCCESS_MEM", "Simple WR/RD passed for mem[4]!", UVM_MEDIUM)
    end
    else begin
    `uvm_error("MEM", $sformatf("Simple WR/RD failed for mem[4]: expected data=0x%x, actual=0x%0x", exp, act))
    end


  endtask

endclass
