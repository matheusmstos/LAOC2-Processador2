module Processor
	(
		input [15:0] DIN,
		input Clock, Resetn, Run,

		output reg Done,
		output [15:0] Buswires,
		output [1:0] Ciclo,
		output reg C0, C1
	);

	reg [7:0] R_in, R_out;
	reg IR_in, A_in, G_in, G_out, Din_out;

	wire [8:0] IR;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G, ALUresult;
	wire [7:0] Xreg, Yreg;
	wire [2:0] opcode;
	wire Clear = Done | Resetn;//Done | Resetn;

//-----------------------------------------------
	regn reg_0(Buswires, R_in[0], Clock, R0);
	regn reg_1(Buswires, R_in[1], Clock, R1);
	regn reg_2(Buswires, R_in[2], Clock, R2);
	regn reg_3(Buswires, R_in[3], Clock, R3);
	regn reg_4(Buswires, R_in[4], Clock, R4);
	regn reg_5(Buswires, R_in[5], Clock, R5);
	regn reg_6(Buswires, R_in[6], Clock, R6);
	regn reg_7(Buswires, R_in[7], Clock, R7);
	regn reg_A(Buswires, A_in, Clock, A);
	regn reg_G(Buswires, G_in, Clock, G);
	regi reg_IR(DIN[8:0], IR_in, Clock, IR);

	ALU alu (A, Buswires, opcode, ALUresult);

	Multiplexador mulx(R0,R1,R2,R3,R4,R5,R6,R7,DIN,G,R_out,G_out,Din_out,Buswires);

//Ciclos ---------------------------------------

	Upcount Counter (Clock, Clear, Ciclo);
	assign opcode = IR[8:6];
	dec3to8 decX (IR[5:3], 1'b1, Xreg);
	dec3to8 decY (IR[2:0], 1'b1, Yreg);

	parameter mv   = 3'b000;
	parameter mvi  = 3'b001;
	parameter add  = 3'b010;
	parameter sub  = 3'b011;
	parameter orr  = 3'b100;
	parameter slt  = 3'b101;
	parameter sll  = 3'b110;
	parameter slr  = 3'b111;

	always @(Ciclo or opcode or Xreg or Yreg) begin
		//initial values

		R_out      = 8'b0;
		R_in       = 8'b0;
		Done       = 1'b0;
		A_in       = 1'b0;
		G_in       = 1'b0;
		G_out      = 1'b0;
		Din_out    = 1'b0;
		IR_in      = 1'b0;

		case (Ciclo)
			2'b00: begin // store DIN in IR in time step 0
				IR_in = 1'b1;
			end

			2'b01: begin //define signals in time step 1

				case (opcode)
					mv: begin
						R_in  = Xreg;
						R_out = Yreg;
						Done = 1'b1;
					end

					mvi: begin
						R_in  = Xreg;
						Din_out = 1'b1;
						Done = 1'b1;
					end

					add, sub, orr, slt, sll, slr: begin
						R_out = Xreg;
						A_in = 1'b1; //solicita escrita
					end

				endcase
			end

			2'b10: begin //define signals in time step 2

				case (opcode)
					add, sub, orr, slt, sll, slr: begin
						R_out = Yreg;
						G_in = 1'b1;
					end
				endcase
			end

			2'b11: begin //define signals in time step 3

				case (opcode)
					add, sub, orr, slt, sll, slr: begin
						R_in  = Xreg;
						G_out = 1'b1;
						Done = 1'b1;
					end
				endcase
			end

		endcase
	end

endmodule

module Processador
 	(
	 	input [17:0] SW,
		input [3:0]	KEY,

		output [17:0] LEDR,
		output [8:0] LEDG,
		output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
	);

	wire [15:0] Buswires;
	wire [15:0] DIN;
	wire [5:0] AdressOut;

	wire [15:0] MemOut;
	wire Done;
	wire Run;
	wire [1:0] Ciclo;
	wire [15:0]R0, R1, R2, R3;
	wire PClock;
	wire MClock;

	assign PClock = ~KEY[0];
	assign MClock = ~KEY[1];
	
	CounterPC c1  (MClock, SW[16], AdressOut);
	ramlpm    mem (AdressOut, MClock, MemOut);
	Processor pc1 (MemOut, PClock, SW[16], SW[17], Done, Buswires, Ciclo, R0, R1);
	
	//CounterPC   (MClock, Resetn,n)
	//ROMLPM		  (n,MemoryClock,data)
	//Processor   (data,PClock,Resetn,Run,BusWires,Done)
	
	assign LEDR[15:0] = Buswires[15:0];
	assign LEDG[8] = Done;


	/*
	Display d7 (Buswires[15:12], 	 HEX7);
	Display d6 ({1'b0,Ciclo[2:0]}, HEX6);
	
	Display d5 ({2'b00,AdressOut[5:4]},HEX5);
	Display d4 (AdressOut[3:0], 	 HEX4);
	
	Display d3 (MemOut[15:12], 	 HEX3);
	Display d2 (MemOut[11:8], 		 HEX2);
	Display d1 (MemOut[7:4], 		 HEX1);
	Display d0 (MemOut[3:0], 		 HEX0);
	
	
*/

	Display d7 (MClock, HEX7);
	Display d6 (PClock, HEX6);
	
	Display d5 (Ciclo, HEX5);
	Display d4 (AdressOut[3:0], 	 HEX4);
	
	Display d3 (R0[3:0], 	 HEX3);
	Display d2 (R1[3:0], 		 HEX2);
	Display d1 (MemOut[7:4], 		 HEX1);
	Display d0 (MemOut[3:0], 		 HEX0);


endmodule
