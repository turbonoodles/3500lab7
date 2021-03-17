`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 05:41:58 PM
// Design Name: 
// Module Name: countdown_tb
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


module countdown_tb(

    );

// pokeable registers
reg clk_1Hz;
reg clk_500Hz;
reg enable;
reg reset;
reg [1:0] start_minutes;
wire [7:0] display_anodes;
wire [6:0] display_cathodes;

// display instantiation
wire [3:0] seconds_count;
wire [3:0] tens_count;
wire [1:0] minutes_count;

triple_sevenseg display(
    .clk ( clk_500Hz ),
    .digit0 ( seconds_count ),
    .digit1 ( tens_count ),
    .digit2 ( {0, 0, minutes_count[1], minutes_count[0]} ),
    .cathodes ( display_cathodes ),
    .anodes ( display_anodes )
);

// clock dividers omitted from testbench

// stop counting at 0
wire all_zero;
assign all_zero = seconds_zero & tens_zero & minutes_zero;

// main time counters
wire seconds_enable; // disable if count == 0; more later
assign seconds_enable = enable & ~all_zero;
wire seconds_zero;
defparam seconds.MAX = 9;
downcounter seconds(
    .clk ( clk_1Hz ),
    .reset ( reset ),
    .start_count ( 0 ),
    .enable ( seconds_enable ),
    .count ( seconds_count ),
    .zero_count ( seconds_zero )
);

wire tens_zero, tens_enable;
assign tens_enable = enable & seconds_zero & ~all_zero; // decrement tens when ones hits zero
defparam tens_seconds.MAX = 5;
downcounter tens_seconds(
    .clk ( clk_1Hz ),
    .reset ( reset ),
    .start_count ( 0 ),
    .enable ( tens_enable ),
    .count ( tens_count ),
    .zero_count ( tens_zero )
);

wire minutes_zero;
wire minutes_enable;
assign minutes_enable = enable & seconds_zero & tens_zero & ~all_zero;
defparam minutes.WIDTH = 2;
defparam minutes.MAX = 0; // only two switches
downcounter minutes(
    .clk ( clk_1Hz ),
    .reset ( reset ),
    .start_count ( start_minutes ),
    .enable ( minutes_enable ),
    .count ( minutes_count ),
    .zero_count ( minutes_zero )
);

// stop counting if all the numbers are zero
wire all_zero;
assign all_zero = seconds_zero & tens_zero & minutes_zero;
assign ones_enable = enable & ~all_zero;

// finally the testbenchy stuff
// 1Hz clock
always begin
    #500000; // yikes
    clk_1Hz = ~clk_1Hz;
end

//500Hz clock
always begin
    #1000;
    clk_500Hz = ~clk_500Hz;
end

initial begin
    clk_1Hz = 0;
    clk_500Hz = 0;
    reset = 1;
    enable = 0;
    start_minutes = 1;

    #1000;
    reset = 0;
    #1000;
    enable = 1;

    #180000000; // three minutes
    $finish;
end

endmodule
