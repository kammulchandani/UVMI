/***********************************************************************
 * Register sequence with randomization for UVM Intermediate lab 1 DMA
 *
 * Run with:
 * % make TESTNAME=dma_test_uvm_seq SIM=+uvm_seq=dma_seq_rand
 * which resolves to:
 * vsim +UVM_TESTNAME=dma_test_uvm_seq +uvm_seq=dma_seq_rand ...
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


class dma_seq_rand extends dma_seq_base;
  `uvm_object_utils(dma_seq_rand)
  function new(string name="dma_seq_rand");
    super.new(name);
  endfunction

  virtual task body();
    uvm_status_e aok;
    uvm_reg_data_t exp, act;

    //------------------------------------------------------------------
    // Wait for design to reset on the DMA interface
    m_dma_cfg.wait_for_reset(.verbose(0));


    //------------------------------------------------------------------
    `uvm_info("RAND", "Randomize just one register: size0", UVM_MEDIUM)
    if (! dma_rm.size0.randomize() with {F.value inside {['h100:'h200]}; } )begin
      `uvm_fatal("RAND", "dma_rm.size0.randomize() failed")
    end
    `uvm_info("RAND", $sformatf("Success, desired size0=0x%0x", dma_rm.size0.get()), UVM_MEDIUM)
    dma_rm.size0.update(aok);


    //------------------------------------------------------------------
    // Directed randomization - just a first step
    // Randomize the entire register model, with fixed values
    // This does NOT change the DUT values
    `uvm_info("RAND", $sformatf("Before directed rand, desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()), UVM_MEDIUM)
    if (! dma_rm.randomize() with {size0.F.value == 8;
				   src0.F.value  == 7;
				   dst0.F.value  == 6;} ) begin
      `uvm_fatal("RAND", "dma_rm.randomize() failed")
    end
    `uvm_info("RAND", $sformatf("After directed rand, desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()), UVM_MEDIUM)
    `uvm_info("RAND", "Update the DUT values", UVM_MEDIUM)
    dma_rm.update(aok);


   //------------------------------------------------------------------
    `uvm_info("RAND", "Randomize the entire register model with only size0.F.value=42 constraint", UVM_MEDIUM)
    repeat (5) begin
      // The constraint could have been written "dma_rm.size0.F.value ..."
      if (! dma_rm.randomize() with {size0.F.value == 'h42; } ) begin
	`uvm_fatal("RAND", "dma_rm.randomize() failed")
      end
      `uvm_info("RAND", $sformatf("Success, desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				  dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()),
		UVM_MEDIUM)
      `uvm_info("RAND", "Update the DUT values", UVM_MEDIUM)
      dma_rm.update(aok);
    end

    //------------------------------------------------------------------
    // Try to generate an error with a bad predict value followed by mirror-check
    `uvm_info("!EXPECT_UVM_ERROR!", "Before bad dst0.predict(999) call !!!!BAD VALUE - EXPECTING A UVM_ERROR!!!", UVM_MEDIUM)
    void'(dma_rm.dst0.predict(999));
    dma_rm.dst0.mirror(aok, UVM_CHECK);
    `uvm_info("!EXPECT_UVM_ERROR!", "After dst0.mirror() call\n\n\t!!!!DID THIS GET A UVM_ERROR?!!!!\n\n", UVM_MEDIUM)


    //------------------------------------------------------------------
    // Try predict + mirror at the block level -> should fail as DUT was never updated, right?
    `uvm_info("RAND", "Before predict() calls", UVM_MEDIUM)
    void'(dma_rm.csr0.predict(8));  // Good value
    void'(dma_rm.size0.predict(8)); // Bogus value
    void'(dma_rm.src0.predict(42)); // Bogus value
    void'(dma_rm.dst0.predict(99)); // Bogus value
    `uvm_info("!EXPECT_UVM_ERROR!", "Before block-level dma_rm.mirror(aok, UVM_CHECK) !!!!EXPECTING MULTIPLE UVM_ERRORs!!!!\n", UVM_MEDIUM)
    `uvm_info("RAND", $sformatf("Before predict, desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()), UVM_MEDIUM)
    dma_rm.mirror(aok, UVM_CHECK);
    `uvm_info("!EXPECT_UVM_ERROR!", "After dma_rm.mirror() call\n\n\t!!!!DID THIS GET A UVM_ERROR for size0, src0, dst0?!!!!\n\n", UVM_MEDIUM)

    `uvm_info("RAND", $sformatf("Desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()), UVM_MEDIUM)

    // DON'T update the values in the DUT
//    dma_rm.update(aok);


    //------------------------------------------------------------------
    // Try predict + mirror at the block level -> should fail as DUT was never updated, right?
    // Randomize the entire register model
    // This does NOT change the DUT values
    if (! dma_rm.randomize() with {size0.F.value == 6;
				   src0.F.value  == 40;
				   dst0.F.value  == 97;} ) begin
      `uvm_fatal("RAND", "dma_rm.randomize() failed")
    end
    `uvm_info("RAND", $sformatf("Block randomize success, desired csr0=0x%0x, size0=0x%0x, src0=0x%0x, dst0=0x%0x",
				dma_rm.csr0.get(), dma_rm.size0.get(), dma_rm.src0.get(), dma_rm.dst0.get()),
	      UVM_MEDIUM)


    // Update the values in the DUT when mirrored != desired
    `uvm_info("RAND", "Update the DUT values", UVM_MEDIUM)
    dma_rm.update(aok);

    // Now check the values against the expected values
    void'(dma_rm.size0.predict(6));
    void'(dma_rm.src0.predict(40));
    void'(dma_rm.dst0.predict(97));
    `uvm_info("RAND", "Before dma_rm.mirror(aok, UVM_CHECK) call - should succeed", UVM_MEDIUM)
    dma_rm.mirror(aok, UVM_CHECK);
    `uvm_info("RAND", "After dma_rm.mirror() call - should have succeeded", UVM_MEDIUM)

  endtask

endclass
