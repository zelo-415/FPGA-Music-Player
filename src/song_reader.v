module song_reader(clk, reset, play, song, note_done, song_done, note, duration, new_note);
	input clk, reset, play, note_done;
	input [1:0] song;
	output reg song_done, new_note;
	output [5:0] note, duration;
	
	parameter RESET=0, NEW_NOTE=1, WAIT=2, NEXT_NOTE=3;
	parameter PLAY=0, END=1;
	reg [1:0] state, nextstate;
	reg  endstate, endnextstate;// initialization is never necessary here.
	wire end_status;
	wire [6:0] song_now;
	wire [11:0] out;
	
	// 时序电路部分
	always @(posedge clk)
	begin
		if(reset)
		begin
		state = RESET;
		endstate = PLAY;
		end
		else begin 
		state = nextstate;
		endstate = endnextstate;
		end
	end
	
	// 地址计数器
	counter_n #(.counter_bits(5),.n(32)) ads_counter(.clk(clk), .r(reset), .en(note_done), .co(end_status), .q(song_now[4:0]));
	song_rom song_rom1(.clk(clk), .addr(song_now), .dout(out));	
	assign note = out[11:6];
	assign song_now[6:5] = song; // put together, instead of using methametics
	assign duration = out[5:0];
	
	// 组合电路部分
	always @(*)
	begin
		case(state)
			RESET:
			begin
				new_note = 0;
				if (play) nextstate = NEW_NOTE;
				else nextstate = RESET;
			end
			NEW_NOTE:
			begin
				new_note = 1;
				nextstate = WAIT;
			end
			WAIT:
			begin
				new_note = 0;
				if(play)
				begin
					if(note_done) nextstate = NEXT_NOTE;
					else nextstate = WAIT;
				end
				else nextstate = RESET;
			end
			NEXT_NOTE:
			begin
				new_note = 0;
				nextstate = NEW_NOTE;
			end
		endcase
		song_done=0;
		case(endstate)
			PLAY:
			begin
				if((duration==0 || end_status)&&state)
				begin
				song_done=1;
				endnextstate = END;
				//ENDFLAG<=1;
				end
				else endnextstate = PLAY;
			end
			END:
			begin
				endnextstate = END;
			end
		endcase
	end

	
endmodule 