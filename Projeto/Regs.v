module regn(R, Rin, Clock, Q)
	input [15:0] R;
	input	Rin;
	input Clock;
	
	output reg [15:0]Q;
	
	initial begin 
		Q = 16'b0;
	end
	
	always @(posedge Clock) begin
		if(Rin) begin
			Q <= R;
		end
	end
endmodule

module regi()