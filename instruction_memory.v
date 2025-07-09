//////////////////////////////////////////////////////////////////////////////////
// Company: UNSW
// Engineer: Jethro Rosettenstein z5492250
// Create Date: 09.07.2025 13:54:02
// Design Name: Pipelined processor
// Module Name: instruction_memory
// Revision:
// Revision 0.01 - File Created
// Comments:
//
// !!! USE AT YOUR OWN RISK !!!
// This code is COOKED cooked.
// Please make sure you understand what this is doing.
// I am not responsible for any bugs this causes; you chose to use it.
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory #(
    parameter integer _BAUD_SCALE = 10416
) (
    input clk,
    input reset,
    input run,
    input txd,
    input [3:0] addr_in,
    output [15:0] insn_out,
    output [7:0] led,
    output read_mode
);

  localparam STATE_WAITING = 2'b00;
  localparam STATE_READING = 2'b01;
  localparam STATE_DONE = 2'b10;
  localparam STATE_EXECUTING = 2'b11;

  integer i;

  reg [15:0] insn_reg[0:15];
  wire [15:0] zero_16b = 16'h0000;
  reg [1:0] state = STATE_WAITING;

  wire uart_msg_done;
  wire [7:0] uart_byte;
  reg write_upper_bits = 1;
  reg [3:0] write_addr = 0;

  assign read_mode = (state != STATE_EXECUTING);
  assign led = uart_byte;

  always @(negedge clk) begin
    write_addr <= write_addr;
    write_upper_bits <= write_upper_bits;
    for (i = 0; i < 16; i = i + 1) begin
      insn_reg[i] <= insn_reg[i];
    end

    if (reset) begin
      state <= STATE_WAITING;
      for (i = 0; i < 16; i = i + 1) begin
        insn_reg[i] <= zero_16b;
      end
    end else if (run) begin
      state <= STATE_EXECUTING;
    end else begin
      if (state == STATE_WAITING) begin
        if (!uart_msg_done) begin
          state <= STATE_READING;
        end else begin
          state <= STATE_WAITING;
        end

      end else if (state == STATE_READING) begin
        if (uart_msg_done) begin
          state <= STATE_DONE;
        end else begin
          state <= STATE_READING;
        end

      end else if (state == STATE_DONE) begin
        if (uart_msg_done) begin
          state <= STATE_WAITING;
        end else begin
          state <= STATE_READING;
        end

        if (write_upper_bits) begin
          insn_reg[write_addr] <= {uart_byte, insn_reg[write_addr][7:0]};
        end else begin
          insn_reg[write_addr] <= {insn_reg[write_addr][15:8], uart_byte};
          write_addr <= write_addr + 1;
        end
        write_upper_bits <= ~write_upper_bits;

      end else begin  // STATE_EXECUTING
        state <= STATE_EXECUTING;
      end
    end
  end

  uart_core #(
      ._BAUD_SCALE(_BAUD_SCALE)
  ) transmission (
      .txd(txd),
      .clk(clk),
      .done(uart_msg_done),
      .result(uart_byte)
  );

  assign insn_out = (state == STATE_EXECUTING) ? insn_reg[addr_in] : zero_16b;
endmodule

