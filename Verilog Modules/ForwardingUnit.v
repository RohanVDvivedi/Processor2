module ForwardingUnit
	(
		input WriteEnable_WB,
		input [2:0] WriteRegAddr_WB,
		input [2:0] ReadRegAddr_EX,
		output reg ForwardingSelect
	);

// ForwardingSelect == 0 then WriteRegData_WB is used as operand for ALU
// else  ReadRegData_EX is used as operand for ALU

always @ ( * )
begin
	if( WriteRegAddr_WB == ReadRegAddr_EX && WriteEnable_WB )
	begin
		ForwardingSelect = 0;
	end
	else
	begin
		ForwardingSelect = 1;
	end
end

endmodule 

