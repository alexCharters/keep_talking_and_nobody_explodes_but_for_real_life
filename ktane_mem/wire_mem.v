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

reg [11:0] ch1, ch2, ch3, ch4, ch5, ch6, ch7, ch0;

adc_controller adc(.clk(clk),
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO),
	.ch0(ch0), .ch1(ch1), .ch2(ch2), .ch3(ch3), .ch4(ch4), .ch5(ch5), .ch6(ch6), .ch7(ch7)
	);


always @ (posedge clk)
	begin
		if(en) begin
			if(addr >= 16'he664 && addr < 16'he886) begin
				q <= {2'h00, ch0[15:3]};
			end
			else if(addr >= 16'he886 && addr < 16'heaa8) begin
				q <= {2'h00, ch1[15:3]};
			end
			else if(addr >= 16'heaa8 && addr < 16'hecca) begin
				q <= {2'h00, ch2[15:3]};
			end
			else if(addr >= 16'hecca && addr < 16'heeec) begin
				q <= {2'h00, ch3[15:3]};
			end
			else if(addr >= 16'heeec && addr < 16'hf10e) begin
				q <= {2'h00, ch4[15:3]};
			end
			else if(addr >= 16'hf10e && addr < 16'hf330) begin
				q <= {2'h00, ch5[15:3]};
			end
		end
	end


endmodule
