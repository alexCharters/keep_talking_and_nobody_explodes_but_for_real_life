module morse_blink(clk, data, set, morse_led, reset);
input clk, set, reset;
input [15:0] data;
output reg morse_led;

parameter IDLE=0, DATA_CAPTURE=1, TIMER_START=2, LED_SHOW=3, FINISH = 4;

reg [2:0] CS, NS;

reg [31:0] seq_len;
reg [59:0] seq;
reg [31:0] counter;
reg [31:0] timer;

//each part represented by 2 bits:
//00: dot
//01: dash
//11: letter pause

//each word has 1 letter pause at the start and two at the end

initial begin 
CS <= IDLE;
NS <= IDLE;
timer <= 0;
counter <= 0;
end


always@(*) begin
	timer = timer;
	seq = seq;
	seq_len = 45;
	counter = counter;
	morse_led = morse_led;
	case(CS)
		IDLE: begin
			counter = 0;
			timer = 0;
			if(set)
				NS = DATA_CAPTURE;
			else
				NS = IDLE;
		end
		DATA_CAPTURE: begin
			counter = 0;
			case(data)
				1: begin
					seq = 60'b1100000011000000001100110001000011000100001111;
					seq_len = 45;
					counter = 45;
				end
				2: begin
					seq = 60'b1100000011000000001100110001000011000100001111;
					seq_len = 45;
					counter = 45;
				end
				3: begin
					seq = 60'b1100000011000000001100110001000011000100001111;
					seq_len = 45;
					counter = 45;
				end
				4: begin
					seq = 60'b1100000011000000001100110001000011000100001111;
					seq_len = 45;
					counter = 45;
				end
				default: begin
					seq = 60'b1100000011000000001100110001000011000100001111;
					seq_len = 45;
					counter = 45;
				end
			endcase
			timer = 0;
			NS = TIMER_START;
			if(~reset)
				NS = IDLE;
		end
		TIMER_START: begin
			counter = counter;
			case(seq[counter -: 2])
				2'b00: timer = 10000;
				2'b01: timer = 20000;
				2'b11: timer = 20000;
				default: begin
					$display(seq[counter -: 2]);
					timer = 0;
				end
			endcase
			NS = LED_SHOW;
			if(~reset)
				NS = IDLE;
		end
		LED_SHOW: begin
			timer = timer;
			counter = counter;
		   $display(seq[counter -: 2]);
			case(seq[counter -: 2])
				2'b00: begin
					if(timer>5000)
						morse_led = 1'b1;
					else
					    morse_led = 1'b0;
				end
				2'b01: begin
					if(timer>5000)
						morse_led = 1'b1;
					else
					    morse_led = 1'b0;
				end
				2'b11: morse_led = 1'b0;
				default: begin
					morse_led = 1'b0;
					$display("reeeeeeee");
				end
							
			endcase
			NS = FINISH;
			if(~reset)
				NS = IDLE;
		end
		FINISH: begin
			timer = timer - 1'b1;
			NS = (timer != 0)?LED_SHOW:TIMER_START;
			counter = (timer != 0)?counter:(counter == 1)?seq_len:counter-2'b10;
			if(~reset)
				NS = IDLE;
		end
		default: begin
			timer = 0;
			counter = 0;
			NS = IDLE;
		end
	endcase
end

always@(posedge clk) begin
	if(~reset)
		CS<=IDLE;
	else
		CS<=NS;
end


endmodule
