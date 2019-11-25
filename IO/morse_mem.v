module morse_mem(data, addr, we, en, clk, morse_led, sevseg1, sevseg2, reset);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en, reset;

output morse_led;
output reg [6:0] sevseg1, sevseg2;

reg set_morse;

wire [6:0] sev1, sev2;

sevseg s1(.bin(data[7:4]), .sev(sev1));
sevseg s2(.bin(data[3:0]), .sev(sev2));
morse_blink blinker(.clk(clk), .data(data), .set(set_morse), .morse_led(morse_led), .reset(reset));

always @ (posedge clk)
	begin
		if(en) begin
			if (we) begin
				if(addr[10] == 0) begin
					sevseg1 <= sev1;
					sevseg2 <= sev2;
					set_morse <= 1'b0;
				end
				else begin
					set_morse <= 1'b1;
				end
			end
			else
				set_morse <= 0;
		end
		else
			set_morse <= 0;
	end

endmodule
