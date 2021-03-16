`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 12:30:28 PM
// Design Name: 
// Module Name: carry_lookahead_tb
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


module carry_lookahead_tb(
    );

reg [3:0] a;
reg [3:0] b;
reg carry_in;
wire [3:0] sum;
wire carry_out;

carry_lookahead dut(
    .A (a),
    .B (b),
    .CIN (carry_in),
    .SUM (sum),
    .COUT (carry_out)
);

initial begin
    carry_in = 0;

    for ( a = 0; a < 15; a = a + 1 ) begin
        for ( b = 0; b < 15; b = b + 1 ) begin
            #10;
            carry_in = 1;
            #10;
            carry_in = 0;
        end
        #10;
    end
    $finish;

end

endmodule