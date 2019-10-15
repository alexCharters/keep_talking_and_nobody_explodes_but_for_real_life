module divider(clock, en);
input clock;
output reg en;

reg [25:0] count;

initial begin
en = 0;
count = 0;
end

always @(posedge clock) begin

	if (count == 2000) begin
		en <= !en;
		count <= 0;
	end
	else begin
		count <= count + 1;
	end
end


endmodule
