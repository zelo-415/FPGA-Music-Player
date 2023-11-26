module mcu(clk, reset, play_pause, next, play, song, reset_play, song_done);
	input clk, reset, play_pause, next, song_done;
	output reg play, reset_play;
	output reg [1:0] song;
	parameter RESET=0, PAUSE=1, PLAY=2, NEXT=3; 
	reg NextSong;
	reg [1:0] state, nextstate;
	// 第一段-时序电路：2位二进制计数器
	always @(posedge clk)
	begin
		if (reset) begin song=0; state = RESET; end
		else
		begin
			state = nextstate;
			if (NextSong) song = (song+1)%4;
		end
	end
	
	// 第二段-组合电路：下一状态和输出电路
	always @(*)
	begin
		case(state)
			RESET:
			begin
				nextstate = PAUSE;
				play = 0;
				NextSong = 0;
				reset_play = 1;
			end
			PAUSE:
			begin
				if(play_pause) nextstate = PLAY;
				else if(next) nextstate = NEXT;
				else nextstate = PAUSE;
				play = 0;
				NextSong = 0;
				reset_play = 0;
			end
			PLAY:
			begin
				if(play_pause) nextstate = PAUSE;
				else if(next) nextstate = NEXT;
				else if(song_done) nextstate = RESET;
				else nextstate = PLAY;
				play = 1;
				NextSong = 0;
				reset_play = 0;
			end
			NEXT:
			begin
				nextstate = PLAY;
				play = 0;
				NextSong = 1;
				reset_play = 1;
			end
		endcase
	end
endmodule