// Code your design here
`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "dut_if.sv"
`include "dut.sv"
`include "tb_pkg.sv"
import tb_pkg::*;

module tb_top;
  logic clk = 0;
  always #5 clk = ~clk;

  dut_if vif(clk);

  dut_adder dut (
    .clk   (clk),
    .rst_n (vif.rst_n),
    .a     (vif.a),
    .b     (vif.b),
    .y     (vif.y)
  );

  initial begin
    vif.rst_n = 0;
    vif.a     = '0;
    vif.b     = '0;
    repeat (3) @(posedge clk);
    vif.rst_n = 1;
  end

  initial begin
    // Provide vif to all components
    uvm_config_db#(virtual dut_if)::set(null, "*", "vif", vif);

    run_test("add_test");
  end
endmodule
