# Visualizer TCL script to define a Register View for the DMA registers
# For the UVM Intermediate course
# Get Visualizer running, then load this file:
# View > Register Viewer > Load Register File...
# 	register_dma.tcl [Open]
# Then open the register view:
# View > Register Viewer > dma_d0
#

proc label_value {do_name regview label var row column radix color } {
  set c1 $column
  set c2 [expr $c1 + 1]

  if { [expr $do_name == 1] } {
          add regview -viewer $regview             -row $row -column $c1 -name $label -foreground $color -alignment Right
  }
        add regview -viewer $regview -radix $radix -row $row -column $c2 -var  $var   -foreground $color -alignment Right
}

proc dut {do_name regview iname row column} {
  set c1 $column
  set c2 [expr $c1 + 1]
  
        add regview -viewer $regview -row $row -column $c2 -name $iname -foreground Red -alignment Right

  label_value $do_name $regview csr0  $iname.csr0  [incr row] $c1 Hex DarkGreen
  label_value $do_name $regview size0 $iname.size0 [incr row] $c1 Hex DarkGreen
  label_value $do_name $regview src0  $iname.src0  [incr row] $c1 Hex DarkGreen
  label_value $do_name $regview dst0  $iname.dst0  [incr row] $c1 Hex DarkGreen
}

set regview dma_d0

dut 1 $regview top_hdl.dma0 0 1
