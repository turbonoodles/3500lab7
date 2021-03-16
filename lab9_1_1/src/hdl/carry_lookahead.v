`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2021 11:59:59 AM
// Design Name: 
// Module Name: rca_dataflow
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


module carry_lookahead(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire CIN,
    output wire [3:0] SUM,
    output wire COUT
    );

// nets for the lookahead carries
wire p0, p1, p2, p3; // propagate bit
wire g0, g1, g2, g3; // generate bit
wire carry1, carry2, carry3;

// lookahead carry logic
assign carry1 = g0 | ( p0 && CIN );
assign carry2 = g1 | ( g0 && p1 ) | ( CIN && p0 && p1 );
assign carry3 = g2 | ( g1 && p2 ) | ( g0 && p1 && p2 ) | ( CIN && p0 && p1 && p2 );
assign COUT = g3 | ( g2 && p3 ) | ( g1 && p2 && p3 ) | ( g0 && p1 && p2 && p3 ) | ( CIN && p0 && p1 && p2 && p3 );

// instantiate four full adders
fulladder #(3, 4, 1) fa0 (
    .a (A[0]),
    .b (B[0]),
    .cin (CIN),
    .p (p0),
    .g (g0),
    .s (SUM[0])
);

fulladder #(3, 4, 1) fa1(
    .a (A[1]),
    .b (B[1]),
    .cin (carry1),
    .p (p1),
    .g (g1),
    .s (SUM[1])
);

fulladder #(3, 4, 1) fa2(
    .a (A[2]),
    .b (B[2]),
    .cin (carry2),
    .p (p2),
    .g (g2),
    .s (SUM[2])
);

fulladder #(3, 4, 1) fa3(
    .a (A[3]),
    .b (B[3]),
    .cin (carry3),
    .p (p3),
    .g (g3),
    .s (SUM[3])
);

endmodule
