/*
    Given an immediate, returns the immediate padded with zeros. Sign does not matter here.
*/
module ZeroExtender(immediate, result);
    input [7:0] immediate;
    output reg [15:0] result;
    always @(*) begin
        result = {8'b00000000, immediate[7:0]};
    end
endmodule