module RegFile  (  
		input [2:0] ReadRegAddr,output reg [7:0] ReadRegData,
		input [2:0] WriteRegAddr,input reg [7:0] WriteRegData,
		input WriteEnable,
		input Clk,input Reset,
		output reg [7:0] Register [0:7]
		);
// All the 8 registers are provided with a port outside of module
// so that that they can be tapped to check for all possible changes
// 2 dimensional porting may not be available in certain tool chains

always @ ( * )
begin
	ReadRegData = Register[ReadRegAddr];	// reading data from RegFile
end

always @ ( * )
begin
	Register[WriteRegAddr] <= ( ( WriteEnable & Clk ) ? WriteRegData : Register[WriteRegAddr] );
	// Writing data to RegFile when required conditions are met
end

always @ ( * )
begin
	if( Reset )
	begin
		Register[0] <= 8'b00000000;
		Register[1] <= 8'b00000001;
		Register[2] <= 8'b00000010;
		Register[3] <= 8'b00000011;
		Register[4] <= 8'b00000100;
		Register[5] <= 8'b00000101;
		Register[6] <= 8'b00000110;
		Register[7] <= 8'b00000111;
	end
end

endmodule

