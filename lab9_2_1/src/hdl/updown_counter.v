`timescale 1ns / 1ps

module updown_counter(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire up,
    output reg [COUNT_SIZE-1:0] count
    );

parameter COUNT_SIZE = 8;

always @(posedge clk, posedge reset) begin
    
    if (reset) count <= 0;
    else begin

        // manage the count
        if (enable) begin

            if (up) begin
                if ( &(count) ) count <= 0; // terminal count; all ones
                else count <= count + 1;
            end
        
            else begin // enable & ~up
                    if ( count == 0 ) count <= {COUNT_SIZE{1'b1}}; // terminal count is all zeroes
                else count <= count - 1;
            end
        end
    end
end

endmodule