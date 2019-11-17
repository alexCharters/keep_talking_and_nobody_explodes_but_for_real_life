module extras_mem(data, write_addr, read_addr, we, re, en, clk, q, sevseg1, sevseg2, sevseg3, leds);
parameter DATA_WIDTH=16; 
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] write_addr;
input [(ADDR_WIDTH-1):0] read_addr;
input we, re, clk, en;

output [6:0] sevseg1, sevseg2, sevseg3;
output reg [2:0] leds;
output reg [15:0] q;

reg setTimer;
reg setStrikes;
wire [15:0] secLeft;
reg [1:0] numStrikes;

timer t1(.sec(data), .set(setTimer), .secLeft(secLeft), .clk(clk), .sevseg1(sevseg1), .sevseg2(sevseg2), .sevseg3(sevseg3));
//strikes s1(.write(data), .set(setStrikes), .leds(numStrikes));

always @ (posedge clk)
	begin
		if(en) begin
			// Write
			if (we) begin
				if(write_addr >= 16'hF330 && write_addr < 16'hF663) begin
					setTimer <= 1;
					setStrikes <= 0;
				end
				else if(write_addr >= 16'hF663 && write_addr < 16'hFFFF) begin
					setStrikes <= 1;
					setTimer <= 0;
				end
				else begin
					setStrikes <= 0;
					setTimer <= 0;
				end	
			end
			else begin
				setStrikes <= 0;
				setTimer <= 0;
			end

			if(re) begin
				if(read_addr >= 16'hF330 && read_addr < 16'hF663) begin
					q = secLeft;
				end
				else if(read_addr >= 16'hF663 && read_addr < 16'hFFFF) begin
					q = numStrikes;
				end
				else begin
					q = 16'h0000;
				end
			end
			
			if(setStrikes) begin
				numStrikes = data[1:0];
				case(numStrikes)
					2'b00: leds = 3'b000;
					2'b01: leds = 3'b100;
					2'b10: leds = 3'b110;
					2'b11: leds = 3'b111;
				endcase
			end
		end
		else begin
			setStrikes <= 0;
			setTimer <= 0;
		end
	end
	
endmodule
