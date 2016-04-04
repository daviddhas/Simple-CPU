Very Simple CPU

Incase you don't have iverilog or gtkwave( both really cool opensource tools),
sudo apt-get install iverilog
sudo apt-get install gtkwave

Run the simulation using:
"iverilog testbench.v && ./a.out && gtkwave dump.vcd"

Now, Insert the data signals in the wave form viewer to check the output.

The memory contains a program to calculate successive Fibonacci numbers.
An explanation for how the program works may be found in "memory.v". In
GTKWave, view the waveforms of WRITE and ACOUT[8:0] (the accumulator output)
side by side. Successive Fibonacci numbers are present in ACOUT[8:0] at every
3rd WRITE signal.

Note: OVERFLOW has not been implemented.

Opcode List:
000: ADD
001: SUB
010: AND
011: INC
100: JMP
101: JC
110: JZ
111: MOV
