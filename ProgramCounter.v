module ProgramCounter(clock, reset, enable, incOrSet, newValue, index);
    input clock, reset, enable, incOrSet;
    input [15:0] newValue;
    output reg [15:0] index;
    always @ (posedge clock) begin
        if(reset == 1'b0) begin
            index <= 0;
        end
        else if(enable == 1'b1) begin
            if(incOrSet == 1'b0)
                index <= index + 16'b1;
            else
                index <= newValue;
        end
    end
endmodule