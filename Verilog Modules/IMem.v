module IMem( input[7:0] Address, output reg [7:0] Instruction , input Reset );
reg [7:0] imem [0:256];

always @ ( * )
begin
	Instruction = imem[Address];
end

always @ ( Reset )
begin
	if( Reset )
	begin
		imem[0] <= 8'b00100111;	//	mov R4,R7
		imem[1] <= 8'b01100001;	//	sll R4,1
		imem[2] <= 8'b00111100;	//	mov R7,R4
        	imem[3] <= 8'b11000001;	//	j L1
		imem[4] <= 8'b01111011;	//	sll R7,3
        	imem[5] <= 8'b00001111;	//	L1: mov R1,R7
	end
end

endmodule


