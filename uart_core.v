`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UNSW
// Engineer: Jethro Rosettenstein z5492250
// Create Date: 07/06/2025 01:38:34 PM
// Module Name: uart_core
// Project Name: UART Core
// Target Devices: basys3
//////////////////////////////////////////////////////////////////////////////////


module uart_core #(
    // Set to 2 when testing
    parameter integer _BAUD_SCALE = 10416
) (
    input txd,
    input clk,
    output wire done,
    output wire [7:0] result
);

  // Value register
  reg [7:0] value_reg = 0;
  assign result = value_reg;

  // States
  localparam integer IDLE = 1'b0;
  localparam integer RECEIVING = 1'b1;
  reg state = IDLE;
  assign done = state == IDLE;

  // Clock divider
  wire clk_div;
  clk_divider #(_BAUD_SCALE) baud_divider (
      .clk(clk),
      .clk_div(clk_div)
  );

  // Bit counter
  reg counter_nreset = 1;
  wire [2:0] bit_count;
  counter bit_counter (
      .clk(clk_div),
      .nreset(counter_nreset),
      .result(bit_count)
  );

  always @(negedge clk_div) begin
    if (state == IDLE) begin
      if (!txd) begin
        state <= RECEIVING;
        counter_nreset <= 1;
        value_reg <= 0;
      end else begin
        counter_nreset <= 0;
        value_reg <= value_reg;
      end
    end else if (state == RECEIVING) begin
      // value_reg[bit_count] <= txd;
      value_reg <= value_reg | (txd << (7 - bit_count));
      if (bit_count == 0) begin
        state <= IDLE;
      end
    end
  end

endmodule
