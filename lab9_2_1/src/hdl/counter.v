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

//synthesis attribute
(* use_dsp48 = "no" *)
module counter(
    input wire clk_100MHz,
    input wire reset,
    input wire enable,
    input wire up, // ~up is down
    output reg pulse_1s,
    output wire [7:0] count
    );

defparam udc.COUNT_SIZE = 8;

wire clk_5MHz;

clk_wiz_0 clockotron (
    // Clock out ports
    .clk_out1(clk_5MHz),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_100MHz)
);      // input clk_in1

// clock divider
reg [19:0] divider_count;
always @(posedge clk_5MHz, posedge reset ) begin
    
    if (reset) divider_count <= 0;
    
    else begin
        if (divider_count == 0) begin
            divider_count <= 500000;
            pulse_1s <= ~pulse_1s;
        end
        else divider_count <= divider_count - 1;
    end

end

// up & down counter instantiation
updown_counter udc(
    .clk (pulse_1s),
    .reset (reset),
    .enable (enable),
    .up (up),
    .count (count)
);

endmodule