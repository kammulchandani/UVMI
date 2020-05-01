interface apb_if(input PCLK,
                 input PRESETn);

  import uvm_pkg::*;
  import apb_agent_pkg::apb_seq_item;

  logic[31:0] PADDR;
  logic[31:0] PRDATA;
  logic[31:0] PWDATA;
  logic[15:0] PSEL; // Only connect the ones that are needed
  logic PENABLE;
  logic PWRITE;
  logic PREADY;

  property psel_valid;
    @(posedge PCLK)
    !$isunknown(PSEL);
  endproperty: psel_valid

  CHK_PSEL: assert property(psel_valid);

  COVER_PSEL: cover property(psel_valid);

  //Methods for the monitor and driver

  //  Monitor methods.
  task automatic monitor_apb(input int apb_index, output apb_seq_item item); 

    item = apb_seq_item::type_id::create("item");

    @(posedge PCLK);
    if(PREADY && PSEL[apb_index])
    // Assign the relevant values to the analysis item fields
      begin
        item.addr = PADDR;
        item.we = PWRITE;
        if(PWRITE)
          begin
            item.data = PWDATA;
          end
        else
          begin
            item.data = PRDATA;
          end
        // return to driver
        // Clone and publish the cloned item to the subscribers
        return ;
      end
    item = null;
  endtask:monitor_apb

  // Driver methods

  task automatic wait_initialize();
    PSEL <= 0;
    PENABLE <= 0;
    PADDR <= 0;
    // Wait for reset to clear
    @(posedge PRESETn);
  endtask: wait_initialize


  task automatic send_txn(input int psel_index, ref apb_seq_item req); 
     PSEL <= 0;
     PENABLE <= 0;
     PADDR <= 0;
     repeat(req.delay)
       @(posedge PCLK);
     PSEL[psel_index] <= 1;
     PADDR <= req.addr;
     PWDATA <= req.data;
     PWRITE <= req.we;
     @(posedge PCLK);
     PENABLE <= 1;
     while (!PREADY)
       @(posedge PCLK);
     if(PWRITE == 0)
     begin
       req.data = PRDATA;
     end
  endtask: send_txn

endinterface: apb_if