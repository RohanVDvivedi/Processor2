module Alu (input [7:0] Operand,input [2:0] Shamt,output reg [7:0] Result,input AluSelect);

always @ ( * )
begin
  Result = ( (AluSelect) ? (Operand << Shamt) : 8'bz );
end

endmodule

