module oled_i2c(clk, data, SCL, SDA, CS);
input clk;
input [7:0] data;
output [5:0] CS;
output SCL;
inout SDA;
parameter [6:0] address = 7'b1010010;
parameter rw = 1'b0;

wire divClk;

divider div(.clock(clk), .en(divClk));
I2C U1(.clk(divClk), .SCL(SCL), .SDA(SDA), .address(address), .rw(rw), .data(data), .dataReady(1'b1), .CS(CS));

endmodule
