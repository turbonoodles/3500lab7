`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 02:18:35 PM
// Design Name: 
// Module Name: counter
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
module counter(
    input wire clk_100MHz,
    input wire reset,
    input wire enable,
    input wire up, // ~up is down
    output reg pulse_1s,
    output wire [7:0] count
    );

wire clk_5MHz;

clk_wiz_0 gandalf (
    // Clock out ports
    .clk_out1(clk_5MHz),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_100MHz)
);      // input clk_in1

// clock divider
reg [21:0] divider_count;
always @(posedge clk_5MHz, posedge reset ) begin
    
    if (reset) divider_count <= 0;
    
    else begin
        if (divider_count == 0) begin
            divider_count <= 2500000;
            pulse_1s <= ~pulse_1s;
        end
        else divider_count <= divider_count - 1;
    end

end

// up & down counter instantiation
// from IP catalog this time
c_counter_binary_0 udc (
  .CLK  (pulse_1s),    // input wire CLK
  .CE   (enable),      // input wire CE
  .SCLR (reset),  // input wire SCLR
  .UP   (up),      // input wire UP
  .Q    (count)        // output wire [7 : 0] Q
);

endmodule