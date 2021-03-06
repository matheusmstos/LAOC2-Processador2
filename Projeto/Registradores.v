module regn
	(
		input [15:0] R,
		input	Rin,
		input Clock,
    
		output reg [15:0]Q
	);

	initial begin
		Q = 16'b0000000000000010;
	end

	always @(posedge Clock) begin
		if(Rin) begin
			Q <= R;
		end
	end
endmodule

module regi
	(
		input [8:0] R,
		input	Rin,
		input Clock,
		
		output reg [8:0]Q
	);

	initial begin
		Q = 9'b0;
	end

	always @(posedge Clock) begin
		if(Rin) begin
			Q <= R;
		end
	end
endmodule
