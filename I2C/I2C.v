module I2C(clk, SCL, SDA, address, rw, data, dataReady, CS);
input clk, dataReady;
input [7:0] data;
input [6:0] address;
input rw;
output reg SCL;
inout SDA;
output reg  [5:0] CS;

reg direction;
reg inp;
wire outp;
reg [7:0] addrw;

reg  [5:0] NS;
parameter [5:0] idle=1, start=2, stopBegin=3, stopEnd=4, pause = 5, setSlave=6, pauseSetSlave=7, holdSlave=8, ackBeginStage=9, ackHoldStage=10, setData=11, pauseSetData=12, holdData=13;

reg [5:0] counter;

bidirec b1(.oe(direction), .clk(clk), .inp(inp), .outp(outp), .bidir(SDA));

initial begin
 CS <= idle;
 direction = 1'b1;
 inp <= 1'b1;
 counter <= 7;
end

always @ (*) begin
	case(CS) 
		idle: begin
			NS <= dataReady ? start : idle;
			direction <= 1;
			inp <= 1'b1;
			SCL <= 1'b1;
			addrw <= {address, rw};
		end
		start: begin
			NS <= pause;
			inp <= 1'b0;
			SCL <= 1'b1;
			counter <= 7;
			direction <= 1;
		end
		pause: begin
			NS <= setSlave;
			inp <= 1'b0;
			SCL <= 1'b1;
		end
		setSlave: begin
			NS <= pauseSetSlave;
			
			SCL <= 1'b0;
			inp <= addrw[counter];
		end
		pauseSetSlave: begin
			NS <= holdSlave;
			
			SCL <= 1'b0;
			inp <= addrw[counter];
			if (counter == 6'b111111) direction <= 0;
		end
		holdSlave: begin
			NS <= (counter == 6'b111111) ? ackBeginStage : setSlave;
			SCL <= 1'b1;
			inp <= addrw[counter];
			counter = counter - 1;
			end
		ackBeginStage: begin
			NS <= ackHoldStage;
			SCL <= 0;
			inp<=1'b0;
		end
		ackHoldStage: begin
			//NS <= start;
			NS <= (SDA == 1'b0) ? setData : stopBegin;
			if(outp == 1'b0) $display("acknowledged");
			else $display("not acknowledged");
			counter <= 7;
			inp<=1'b0;
		end
		setData: begin
			direction<=1;
			NS <= pauseSetData;
			SCL <= 1'b0;
			inp <= data[counter];
			if (counter == 6'b111111) direction <= 0;
		end
		pauseSetData: begin
			NS <= holdData;
			
			SCL <= 1'b0;
			inp <= data[counter];
		end
		holdData: begin
			NS <= (counter == 6'b111111) ? stopBegin : setData;
			SCL <= 1'b1;
			inp <= data[counter];
			counter = counter - 1;
			end
		
		
		
		
		stopBegin: begin
			NS <= stopEnd;
			inp <= 0;
			SCL <= 1;
			direction <= 1;
		end
		stopEnd: begin
			NS <= idle;
			inp <= 1;
			SCL <= 1;
			direction <= 1;
		end
	endcase
	
end

always @ (posedge clk) begin
	CS <= NS;
end

endmodule
