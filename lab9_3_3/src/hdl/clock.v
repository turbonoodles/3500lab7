`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 10:01:28 PM
// Design Name: 
// Module Name: clock
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


module clock(
    input wire clk_100MHz,
    input wire enable,
    input wire reset,
    output wire [6:0] display_cathodes,
    output wire [7:0] display_anodes
    );

// 100MHz - 5MHz clocking wizard
wire clk_5MHz;
clk_wiz_0 merlin(
    .clk_in1 (clk_100MHz),
    .clk_out1 (clk_5MHz),
    .locked (locked)
);

// 1Hz clock divider
reg clk_1Hz;
reg [24:0] divider_count_1Hz;

always @( posedge clk_5MHz ) begin
    if (reset) divider_count_1Hz <= 2499999;
    else begin
        if ( divider_count_1Hz == 0 ) begin
            divider_count_1Hz <= 2499999;
            clk_1Hz = ~clk_1Hz;
        end
        else divider_count_1Hz <= divider_count_1Hz - 1;
    end
end

reg clk_500Hz;
reg [12:0] divider_count_500Hz;

always @( posedge clk_5MHz ) begin
    if (reset) divider_count_500Hz <= 5000;
    else begin
        if ( divider_count_500Hz == 0 ) begin
            divider_count_500Hz <= 5000;
            clk_500Hz = ~clk_500Hz;
        end
        else divider_count_500Hz <= divider_count_500Hz - 1;
    end
end

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

//display
quad_sevenseg display(
    .clk (clk_500Hz),
    .digit0 (seconds_ones),
    .digit1 (seconds_tens),
    .digit2 (minutes_ones),
    .digit3 (minutes_tens),
    .cathodes (display_cathodes),
    .anodes (display_anodes)
);
endmodule
