module morse_mem(data, addr, we, en, clk, morse_led, sevseg1, sevseg2);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;

output reg morse_led;
output reg [6:0] sevseg1, sevseg2;

wire [6:0] sev1, sev2;

sevseg s1(.bin(data[7:4]), .sev(sev1));
sevseg s2(.bin(data[3:0]), .sev(sev2));

always @ (posedge clk)
	begin
		if(en) begin
			if (we) begin
				if(addr[10] == 0) begin
					sevseg1 <= sev1;
					sevseg2 <= sev2;
				end
				else begin
					morse_led <= data[0];
				end
			end
		end
	end

endmodule
