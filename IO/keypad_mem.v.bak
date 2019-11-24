module keypad_mem(data, addr, we, en, clk, q, sda, scl, leds);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;

output reg [15:0] q;
output reg [3:0] leds;
output scl;
inout sda;

wire setGlyph1, setGlyph2, setGlyph3, setGlyph4; 

//oled_write o1(.set(setGlyph1), .word(data[4:0]), .scl(scl), .sda(sda), .clk(clk), .addr(7'b1111111)); //change address
//oled_write o2(.set(setGlyph2), .word(data[4:0]), .scl(scl), .sda(sda), .clk(clk), .addr(7'b1111111)); //change address
//oled_write o3(.set(setGlyph3), .word(data[4:0]), .scl(scl), .sda(sda), .clk(clk), .addr(7'b1111111)); //change address
//oled_write o4(.set(setGlyph4), .word(data[4:0]), .scl(scl), .sda(sda), .clk(clk), .addr(7'b1111111)); //change address

assign setGlyph1 = (en && we && addr[10:8] == 3'b100);
assign setGlyph2 = (en && we && addr[10:8] == 3'b101);
assign setGlyph3 = (en && we && addr[10:8] == 3'b110);
assign setGlyph4 = (en && we && addr[10:8] == 3'b111);

always @ (posedge clk)
	begin
		if(en) begin
			// Write
			if (we) begin
				case(addr[10:8])
					3'b000: leds[3] <= data[0];
					3'b001: leds[2] <= data[0];
					3'b010: leds[1] <= data[0];
					3'b011: leds[0] <= data[0];
					default: begin
					leds[3] <= leds[3];
					leds[2] <= leds[2];
					leds[1] <= leds[1];
					leds[0] <= leds[0];
					end
				endcase
//				if(addr >= 16'hcccc && addr < 16'hce65) begin
//					leds[3] <= data[0];
//				end
//				else if(addr >= 16'hce65 && addr < 16'hcfee) begin
//					leds[2] <= data[0];
//				end
//				else if(addr >= 16'hcfee && addr < 16'hd187) begin
//					leds[1] <= data[0];
//				end
//				else if(addr >= 16'hd187 && addr < 16'hd320) begin
//					leds[0] <= data[0];
//				end
//				else if(addr >= 16'hd320 && addr < 16'hd4b9) begin
//					setGlyph1 <= 0;
//					setGlyph2 <= 0;
//					setGlyph3 <= 0;
//					setGlyph4 <= 1;
//				end
//				else if(addr >= 16'hd4b9 && addr < 16'hd652) begin
//					setGlyph1 <= 0;
//					setGlyph2 <= 0;
//					setGlyph3 <= 1;
//					setGlyph4 <= 0;
//				end
//				else if(addr >= 16'hd659 && addr < 16'hd7eb) begin
//					setGlyph1 <= 0;
//					setGlyph2 <= 1;
//					setGlyph3 <= 0;
//					setGlyph4 <= 0;
//				end
//				else if(addr >= 16'hd7eb && addr < 16'hd998) begin
//					setGlyph1 <= 1;
//					setGlyph2 <= 0;
//					setGlyph3 <= 0;
//					setGlyph4 <= 0;
//				end
//				else begin
//					setGlyph1 <= 0;
//					setGlyph2 <= 0;
//					setGlyph3 <= 0;
//					setGlyph4 <= 0;
//				end	
			end

			q <= 16'h0000;
		end
	end

endmodule
