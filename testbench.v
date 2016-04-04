// The testbench for the CPU
// Programming is done by editing memory.v


`include "simplecpu.v"
`include "memory.v"


module test();
   reg clk;
   wire READ;
   wire WRITE;
   wire [8:0] DATA;
   wire [8:0] D;
   wire [5:0] A;

   simplecpu CPU(.clk(clk), .D(D[8:0]), .READ(READ), .WRITE(WRITE), .A(A[5:0]), .DATA(DATA[8:0]));
   memory M(.READ(READ), .WRITE(WRITE), .DATA(DATA[8:0]), .A(A[5:0]), .D(D[8:0]));

   initial begin
	  clk = 1;
	  $dumpvars();
	  #1000 $finish;
   end

   always #1 clk = ~clk;
endmodule // test
