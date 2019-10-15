module extras_mem(data, addr, we, en, clk, q, sevseg1, sevseg2, sevseg3, leds);
parameter DATA_WIDTH=16; 
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;

output [6:0] sevseg1, sevseg2, sevseg3;
output [2:0] leds;
output reg [15:0] q;

reg setTimer;
reg setStrikes;
wire secLeft;
reg numStrikes;

assign leds = numStrikes;

timer t1(.sec(data), .set(setTimer), .secLeft(secLeft), .sevseg1(sevseg1), .sevseg2(sevseg2), .sevseg3(sevseg3));
//strikes s1(.write(data), .set(setStrikes), .leds(numStrikes));

always @ (posedge clk)
	begin
		if(en) begin
			// Write
			if (we) begin
				if(addr >= 16'hF330 && addr < 16'hF663) begin
					setTimer <= 1;
					setStrikes <= 0;
				end
				else if(addr >= 16'hF330 && addr < 16'hF663) begin
					setStrikes <= 1;
					setTimer <= 0;
				end
				else begin
					setStrikes <= 0;
					setTimer <= 0;
				end	
			end

			if(addr >= 16'hF330 && addr < 16'hF663) begin
				q <= secLeft;
			end
			else if(addr >= 16'hF330 && addr < 16'hF663) begin
				q <= numStrikes;
			end
			else begin
				q <= 16'h0000;
			end
		end
	end
	
endmodule
