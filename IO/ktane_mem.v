module ktane_mem(data,
	addr,
	we,
	clk,
	q,
	sdabutt,
	sclbutt,
	sda1,
	scl1,
	sda2,
	scl2,
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
	ADC_CONVST,
	ADC_SCK,
	ADC_SDI,
	ADC_SDO
	);
parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
//parameter data = 16'b0000000001000011;
//parameter addr = 16'hF330;
input we, clk;

input button, morse_left, morse_right, morse_tx, keypad_TL, keypad_TR, keypad_LL, keypad_LR;

output [15:0] q;
output sclbutt, scl1, scl2, morse_led;
inout sdabutt, sda1, sda2;

output [3:0] keypad_leds;
output [2:0] led1, led2, strike_leds;

output [6:0] morse_sevseg1, morse_sevseg2, timer_sevseg1, timer_sevseg2, timer_sevseg3;

wire button_en, keypad_en, morse_en, wires_en, extra_en;

reg [2:0] output_sel;


wire [15:0] ram_out, button_out, keypad_out, wires_out, extra_out;

input		ADC_SDO;

output	ADC_CONVST;
output	ADC_SCK;
output	ADC_SDI;

//dual_port_ram ram(.data(data), .read_addr(read_addr), .write_addr(write_addr), .we(we), .re(re), .clk(clk), .q(ram_out));
BlockRam br(.data(data), .addr(addr), .we(we), .clk(clk), .q(ram_out));
button_mem button_mem(
	.data(data),
	.addr(addr),
	.we(we),
	.clk(clk),
	.en(button_en),
	.q(button_out),
	.sda(sdabutt),
	.scl(sclbutt),
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
keypad_mem keypad_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(keypad_en), .q(keypad_out), .sda1(sda1), .scl1(scl1), .sda2(sda2), .scl2(scl2), .leds(keypad_leds));
morse_mem morse_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(morse_en), .morse_led(morse_led), .sevseg1(morse_sevseg1), .sevseg2(morse_sevseg2));
wire_mem wires_mem(.data(data), .addr(addr), .clk(clk), .en(wires_en), .q(wires_out), .ADC_CONVST(ADC_CONVST), .ADC_SCK(ADC_SCK), .ADC_SDI(ADC_SDI), .ADC_SDO(ADC_SDO));
extras_mem extras_mem(.data(data), .addr(addr), .we(we), .clk(clk), .en(extra_en), .q(extra_out), .sevseg1(timer_sevseg1), .sevseg2(timer_sevseg2), .sevseg3(timer_sevseg3), .leds(strike_leds));

mux5 output_mux(.a(ram_out), .b(button_out), .c(keypad_out), .d(wires_out), .e(extra_out), .sel(output_sel), .out(q));

//assign ram_en = (addr[15:14] != 2'b11);
assign button_en = (addr[15:11] == 5'b11000);
assign keypad_en = (addr[15:11] == 5'b11001);
assign morse_en = (addr[15:11] == 5'b11010);
assign wires_en = (addr[15:11] == 5'b11011);
assign extra_en = (addr[15:11] == 5'b11100 || addr[15:11] == 5'b11101|| addr[15:11] == 5'b11110 || addr[15:11] == 5'b11111);

always @(*) begin
	case(addr[15:11])
		5'b11000: output_sel = 3'b001;
		5'b11001: output_sel = 3'b010;
		5'b11011: output_sel = 3'b011;
		5'b11100: output_sel = 3'b100;
		5'b11101: output_sel = 3'b100;
		5'b11110: output_sel = 3'b100;
		5'b11111: output_sel = 3'b100;
		default: output_sel = 3'b000;
	endcase
end

//always @ (posedge clk) begin
//		if(write_addr >= 16'h0000 && write_addr < 16'hC000) begin
//			ram_en = 1;
//			button_en = 0;
//			keypad_en = 0;
//			morse_en = 0;
//			wires_en = 0;
//			extra_en =0;
//		end
//		else if(write_addr >= 16'hc000 && write_addr < 16'hcccc) begin
//			ram_en = 0;
//			button_en = 1;
//			keypad_en = 0;
//			morse_en = 0;
//			wires_en = 0;
//			extra_en =0;
//		end
//		else if(write_addr >= 16'hcccc && write_addr < 16'hd998) begin
//			ram_en = 0;
//			button_en = 0;
//			keypad_en = 1;
//			morse_en = 0;
//			wires_en = 0;
//			extra_en =0;
//		end
//		else if(write_addr >= 16'hd998 && write_addr < 16'he664) begin
//			ram_en = 0;
//			button_en = 0;
//			keypad_en = 0;
//			morse_en = 1;
//			wires_en = 0;
//			extra_en =0;
//		end
//		else if(write_addr >= 16'he664 && write_addr < 16'hf330) begin
//			ram_en = 0;
//			button_en = 0;
//			keypad_en = 0;
//			morse_en = 0;
//			wires_en = 1;
//			extra_en =0;
//		end
//		else if(write_addr >= 16'hf330 && write_addr < 16'hfffc) begin
//			ram_en = 0;
//			button_en = 0;
//			keypad_en = 0;
//			morse_en = 0;
//			wires_en = 0;
//			extra_en = 1;
//		end
//
//
//		if(read_addr >= 16'h0000 && read_addr < 16'hC000) begin
//			ram_en = 1;
//			output_sel = 3'b000;
//		end
//		else if(read_addr >= 16'hc000 && read_addr < 16'hcccc) begin
//			button_en = 1;
//			output_sel = 3'b001;
//		end
//		else if(read_addr >= 16'hcccc && read_addr < 16'hd998) begin
//			keypad_en = 1;
//			output_sel = 3'b010;
//		end
//		else if(read_addr >= 16'hd998 && read_addr < 16'he664) begin
//			morse_en = 1;
//		end
//		else if(read_addr >= 16'he664 && read_addr < 16'hf330) begin
//			wires_en = 1;
//			output_sel = 3'b011;
//		end
//		else if(read_addr >= 16'hf330 && read_addr < 16'hfffc) begin
//			extra_en = 1;
//			output_sel = 3'b100;
//		end
//end
endmodule
