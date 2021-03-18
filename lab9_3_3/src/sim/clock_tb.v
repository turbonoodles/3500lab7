`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 10:16:35 PM
// Design Name: 
// Module Name: clock_tb
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


module clock_tb(

    );

reg clk_1Hz;
reg enable;
reg reset;

wire [3:0] minutes_ones;
wire [2:0] minutes_tens;
wire [3:0] seconds_ones;
wire [2:0] seconds_tens;

// main time counters
wire seconds_enable, seconds_tc;
assign seconds_enable = enable;
mod60_counter seconds(
    .clk (clk_1Hz),
    .reset (reset),
    .enable (seconds_enable),
    .ones (seconds_ones),
    .tens (seconds_tens),
    .terminal_count (seconds_tc)
);

wire minutes_enable, minutes_tc;
assign minutes_enable = seconds_tc & enable;
mod60_counter minutes(
    .clk (clk_1Hz),
    .reset (reset),
    .enable (minutes_enable),
    .ones (minutes_ones),
    .tens (minutes_tens),
    .terminal_count (minutes_tc)
);

initial begin
    clk_1Hz = 0;
    enable = 0;
    reset = 0;
    
    // power on reset
    #1000;
    reset = 1;
    #1000;
    reset = 0;
    enable = 1;

    #180000000; // three minutes
    $finish;
end

always begin
    #500000;
    clk_1Hz = ~clk_1Hz;
end

endmodule