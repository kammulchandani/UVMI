// Package that holds the inc register class

package inc_reg_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"

class inc_reg extends uvm_reg;
  // Constructor has extra arguments compared to uvm_object
  function new(string name="", int unsigned n_bits, int has_coverage);
    super.new(name, n_bits, has_coverage);
  endfunction

  // Register hook method
  virtual task post_read(uvm_reg_item rw);
    uvm_reg rg;
    uvm_reg_data_t val;
    uvm_status_e aok;

    // Fetch the register command
    if (! $cast(rg, rw.element)) `uvm_fatal("$cast", "failed")

    // Update the mirror with the new value
    val = rg.get_mirrored_value() + 1;
    `uvm_info("inc_reg", $sformatf("post_read: updating the mirror to 0x%0x", val), UVM_HIGH)
    void'(rg.predict(val));

    // Increment the RTL register on backdoor reads
    //
    // LAB 4 ASSIGNMENT
    // 1. Check rw.path to see if this is a UVM_BACKDOOR. If so:
    //    a. Declare a 16 bit variable v16
    //    b. Call peek to fetch the value from the DUT into v16
    //    c. Increment v16
    //    d. Finally, call poke to put v16 into the DUT
    // 2. Add a message to trace the operation
    //****** INSERT LAB CODE HERE


    //**********END LAB INSERT***************

  endtask

endclass

endpackage
