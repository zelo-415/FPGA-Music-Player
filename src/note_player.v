module note_player(clk, reset, play_enable, note_to_load, duration_to_load, load_new_note, note_done, sampling_pulse, beat, sample, sample_ready);
	input clk, reset, play_enable, load_new_note, sampling_pulse, beat;
	input [5:0] note_to_load, duration_to_load;
	output reg note_done;
	output sample_ready;
	output [15:0] sample;
	
	parameter RESET=0, WAIT=1, PLAY=2, DONE=3, LOAD=4;
	reg [2:0] state, nextstate;
	reg timer_clear, load;
	wire timer_done;
	wire [19:0] k;
	wire [5:0] addr;
	
	
	always @(posedge clk)
	begin
		if(reset) state = RESET;
		else state = nextstate;
	end
	
	// d
	dffre #(.n(6)) dload (.d(note_to_load), .en(load), .r(~play_enable+reset), .clk(clk), .q(addr));
	// FreqROM
	frequency_rom FreqROM(.clk(clk), .addr(addr), .dout(k));
	// dds
	dds dds1(.clk(clk), .k({2'b00, k}), .reset(~play_enable+reset), .sampling_pulse(sampling_pulse), .sample(sample), .new_sample_ready(sample_ready));
	// 音符节拍计定时器
	timer #(.counter_bits(6)) song_timer(.clk(clk), .r(timer_clear), .en(beat), .done(timer_done),.n(duration_to_load));
	
	always @(*)
	begin
		case(state)
			RESET:
			begin
				timer_clear = 1;
				load = 0;
				note_done = 0;
				nextstate = WAIT;
			end
			WAIT:
			begin
				timer_clear = 0;
				load = 0;
				note_done = 0;
				if(play_enable)
				begin
					if(timer_done) nextstate = DONE;
					else
					begin
						if(load_new_note) nextstate = LOAD;
						else nextstate = WAIT;
					end
				end
				else nextstate = RESET;
			end
			DONE:
			begin
				timer_clear = 1;
				load = 0;
				note_done = 1;
				nextstate = WAIT;
			end
			LOAD:
			begin
				timer_clear = 1;
				load = 1;
				note_done = 0;
				nextstate = WAIT;
			end
		endcase
	end
endmodule