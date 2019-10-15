module wire_mem(data, addr, en, clk, q);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=16;

input [(DATA_WIDTH-1):0] data;
input [(ADDR_WIDTH-1):0] addr;
input clk, en;

output reg [15:0] q;

reg [6:0] val1, val2, val3, val4, val5, val6;

//adc_read adc_wire1(.pin(3'b000), .val(val1));
//adc_read adc_wire2(.pin(3'b001), .val(val2));
//adc_read adc_wire3(.pin(3'b010), .val(val3));
//adc_read adc_wire4(.pin(3'b011), .val(val4));
//adc_read adc_wire5(.pin(3'b100), .val(val5));
//adc_read adc_wire6(.pin(3'b101), .val(val6));

always @ (posedge clk)
	begin
		if(en) begin
			if(addr >= 16'he664 && addr < 16'he886) begin
				q <= val1;
			end
			else if(addr >= 16'he886 && addr < 16'heaa8) begin
				q <= val2;
			end
			else if(addr >= 16'heaa8 && addr < 16'hecca) begin
				q <= val3;
			end
			else if(addr >= 16'hecca && addr < 16'heeec) begin
				q <= val4;
			end
			else if(addr >= 16'heeec && addr < 16'hf10e) begin
				q <= val5;
			end
			else if(addr >= 16'hf10e && addr < 16'hf330) begin
				q <= val6;
			end
		end
	end


endmodule
