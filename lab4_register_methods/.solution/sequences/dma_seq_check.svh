/***********************************************************************
 * Simple register sequence for UVM Intermediate lab 1 DMA
 * Try different checking schemes such as r/w, predict/mirror
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_check
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


class dma_seq_check extends dma_seq_base;
  `uvm_object_utils(dma_seq_check)
  function new(string name="dma_seq_check");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t actual;

    /////////////////////////////////////////////////////////////////////////////
    // Style 1: write(); read(), if-error
    // size0, non-volatile
    $display("\n");
    `uvm_info("REG", "size0.write(4)/read front door", UVM_MEDIUM)
    actual = '1;
    dma_rm.size0.write(aok, 4,     .parent(this));
    dma_rm.size0.read(aok, actual, .parent(this));

    if (actual === 4) begin
      `uvm_info("SUCCESS_REG", "Write, read succeeded for size0", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Write, read failed for size0, actual=0x%0x, expect=4!", actual))
    end


    /////////////////////////////////////////////////////////////////////////////
    // Style 2: write(); mirror(), if-error
    // size0, non-volatile
    $display("\n");
    `uvm_info("REG", "size0.write(6)/mirror/get_mirrored_value front door", UVM_MEDIUM)
    dma_rm.size0.write(aok, 6, .parent(this));
    dma_rm.size0.mirror(aok,   .parent(this));

    if (dma_rm.size0.get_mirrored_value() === 6) begin
      `uvm_info("SUCCESS_REG", "Write, mirror/get_mirrored_value succeeded for size0", UVM_MEDIUM)
    end
    else begin
    `uvm_error("REG", $sformatf("Write, mirror/get_mirrored_value failed for size0, actual=0x%0x, expect=4!", dma_rm.size0.get_mirrored_value()))
    end


    /////////////////////////////////////////////////////////////////////////////
    // Style 3: write(); predict(); mirror();
    // size0, non-volatile
    $display("\n");
    `uvm_info("REG", "size0.write(8)/predict/mirror(check) front door", UVM_MEDIUM)
    dma_rm.size0.write(aok, 8, .parent(this));
    void'(dma_rm.size0.predict(8));
    dma_rm.size0.mirror(aok, UVM_CHECK, .parent(this));


    `uvm_info("!EXPECT_UVM_ERROR!", "size0.predict(888)\n\n\t !!!BAD VALUE - SHOULD CAUSE UVM_ERROR!!!\n\n", UVM_MEDIUM)
    void'(dma_rm.size0.predict(888));
    dma_rm.size0.mirror(aok, UVM_CHECK, .parent(this));

    `uvm_info("REG", "size0.write/predict/mirror(check) front door done", UVM_MEDIUM)

  endtask

endclass
