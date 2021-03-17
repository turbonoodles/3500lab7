`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 10:23:27 PM
// Design Name: 
// Module Name: countdown
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


module countdown(
    input wire clk_100MHz,
    input wire enable,
    input wire reset,
    input wire [1:0] start_minutes,
    output wire [6:0] display_cathodes,
    output wire [7:0] display_anodes
    );

// display instantiation
wire [3:0] ones_seconds;
wire [3:0] tens_seconds;
wire [3:0] minutes;

triple_sevenseg display(
    .clk (clk_500Hz),
    .digit0 (ones_seconds),
    .digit1 (tens_seconds),
    .digit2 (minutes),
    .cathodes (display_cathodes),
    .anodes (display_anodes)
);

// 5MHz clock divider
wire clk_5MHz;
clk_wiz_0 weasley(
    .clk_in1 ( clk_100MHz ),
    .clk_out1 ( clk_5MHz ),
    .locked (locked)
);

// 1Hz clock divider
reg clk_1Hz;
reg [24:0] divider_count;
always @( clk_5MHz ) begin
    if (reset) divider_count <= 2499999;
    else begin
        if ( divider_count == 0 ) begin
            divider_count <= 2499999;
            clk_1Hz = ~clk_1Hz;
        end
        else divider_count <= divider_count - 1;
    end
end

// main time counters
wire minutes_enable;
wire [3:0] seconds_count;
defparam seconds.MAX = 9;
downcounter seconds(
    .clk ( clk_1Hz ),
    .reset (reset),
    .start_count (0),
    .enable (enable),
    .count (seconds_count),
    .zero_count (tens_enable)
);

wire [3:0] tens_count;
defparam tens_seconds.MAX = 5;
downcounter tens_seconds(
    .clk ( clk_1Hz ),
    .reset ( reset ),
    .start_count (5),
    .enable ( tens_enable ),
    .count ( tens_count ),
    .zero_count ( minutes_enable )
);

wire [3:0] minutes_count;
defparam minutes.MAX = 0; // only two switches
downcounter minutes(
    .clk ( clk_1Hz ),
    .reset ( reset ),
    .start_count ( start_minutes ),
    .enable ( minutes_enable ),
    .count ( minutes_count ),
    .zero_count ( minutes_zero )
);

endmodule