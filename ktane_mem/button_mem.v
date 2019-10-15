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

reg setWord, setColor, setStrip;

//oled_write o1(.set(setWord), .word(data[4:0]), .scl(scl), .sda(sda), .clk(clk), .addr(7'b1111111)); //change address
rgb_led l1(.clk(clk), .set(setColor), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led1));
rgb_led l2(.clk(clk), .set(setStrip), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led2));

always @ (posedge clk)
	begin
		if(en) begin
			// Write
			if (we) begin
				if(addr >= 16'hC000 && addr < 16'hC444) begin
					setWord <= 1;
					setColor <= 0;
					setStrip <= 0;
				end
				else if(addr >= 16'hC444 && addr < 16'hC888) begin
					setWord <= 0;
					setColor <= 1;
					setStrip <= 0;
				end
				else if(addr >= 16'hC888 && addr < 16'hcccc) begin
					setWord <= 0;
					setColor <= 0;
					setStrip <= 1;
				end
				else begin
					setWord <= 0;
					setColor <= 0;
					setStrip <= 0;
				end	
			end

			if(addr >= 16'hF330 && addr < 16'hF663) begin
				q <= {morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton, 8'b00000000};
			end
			else begin
				q <= 16'h0000;
			end
		end
	end

endmodule
