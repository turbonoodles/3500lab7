`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 10:17:53 PM
// Design Name: 
// Module Name: mod60_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mod60_counter(
    input wire clk,
    input wire enable,
    input wire reset,
    output wire [3:0] ones,
    output wire [2:0] tens,
    output wire terminal_count
    );

wire nine, fifty; // terminal count on ones, tens respectively

assign terminal_count = nine & fifty;

wire ones_enable;
assign ones_enable = enable;
mod10_counter ones_ctr (
  .CLK (clk),          // input wire CLK
  .CE ( ones_enable ),            // input wire CE
  .SCLR( reset ),        // input wire SCLR
  .THRESH0( nine ),  // output wire THRESH0
  .Q (ones)              // output wire [3 : 0] Q
);

wire tens_enable;
assign tens_enable = nine & enable;
mod6_counter tens_ctr (
  .CLK(clk),          // input wire CLK
  .CE( tens_enable ),            // input wire CE
  .SCLR( reset ),        // input wire SCLR
  .THRESH0( fifty ),  // output wire THRESH0
  .Q (tens)              // output wire [2 : 0] Q
);

endmodule
