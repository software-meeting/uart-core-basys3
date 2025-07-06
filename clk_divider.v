`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNSW
// Engineer: Jethro Rosettenstein z5492250
// Create Date: 07/06/2025 12:46:01 PM
// Module Name: clk_divider
// Project Name: UART Core
// Target Devices: basys3
//////////////////////////////////////////////////////////////////////////////////


module clk_divider #(
    parameter integer N = 868  // Baud rate: 100MHz / 115200
) (
    input clk,
    output wire clk_div
);

  reg [($clog2(N/2)-1):0] counter = N / 2;
  reg clk_div_reg = 0;
  assign clk_div = clk_div_reg;

  always @(negedge clk) begin
    if (counter == 0) begin
      counter <= N / 2 - 1;
      clk_div_reg <= ~clk_div_reg;
    end else begin
      counter <= counter - 1;
    end
  end

endmodule





























