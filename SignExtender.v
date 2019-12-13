/*
    Using a given immediate, returns the immediate padded with its sign bit.
*/
module SignExtender(immediate, extended);
    input [7:0] immediate;
    output reg [15:0] extended;
    always @ (*) begin
        extended = {immediate[7], immediate[7], immediate[7], immediate[7], immediate[7], immediate[7], immediate[7], immediate[7], immediate[7:0]};
    end
endmodule