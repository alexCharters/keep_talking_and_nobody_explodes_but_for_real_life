module mux4to1(in1, in2, in3, in4, select, out);
    input [15:0] in1, in2, in3, in4;
    input [1:0] select;
    output reg [15:0] out;
    always @ (*) begin
        case(select[1])
            1'b0: begin
                if(select[0] == 1'b0)
                    out = in1;
                else
                    out = in2;
            end
            1'b1: begin
                if(select[0] == 0)
                    out = in3;
                else
                    out = in4;
            end
        endcase
    end
endmodule