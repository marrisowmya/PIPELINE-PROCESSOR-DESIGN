# PIPELINE-PROCESSOR-DESIGN

Pipelining is a technique used in processors to increase instruction throughput (number of instructions executed per unit time). Just like an assembly line in a factory, different stages of instruction execution are divided into separate steps, allowing multiple instructions to be processed simultaneously.

A 4-stage pipelined processor divides the instruction execution into four sequential stages to improve performance by allowing multiple instructions to be processed simultaneously. The stages are:

Instruction Fetch (IF):
The processor fetches the instruction from memory.

Instruction Decode (ID):
The instruction is decoded, and the required registers or operands are identified.

Execute (EX):
The actual operation (like ADD, SUB) is performed using the decoded operands.

Memory/Write-Back (MEM):
The result is either written to a register or memory (if it’s a LOAD or STORE instruction).

✨ Advantages:
Increases instruction throughput.

Efficient CPU resource usage.

Improves overall performance.

