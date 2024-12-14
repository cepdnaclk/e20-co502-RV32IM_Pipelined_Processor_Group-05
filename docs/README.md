---
layout: home
permalink: index.html

# RV32IM Pipelined Processor
---

[comment]: # "This is the standard layout for the project, but you can clean this and use your own template"

# Project Title

---

<!-- 
This is a sample image, to show how to add images to your page. To learn more options, please refer [this](https://projects.ce.pdn.ac.lk/docs/faq/how-to-add-an-image/)

![Sample Image](./images/sample.png)
 -->

## Team
-  E/20/024, Ariyarathna D.B.S., [email](e20024@eng.pdn.ac.lk)
-  E/20/242, Malinga G.A.I., [email](e20242@eng.pdn.ac.lk)
-  E/20/366 , Seneviratne A.P.B.P., [email](e20366@eng.pdn.ac.lk)

## Table of Contents
1. [RV32IM Pipeline Processor Design](#introduction)
2. [Key Features of the RV32IM Processor](#other-sub-topics)
3. [Links](#links)

---

## RV32IM Pipeline Processor Design

This project focuses on designing a 32-bit RISC-V RV32IM pipeline processor with five stages: Instruction Fetch (IF), Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). The processor supports the RV32I base instructions and the M-extension for integer multiplication and division. The design emphasizes efficient instruction flow with minimized hazards, utilizing forwarding and stalling for data hazards and branch prediction for control hazards.

The processor is implemented using Verilog , simulated with tools like ModelSim, and tested using the RISC-V toolchain and compliance tests. Performance optimizations include pipeline balancing and optional cache integration for faster memory access. The project delivers a functional HDL codebase, test results, and optionally, an FPGA prototype.

This design project enhances understanding of processor architecture, pipelining, and ISA implementation, providing a solid foundation for exploring advanced computer engineering concepts.

## Key Features of the RV32IM Processor

###1. Pipeline Stages:
Instruction Fetch (IF)
Instruction Decode (ID)
Execute (EX)
Memory Access (MEM)
Write Back (WB)
The design ensures efficient instruction flow with minimized hazards and optimized performance.

###2. Supported Instruction Set:
RV32I Base Instructions: Arithmetic, logical, control flow, and load/store operations.
M Extension: Multiplication (MUL) and division (DIV) instructions.

###3. Hazard Handling:
Data hazards: Managed through forwarding and stalling mechanisms.
Control hazards: Addressed using branch prediction or static/dynamic strategies.

###4. Performance Enhancements:
Pipeline balancing to reduce cycle latency.
Cache integration for faster memory access.

###5. Simulation and Verification:
Implemented using HDL (Verilog or VHDL).
Verified using testbenches with RISC-V compliance tests and custom test cases.

###6. Tools and Technologies:
Hardware Description Language (HDL): Verilog/VHDL for processor implementation.
Simulation Tools: ModelSim, Vivado, or equivalent.
Synthesis Tools: FPGA tools like Quartus or Vivado for hardware prototyping.
RISC-V Toolchain: GCC compiler and spike simulator for program generation and debugging.


## Links

- [Project Repository](https://github.com/cepdnaclk/{{ page.repository-name }}){:target="_blank"}
- [Project Page](https://cepdnaclk.github.io/{{ page.repository-name}}){:target="_blank"}
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)


[//]: # (Please refer this to learn more about Markdown syntax)
[//]: # (https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
