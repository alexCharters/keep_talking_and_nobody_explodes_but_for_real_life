module sevseg(bin,sev);
     
     //Declare inputs,outputs and internal variables.
     input [3:0] bin;
     output reg [6:0] sev;

//always block for converting bcd digit into 7 segment format
    always @(bin)
    begin
        case (bin) //case statement
            0 : sev = 7'b1000000;
            1 : sev = 7'b1111001;
            2 : sev = 7'b0100100;
            3 : sev = 7'b0110000;
            4 : sev = 7'b0011001;
            5 : sev = 7'b0010010;
            6 : sev = 7'b0000010;
            7 : sev = 7'b1111000;
            8 : sev = 7'b0000000;
            9 : sev = 7'b0010000;
				10 : sev = 7'b0001000;
				11 : sev = 7'b0000011;
				12 : sev = 7'b1000110;
				13 : sev = 7'b0100001;
				14 : sev = 7'b0000110;
				15 : sev = 7'b0001110;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : sev = 7'b1111111; 
        endcase
    end
endmodule
	 