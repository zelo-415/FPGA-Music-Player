module full_adder_n(a, b, s);
	parameter n=1;
	input [n-1:0]a;
	input [n-1:0]b;
	output [n-1:0] s;
	//output reg co;
	reg [n:0] ci;
	reg [n-1:0] s;
	integer i;
	
	always @(a or b or ci)
	begin
		ci[0]=0;
		for ( i=0 ; i<n ; i=i+1)
		begin
		s[i] = a[i]^b[i]^ci[i];
		ci[i+1] = a[i]&&b[i] || a[i]&&ci[i] ||  ci[i]&&b[i] ; // 进位
		end
		//co = ci[n];
	end
	
endmodule
