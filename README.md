# RISC16 – Custom 16-bit Processor in VHDL

A custom 16-bit RISC processor designed and implemented in VHDL and verified through simulation using ModelSim.

The project was built to explore processor architecture beyond individual digital-logic components by integrating a complete datapath, control logic, memory system, ALU operations, and control-flow execution.

## Architecture

The processor consists of:

- 16-bit Program Counter (PC)
- Instruction Memory
- 8 × 16-bit Register File
- 16-bit ALU
- Control Unit
- Data Memory
- Branch Control Logic
- Write-back datapath

The processor follows a fetch → decode → execute → memory → write-back flow.

## ALU

The ALU supports multiple arithmetic and logical operations:

- ADD
- SUB
- AND
- OR
- XOR
- Shift Left
- Shift Right

Status information is generated from ALU execution, including a Zero flag used by branch logic.

## Control Unit

The Control Unit decodes the instruction opcode and generates the control signals required by the datapath, including:

- Register Write
- Memory Read
- Memory Write
- ALU Source
- ALU Operation
- Branch Control

## Control Flow

Conditional branching is implemented using the ALU Zero flag and branch-control logic.

When the branch condition is satisfied, the processor selects the branch target as the next Program Counter instead of PC + 1.

### Verified Branch Example

ModelSim simulation verified a successful branch:

PC sequence:

0000 → 0001 → 0002 → 0005 → 0006 → 0007 → 0008

At PC = 0x0002, the branch condition is satisfied and execution jumps directly to PC = 0x0005.

This demonstrates that the processor can modify program flow dynamically instead of simply executing instructions sequentially.

## Simulation

The processor was verified in ModelSim using a dedicated VHDL testbench.

The simulation monitors key internal signals including:

- Clock
- Program Counter
- Current Instruction
- ALU Result
- Zero Flag
- Branch Signal

Example waveform:

![RISC16 ModelSim Branch Simulation](docs/branch_simulation.png)

## Project Structure

    RISC16_Processor/
    ├── alu.vhd
    ├── register_file.vhd
    ├── program_counter.vhd
    ├── instruction_memory.vhd
    ├── data_memory.vhd
    ├── control_unit.vhd
    ├── risc16_processor.vhd
    ├── risc16_processor_tb.vhd
    ├── docs/
    │   └── branch_simulation.png
    └── README.md

## Tools

- VHDL
- ModelSim Intel FPGA Starter Edition
- RTL simulation and waveform analysis

## What I Practiced

Through this project I practiced integrating individual digital-design blocks into a complete processor datapath, implementing instruction decoding and control signals, handling register and memory operations, implementing conditional control flow, and verifying processor behavior through simulation.

## Future Improvements

Possible extensions include:

- Additional instructions
- Jump instructions
- Expanded memory addressing
- FPGA implementation
- Pipelined execution
- Hazard detection and forwarding