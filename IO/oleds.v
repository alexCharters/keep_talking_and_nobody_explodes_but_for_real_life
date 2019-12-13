module oleds(
	clk,
	data,
	SCL,
	SDA,
	dataReady,
	rst,
	address_sel
);
input clk, dataReady, rst;
input [15:0] data;
output SCL;
inout SDA;
//parameter [7:0] data = 8'b00000001;
parameter [6:0] address1 = 7'b0111100;
parameter [6:0] address2 = 7'b0111101;
parameter rw = 1'b0;
input address_sel;

wire [6:0]address;

assign address = (address_sel)?address2:address1;

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

//reg [255:0] glyph1 [0:31];
//reg [255:0] glyph2 [0:31];
//reg [255:0] glyph3 [0:31];
//reg [255:0] glyph4 [0:31];
//reg [255:0] glyph5 [0:31];
//reg [255:0] glyph6 [0:31];
//reg [255:0] glyph7 [0:31];
//reg [255:0] glyph8 [0:31];
//reg [255:0] glyph9 [0:31];
//reg [255:0] glyph10 [0:31];
//reg [255:0] glyph11 [0:31];
//reg [255:0] glyph12 [0:31];
//reg [255:0] glyph13 [0:31];
//reg [255:0] glyph14 [0:31];
//reg [255:0] glyph15 [0:31];
//reg [255:0] glyph16 [0:31];
//reg [255:0] glyph17 [0:31];
//reg [255:0] glyph18 [0:31];
//reg [255:0] glyph19 [0:31];
//reg [255:0] glyph20 [0:31];
//reg [255:0] glyph21 [0:31];
//reg [255:0] glyph22 [0:31];
//reg [255:0] glyph23 [0:31];
//reg [255:0] glyph24 [0:31];
//reg [255:0] glyph25 [0:31];
//reg [255:0] glyph26 [0:31];
//reg [255:0] glyph27 [0:31];
//reg [255:0] glyph28 [0:31];
//reg [255:0] glyph29 [0:31];
//reg [255:0] glyph30 [0:31];


reg isStartSeq;
reg packetEnded;
reg [5:0] data_counter;
reg [6:0] data_packet_counter;
reg [31:0] data_byte_counter;
reg [31:0] packet_wait_counter;
reg [31:0] packet_start_counter;

parameter [4:0] idle = 0, begin_seq=1, end_seq=2, begin_data=3, end_data=4, start_data=5;

assign scl_i = SCL;
assign SCL = scl_o;
assign sda_i = SDA;
assign SDA = (state == 5'b00110 || state == 5'b01001 || state == 5'b00001) ? 1'bz : sda_o;

reg [15:0] data_latch;
reg [6:0] address_latch;

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
	stop_on_idle = 1;
	data_counter = 1;
	isStartSeq = 1'b0;
	data_byte_counter = 0;
	data_packet_counter = 0;
	packet_wait_counter = 0;
	packet_start_counter = 0;
	packetEnded = 0;
	CS = idle;
	NS = idle;
	
//	$readmemb("glyph1.txt", glyph1);
//	$readmemb("glyph2.txt", glyph2);
//	$readmemb("glyph3.txt", glyph3);
//	$readmemb("glyph4.txt", glyph4);
//	$readmemb("glyph5.txt", glyph5);
//	$readmemb("glyph6.txt", glyph6);
//	$readmemb("glyph7.txt", glyph7);
//	$readmemb("glyph8.txt", glyph8);
//	$readmemb("glyph9.txt", glyph9);
//	$readmemb("glyph10.txt", glyph10);
//	$readmemb("glyph11.txt", glyph11);
//	$readmemb("glyph12.txt", glyph12);
//	$readmemb("glyph13.txt", glyph13);
//	$readmemb("glyph14.txt", glyph14);
//	$readmemb("glyph15.txt", glyph15);
//	$readmemb("glyph16.txt", glyph16);
//	$readmemb("glyph17.txt", glyph17);
//	$readmemb("glyph18.txt", glyph18);
//	$readmemb("glyph19.txt", glyph19);
//	$readmemb("glyph20.txt", glyph20);
//	$readmemb("glyph21.txt", glyph21);
//	$readmemb("glyph22.txt", glyph22);
//	$readmemb("glyph23.txt", glyph23);
//	$readmemb("glyph24.txt", glyph24);
//	$readmemb("glyph25.txt", glyph25);
//	$readmemb("glyph26.txt", glyph26);
//	$readmemb("glyph27.txt", glyph27);
//	$readmemb("glyph28.txt", glyph28);
//	$readmemb("glyph29.txt", glyph29);
//	$readmemb("glyph30.txt", glyph30);
end

always@(*) begin
	cmd_address = address_latch;
	cmd_start = 1'b1;
	isStartSeq = 1'b0;
	cmd_read = 1'b0;
	cmd_write = 1'b0;
	cmd_write_multiple = 1'b1;
	cmd_stop = 1'b0;
	cmd_valid = 1'b1;
	data_in_valid = 1'b1;
	prescale = 0;
	stop_on_idle = 1;
	
	if(data_in_ready) cmd_start = 0;
	
	case(CS)
		idle: begin
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b0;
			cmd_valid = 1'b0;
			data_in_last = 1'b0;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded = 1'b0;
			NS = (dataReady)?begin_seq:idle;
			cmd_start = (dataReady)?1'b1:1'b0;
		end
		begin_seq: begin
			isStartSeq = 1'b1;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = (data_counter==34)?1'b0:1'b1;
			data_in_last = (data_counter==34)?1'b1:1'b0;
			cmd_stop = (data_counter==34)?1'b1:1'b0;
			cmd_valid = 1'b1;
			data_in_valid = 1'b1;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded = 1'b0;
			NS=(~bus_active && data_counter>33)?end_seq:begin_seq;
		end
		end_seq: begin
			isStartSeq = 1'b1;
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b1;
			cmd_valid = 1'b1;
			data_in_last = 1'b1;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded = 1'b0;
			NS =(packet_wait_counter == 100000)?start_data:end_seq;
			cmd_start = 1'b0;
		end
		begin_data: begin
			isStartSeq = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = (data_byte_counter==264)?1'b0:1'b1;
			data_in_last = (data_byte_counter==264)?1'b1:1'b0;
			cmd_stop = (data_byte_counter==264)?1'b1:1'b0;
			cmd_valid = 1'b1;
			data_in_valid = 1'b1;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded = 1'b0;
			NS=(~bus_active && data_byte_counter>263)?end_data:begin_data;
		end
		end_data: begin
			isStartSeq = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			data_in_last = 1'b1;
			cmd_stop = 1'b1;
			cmd_valid = 1'b1;
			data_in_valid = 1'b0;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded=1'b1;
			NS = (packet_wait_counter==100000)?start_data:(data_packet_counter == 34)?idle:end_data;
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
			data_in_last = 1'b0;
			prescale = 0;
			stop_on_idle = 1;
			packetEnded=1'b1;
			//NS = (packet_start_counter==500000)?begin_data:(data_packet_counter == 33)?idle:start_data;
			NS = (packet_start_counter==500)?begin_data:start_data;
			cmd_start = 1'b1;
		end
		default: begin
			cmd_start = 1'b0;
			cmd_read = 1'b0;
			cmd_write = 1'b0;
			cmd_write_multiple = 1'b0;
			cmd_stop = 1'b0;
			cmd_valid = 1'b0;
			data_in_last = 1'b1;
			data_in_valid = 1'b0;
			prescale = 0;
			packetEnded = 0;
			stop_on_idle = 1;
			NS = idle;
			cmd_start = (dataReady)?1'b1:1'b0;
		end
	endcase
		
	if(isStartSeq) begin
		case(data_counter)
			2: data_in = 8'h00;
			3: data_in = 8'hAE;
			4: data_in = 8'hD5;
			5: data_in = 8'h80;
			6: data_in = 8'hA8;
			7: data_in = 8'h3F;
			8: data_in = 8'hD3;
			9: data_in = 8'h00;
			10: data_in = 8'h40;
			11: data_in = 8'h8D;
			12: data_in = 8'h14;
			13: data_in = 8'h20;
			14: data_in = 8'h00;
			15: data_in = 8'hA1;
			16: data_in = 8'hC8;
			17: data_in = 8'hDA;
			18: data_in = 8'h12;
			19: data_in = 8'h81;
			20: data_in = 8'hCF;
			21: data_in = 8'hD9;
			22: data_in = 8'hF1;
			23: data_in = 8'hDB;
			24: data_in = 8'h40;
			25: data_in = 8'hA4;
			26: data_in = 8'hA6;
			27: data_in = 8'h2E;
			28: data_in = 8'hAF;
			29: data_in = 8'h22;
			30: data_in = 8'h00;
			31: data_in = 8'hFF;
			32: data_in = 8'h21;
			33: data_in = 8'h00;
			34: data_in = 8'h7F;
			default: data_in = 8'hAA;
		endcase
	end
	else begin
		case(data_latch)
//			0: data_in = (data_byte_counter==8)?8'h40:8'hAA;
//			1: data_in = (data_byte_counter==8)?8'h40:glyph1[data_packet_counter][data_byte_counter-9 -: 8];
//			2: data_in = (data_byte_counter==8)?8'h40:glyph2[data_packet_counter][data_byte_counter-9 -: 8];
//			3: data_in = (data_byte_counter==8)?8'h40:glyph3[data_packet_counter][data_byte_counter-9 -: 8];
//			4: data_in = (data_byte_counter==8)?8'h40:glyph4[data_packet_counter][data_byte_counter-9 -: 8];
//			5: data_in = (data_byte_counter==8)?8'h40:glyph5[data_packet_counter][data_byte_counter-9 -: 8];
//			6: data_in = (data_byte_counter==8)?8'h40:glyph6[data_packet_counter][data_byte_counter-9 -: 8];
//			7: data_in = (data_byte_counter==8)?8'h40:glyph7[data_packet_counter][data_byte_counter-9 -: 8];
//			8: data_in = (data_byte_counter==8)?8'h40:glyph8[data_packet_counter][data_byte_counter-9 -: 8];
//			9: data_in = (data_byte_counter==8)?8'h40:glyph9[data_packet_counter][data_byte_counter-9 -: 8];
//			10: data_in = (data_byte_counter==8)?8'h40:glyph10[data_packet_counter][data_byte_counter-9 -: 8];
//			11: data_in = (data_byte_counter==8)?8'h40:glyph11[data_packet_counter][data_byte_counter-9 -: 8];
//			12: data_in = (data_byte_counter==8)?8'h40:glyph12[data_packet_counter][data_byte_counter-9 -: 8];
//			13: data_in = (data_byte_counter==8)?8'h40:glyph13[data_packet_counter][data_byte_counter-9 -: 8];
//			14: data_in = (data_byte_counter==8)?8'h40:glyph14[data_packet_counter][data_byte_counter-9 -: 8];
//			15: data_in = (data_byte_counter==8)?8'h40:glyph15[data_packet_counter][data_byte_counter-9 -: 8];
//			16: data_in = (data_byte_counter==8)?8'h40:glyph16[data_packet_counter][data_byte_counter-9 -: 8];
//			17: data_in = (data_byte_counter==8)?8'h40:glyph17[data_packet_counter][data_byte_counter-9 -: 8];
//			18: data_in = (data_byte_counter==8)?8'h40:glyph18[data_packet_counter][data_byte_counter-9 -: 8];
//			19: data_in = (data_byte_counter==8)?8'h40:glyph19[data_packet_counter][data_byte_counter-9 -: 8];
//			20: data_in = (data_byte_counter==8)?8'h40:glyph20[data_packet_counter][data_byte_counter-9 -: 8];
//			21: data_in = (data_byte_counter==8)?8'h40:glyph21[data_packet_counter][data_byte_counter-9 -: 8];
//			22: data_in = (data_byte_counter==8)?8'h40:glyph22[data_packet_counter][data_byte_counter-9 -: 8];
//			23: data_in = (data_byte_counter==8)?8'h40:glyph23[data_packet_counter][data_byte_counter-9 -: 8];
//			24: data_in = (data_byte_counter==8)?8'h40:glyph24[data_packet_counter][data_byte_counter-9 -: 8];
//			25: data_in = (data_byte_counter==8)?8'h40:glyph25[data_packet_counter][data_byte_counter-9 -: 8];
//			26: data_in = (data_byte_counter==8)?8'h40:glyph26[data_packet_counter][data_byte_counter-9 -: 8];
//			27: data_in = (data_byte_counter==8)?8'h40:glyph27[data_packet_counter][data_byte_counter-9 -: 8];
//			28: data_in = (data_byte_counter==8)?8'h40:glyph28[data_packet_counter][data_byte_counter-9 -: 8];
//			29: data_in = (data_byte_counter==8)?8'h40:glyph29[data_packet_counter][data_byte_counter-9 -: 8];
//			30: data_in = (data_byte_counter==8)?8'h40:glyph30[data_packet_counter][data_byte_counter-9 -: 8];
			default: data_in= (data_byte_counter==8)?8'h40:8'hAA;
		endcase
	end
	
end

always@(posedge data_in_ready or posedge packetEnded) begin
	if(packetEnded) begin
		data_byte_counter = 0;
		//data_counter = (CS != begin_seq) ? 1 : data_counter+1'b1;
	end
	else begin
		data_counter = (CS != begin_seq) ? 1'b1 : data_counter+1'b1;
		data_byte_counter = (CS != begin_data) ? 0 : data_byte_counter+8;
		//data_packet_counter = data_packet_counter;
	end
end

always@(posedge packetEnded) begin
	data_packet_counter = (data_packet_counter==34)?7'b0:data_packet_counter+1'b1;
end

always@(negedge dataReady) begin
	data_latch <= data;
	address_latch <= address;
end

always@(posedge clk) begin
	CS <= NS;
	packet_wait_counter <= (CS==end_data || CS==end_seq)?packet_wait_counter+1:0;
	packet_start_counter <= (CS==start_data)?packet_start_counter+1:0;
	
	if(rst) begin
		packet_wait_counter <= 0;
		packet_start_counter <= 0;
		CS <= idle;
	end
end

endmodule
