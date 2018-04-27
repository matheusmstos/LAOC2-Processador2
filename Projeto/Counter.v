module CounterPC
	(
		input MClock,
		input Resetn,

		output reg [4:0] n
	);


	initial begin
		n = 5'b00000;
	end

	always @(posedge MClock) begin

		if(Resetn == 1'b1) begin
			n = 5'b00000;
		end
		else begin
			n = n + 1'b1;
		end

	end

endmodule

module Upcount
	(
		input PClock,
		input Resetn,

		output reg [1:0] n
	);

	initial begin
		n = 2'b11;
	end

	always @(posedge PClock) begin

		if(Resetn == 1'b1) begin
			n = 2'b11;
		end
		else begin
			n = n + 1'b1;
		end

	end

endmodule
