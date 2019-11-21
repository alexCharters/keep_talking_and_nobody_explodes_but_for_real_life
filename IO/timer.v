module timer(sec, set, secLeft, clk, sevseg1, sevseg2, sevseg3);

parameter clockSpeed = 50000000;

input set, clk;
input [15:0] sec;

output reg [15:0] secLeft;
output [6:0] sevseg1, sevseg2, sevseg3;

reg [31:0] counter;

sec_to_sevseg s1(.sec(secLeft), .sevseg1(sevseg1), .sevseg2(sevseg2), .sevseg3(sevseg3));

initial begin
	counter <= 0;
end

always @(posedge clk) begin
	if(set) begin
		secLeft <= sec;
		counter <= 0;
	end
//	else if(secLeft == 0)
//		secLeft <= 0;
	else if(set == 0)
		secLeft <= (counter==clockSpeed)?secLeft-1'b1:secLeft;

	counter <= (counter==clockSpeed)?0:counter+1;
end

endmodule
