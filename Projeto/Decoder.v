module dec3to8
  (
    input [2:0] W,
    input En,
		
    output reg [7:0] Y
  );

	always @(W or En) begin
		if (En == 1) begin
			case (W)
				3'b000: Y = 8'b10000000;
				3'b001: Y = 8'b01000000;
				3'b010: Y = 8'b00100000;
				3'b011: Y = 8'b00010000;
				3'b100: Y = 8'b00001000;
				3'b101: Y = 8'b00000100;
				3'b110: Y = 8'b00000010;
				3'b111: Y = 8'b00000001;
				
			endcase
		end
		else begin
			Y = 8'b00000000;
		end
	end
endmodule

module Display(Valor,Mostra);
	input [3:0]Valor;
	output reg [6:0]Mostra;
	
	always begin
		case (Valor)
				4'b0000: Mostra = 7'b1000000;			// 0
				4'b0001: Mostra =	7'b1111001;			//	1
				4'b0010: Mostra = 7'b0100100;			//	2
				4'b0011: Mostra = 7'b0110000;			//	3
				4'b0100: Mostra = 7'b0011001;			// 4
				4'b0101: Mostra = 7'b0010010;			// 5
				4'b0110: Mostra = 7'b0000010;			// 6
				4'b0111: Mostra = 7'b1011000;			// 7
				4'b1000: Mostra = 7'b0000000;			// 8 certo
				4'b1001: Mostra = 7'b0010000;			// 9
				4'b1010: Mostra = 7'b0001000;		   // A
				4'b1011: Mostra = 7'b0000011;			// B
				4'b1100: Mostra = 7'b1000110;			// C
				4'b1101: Mostra = 7'b0100001;			// D
				4'b1110: Mostra = 7'b0000110;			// E
				4'b1111: Mostra = 7'b0001110;			// F
		endcase
	end
endmodule