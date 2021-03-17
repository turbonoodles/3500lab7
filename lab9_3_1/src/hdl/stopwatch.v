`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 08:29:15 PM
// Design Name: 
// Module Name: stopwatch
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

module stopwatch(
    input wire clk_100MHz,
    input wire reset,
    input wire enable_in,
    output [6:0] digit_cathodes,
    output [7:0] digit_anodes
    );

wire clk_5MHz;
clk_wiz_0 saruman(
    .clk_in1 (clk_100MHz),
    .clk_out1 (clk_5MHz),
    .locked (locked)
);

// divide clock to 0.1s
reg [24:0] div_count;
reg clk_10Hz;

// 10Hz clock generation for the timer
always @(posedge clk_5MHz) begin
    if (reset) div_count <= 249999;
    else begin
        if (div_count == 0) begin
            div_count <= 249999;
            clk_10Hz <= ~clk_10Hz;
        end
        else div_count <= div_count - 1;
    end
end

// 500Hz clock generation for the display
reg [13:0] disp_div_count;
reg clk_500Hz;

always @(posedge clk_5MHz) begin
    if (reset) disp_div_count <= 10000;
    else begin
        if (disp_div_count == 0) begin
            disp_div_count <= 10000;
            clk_500Hz <= ~clk_500Hz;
        end
        else disp_div_count <= disp_div_count - 1;
    end
end

// instantiate counters
// tenths of seconds
wire[3:0] tenths_digit;
wire ones_enable;
wire enable; // both enable_in and under 5 minutes; more later
mod_10_counter tenths_secs(
    .CLK (clk_10Hz),
    .CE (enable),
    .SCLR (reset),
    .THRESH0 (ones_enable),
    .Q (tenths_digit)
);

// seconds counter
wire[3:0] seconds_digit;
wire nine;

mod_10_counter seconds(
    .CLK (clk_10Hz),
    .CE (ones_enable),
    .SCLR (reset),
    .THRESH0 ( nine ),
    .Q (seconds_digit)
);

wire[3:0] tens_seconds_digit;
wire fifty;

mod_6_counter tens_seconds(
    .CLK (clk_10Hz),
    .CE ( nine ),
    .SCLR (reset),
    .THRESH0 (fifty),
    .Q (tens_seconds_digit)
);

// only count minutes if 59s
wire count_minutes;
assign count_minutes = fifty & nine;
wire [3:0] minutes_digit;

mod_6_counter minutes(
    .CLK (clk_10Hz),
    .CE (count_minutes),
    .SCLR (reset),
    .THRESH0 ( five ),
    .Q (minutes_digit)
);

// instantiate quad BCD display
quad_sevenseg display(
    .clk ( clk_500Hz ),
    .digit0 (tenths_digit),
    .digit1 (seconds_digit),
    .digit2 (tens_seconds_digit),
    .digit3 (minutes_digit),
    .cathodes (digit_cathodes),
    .anodes (digit_anodes)
);

// stop counting at 5 minutes
// all the thresholds are on
wire tc;
assign tc = ones_enable & nine & fifty & five; // terminal count of five minutes
assign enable = enable_in & ~tc;

endmodule