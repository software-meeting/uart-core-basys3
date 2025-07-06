`timescale 1ns / 1ps

module uart_core_instantiation #(
    integer _BAUD_SCALE = 10416
) (
    input clk,
    input RsRx,
    output [15:0] led
);

  reg [7:0] led_reg = 0;
  assign led = {8'h00, led_reg};
  wire done;

  wire [7:0] core_out;
  uart_core #(
      ._BAUD_SCALE(_BAUD_SCALE)
  ) core (
      .txd(RsRx),
      .clk(clk),
      .done(done),
      .result(core_out)
  );

  always @(posedge done) begin
    led_reg <= core_out;
  end

endmodule
