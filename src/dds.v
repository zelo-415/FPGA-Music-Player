 module dds(clk, k,reset, sampling_pulse, sample, new_sample_ready);
	input clk, reset, sampling_pulse;
	input  [21:0] k; 
	output [15:0] sample;
	output new_sample_ready;
	
	wire [21:0] d1, raw_addr;
	wire area;
	reg [15:0]data;
	wire [15:0] raw_data;
	reg [9:0] addr1;
	
	full_adder_n #(.n(22)) adder(.a(raw_addr), .b(k), .s(d1));
	dffre #(.n(22)) diff1(.d(d1), .en(sampling_pulse), .r(reset), .clk(clk), .q(raw_addr));
	dffre #(.n(1)) diff2(.d(raw_addr[21]), .en(1), .r(0), .clk(clk), .q(area));
	
	always @(*)
	begin
	if (raw_addr[20]==0)
		begin
		addr1 = raw_addr[19:10];
		end
	else 
		begin
		if (raw_addr[19:10]==1024)
			begin
			addr1 = 1023;
			end
		else
			begin
			addr1 = ~raw_addr[19:10]+1;
			end
		end
	end
	
	sine_rom sinerom1( .clk(clk), .addr(addr1), .dout(raw_data[15:0]));
	
	always @(*)
	begin
	if (area)
		begin
			data = ~raw_data[15:0]+1;
		end
	else
		begin
			data = raw_data[15:0];
		end
	
	end
	
	dffre #(.n(16)) diff3(.d(data), .en(sampling_pulse), .r(0), .clk(clk), .q(sample));
	dffre #(.n(1)) diff4(.d(sampling_pulse), .en(1), .r(0), .clk(clk), .q(new_sample_ready));	
	
endmodule