module oled_i2c(clk, data, SCL, SDA, dataReady, rst, debug_leds);
input clk, dataReady, rst;
input [7:0] data;
output SCL;
output [8:0] debug_leds;
inout SDA;
parameter [6:0] address = 7'b1010010;
parameter rw = 1'b0;

wire divClk;

reg [6:0] cmd_address;
reg cmd_start, cmd_read, cmd_write, cmd_write_multiple, cmd_valid, cmd_stop;
reg [7:0] data_in;
reg data_in_valid, data_in_last, data_out_ready;
wire scl_i, sda_i;
reg [15:0] prescale;
reg stop_on_idle;

wire cmd_ready, data_in_ready, data_out_last;
wire [7:0] data_out;
wire scl_o, scl_t, sda_o, sda_t;
wire busy, bus_control, bus_active, missed_ack;
wire [4:0] state;

assign scl_i = SCL;
assign SCL = scl_o;
assign sda_i = SDA;
assign SDA = (state == 5'b00110) ? 1'bz : sda_o;



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
	 .state(state),
	 .debug_leds(debug_leds)
);

initial begin
	cmd_address = 7'b1010010;
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
end

always@(posedge clk) begin
	cmd_address = 7'b1010010;
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
end

endmodule
