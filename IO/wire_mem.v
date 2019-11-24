module wire_mem(data, addr, en, clk, q, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input clk, en;
input		ADC_SDO;

output	ADC_CONVST;
output	ADC_SCK;
output	ADC_SDI;


output reg [15:0] q;

wire [11:0] ch0;
wire [11:0] ch1;
wire [11:0] ch2;
wire [11:0] ch3;
wire [11:0] ch4;
wire [11:0] ch5;

adc_controller adc(.clk(clk),
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO),
	.ch0(ch0),
	.ch1(ch1),
	.ch2(ch2),
	.ch3(ch3),
	.ch4(ch4),
	.ch5(ch5)
	);


always @ (*) begin
		case(addr[10:8])
			3'b000: q <= ch0;
			3'b001: q <= ch1;
			3'b010: q <= ch2;
			3'b011: q <= ch3;
			3'b100: q <= ch4;
			3'b101: q <= ch5;
			default: q <= 16'hAAAA;
		endcase
//			if(addr >= 16'he664 && addr < 16'he886) begin
//				q <= ch[0];
//			end
//			else if(addr >= 16'he886 && addr < 16'heaa8) begin
//				q <= ch[1];
//			end
//			else if(addr >= 16'heaa8 && addr < 16'hecca) begin
//				q <= ch[2];
//			end
//			else if(addr >= 16'hecca && addr < 16'heeec) begin
//				q <= ch[3];
//			end
//			else if(addr >= 16'heeec && addr < 16'hf10e) begin
//				q <= ch[4];
//			end
//			else if(addr >= 16'hf10e && addr < 16'hf330) begin
//				q <= ch[5];
//			end
//		end
end


endmodule
