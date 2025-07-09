`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNSW
// Engineer: Jethro Rosettenstein z5492250
//
// Create Date: 07/09/2025 08:21:51 PM
// Design Name: Mock Uart
// Module Name: mock_uart_sim
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module mock_uart_sim #(
    parameter integer _BAUD_SCALE = 10416
) (
    input s,
    input clk,
    input [7:0] data,
    output reg done,
    output pin
);

  parameter STATE_IDLE = 1'b0;
  parameter STATE_SEND = 1'b1;

  wire clk_div;
  reg counter_nreset = 1;
  wire [2:0] bit_count;
  reg state = STATE_IDLE;
  reg pin_reg = 1;
  assign pin = pin_reg;

  clk_divider #(
      .N(_BAUD_SCALE)
  ) div (
      .clk(clk),
      .clk_div(clk_div)
  );

  counter bits (
      .clk(clk_div),
      .nreset(counter_nreset),
      .result(bit_count)
  );

  always @(negedge clk_div) begin
    state <= state;
    if (state == STATE_IDLE) begin
      pin_reg <= 1;
      done <= 1;
      counter_nreset <= 0;
      if (s == 1) begin
        state <= STATE_SEND;
        pin_reg <= 0;
        counter_nreset <= 1;
      end
    end else begin
      done <= 0;
      counter_nreset <= 1;
      pin_reg <= data[7-bit_count];
      if (bit_count == 0) begin
        state <= STATE_IDLE;
      end
    end
  end


endmodule
