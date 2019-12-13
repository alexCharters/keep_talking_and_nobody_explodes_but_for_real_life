// Multiplexor for two values. Behaves as one would expect, with 0 selecting in1, and 1 selecting in2.
module mux2to1(in1, in2, select, out);
    input [15:0] in1, in2;
    input select;
    output reg [15:0] out;
    always @ (*) begin
		if(select == 0)
			out = in1;
		else
			out = in2;
	 end
endmodule