module lfsr_rng
   #(parameter BITS = 11)
   (
    input             clk,
    input             rst_n,

    output reg [BITS-1:0] data
    );

   wire [BITS-1:0] data_next;
	
	initial begin
		data <= 5'h1f;
	end
	
   assign data_next = {(data[BITS-1]^data[2]), data[BITS-1:1]};


   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
         data <= 5'h1f;
      else
         data <= data_next;
   end

endmodule