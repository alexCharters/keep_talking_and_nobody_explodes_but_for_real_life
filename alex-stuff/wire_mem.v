module wire_mem(data, addr, en, re, clk, q);   //, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input clk, en, re;
//input		ADC_SDO;
//
//output	ADC_CONVST;
//output	ADC_SCK;
//output	ADC_SDI;


output reg [15:0] q;

reg [11:0] ch [7:0];

//adc_controller adc(.clk(clk),
//	.ADC_CONVST(ADC_CONVST),
//	.ADC_SCK(ADC_SCK),
//	.ADC_SDI(ADC_SDI),
//	.ADC_SDO(ADC_SDO),
//	.ch(ch)
//	);


always @ (posedge clk)
	begin
		if(en & re) begin
			if(addr >= 16'he664 && addr < 16'he886) begin
				q <= ch[0];
			end
			else if(addr >= 16'he886 && addr < 16'heaa8) begin
				q <= ch[1];
			end
			else if(addr >= 16'heaa8 && addr < 16'hecca) begin
				q <= ch[2];
			end
			else if(addr >= 16'hecca && addr < 16'heeec) begin
				q <= ch[3];
			end
			else if(addr >= 16'heeec && addr < 16'hf10e) begin
				q <= ch[4];
			end
			else if(addr >= 16'hf10e && addr < 16'hf330) begin
				q <= ch[5];
			end
		end
	end


endmodule
