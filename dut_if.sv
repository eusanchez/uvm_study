interface dut_if(input logic clk);
  logic       rst_n;
  logic [7:0] a;
  logic [7:0] b;
  logic [8:0] y;

  // ==========================================================
  // Assertion 1: After reset is released, y should never be X/Z
  // ==========================================================
  property p_y_never_unknown;
    @(posedge clk) disable iff (!rst_n)
      !$isunknown(y);
  endproperty

  a_y_never_unknown: assert property (p_y_never_unknown)
    else $error("ASSERT FAIL: y is X/Z at time %0t", $time);
    
  property failing_assertion;
    @(posedge clk) disable iff (!rst_n)
    (y == 0);
  endproperty
    
    a_y_always_zero: assert property (failing_assertion)
      else $error("ASSERTION FIRED at time %0t: y=%0d (expected 0)", $time, y);
endinterface
