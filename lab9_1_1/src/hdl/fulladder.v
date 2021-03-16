`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2021 11:44:17 AM
// Design Name: 
// Module Name: ripple_carry_adder
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


module fulladder(
    input wire b, // number 1
    input wire a, // number 2
    input wire cin,     // carry in 
    output wire s, // sum
    output wire p, 
    output wire g
    );

// delay parameters
parameter AND_DELAY = 2;
parameter XOR_DELAY = 2;
parameter INV_DELAY = 2;

// full adder for carry-lookahead
xor #(XOR_DELAY) sum (s, a, b, cin);
or #(AND_DELAY) pro (p, a, b);
and #(AND_DELAY) gen (g, a, b);

endmodule