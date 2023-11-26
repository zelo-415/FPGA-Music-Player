module music_player (clk, reset, play_pause, next, NewFrame, sample, play, song);
	parameter sim=0;
	
	input clk, reset, play_pause, next, NewFrame;
	output [15:0] sample;
	output play;
	output [1:0] song;
	
	wire reset_play, song_done, note_done, new_note, ready, beat;
	wire [5:0] note, duration;
	
	mcu mcu1(.clk(clk), .reset(reset), .play_pause(play_pause), .next(next), .play(play), .song(song), .reset_play(reset_play), .song_done(song_done));
	song_reader song_reader1(.clk(clk), .reset(reset_play), .play(play), .song(song), .note_done(note_done), .song_done(song_done), .note(note), .duration(duration), .new_note(new_note));
	simul simul1(.clk(clk), .in(NewFrame), .out(ready));
	if (sim) counter_n #(.counter_bits(6),.n(64)) c1(.clk(clk), .r(0), .en(ready), .co(beat), .q());
	else counter_n #(.counter_bits(10),.n(1000)) c1(.clk(clk), .r(0), .en(ready), .co(beat), .q());
	note_player note_player1(.clk(clk), .reset(reset_play), .play_enable(play), .note_to_load(note), .duration_to_load(duration), .load_new_note(new_note), .note_done(note_done), .sampling_pulse(ready), .beat(beat), .sample(sample), .sample_ready());
	
endmodule