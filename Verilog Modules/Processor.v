module Processor (input Reset,input Clk,output [7:0] Register [0:7]);

// The main Pipeline Registers
reg [7:0] PC;
reg [7:0] IF_ID;
reg [19:0] ID_EX;
reg [20:0] EX_WB;

//on reset we make all registers to value 0
always @ (posedge Reset)
begin
	PC    <= 0;
	IF_ID <= 0;
	ID_EX <= 0;
	EX_WB <= 0;
end

// All wire connections declarations
/*
	a Signal can persists in pipeline for multiple stages
		Signal_ID is the same signal in instruction decode stage
		Signal_EX is the signal in execute stage
		Signal_WB is the same signal in write back stage
*/
wire [7:0] NextAddress; 	// Next Address Calculation
wire [7:0] Instruction;
wire [1:0] Opcode;
wire [2:0] Rsrc;
wire [2:0] Rdst;
wire [2:0] Shamt_ID,Shamt_EX;
wire [5:0] JumpOffset;
wire [7:0] JumpOffsetExtended;
wire [2:0] ReadRegAddr_ID,ReadRegAddr_EX;
wire [2:0] WriteRegAddr_ID,WriteRegAddr_EX,WriteRegAddr_WB;
wire [7:0] ReadRegData_ID,ReadRegData_EX;
wire [7:0] WriteRegData_WB;
wire [7:0] Operand_EX,Operand_WB;
wire [7:0] Result_EX,Result_WB;
wire WriteEnable_ID,WriteEnable_EX,WriteEnable_WB;
wire WriteRegDataSelect_ID,WriteRegDataSelect_EX,WriteRegDataSelect_WB;
wire AluSelect_ID,AluSelect_EX;
wire ReadRegAddrSelect_ID;
wire IsJump_ID;
wire ForwardingSelect;

/*
	Format ::::
	StageName stage start
		combinational logic relating to that stage only
	StageName stage end
*/

// IF stage start
	IMem IMEM (PC,Instruction,Reset);	// Only Instruction Memory is there in IF stage
// IF stage end

// ID stage start
	// Instruction to Instruction Fields
	assign {Opcode,Rdst,Rsrc} = IF_ID;
	assign Shamt_ID = Rsrc;
	assign JumpOffset = IF_ID[5:0];

	assign ReadRegAddr_ID = ((ReadRegAddrSelect_ID)?Rsrc:Rdst);		// Select register to read

	assign NextAddress = ((IsJump_ID)?JumpOffsetExtended:8'b1) + PC;	// Calculation of jump address for next instruction

	assign WriteRegAddr_ID = Rdst;		// address of writing register for writeback stage

	SignExtend SIGNEXTEND (JumpOffset,JumpOffsetExtended);	// signextend jump offset

	// 2 Important modules of processor below , ControlUnit and RegFile
	ControlUnit CONTROLUNIT (Opcode,IsJump_ID,ReadRegAddrSelect_ID,AluSelect_ID,WriteRegDataSelect_ID,WriteEnable_ID);
	RegFile REGFILE (ReadRegAddr_ID,ReadRegData_ID,WriteRegAddr_WB,WriteRegData_WB,WriteEnable_WB,Clk,Reset,Register);
// ID stage end

// EX stage start
	// Take Appropritate Signals From ID_EX stage for computation in EX stage
	assign {Shamt_EX,WriteRegAddr_EX,ReadRegAddr_EX,ReadRegData_EX,AluSelect_EX,WriteRegDataSelect_EX,WriteEnable_EX} = ID_EX;

	// The Operand of ALU is selected by the forwarding unit
	// we can use either data read from reg file or write data from writeback stage
	assign Operand_EX = ((ForwardingSelect)?ReadRegData_EX:WriteRegData_WB);

	// The main module of EX stage is ALU
	Alu ALU (Operand_EX,Shamt_EX,Result_EX,AluSelect_EX);

	// The Forwarding unit Assists EX stage to execute instruction with RAW,EX-EX data dependency 
	ForwardingUnit FORWARDINGUNIT (WriteEnable_WB,WriteRegAddr_WB,ReadRegAddr_EX,ForwardingSelect);
// EX stage end

// WB stage start
	// Take Appropriate signals from EX_WB pipeline register for computation in Writeback stage
	assign {WriteRegAddr_WB,Operand_WB,Result_WB,WriteRegDataSelect_WB,WriteEnable_WB} = EX_WB;

	// The Register file declared above is given with Signals from Write back stage to write to register file
	// The Write data can be Result of ALU for sll instruction
	// or ALU operand for mov instruction, which is selected by WriteRegDataSelect_WB which was earlier generated by controlunit
	assign WriteRegData_WB = ((WriteRegDataSelect_WB)?Result_WB:Operand_WB);
// WB stage end

// Forward all pipeline registers with corresponding signals every clock
always @ (posedge Clk)
begin
  PC    <= {NextAddress};
  IF_ID <= ((IsJump_ID)?8'b10000000:Instruction); // We require a stall every jump, 0x80 is a NOP
  ID_EX <= {Shamt_ID,WriteRegAddr_ID,ReadRegAddr_ID,ReadRegData_ID,AluSelect_ID,WriteRegDataSelect_ID,WriteEnable_ID};
  EX_WB <= {WriteRegAddr_EX,Operand_EX,Result_EX,WriteRegDataSelect_EX,WriteEnable_EX};
end

endmodule
