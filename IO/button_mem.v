module button_mem(data, addr, we, en, clk, q, sda, scl, led1, led2, morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input we, clk, en;
input morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton; //all buttons

output reg [15:0] q;
output scl;
inout sda;
output [2:0] led1, led2;

wire setWord, setColor, setStrip;

oleds button_oled(.clk(clk), .data(data), .SCL(scl), .SDA(sda), .dataReady(setWord), .rst(1'b0), .address_sel(1'b0));
rgb_led l1(.clk(clk), .set(setColor), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led1));
rgb_led l2(.clk(clk), .set(setStrip), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led2));

assign setWord = (en && we && addr[10:9] == 2'b00);
assign setColor = (en && we && addr[10:9] == 2'b01);
assign setStrip = (en && we && addr[10:9] == 2'b10);

always@(*) begin
	if(addr[10:8] == 3'b000) begin
		q <= {15'b000000000000000, button_bigButton};
	end
	else if(addr[10:8] == 3'b001) begin
		q <= {15'b000000000000000, morse_left};
	end
	else if(addr[10:8] == 3'b010) begin
		q <= {15'b000000000000000, morse_right};
	end
	else if(addr[10:8] == 3'b011) begin
		q <= {15'b000000000000000, morse_tx};
	end
	else if(addr[10:8] == 3'b100) begin
		q <= {15'b000000000000000, keypad_TL};
	end
	else if(addr[10:8] == 3'b101) begin
		q <= {15'b000000000000000, keypad_TR};
	end
	else if(addr[10:8] == 3'b110) begin
		q <= {15'b000000000000000, keypad_LL};
	end
	else if(addr[10:8] == 3'b111) begin
		q <= {15'b000000000000000, keypad_LR};
	end
	else begin
		q <= 16'b1111111111111111;
	end
end
	
//initial begin
//	setWord = 0;
//	setColor = 0;
//	setStrip = 0;
//end
//
//always @ (posedge clk or posedge en)
//	begin
//		if(en) begin
//		   q = 16'h0000;
//			// Write
//			if (we) begin
//				if(write_addr >= 16'hC000 && write_addr < 16'hC444) begin
//					setWord = 1;
//					setColor = 0;
//					setStrip = 0;
//				end
//				else if(write_addr >= 16'hC444 && write_addr < 16'hC888) begin
//					setWord = 0;
//					setColor = 1;
//					setStrip = 0;
//				end
//				else if(write_addr >= 16'hC888 && write_addr < 16'hcccc) begin
//					setWord = 0;
//					setColor = 0;
//					setStrip = 1;
//				end
//				else begin
//					setWord = 0;
//					setColor = 0;
//					setStrip = 0;
//				end	
//			end
//			else begin
//				setWord = 0;
//				setColor = 0;
//				setStrip = 0;
//			end
//            
//			if(re) begin
//				if(read_addr >= 16'hC000 && read_addr < 16'hC444) begin
//					q = {morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton, 8'b00000000};
//				end
//				else begin
//					q = 16'h0000;
//				end
//			end
//		end
//		else begin
//			setWord <= 0;
//			setColor <= 0;
//			setStrip <= 0;
//			q = 16'h0000;
//		end
//	end

endmodule
