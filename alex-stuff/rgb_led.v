module rgb_led(clk, set, r, g, b, pins);
input clk, set;
input [4:0] r, g, b;
output reg [2:0] pins;	

reg [4:0] counter = 0;
reg [4:0] r_copy, g_copy, b_copy;

always @ (posedge clk)
begin
  if(set) begin
		r_copy <= r;
		g_copy <= g;
		b_copy <= b;
  end

  counter <= counter + 1'b1;
  pins[0] <= (counter < r_copy);
  pins[1] <= (counter < g_copy);
  pins[2] <= (counter < b_copy);
end

endmodule
