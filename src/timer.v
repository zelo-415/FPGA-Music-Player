module timer (clk, r, en, done,n);
	parameter counter_bits=1;
	input clk, r, en;
	input [5:0] n;
	output done;
	
	reg [counter_bits:1] q;

	always @(posedge clk )
	begin
		if (r==1) q=0;
		else if (r==0&&en==1) q=q+1;
	end
	assign done = en&&(q==n-1);
endmodule
