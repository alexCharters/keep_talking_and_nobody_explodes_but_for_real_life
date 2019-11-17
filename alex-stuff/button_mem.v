module button_mem(data, write_addr, read_addr, we, re, en, clk, q, sda, scl, led1, led2, morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton, debug_leds);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] write_addr;
input [(ADDR_WIDTH-1):0] read_addr;
input we, re, clk, en;
input morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton; //all buttons

output [5:0] debug_leds;

output reg [15:0] q;
output scl;
inout sda;
output [2:0] led1, led2;

reg setWord, setColor, setStrip;

oleds button_oled(.clk(clk), .data(data), .SCL(scl), .SDA(sda), .dataReady(setWord), .rst(1'b0), .debug_leds(debug_leds));
rgb_led l1(.clk(clk), .set(setColor), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led1));
rgb_led l2(.clk(clk), .set(setStrip), .r(data[14:10]), .g(data[9:5]), .b(data[4:0]), .pins(led2));

initial begin
	setWord = 0;
	setColor = 0;
	setStrip = 0;
end

always @ (posedge clk or posedge en)
	begin
		if(en) begin
		   q = 16'h0000;
			// Write
			if (we) begin
				if(write_addr >= 16'hC000 && write_addr < 16'hC444) begin
					setWord = 1;
					setColor = 0;
					setStrip = 0;
				end
				else if(write_addr >= 16'hC444 && write_addr < 16'hC888) begin
					setWord = 0;
					setColor = 1;
					setStrip = 0;
				end
				else if(write_addr >= 16'hC888 && write_addr < 16'hcccc) begin
					setWord = 0;
					setColor = 0;
					setStrip = 1;
				end
				else begin
					setWord = 0;
					setColor = 0;
					setStrip = 0;
				end	
			end
			else begin
				setWord = 0;
				setColor = 0;
				setStrip = 0;
			end
            
			if(re) begin
				if(read_addr >= 16'hC000 && read_addr < 16'hC444) begin
					q = {morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR, button_bigButton, 8'b00000000};
				end
				else begin
					q = 16'h0000;
				end
			end
		end
		else begin
			setWord <= 0;
			setColor <= 0;
			setStrip <= 0;
			q = 16'h0000;
		end
	end

endmodule
