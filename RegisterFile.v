//Register file for default style of cr16 (16bit regs, 16 regs)
module RegisterFile
	#(parameter WIDTH = 16, REGISTER_BITS = 4)
	(clock, reset, shouldWrite, register1Address, register2Address, writeAddress, writeData, register1Data, register2Data);
	input clock, reset, shouldWrite;
	input [(WIDTH - 1) : 0] writeData;
	input [(REGISTER_BITS - 1) : 0] register1Address, register2Address, writeAddress;
	//This is setup so if we want to use slightly larger values we can 
	reg [(WIDTH-1):0] DataBlock [(1 << REGISTER_BITS) - 1: 0];
	output [(WIDTH-1) : 0] register1Data, register2Data;
	//Set the regfile to respond to pos clock edge for handling read and writes
	integer i = 0;
	always @ (posedge clock) begin
		if(reset == 0) begin
			for(i = 0; i <= (1 << REGISTER_BITS) - 1; i = i + 1)
				DataBlock[i] = 0;
		end

		if(shouldWrite)
			DataBlock[writeAddress] <= writeData;
	end
	/* 
		if either address requests for register 0, we simply put a zero back on the line.
		Otherwise, fetch the data from the DataBlock and put that value on the respective output
	*/
	assign register1Data = (register1Address == 0 ? 0 : DataBlock[register1Address]);
	assign register2Data = (register2Address == 0 ? 0 : DataBlock[register2Address]);
endmodule
