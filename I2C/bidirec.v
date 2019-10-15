module bidirec (oe, clk, inp, outp, bidir);

// Port Declaration

input   oe;
input   clk;
input   inp;
output  outp;
inout   bidir;

reg     a;

assign bidir = oe ? a : 1'bZ ;
assign outp  = bidir;

// Always Construct

always @ (posedge clk)
begin
    a <= inp;
end

endmodule
