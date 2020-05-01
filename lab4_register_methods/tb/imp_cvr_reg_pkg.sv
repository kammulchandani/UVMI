// Package that holds the implicit coverage register class

package imp_cvr_reg_pkg;
  import uvm_pkg::*;

class imp_cvr_reg extends uvm_reg;
  function new(string name="", int unsigned n_bits, int has_coverage);
    super.new(name, n_bits, has_coverage);
  endfunction

  virtual function void sample(uvm_reg_data_t  data,
                               uvm_reg_data_t  byte_en,
                               bit             is_read,
                               uvm_reg_map     map);
    // Call virtual method in the generated class
    sample_values();
  endfunction

endclass : imp_cvr_reg

  
endpackage : imp_cvr_reg_pkg
  
