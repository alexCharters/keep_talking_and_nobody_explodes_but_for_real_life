module extras_mem(data, addr, we, en, clk, q, sevseg1, sevseg2, sevseg3, leds);
parameter DATA_WIDTH=16; 
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;

output [6:0] sevseg1, sevseg2, sevseg3;
output reg [2:0] leds;
output reg [15:0] q;

wire setTimer;
wire setStrikes;
wire [15:0] secLeft;
reg [1:0] numStrikes;

timer t1(.sec(data), .set(setTimer), .secLeft(secLeft), .clk(clk), .sevseg1(sevseg1), .sevseg2(sevseg2), .sevseg3(sevseg3));
//strikes s1(.write(data), .set(setStrikes), .leds(numStrikes));

assign setTimer = (en && we && !addr[10]);
assign setStrikes = (en && we && addr[10]);

initial begin
	numStrikes = 0;
end

always @ (*) begin
		if(!addr[10]) begin
			q = secLeft;
		end
		else begin
			q = numStrikes;
		end
			
		if(setStrikes) begin
			numStrikes = data[1:0];
			case(numStrikes)
				2'b00: leds = 3'b000;
				2'b01: leds = 3'b100;
				2'b10: leds = 3'b110;
				2'b11: leds = 3'b111;
				default: leds = leds;
			endcase
		end
		else begin
			numStrikes = numStrikes;
			leds = leds;
		end
	end
	
endmodule
