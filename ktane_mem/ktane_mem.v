module ktane_mem(data,
	//addr,
	we,
	en,
	clk,
	q,
	sda,
	scl,
	led1,
	led2,
	button,
	morse_left,
	morse_right,
	morse_tx,
	morse_led,
	keypad_TL,
	keypad_TR,
	keypad_LL,
	keypad_LR,
	keypad_leds,
	morse_sevseg1,
	morse_sevseg2,
	timer_sevseg1,
	timer_sevseg2,
	timer_sevseg3,
	strike_leds,
	debug_leds);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
//input [(ADDR_WIDTH-1):0] addr;
//parameter data = 16'b0000000001000011;
parameter addr = 16'hF330;
input we, clk, en;

input button, morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR;

output [15:0] q;
output scl, morse_led;
inout sda;

output [3:0] keypad_leds;
output [2:0] led1, led2, strike_leds;

output [6:0] morse_sevseg1, morse_sevseg2, timer_sevseg1, timer_sevseg2, timer_sevseg3;
output [8:0] debug_leds;

reg ram_en, button_en, keypad_en, morse_en, wires_en, extra_en;

reg [2:0] output_sel;

wire scl1;


wire [15:0] ram_out, button_out, keypad_out, wires_out, extra_out;

dual_port_ram ram(.data(data), .addr(addr), .we(we), .clk(clk), .en(ram_en), .q(ram_out));
button_mem button_mem(
	.data(data),
	.addr(addr),
	.we(we),
	.clk(clk),
	.en(button_en),
	.q(button_out),
	.sda(sda),
	.scl(scl1),
	.led1(led1),
	.led2(led2),
	.morse_left(morse_left),
	.morse_right(morse_right),
	.morse_tx(morse_tx),
	.keypad_TL(keypad_TL),
	.keypad_TR(keypad_TR),
	.keypad_LL(keypad_LL),
	.keypad_LR(keypad_LR),
	.button_bigButton(button));
keypad_mem keypad_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(keypad_en), .q(keypad_out), .sda(sda), .scl(scl), .leds(keypad_leds));
morse_mem morse_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(morse_en), .morse_led(morse_led), .sevseg1(morse_sevseg1), .sevseg2(morse_sevseg2));
wire_mem wires_mem(.data(data), .addr(addr), .clk(clk), .en(wires_en), .q(wires_out));
extras_mem extras_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(extra_en), .q(extra_out), .sevseg1(timer_sevseg1), .sevseg2(timer_sevseg2), .sevseg3(timer_sevseg3), .leds(strike_leds));

mux5 output_mux(.a(ram_out), .b(button_out), .c(keypad_out), .d(wires_out), .e(extra_out), .sel(output_sel), .out(q));

always @ (posedge clk) begin
	if (en) begin
		if(addr >= 16'h0000 && addr < 16'hC000) begin
			ram_en <= 1;
			button_en <= 0;
			keypad_en <= 0;
			morse_en <= 0;
			wires_en <= 0;
			extra_en <=0;
			output_sel <= 3'b000;
		end
		else if(addr >= 16'hc000 && addr < 16'hcccc) begin
			ram_en <= 0;
			button_en <= 1;
			keypad_en <= 0;
			morse_en <= 0;
			wires_en <= 0;
			extra_en <=0;
			output_sel <= 3'b001;
		end
		else if(addr >= 16'hcccc && addr < 16'hd998) begin
			ram_en <= 0;
			button_en <= 0;
			keypad_en <= 1;
			morse_en <= 0;
			wires_en <= 0;
			extra_en <=0;
			output_sel <= 3'b010;
		end
		else if(addr >= 16'hd998 && addr < 16'he664) begin
			ram_en <= 0;
			button_en <= 0;
			keypad_en <= 0;
			morse_en <= 1;
			wires_en <= 0;
			extra_en <=0;
		end
		else if(addr >= 16'he664 && addr < 16'hf330) begin
			ram_en <= 0;
			button_en <= 0;
			keypad_en <= 0;
			morse_en <= 0;
			wires_en <= 1;
			extra_en <=0;
			output_sel <= 3'b011;
		end
		else if(addr >= 16'hf330 && addr < 16'hfffc) begin
			ram_en <= 0;
			button_en <= 0;
			keypad_en <= 0;
			morse_en <= 0;
			wires_en <= 0;
			extra_en <= 1;
			output_sel <= 3'b100;
		end
	end
	else begin
		ram_en <= 0;
		button_en <= 0;
		keypad_en <= 0;
		morse_en <= 0;
		wires_en <= 0;
		extra_en <= 0;
	end
end
endmodule
