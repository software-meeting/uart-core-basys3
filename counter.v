`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNSW
// Engineer: Jethro Rosettenstein z5492250
// Create Date: 07/06/2025 12:46:01 PM
// Module Name: counter
// Project Name: UART Core
// Target Devices: basys3
//////////////////////////////////////////////////////////////////////////////////


module counter #(
    parameter integer N = 3
) (
    input clk,
    input nreset,
    output wire [(N-1):0] result
);

  reg [(N-1):0] counter = {N{1'b1}} + 1;
  assign result = counter;

  always @(negedge clk) begin
    if (!nreset) begin
      counter <= {N{1'b1}};
    end else begin
      counter <= counter - 1;
    end
  end

endmodule
