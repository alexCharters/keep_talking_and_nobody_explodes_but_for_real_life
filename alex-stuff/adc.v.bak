module adc_controller(
	clk, // max 40mhz
	
	// adc interface
	ADC_CONVST,
	ADC_SCK,
	ADC_SDI,
	ADC_SDO,
	ch
);

input	clk;

// start measure
reg 	measure_start;
reg	[2:0]	measure_ch;
wire	measure_done;
wire	[11:0] measure_dataread;

output reg [11:0] ch [7:0];



output	ADC_CONVST;
output	ADC_SCK;
output	reg ADC_SDI;
input		ADC_SDO;

adc_ltc2308 adc(.clk(clk),
	.measure_start(measure_start),
	.measure_ch(measure_ch),
	.measure_done(measure_done),
	.measure_dataread(measure_dataread),
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO) );
	
initial begin
	measure_ch <= 3'b000;
	measure_start <= 1'b0;
end
	
always@ (posedge clk) begin
	ch[measure_ch] <= measure_dataread;
	measure_ch <= measure_ch + 1;
end

endmodule
