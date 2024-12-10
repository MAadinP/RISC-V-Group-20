<center>

## RISC-V-Group-20 Documentation (IAC Coursework)

</center>

<br>

### **Objectives**

- [x] To learn RISC-V 32-bit integer instruction set architecture 
- [x] To implement a single-cycle **RV32IM** instruction set in a microarchitecture
- [x] To implement the F1 starting light algorithm in **RV32IM** assembly language
- [x] To verify your **RV32IM** design
- [x] As stretched goal, to implement a simple pipelined version of the microarchitecture with hazard detection and mitigation
- [ ] As a further stretched goal, add data cache to the pipelined **RV32IM**
- [ ] As a further streched goal, complete the **RV32IM** processor


<br>

---

<br>


### Breakdown Of Tasks


<div align = "center">

| Tasks    |      Aadin      |  Ethan | Darryl | Dawud | Aidan |
|:----------:|:-------------:|:------:|:------:|:-----:|:-----:|
| col 1 is |  left-aligned | $1600 ||||
| col 2 is |    centered   |   $12 ||||
| col 3 is | right-aligned |    $1 ||||


</div>


<br>

---

<br>

### **Conventions**

- **Snakecase** (snake_case)
- Ensure all variables have a **lowercase** letter (so that the extensions colour them correctly)
- Keep variable names as **simple** and **clear** as possible (where possible, stick to the diagrams)
- Module declaration convention (see [mux.sv](rtl/mux.sv) for reference):
    - **One** tab after _input/output_ 
    - **One** soace bar after _logic_ 
    - **[XXXX_WIDTH-1:0]** 
    - **One** tab after longest bracket and then variable name
<br>

---

<br>

### **Structural Level Breakdown**

- [reg_file.sv](rtl/reg_file.sv)
- [control_unit.sv](rtl/control_unit.sv)
    - [main_decoder.sv](rtl/main_decoder.sv)
    - [alu_decoder.sv](rtl/alu_decoder.sv)
- [instruction_memory.sv](rtl/instruction_memory.sv)
- [mux.sv](rtl/mux.sv)
- [program_counter.sv](rtl/program_counter.sv)
- [sign_extend.sv](rtl/sign_extend.sv)
- [add.sv](rtl/add.sv)
- [data_memory.sv](rtl/data_memory.sv)
- [_top.sv_](rtl/top.sv) 



<br>

---

<br>

### Testbenches


<br>

---

<br>

### References

#### Control Unit

##### ALU Decoder (Control Unit)

<center>

</center>

##### Main Decoder (Control Unit)

<center>

</center>

#### Branch Unit
    
<center>

</center>

#### Sign Extend

<center>

</center>

#### ALU

<center>

</center>

#### Instruction Memory

<center>

</center>

#### Data Memory

<center>

</center>

#### Program Counter

<center>



</center>

<br>

---

<br>

### Extension - Pipelined CPU + RISCV-32M Implementation

#### Pipelined CPU