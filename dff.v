// DFF required for storing the CARRY flag from the ALU
// The DFF needs to be posedge triggered to avoid trouble


module dff(input CLK, input D, output reg Q);
   always @(posedge CLK) Q = D;
endmodule // dff
