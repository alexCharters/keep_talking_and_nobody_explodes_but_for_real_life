module sec_to_sevseg(sec, sevseg1, sevseg2, sevseg3);
input [16:0] sec;

output [6:0] sevseg1, sevseg2, sevseg3;

reg [3:0] val1, val2, val3;

sevseg s1(.bin(val1), .sev(sevseg1));
sevseg s2(.bin(val2), .sev(sevseg2));
sevseg s3(.bin(val3), .sev(sevseg3));

always@(*) begin
	val1 = sec/60;
	val2 = (sec-val1*60)/10;
	val3 = (sec-val1*60)-(val2*10);
end

endmodule