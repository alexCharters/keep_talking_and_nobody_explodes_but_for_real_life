module oled_i2c(
	clk,
	//data,
	SCL,
	SDA,
	dataReady,
	rst,
	debug_leds
);
input clk, dataReady, rst;
//input [7:0] data;
output SCL;
output [8:0] debug_leds;
inout SDA;
parameter [7:0] data = 8'b00000001;
parameter [6:0] address = 7'b1010010;
parameter rw = 1'b0;



wire divClk;

reg [6:0] cmd_address;
reg cmd_start, cmd_read, cmd_write, cmd_write_multiple, cmd_valid, cmd_stop;
reg [7:0] data_in;
reg data_in_valid, data_in_last, data_out_ready;
wire data_out_valid;
wire scl_i, sda_i;
reg [15:0] prescale;
reg stop_on_idle;

wire cmd_ready, data_in_ready, data_out_last;
wire [7:0] data_out;
wire scl_o, scl_t, sda_o, sda_t;
wire busy, bus_control, bus_active, missed_ack;
wire [4:0] state;

reg [4:0] CS, NS;

reg [247:0] glyph1 [0:33];
initial $readmemb("glyph1.txt", glyph1);

reg isStartSeq;
reg packetEnded;
reg [31:0] data_counter;
reg [31:0] data_packet_counter;
reg [31:0] data_byte_counter;
reg [31:0] packet_wait_counter;
reg [31:0] packet_start_counter;

parameter [4:0] idle = 0, begin_seq=1, end_seq=2, begin_data=3, end_data=4, start_data=5;

assign scl_i = SCL;
assign SCL = scl_o;
assign sda_i = SDA;
assign SDA = (state == 5'b00110 || state == 5'b01001 || state == 5'b00111 || state == 5'b00001) ? 1'bz : sda_o;

assign debug_leds = {data_counter, CS[1:0]};

divider div(.clock(clk), .en(divClk));

I2C
U1 (
    .clk(divClk),
    .rst(1'b0),
    .cmd_address(cmd_address),
    .cmd_start(cmd_start),
    .cmd_read(cmd_read),
    .cmd_write(cmd_write),
    .cmd_write_multiple(cmd_write_multiple),
    .cmd_stop(cmd_stop),
    .cmd_valid(cmd_valid),
    .cmd_ready(cmd_ready),
    .data_in(data_in),
    .data_in_valid(data_in_valid),
    .data_in_ready(data_in_ready),
    .data_in_last(data_in_last),
    .data_out(data_out),
    .data_out_valid(data_out_valid),
    .data_out_ready(data_out_ready),
    .data_out_last(data_out_last),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .busy(busy),
    .bus_control(bus_control),
    .bus_active(bus_active),
    .missed_ack(missed_ack),
    .prescale(prescale),
    .stop_on_idle(stop_on_idle),
	 .state(state)
	 //.debug_leds(debug_leds)
);

initial begin
	cmd_address = 7'b0111100;
	cmd_start = 1'b1;
	cmd_read = 1'b0;
	cmd_write = 1'b0;
	cmd_write_multiple = 1'b1;
	cmd_stop = 1'b0;
	cmd_valid = 1'b1;
	data_in = 8'b00000000;
	data_in_valid = 1'b1;
	prescale = 0;
	stop_on_idle = 0;
	data_counter = 0;
	isStartSeq = 1'b0;
	data_byte_counter = 0;
	data_packet_counter = 0;
	packet_wait_counter = 0;
	packet_start_counter = 0;
	CS = idle;
	NS = idle;
end

always@(*) begin
	cmd_address = 7'b0111100;
	//cmd_start = 1'b1;
	cmd_read = 1'b0;
	cmd_write = 1'b0;
	cmd_write_multiple = 1'b1;
	cmd_stop = 1'b0;
	cmd_valid = 1'b1;
	data_in_valid = 1'b1;
	prescale = 0;
	stop_on_idle = 0;
	
	if(data_in_ready) cmd_start = 0;
	
	case(CS)
		idle: begin
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b0;
			cmd_valid = 1'b0;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 0;
			NS = (dataReady)?begin_seq:idle;
			cmd_start = (dataReady)?1'b1:1'b0;
		end
		begin_seq: begin
			isStartSeq = 1'b1;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b1;
			cmd_stop = 1'b0;
			cmd_valid = 1'b1;
			data_in_valid = 1'b1;
			prescale = 0;
			stop_on_idle = 0;
			NS=(data_counter==27)?end_seq:begin_seq;
		end
		end_seq: begin
			isStartSeq = 1'b1;
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b1;
			cmd_valid = 1'b0;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 0;
			NS =(packet_wait_counter == 500000)?start_data:end_seq;
			cmd_start = (dataReady)?1'b1:1'b0;
		end
		begin_data: begin
			isStartSeq = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b1;
			cmd_stop = 1'b0;
			cmd_valid = 1'b1;
			data_in_valid = 1'b1;
			prescale = 0;
			stop_on_idle = 0;
			packetEnded = 1'b0;
			NS=(data_byte_counter==240&&data_in_ready)?end_data:begin_data;
		end
		end_data: begin
			isStartSeq = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b1;
			cmd_valid = 1'b1;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 0;
			packetEnded=1'b1;
			NS = (packet_wait_counter==500000)?start_data:end_data;
			cmd_start = 1'b0;
		end
		start_data: begin
			isStartSeq = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b1;
			cmd_stop = 1'b0;
			cmd_valid = 1'b1;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 0;
			packetEnded=1'b1;
			NS = (packet_start_counter==500000)?begin_data:(data_packet_counter == 33)?idle:start_data;
			cmd_start = 1'b1;
		end
		default: begin
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b0;
			cmd_valid = 1'b0;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 0;
			NS = idle;
			cmd_start = (dataReady)?1'b1:1'b0;
		end
	endcase
		
	if(isStartSeq) begin
		case(data_counter)
			1: data_in = 8'h00;
			2: data_in = 8'hAE;
			3: data_in = 8'hD5;
			4: data_in = 8'h80;
			5: data_in = 8'hA8;
			6: data_in = 8'h3F;
			7: data_in = 8'hD3;
			8: data_in = 8'h00;
			9: data_in = 8'h40;
			10: data_in = 8'h8D;
			11: data_in = 8'h14;
			12: data_in = 8'h20;
			13: data_in = 8'h00;
			14: data_in = 8'hA1;
			15: data_in = 8'hC8;
			16: data_in = 8'hDA;
			17: data_in = 8'h12;
			18: data_in = 8'h81;
			19: data_in = 8'hCF;
			20: data_in = 8'hD9;
			21: data_in = 8'hF1;
			22: data_in = 8'hD8;
			23: data_in = 8'h40;
			24: data_in = 8'hA4;
			25: data_in = 8'hA6;
			26: data_in = 8'h2E;
			27: data_in = 8'hAF;
			28: data_in = 8'h00;
			29: data_in = 8'h22;
			30: data_in = 8'h00;
			31: data_in = 8'hFF;
			32: data_in = 8'h21;
			33: data_in = 8'h7F;
			default: data_in = 8'hAA;
		endcase
	end
	else begin
		case(data)
			0: data_in = 8'h00;
			1: data_in = glyph1[data_packet_counter][data_byte_counter+7 -: 7];
			// 2: data_in = glyph2[data_packet_counter][data_byte_counter+7 -: 7];
			// 3: data_in = glyph3[data_packet_counter][data_byte_counter+7 -: 7];
			// 4: data_in = glyph4[data_packet_counter][data_byte_counter+7 -: 7];
			// 5: data_in = glyph5[data_packet_counter][data_byte_counter+7 -: 7];
			// 6: data_in = glyph6[data_packet_counter][data_byte_counter+7 -: 7];
			// 7: data_in = glyph7[data_packet_counter][data_byte_counter+7 -: 7];
			// 8: data_in = glyph8[data_packet_counter][data_byte_counter+7 -: 7];
			// 9: data_in = glyph9[data_packet_counter][data_byte_counter+7 -: 7];
			// 10: data_in = glyph10[data_packet_counter][data_byte_counter+7 -: 7];
			// 11: data_in = glyph11[data_packet_counter][data_byte_counter+7 -: 7];
			// 12: data_in = glyph12[data_packet_counter][data_byte_counter+7 -: 7];
			// 13: data_in = glyph13[data_packet_counter][data_byte_counter+7 -: 7];
			// 14: data_in = glyph14[data_packet_counter][data_byte_counter+7 -: 7];
			// 15: data_in = glyph15[data_packet_counter][data_byte_counter+7 -: 7];
			// 16: data_in = glyph16[data_packet_counter][data_byte_counter+7 -: 7];
			// 17: data_in = glyph17[data_packet_counter][data_byte_counter+7 -: 7];
			// 18: data_in = glyph18[data_packet_counter][data_byte_counter+7 -: 7];
			// 19: data_in = glyph19[data_packet_counter][data_byte_counter+7 -: 7];
			// 20: data_in = glyph20[data_packet_counter][data_byte_counter+7 -: 7];
			// 21: data_in = glyph21[data_packet_counter][data_byte_counter+7 -: 7];
			// 22: data_in = glyph22[data_packet_counter][data_byte_counter+7 -: 7];
			// 23: data_in = glyph23[data_packet_counter][data_byte_counter+7 -: 7];
			// 24: data_in = glyph24[data_packet_counter][data_byte_counter+7 -: 7];
			// 25: data_in = glyph25[data_packet_counter][data_byte_counter+7 -: 7];
			// 26: data_in = glyph26[data_packet_counter][data_byte_counter+7 -: 7];
			// 27: data_in = glyph27[data_packet_counter][data_byte_counter+7 -: 7];
			default: data_in= 0;
		endcase
	end
	
end

always@(posedge data_in_ready or posedge packetEnded) begin
	if(~rst) begin
		if(packetEnded) begin
			data_packet_counter = data_packet_counter+1;
			data_byte_counter = 0;
		end
		else begin
			data_counter = (CS != begin_seq) ? 1 : data_counter+1'b1;
			data_byte_counter = (CS != begin_data) ? 0 : data_byte_counter+8;
		end
	end
	else begin
		data_counter = 1'b0;
		data_byte_counter = 1'b0;
	end
	
end

always@(posedge clk) begin
	CS <= NS;
	packet_wait_counter = (CS==end_data || CS==end_seq)?packet_wait_counter+1:0;
	packet_start_counter = (CS==start_data)?packet_start_counter+1:0;
	
	if(rst) begin
		packet_wait_counter <= 0;
		packet_start_counter <= 0;
		CS <= idle;
	end
end

endmodule
