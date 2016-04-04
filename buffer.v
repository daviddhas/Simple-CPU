// Tri state buffers for the data bus


module buffer6bit(input wire [5:0] in, input enable, output wire [5:0] out);
   // Program counter buffer
   assign out[5:0] = enable ? in[5:0] : 6'bzzzzzz;
endmodule // buffer6bit


module buffer9bit(input wire [8:0] in, input enable, output wire [8:0] out);
   // Data register buffer and memory buffer
   assign out[8:0] = enable ? in[8:0] : 9'bzzzzzzzzz;
endmodule // buffer9bit
