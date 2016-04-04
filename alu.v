// The ALU with three operations: ADD, AND and SUB


module ALU(input wire [1:0] SEL, input wire [8:0] AC, input wire [8:0] DR, output ALUCARRY, output wire [8:0] OUT);
   // If SEL = 00, ADD
   // If SEL = 01, SUB
   // If SEL = 10, AND
   // IF SEL = 11, invalid, we go with AND
   assign {ALUCARRY, OUT[8:0]} = (SEL == 2'b00) ? AC[8:0] + DR[8:0] :
							  (SEL == 2'b01) ? AC[8:0] - DR[8:0] :
							  AC[8:0] & DR[8:0];
endmodule // ALU
