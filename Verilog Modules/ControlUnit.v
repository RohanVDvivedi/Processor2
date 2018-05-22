module ControlUnit (input[1:0] Opcode,output reg IsJump,output reg ReadRegAddrSelect,output reg AluSelect,output reg WriteRegDataSelect,output reg WriteEnable);

always @ ( * )
begin
  case (Opcode)
		2'b00 :// mov
		begin
			IsJump             = 1'b0;
			ReadRegAddrSelect  = 1'b1;
			AluSelect          = 1'bx;
			WriteRegDataSelect = 1'b0;
			WriteEnable        = 1'b1;
		end
		2'b01 :// sll
		begin
			IsJump             = 1'b0;
			ReadRegAddrSelect  = 1'b0;
			AluSelect          = 1'b1;
			WriteRegDataSelect = 1'b1;
			WriteEnable        = 1'b1;
		end
		2'b10 :
		begin
			IsJump             = 1'b0;
			ReadRegAddrSelect  = 1'bx;
			AluSelect          = 1'bx;
			WriteRegDataSelect = 1'bx;
			WriteEnable        = 1'b0;
		end
		2'b11 :// j
		begin
			IsJump             = 1'b1;
			ReadRegAddrSelect  = 1'bx;
			AluSelect          = 1'bx;
			WriteRegDataSelect = 1'bx;
			WriteEnable        = 1'b0;
		end
	endcase
end

endmodule

