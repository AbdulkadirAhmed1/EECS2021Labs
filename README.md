# Low Level Projects

## RISC-V

### Overview
The initiative in this section involves low-level programming where I write **assembly code** based on **procedural language code** (such as **C** or **Python**). These projects provide hands-on experience with assembly language and processor architecture.

### RISC-V Development
- **Assembly Translation**: I translate high-level programming concepts (such as **loops**, **recursion**, and **conditionals**) into RISC-V assembly, closely mimicking what a compiler does manually.

### Purpose
Understanding and working with **RISC-V architecture** is essential for developing efficient and optimized low-level software, particularly in embedded systems and hardware design. By working with RISC-V assembly, I gain a deeper understanding of how software interacts directly with hardware, which is critical for performance-sensitive applications such as operating systems, device drivers, and firmware development. Additionally, RISC-V's open-source nature makes it an important tool for creating custom processors and optimizing existing architectures.


____________________________________________________________________________________________________________________________________________________________________________________________

## Verilog

### Overview
In this section, I worked on Verilog projects where I designed digital systems and processors at a very low level.

### Projects
- **CPU Design**: *Project A*
  - **Status**: Active 
  - **Description**: I created a **CPU** with the following five main data paths:
        1. **IF (Instruction Fetch)**
        2. **ID (Instruction Decode)**
        3. **EXE (Execute)**
        4. **MEM (Memory Access)**
        5. **WB (Write Back)**

- **Cache System Design**: *Project B*
  - **Status**: N/A (Not Available)
  - **Description**: I developed a system that integrates multiple levels of **cache** (L1, L2, L3) to optimize the CPU's performance by minimizing memory access time. (This project implments 
    *Project A*)
      
- **Pipelined CPU Design**: *Project C*
  - **Status**: N/A (Not Available)
  - **Description**: In this project, the CPU design incorporates pipelining to increase instruction throughput. Each instruction passes through the stages of **IF**, **ID**, **EXE**, **MEM**, 
    and **WB**, allowing the CPU to execute multiple instructions at once. However, this specific design has not yet been fully implemented or tested. (This project implments *Project A*)


### Highlights
- **CPU Design**: Designed a functional CPU architecture that includes all the necessary components for instruction execution.
- **Cache Design**: Implemented cache levels (L1, L2, L3) to simulate and improve data retrieval times, reflecting real-world processor cache hierarchies. 

____________________________________________________________________________________________________________________________________________________________________________________________

### Conclusion: Manipulating Machine Code
In both **RISC-V assembly programming** and **Verilog hardware design**, we are working at a low level of abstraction. While in **RISC-V**, we translate high-level programming concepts into assembly code (which is closely tied to machine code), in **Verilog**, we design hardware that ultimately depends on machine code. The image below highlights how **assembly code** and **machine code** are closely connected, and how both **RISC-V** and **Verilog** play a role in manipulating and working with these low-level representations.

![Programming Paradigms](https://i.imgur.com/buYiSAt.jpeg)


