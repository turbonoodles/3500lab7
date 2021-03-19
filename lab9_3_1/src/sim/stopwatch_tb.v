`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2021 09:20:36 PM
// Design Name: 
// Module Name: stopwatch_tb
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


module stopwatch_tb(
    );

reg clk_10Hz;
reg reset;
reg enable_in;

wire [6:0] digit_cathodes;
wire [7:0] digit_anodes;

// omit dividers and wizards

// instantiate counters
// tenths of seconds
wire[3:0] tenths_digit;
wire point_nine;
wire enable; // both enable_in and under 5 minutes; more later
mod_10_counter tenths_secs(
    .CLK (clk_10Hz),
    .CE (enable),
    .SCLR (reset),
    .THRESH0 (point_nine),
    .Q (tenths_digit)
);

// seconds counter
wire[3:0] seconds_digit;
wire nine;
wire ones_enable;
assign ones_enable = point_nine & enable;
mod_10_counter seconds(
    .CLK (clk_10Hz),
    .CE (ones_enable),
    .SCLR (reset),
    .THRESH0 ( nine ),
    .Q (seconds_digit)
);

wire[3:0] tens_seconds_digit;
wire fifty;
wire tens_enable;
assign tens_enable = point_nine & nine & enable;
mod_6_counter tens_seconds(
    .CLK (clk_10Hz),
    .CE ( tens_enable ),
    .SCLR (reset),
    .THRESH0 (fifty),
    .Q (tens_seconds_digit)
);

// only count minutes if 59s
wire count_minutes;
assign count_minutes = point_nine & nine & fifty & enable;
wire [3:0] minutes_digit;

mod_6_counter minutes(
    .CLK (clk_10Hz),
    .CE (count_minutes),
    .SCLR (reset),
    .THRESH0 ( five ),
    .Q (minutes_digit)
);

// neglect display for this testbench

// stop counting at 5 minutes
// all the thresholds are on
assign enable = enable_in & ~five; // stop counting at 5 minutes

// testbenchy stuff
always begin
    #50000;
    clk_10Hz = ~clk_10Hz;
end

initial begin
    clk_10Hz = 0;
    reset = 0;
    enable_in = 0;

    #1000000;
    reset = 1;
    #2000000;
    reset = 0;
    enable_in = 1;
    #330000000; // five minutes
    reset = 1;
    #1000000;
    reset = 0;

    #120000000;
    $finish;
end

endmodule
