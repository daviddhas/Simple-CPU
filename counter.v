// Contains various counters required in the CPU


module counter5bit(input CLK, LD, INC, CLR, input wire [4:0] DATA, output reg [4:0] STATE);
   // 5-bit counter for the hardwired control unit
   always @(negedge CLK) begin
	  if(CLR)      STATE[4:0] <= 5'b00000;
	  else if(LD)  STATE[4:0] <= DATA[4:0];
	  else if(INC) STATE[4:0] <= STATE[4:0]+1;
   end
endmodule // counter5bit


module counter6bit(input CLK, LD, INC, CLR, input wire [5:0] DATA, output reg [5:0] STATE);
   // 6-bit counter for the program counter
   always @(negedge CLK) begin
	  if(CLR)      STATE[5:0] <= 6'b000000;
	  else if(LD)  STATE[5:0] <= DATA[5:0];
	  else if(INC) STATE[5:0] <= STATE[5:0]+1;
   end
endmodule // counter6bit


module counter9bit(input CLK, LD, INC, CLR, input wire [8:0] DATA, output reg [8:0] STATE);
   // 9-bit counter for the accumulator
   always @(negedge CLK) begin
	  if(CLR)      STATE[8:0] <= 9'b000000000;
	  else if(LD)  STATE[8:0] <= DATA[8:0];
	  else if(INC) STATE[8:0] <= STATE[8:0]+1;
   end
endmodule // counter9bit
