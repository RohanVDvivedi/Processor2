module TB();
  reg Clk,Reset;

  // Register 2 dimensional wire is used to tap into register values
  wire[7:0] Register[0:7];
  wire[7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
  assign reg0 = Register[0];
  assign reg1 = Register[1];
  assign reg2 = Register[2];
  assign reg3 = Register[3];
  assign reg4 = Register[4];
  assign reg5 = Register[5];
  assign reg6 = Register[6];
  assign reg7 = Register[7];

// two dimensional input output ports may not be available in certain toolchains    
  Processor P (Reset,Clk,Register);
  
  initial begin
    // below two lines are specific to my simulator
    $dumpfile("dump.vcd");
    $dumpvars(1);

    Clk = 0;Reset = 0;
    #1;
    Clk = 0;Reset = 1;
    #1;
    Clk = 0;Reset = 0;
    #1;
    repeat(18)
      begin
        Clk = ~Clk;
        #1;
      end

  end
  
endmodule

