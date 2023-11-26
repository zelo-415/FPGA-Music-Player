module counter_n (clk, r, en, co, q);
	parameter counter_bits=1, n=2;
	input clk, r, en;
	output co;
	output [counter_bits:1] q;
	wire co;
	reg [counter_bits:1] q=0;

	always @(posedge clk )
	begin
		if (r==1) q<=0;
		else if(en)
   begin
       if(q==(n-1))
       q=0;
       else
       q=q+1;
   end
	end
	assign co = en&&(q==n-1);
endmodule