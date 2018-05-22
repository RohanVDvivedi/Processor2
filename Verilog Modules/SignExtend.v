module SignExtend(input [5:0] In,output [7:0] Out);
	assign Out = { {2{In[5]}} ,In[5:0] };
endmodule
