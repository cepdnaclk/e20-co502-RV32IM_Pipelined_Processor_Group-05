[comment]: # "This is the standard layout for the project, but you can clean this and use your own template"

# RV32IM Pipeline Processor 

---

<!-- 
This is a sample image, to show how to add images to your page. To learn more options, please refer [this](https://projects.ce.pdn.ac.lk/docs/faq/how-to-add-an-image/)

![Sample Image](./images/sample.png)
 -->

### Team members
-  E/20/024, Ariyarathna D.B.S., [e20024@eng.pdn.ac.lk]
-  E/20/242, Malinga G.A.I., [e20242@eng.pdn.ac.lk]
-  E/20/366 , Seneviratne A.P.B.P., [e20366@eng.pdn.ac.lk]

### Supervisor
- Dr. Isuru Nawinna , [isurunawinne@eng.pdn.ac.lk]
## Table of Contents
1. [RV32IM Pipeline Processor Design](#RV32IM-Pipeline-Processor-Design)
2. [Key Features of the RV32IM Processor](#key-Features-of-the-RV32IM-Processor)
3. [Links](#links)

---

## RV32IM Pipeline Processor Design

This project involves designing a 32-bit RISC-V RV32IM pipelined processor featuring the standard five stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). The processor supports the full RV32I base instruction set along with the M-extension for integer multiplication and division. The design emphasizes correct instruction flow, efficient pipeline operation, and proper handling of hazards.

The processor is implemented in Verilog and verified using comprehensive simulation workflows. A custom testbench is used to stimulate the processor, while GTKWave assists with waveform analysis. Power and timing characteristics are evaluated using Synopsys PrimePower and PrimeTime, providing accurate reports for performance and timing validation.

This project strengthens understanding of processor architecture, pipeline behavior, RISC-V ISA implementation, timing analysis, and low-level hardware design.

## Key Features of the RV32IM Processor

### Pipeline Stages:
Instruction Fetch (IF)
Instruction Decode (ID)
Execute (EX)
Memory Access (MEM)
Write Back (WB)
The design ensures efficient instruction flow with minimized hazards and optimized performance.

### Supported Instruction Set:
RV32I Base Instructions: Arithmetic, logical, control flow, and load/store operations.
M Extension: Multiplication (MUL) and division (DIV) instructions.

### Hazard Handling:
Data hazards: Managed through forwarding and stalling mechanisms.
Control hazards: Addressed using branch prediction or static/dynamic strategies.

### Performance Enhancements:
Pipeline balancing for improved throughput.
Timing optimization based on PrimeTime analysis.
Power evaluation using PrimePower.

### Simulation and Verification:
Verilog implementation using structured modular design.
Testbench-based simulation to validate functional correctness.
GTKWave for waveform inspection.
Synopsys PrimePower for power analysis.
Synopsys PrimeTime for timing and path verification.
Tested with RISC-V toolchain and custom test programs.

### Tools and Technologies:
Hardware Description Language: Verilog
Simulation: Testbench + GTKWave
Timing & Power Analysis: Synopsys PrimeTime, Synopsys PrimePower
RISC-V Toolchain: GCC compiler and Spike simulator


## Links

- [Project Repository](https://github.com/cepdnaclk/e20-co502-RV32IM_Pipelined_Processor_Group-05)
- [Project Page](https://cepdnaclk.github.io/e20-co502-RV32IM_Pipelined_Processor_Group-05)
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)


[//]: # (Please refer this to learn more about Markdown syntax)
[//]: # (https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
