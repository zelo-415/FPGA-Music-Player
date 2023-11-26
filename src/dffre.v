module dffre (d, en, r, clk, q);
	parameter n=1;
	input [n-1:0]d;
	input en,r,clk;
	output [n-1:0]q=0;
	reg [n-1:0]q;
	always @(posedge clk )
	begin
		if (r==1) q=0;
		else if (r==0&&en==1) q=d;
	end

endmodule