module mux5 (a, b, c, d, e, sel, out);
parameter DATA_WIDTH=16;

input [DATA_WIDTH-1:0] a, b, c, d, e;
input [2:0] sel;
output reg [DATA_WIDTH-1:0] out;

   always @ (*) begin
      case (sel)
         3'b000 : out <= a;
         3'b001 : out <= b;
         3'b010 : out <= c;
         3'b011 : out <= d;
			3'b100 : out <= e;
			default: out <= {DATA_WIDTH{1'b0}};
      endcase
   end
endmodule