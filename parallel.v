// Various memory elements with only parallel load
// ability, required in the CPU


module parallel3bit(input CLK, LD, input wire [2:0] DATA, output reg[2:0] STATE);
   // 3-bit instruction register
   // Positive edge triggered to load data ahead of time.
   // Code does not work otherwise!
   // (Because then the register loads its value at the same time the input changes)
   always @(posedge CLK) begin
	  if(LD) STATE[2:0] = DATA[2:0];
   end
endmodule // parallel3bit


module parallel6bit(input CLK, LD, input wire [5:0] DATA, output reg[5:0] STATE);
   // 6-bit address register
   always @(negedge CLK) begin
	  if(LD) STATE[5:0] = DATA[5:0];
   end
endmodule // parallel6bit


module parallel9bit(input CLK, LD, input wire [8:0] DATA, output reg[8:0] STATE);
   // 9-bit data register
   always @(negedge CLK) begin
	  if(LD) STATE[8:0] = DATA[8:0];
   end
endmodule // parallel9bit
