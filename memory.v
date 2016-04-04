// The memory for the CPU (and the program as well)


module memory(input READ, input WRITE, input wire [8:0] DATA, input wire [5:0] A, output reg [8:0] D);
   reg [8:0] M[63:0]; // 64 words x 9 bits per word

   always @(posedge READ) begin
	  D[8:0] = M[A[5:0]][8:0];
   end

   // Assuming READ and WRITE are not asserted at the same time
   always @(posedge WRITE) begin
	  M[A[5:0]][8:0] = DATA[8:0];
   end

   // The initial value of the memory contains the entire program
   // Data and instructions stored in the same memory makes
   // the program quite confusing. It gets more interesting when
   // writing to memory is involved as well

   // The existing program computes successive terms of the Fibonacci Series
   // Observe the value of ACOUT[8:0] (the accumulator output) at every 3rd high WRITE signal
   initial begin
	  M[00][8:0] = 9'b010001100;// clear AC to 0 by ANDing with 0
	  M[01][8:0] = 9'b000001010;// load f(n-1) in AC
	  M[02][8:0] = 9'b111001001;// write AC, f(n-1) to f(n-2)
	  M[03][8:0] = 9'b010001100;// clear AC to 0 using AND again
	  M[04][8:0] = 9'b000001011;// load f(n) in AC
	  M[05][8:0] = 9'b111001010;// write AC, f(n) to f(n-1)
	  M[06][8:0] = 9'b000001001;// add f(n-1) to AC to get f(n+1)
	  M[07][8:0] = 9'b111001011;// write AC, f(n+1) to f(n)
	  M[08][8:0] = 9'b100000000;// jump back to instruction 00
	  M[09][8:0] = 9'b000000000;// memory f(n-2), initially f(0) = 0
	  M[10][8:0] = 9'b000000001;// memory f(n-1), initially f(1) = 1
	  M[11][8:0] = 9'b000000001;// memory f(n), initially n = 2, f(2) = 1
	  M[12][8:0] = 9'b000000000;// memory 0 for clearing AC using AND
	  M[13][8:0] = 9'b000000000;
	  M[14][8:0] = 9'b000000000;
	  M[15][8:0] = 9'b000000000;
	  M[16][8:0] = 9'b000000000;
	  M[17][8:0] = 9'b000000000;
	  M[18][8:0] = 9'b000000000;
	  M[19][8:0] = 9'b000000000;
	  M[20][8:0] = 9'b000000000;
	  M[21][8:0] = 9'b000000000;
	  M[22][8:0] = 9'b000000000;
	  M[23][8:0] = 9'b000000000;
	  M[24][8:0] = 9'b000000000;
	  M[25][8:0] = 9'b000000000;
	  M[26][8:0] = 9'b000000000;
	  M[27][8:0] = 9'b000000000;
	  M[28][8:0] = 9'b000000000;
	  M[29][8:0] = 9'b000000000;
	  M[30][8:0] = 9'b000000000;
	  M[31][8:0] = 9'b000000000;
	  M[32][8:0] = 9'b000000000;
	  M[33][8:0] = 9'b000000000;
	  M[34][8:0] = 9'b000000000;
	  M[35][8:0] = 9'b000000000;
	  M[36][8:0] = 9'b000000000;
	  M[37][8:0] = 9'b000000000;
	  M[38][8:0] = 9'b000000000;
	  M[39][8:0] = 9'b000000000;
	  M[40][8:0] = 9'b000000000;
	  M[41][8:0] = 9'b000000000;
	  M[42][8:0] = 9'b000000000;
	  M[43][8:0] = 9'b000000000;
	  M[44][8:0] = 9'b000000000;
	  M[45][8:0] = 9'b000000000;
	  M[46][8:0] = 9'b000000000;
	  M[47][8:0] = 9'b000000000;
	  M[48][8:0] = 9'b000000000;
	  M[49][8:0] = 9'b000000000;
	  M[50][8:0] = 9'b000000000;
	  M[51][8:0] = 9'b000000000;
	  M[52][8:0] = 9'b000000000;
	  M[53][8:0] = 9'b000000000;
	  M[54][8:0] = 9'b000000000;
	  M[55][8:0] = 9'b000000000;
	  M[56][8:0] = 9'b000000000;
	  M[57][8:0] = 9'b000000000;
	  M[58][8:0] = 9'b000000000;
	  M[59][8:0] = 9'b000000000;
	  M[60][8:0] = 9'b000000000;
	  M[61][8:0] = 9'b000000000;
	  M[62][8:0] = 9'b000000000;
	  M[63][8:0] = 9'b000000000;
   end
endmodule // memory
