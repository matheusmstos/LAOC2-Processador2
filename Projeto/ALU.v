module ALU
	(	input [15:0] A,
		input [15:0] b,
		input [2:0] op,

		output reg [15:0] result
	);

	parameter add  = 3'b010;
	parameter sub  = 3'b011;
	parameter orr  = 3'b100;
	parameter slt  = 3'b101;
	parameter sll  = 3'b110;
	parameter slr  = 3'b111;

	always @(A or b or op) begin
		case(op)
			add: result = A + b;
			sub: result = A - b;
      orr: result = A | b;
			slt: if(A < b)result = 16'b1; else result = 16'b0;
			sll: result = A << b;
			slr: result = A >> b;
		endcase
	end

endmodule
