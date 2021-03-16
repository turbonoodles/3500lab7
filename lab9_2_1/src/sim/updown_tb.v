`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 03:03:53 PM
// Design Name: 
// Module Name: updown_tb
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
module updown_tb(
    );

parameter COUNTER_WIDTH = 4;
defparam dut.COUNT_SIZE = COUNTER_WIDTH;

reg clk;
reg reset;
reg enable;
reg up;
wire [COUNTER_WIDTH-1:0] count;

updown_counter dut(
    .clk (clk),
    .reset (reset),
    .enable (enable),
    .up (up),
    .count (count)
);

initial begin
    reset = 0;
    up = 0;
    enable = 0;
    clk = 0;
    #50;
    // begin by resetting
    reset = 1;
    #10;
    reset = 0;

    //let's count up
    up = 1;
    enable = 1;
    #1000;

    // stop
    enable = 0;
    #200;

    // down
    up = 0;
    enable = 1;
    #1500;

    up = 1;
    #1500;

    $finish;
end

// clock generator
always begin
    #10;
    clk = ~clk;
end
endmodule
