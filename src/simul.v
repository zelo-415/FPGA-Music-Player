module simul(clk,in,out);
	input clk,in;
	output out;
	wire q1, q2;
	dffre dffre1 (.d(in), .en(1), .r(0), .clk(clk), .q(q1));
	dffre dffre2 (.d(q1), .en(1), .r(0), .clk(clk), .q(q2));
	assign out = q1*(~q2);
endmodule