// The main CPU description
// All units are negative edge triggered
// memory.v is not included here as it is external

// IR is positive edge triggered to load its data
// beforehand, without which we run into problems
// (That is, IR loads DATA just as it changes)


`include "alu.v"
`include "buffer.v"
`include "counter.v"
`include "decoder.v"
`include "dff.v"
`include "parallel.v"


module simplecpu(input clk, input wire [8:0] D, output READ, WRITE, output wire [5:0] A, output wire [8:0] DATA);
   wire [8:0] BUS;

   // Zero and carry flags
   wire 	  ZERO, CARRY;

   // Output wires of all the registers
   // Input wires are from the data bus
   // Output of AR is simply A
   wire [5:0] PCOUT;
   wire [8:0] DROUT;
   wire [8:0] ACOUT;
   wire [2:0] IROUT;

   // Output wires of the ALU
   wire [8:0] ALUOUT;
   wire 	  ALUCARRY;

   // Counter state
   wire [4:0] STATE;

   // Decoder outputs (one-hot state) (total 14)
   wire 	  FETCH1;// 00000
   wire 	  FETCH2;// 00001
   wire 	  FETCH3;// 00010
   wire 	  ADD1;  // 10000
   wire 	  ADD2;  // 10001
   wire 	  SUB1;  // 10010
   wire 	  SUB2;  // 10011
   wire 	  AND1;  // 10100
   wire 	  AND2;  // 10101
   wire 	  INC1;  // 10110
   wire 	  JMP1;  // 11000
   wire 	  JC1;   // 11010
   wire 	  JZ1;   // 11100
   wire 	  MOV1;  // 11110

   // Conditional operation states
   wire 	  JC1VALID;
   assign JC1VALID = JC1 && CARRY; // Self-explanatory
   wire 	  JZ1VALID;
   assign JZ1VALID = JZ1 && ZERO; // Self-explanatory

   // Unused decoder outputs (18)
   wire 	  UN01;
   wire 	  UN02;
   wire 	  UN03;
   wire 	  UN04;
   wire 	  UN05;
   wire 	  UN06;
   wire 	  UN07;
   wire 	  UN08;
   wire 	  UN09;
   wire 	  UN10;
   wire 	  UN11;
   wire 	  UN12;
   wire 	  UN13;
   wire 	  UN14;
   wire 	  UN15;
   wire 	  UN16;
   wire 	  UN17;
   wire 	  UN18;

   // Control signals for the parallel load registers
   // CLK is common to all
   wire 	  ARLOAD;
   wire 	  DRLOAD;
   wire 	  IRLOAD;

   // Control signals for the counters
   wire 	  PCLOAD;
   wire 	  PCINC;
   wire 	  ACLOAD;
   wire 	  ACINC;

   // Inputs for the CARRY dff
   wire 	  CARRYCLK;
   wire 	  CARRYD;

   // Initial clear signal for PC and AC
   reg  	  INITIALCLR;

   // CPU should run only after PC and AC are cleared
   assign CLK = clk && (~INITIALCLR);

   // Control signal for the ALU
   wire [1:0] ALUSEL;

   // Control signal for the counter in the hardwired control unit
   wire 	  LOAD;
   wire 	  CLR;
   wire 	  INC;

   // Control signals for the tri-state buffers
   wire 	  MEMBUS;
   wire 	  PCBUS;
   wire 	  DRBUS;

   // Initializing the registers
   // AR, DR and IR are parallel load registers
   parallel6bit AR(.CLK(CLK), .LD(ARLOAD), .DATA(BUS[5:0]), .STATE(A[5:0]));
   parallel9bit DR(.CLK(CLK), .LD(DRLOAD), .DATA(BUS[8:0]), .STATE(DROUT[8:0]));
   parallel3bit IR(.CLK(CLK), .LD(IRLOAD), .DATA(BUS[8:6]), .STATE(IROUT[2:0]));

   // Note: I don't have a very good explanation for why this arrangement
   // of CLKs and CLRs for PC, AC and COUNT works yet.

   // PC is a counter
   counter6bit PC(.CLK(CLK), .LD(PCLOAD), .INC(PCINC), .CLR(INITIALCLR), .DATA(BUS[5:0]), .STATE(PCOUT[5:0]));

   // AC is a counter connected to the ALU outputs
   counter9bit AC(.CLK(CLK), .LD(ACLOAD), .INC(ACINC), .CLR(INITIALCLR), .DATA(ALUOUT[8:0]), .STATE(ACOUT[8:0]));
   ALU ALU1(.SEL(ALUSEL[1:0]), .AC(ACOUT[8:0]), .DR(BUS[8:0]), .ALUCARRY(ALUCARRY), .OUT(ALUOUT[8:0]));

   // Tri-state buffers for the data bus
   buffer6bit PCBUF(.in(PCOUT[5:0]), .enable(PCBUS), .out(BUS[5:0]));
   buffer9bit DRBUF(.in(DROUT[8:0]), .enable(DRBUS), .out(BUS[8:0]));
   buffer9bit MEMBUF(.in(D[8:0]), .enable(MEMBUS), .out(BUS[8:0]));

   // The counter and decoder for the control unit
   // Counter has data inputs {1, IR[2:0], 0}
   // Counter uses clk directly (as CLR clears it)
   // Decoder has outputs as the one-hot states and some unused outputs
   counter5bit COUNT(.CLK(clk), .LD(LOAD), .INC(INC), .CLR(CLR), .DATA({1'b1, IROUT[2:0], 1'b0}), .STATE(STATE[4:0]));
   decoder DEC(.IN(STATE[4:0]), .OUT({FETCH1, FETCH2, FETCH3, UN01, UN02, UN03, UN04, UN05, UN06, UN07, UN08, UN09, UN10, UN11, UN12, UN13, ADD1, ADD2, SUB1, SUB2, AND1, AND2, INC1, UN14, JMP1, UN15, JC1, UN16, JZ1, UN17, MOV1, UN18}));

   // Combinational logic for the control signals
   // Combinational logic for the STATE counter
   // STATE needs to be set to zero in the beginning
   // The STATE counter uses clk directly as only synchronous reset is available
   assign CLR = ADD2 || AND2 || SUB2 || INC1 || JMP1 || JC1 || JZ1 || MOV1 || INITIALCLR;
   assign INC = FETCH1 || FETCH2 || ADD1 || AND1 || SUB1;
   assign LOAD = FETCH3;

   // Control signals for the tri-state buffers
   assign PCBUS = FETCH1;
   assign DRBUS = FETCH3 || ADD2 || AND2 || SUB2 || JMP1 || JC1VALID || JZ1VALID;
   assign MEMBUS = FETCH2 || ADD1 || AND1 || SUB1;

   // Control signals for the registers
   assign ARLOAD = FETCH1 || FETCH3;
   assign PCLOAD = JMP1 || JC1VALID || JZ1VALID;
   assign PCINC = FETCH2;
   assign DRLOAD = FETCH2 || ADD1 || AND1 || SUB1;
   assign ACLOAD = ADD2 || AND2 || SUB2;
   assign ACINC = INC1;
   assign IRLOAD = FETCH3;
   assign ALUSEL[1:0] = {AND2, SUB2};

   // Control signal for the READ output
   assign READ = FETCH2 || ADD1 || AND1 || SUB1;

   // Control signal and data for the WRITE output
   assign WRITE = MOV1;
   assign DATA[8:0] = ACOUT[8:0];

   // Zero flag
   assign ZERO = ~(ACOUT[0] || ACOUT[1] || ACOUT[2] || ACOUT[3] || ACOUT[4] || ACOUT[5] || ACOUT[6] || ACOUT[7] || ACOUT[8]);

   // Carry flag register
   // Carry becomes 1 if addition is done that exceeds the range
   // Carry is set to 0 on SUB, AND or INC
   dff CARRYFF(.CLK(CARRYCLK), .D(CARRYD), .Q(CARRY));
   assign CARRYCLK = ADD2 || SUB2 || AND2 || INC1;
   assign CARRYD = (ALUCARRY && ADD2);

   initial begin
	  // Set program counter to zero
	  // Set accumulator to zero
	  // Set state to FETCH1
	  INITIALCLR = 1;
   end

   // May need to start with clk=1 because of this
   always @(negedge clk) begin
	  INITIALCLR = 0;
   end
endmodule // simplecpu
