module morse_blink(clk, data, set, morse_led, reset, debug_leds);
input clk, set, reset;
input [15:0] data;
output reg morse_led;
output [9:0] debug_leds;
wire slow_clock;

morse_divider div(clk, slow_clock);

parameter IDLE=0, DATA_CAPTURE=1, TIMER_START=2, LED_SHOW=3, FINISH = 4;

reg [2:0] CS, NS;

reg [31:0] seq_len;
reg [59:0] seq;
reg [31:0] counter;
reg [31:0] timer;

reg reduce_counter, reduce_timer, set_timer, set_counter;


//each part represented by 2 bits:
//00: dot
//01: dash
//11: letter pause

//each word has 1 letter pause at the start and two at the end
assign debug_leds = counter[9:0];//timer[9:0];

initial begin 
CS <= IDLE;
NS <= IDLE;
timer <= 0;
counter <= 0;
morse_led <= 0;
end


always@(*) begin
	//timer = 0;
	//counter = 0;
	morse_led = morse_led;
	case(CS)
		IDLE: begin
			morse_led = 0;
			set_timer = 1'b0;
			reduce_timer = 1'b0;
			reduce_counter = 1'b0;
			set_counter = 1'b0;
			if(set)
				NS = DATA_CAPTURE;
			else
				NS = IDLE;
		end
		DATA_CAPTURE: begin
			morse_led = 0;
			set_timer = 1'b0;
			reduce_timer = 1'b0;
			reduce_counter = 1'b0;
			set_counter = 1'b1;
			NS = TIMER_START;
			if(~reset)
				NS = IDLE;
		end
		TIMER_START: begin
			morse_led = 0;
			
			set_timer = 1'b1;
			reduce_timer = 1'b0;
			reduce_counter = 1'b0;
			set_counter = 1'b0;
			
			NS = LED_SHOW;
			if(~reset)
				NS = IDLE;
		end
		LED_SHOW: begin
			set_timer = 1'b0;
			reduce_timer = 1'b0;
			reduce_counter = 1'b0;
			set_counter = 1'b0;
		   $display(seq[counter -: 2]);
			case(seq[counter -: 2])
				2'b00: begin
					if(timer>5000000)
						morse_led = 1'b1;
					else
					    morse_led = 1'b0;
				end
				2'b01: begin
					if(timer>5000000)
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
			set_timer = 1'b0;
			reduce_timer = 1'b1;
			reduce_counter = 1'b1;
			set_counter = 1'b0;
			morse_led = morse_led;
			if(~reset) begin
				NS = IDLE;
			end
			else begin
				NS = (timer != 0)?LED_SHOW:TIMER_START;
			end
		end
		default: begin
			set_timer = 1'b0;
			NS = IDLE;
		end
	endcase
end

always@(posedge clk) begin
	if(set_counter) begin
		case(data)
			1: begin
				seq <= 60'b1100000011000000001100110001000011000100001111;
				seq_len <= 45;
				counter <= 45;
			end
			2: begin
				seq <= 60'b1100000011000000001100110001000011000100001111;
				seq_len <= 45;
				counter <= 45;
			end
			3: begin
				seq <= 60'b1100000011000000001100110001000011000100001111;
				seq_len <= 45;
				counter <= 45;
			end
			4: begin
				seq <= 60'b1100000011000000001100110001000011000100001111;
				seq_len <= 45;
				counter <= 45;
			end
			default: begin
				seq <= 60'b1100000011000000001100110001000011000100001111;
				seq_len <= 45;
				counter <= 45;
			end
		endcase
	end
	else if(reduce_counter)
		counter <= (timer != 0)?counter:(counter == 1)?seq_len:counter - 2'b10;
	else
		counter <= counter;
		
	
	if (set_timer) begin
		case(seq[counter -: 2])
			2'b00: timer = 10000000;
			2'b01: timer = 20000000;
			2'b11: timer = 12000000;
			default: begin
				$display(seq[counter -: 2]);
				timer = 0;
			end
		endcase
	end
	else if(reduce_timer) begin
		timer <= (timer == 0)?0:timer - 1'b1;
	end
	else begin
		timer <= timer;
	end

	if(~reset)
		CS<=IDLE;
	else
		CS<=NS;
end


endmodule
