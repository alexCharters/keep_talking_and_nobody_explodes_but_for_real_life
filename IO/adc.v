module adc_controller(
	clk, // max 40mhz
	
	// adc interface
	ADC_CONVST,
	ADC_SCK,
	ADC_SDI,
	ADC_SDO,
	ch0,
    ch1,
    ch2,
    ch3,
    ch4,
    ch5
);

input	clk;

// start measure
reg 	measure_start;
reg	[2:0]	measure_ch;
wire	measure_done;
wire	[11:0] measure_dataread;

output reg [11:0] ch0;
output reg [11:0] ch1;
output reg [11:0] ch2;
output reg [11:0] ch3;
output reg [11:0] ch4;
output reg [11:0] ch5;



output	ADC_CONVST;
output	ADC_SCK;
output   ADC_SDI;
input		ADC_SDO;

adc_ltc2308 adc(.clk(clk),
	.measure_start(measure_start),
	.measure_ch(measure_ch),
	.measure_done(measure_done),
	.measured_data(measure_dataread),
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO) );
	
initial begin
	measure_ch <= 3'b000;
	measure_start <= 1'b0;
end
	
always@ (posedge clk) begin
	if(measure_done) begin
    case(measure_ch)
        0: ch0 <= measure_dataread;
        1: ch1 <= measure_dataread;
        2: ch2 <= measure_dataread;
        3: ch3 <= measure_dataread;
        4: ch4 <= measure_dataread;
        5: ch5 <= measure_dataread;
    endcase
	end
end

always @(posedge measure_done) begin
	measure_ch <= (measure_ch == 5)?1'b0:measure_ch + 1'b1;
end

endmodule
