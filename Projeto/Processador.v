module Processador();
	
//Ciclos ---------------------------------------

	UpCount Counter (Clear, Clock, Ciclo);
	assign opcode = IR[9:6];
	dec3to8 decX (IR[5:3], 1'b1, Xreg);
	dec3to8 decY (IR[2:0], 1'b1, Yreg);
	
	parameter mv   = 4'b0000;
	parameter mvi  = 4'b0001;
	parameter add  = 4'b0011;
	parameter sub  = 4'b0100;
	parameter orr  = 4'b0101;
	parameter slt  = 4'b0110;
	parameter sll  = 4'b0111;
	parameter slr  = 4'b1000;
	
	always @(Ciclo or opcode or Xreg or Yreg) begin
		//initial values
		
			R_out      = 8'b0;
			R_in       = 8'b0;
			Done       = 1'b0;
			A_in       = 1'b0;
			G_in       = 1'b0;
			G_out      = 1'b0;
			Din_out    = 1'b0;
			//IR_in      = 1'b0;
			
		case (ciclo)
			2'b00: begin // store DIN in IR in time step 0
				IRin = 1'b1;
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
			end
		endcase
	end
	
	
	
	regn reg_0();
	regn reg_1();
	regn reg_2();
	regn reg_3();
	regn reg_4();
	regn reg_5();
	regn reg_6();
	regn reg_7();	
	regn reg_A();
	regn reg_G();
	regi reg_IR()
	
endmodule