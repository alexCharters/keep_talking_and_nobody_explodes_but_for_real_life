module keypad_mem(data, addr, we, en, clk, q, sda1, scl1, sda2, scl2, leds);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;

output reg [15:0] q;
output reg [3:0] leds;
output scl1, scl2;
inout sda1, sda2;

wire addr_sel1, addr_sel2;

wire setGlyph1, setGlyph2, setGlyph3, setGlyph4; 

oleds button_oled1(.clk(clk), .data(data), .SCL(scl1), .SDA(sda1), .dataReady(setGlyph1 | setGlyph2), .rst(1'b0), .address_sel(addr_sel1));
oleds button_oled2(.clk(clk), .data(data), .SCL(scl2), .SDA(sda2), .dataReady(setGlyph3 | setGlyph4), .rst(1'b0), .address_sel(addr_sel2));

assign setGlyph1 = (en && we && addr[10:8] == 3'b100);
assign setGlyph2 = (en && we && addr[10:8] == 3'b101);
assign setGlyph3 = (en && we && addr[10:8] == 3'b110);
assign setGlyph4 = (en && we && addr[10:8] == 3'b111);

assign addr_sel1 = (en && we && addr[10:8] == 3'b101);
assign addr_sel2 = (en && we && addr[10:8] == 3'b111);

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
