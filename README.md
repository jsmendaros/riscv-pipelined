# riscv-pipelined
Pipelined RISC-V 64-bit processor implementation in Verilog


![image](https://user-images.githubusercontent.com/35986446/125319563-78a5bc00-e36d-11eb-895e-628bbbcf93b5.png)

Based on the above implementation from Computer Organization and Design RISC-V Edition by Patterson and Hennessy.

Created in Xilinx Vivado for Arty A7-35 board.

## Instructions supported
* Register-register: add, sub, and, or, xor
* Register-immediate: addi
* Branches: beq, bne, jal, jalr
* Load/Store: ld, lw, lh, lwu, lhu, sd, sw, sh

## Memory files
* Memory files were provided by my professor at (https://github.com/snapdensing/CoE113/tree/master/memory_model)
* Load and store instructions are intended to interface with these modules
