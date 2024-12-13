<center>

## Aadin Personal Statement

</center>

explaining what you contributed, 
a reflection about what you have learned in this project, 
mistakes you made, 
special design decisons, and what you might do differently if you were to do it again 


### Contents

[**Reflections**](#reflections)

[**Design Decisions**](#design-decisions)
- [all_tests.sh](#all_testssh)
- [data_memory.sv](#data_memorysv)
- [branch_control.sv](#branch_controlsv)
- [sign_extend.sv](#sign_extendsv)
- [alu_decoder.sv](#alu_decodersv)
- [top.sv](#topsv)
- [f1-test](#f1-test)
- [cache](#cache)

[**What would I do differently?**](#what-i-might-do-differently)

<br>

---

<br>

### Reflections

- From this coursework, I learned how to overcome challenges when working as a group, especially to do with different skill levels and commitments of teammates
- I learnt to a deeper extent how to use Github and git version control in a way that might emulate a professional workspace
- I learnt how to write bash scripts to a much higher level for example evidenced in [all_tests.sh](../all_tests.sh) to solve the problem of running many tests with different strutures and requirements
- What I did well was as well as being repo master, I also had to micromanage every individuals work, which I often found demanding but I dealt with it in a structured way - for instance, to help my teammates, I made control logic table so that everyone had a centralised form to compare control/logic signals to

### Design Decisions

#### all_tests.sh

- **Relevant Commits:** 
    - fully functional all_tests.sh script and added to single cycle documentations
- Written to call all tests and testbenches available in the tb/ folder in one command.
- This script starts by running the Gtest testbenches and the output for the number of tests passed can be seen in the terminal
- ![image0](image.png)

- This bit of the script makes sure that all the tests pass in which case it will proceed to the next tests will be run
![failtest](image-1.png)
- In an incorrect case:
    - enter the tb directory and run **./doit.sh** <tests/<file_tb.cpp>> to run an individual test or without any parameters to run all tests in the tests/ directory 
    - enter the reference directory and running the **./reference.sh** (ensure that the data memory is initialised to the relevant .mem file)
- The next stage is to connect the vbuddy and then execute the f1 program and the pdf plots
![vbuddy](image-2.png)
![runvbuddy](image-3.png)

### major fixes

- **Relevant Commits:**
    -

- There were some major fixes 

#### data_memory.sv

- **Relevant Commits:**
    - 

- In this file, I wrote all the logic to implement LB, LBU, LH, LHU and LW along side SW, SH and SB
- I used the func3 and case statemnets to know (assuming aligned address access for a byte addressable memory)

#### branch_control.sv

- **Relevant Commits:**
    -

- Takes the data from the output of the register file and then using a branch_src control signal to do the relavant conditional comparison, then outputs pc_src to take the conditional change in PC
- Put this block outside the control unit as I could see issues with the decode stage in the pipelined cpu, made for scalability into pipelining.
- Realised that the branch unit would sit in a different stage to the control unit

#### sign_extend.sv

- **Relevant Commits:**
    - 
- Designed to work for all types of instructions especially 

#### alu_decoder.sv
- **Relevant Commits:**
    -
- Started by writing alu decoder and 

#### top.sv 
- **Relevant Commits:**
    -

- Put the entire cpu together drawing the followin cpu schematic as a reference

#### f1-test
- **Relevant Commits:**
    - finished pdf testbench and f1 for vbuddy

- Inital design was to use it as a reset then I updated it to function

#### cache

- **Relevant Commits:**
    - 
- Helped to put together 

### What I might do differently?

- Within the group, I would enforce a better and stricter timeline so that I can manage when people deliver their sections and leave enough time for them to test and for me to help them with their tests.

- If I had more time, I would continue to add instruction cache
