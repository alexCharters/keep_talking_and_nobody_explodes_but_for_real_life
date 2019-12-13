/*
    Module to hold current instruction offset (where we are in the instruction mem!)
    The PC can also accept a new address to jump to, making branches and jumps much easier to handle.
*/
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
                index <= index + 16'b1; //increment the pc
            else
                index <= newValue; //set the pc to the new address provided.
        end
    end
endmodule