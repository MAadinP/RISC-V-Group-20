# Full instruction set 32-IM architecture
This branch contains a pipelined 32-IM RISC-V architectre with the entire instruction set.  
For a more detailed commit history of this version please see: [Pipelined Risc-V](https://github.com/TheZuzuSnuSnu/Risc-V), access has been given to pykc.


## Directory tree

```
.
├── Muxsel.png
├── README.md
├── all_tests.sh
├── rtl
│   ├── alu.sv
│   ├── branch_unit.sv
│   ├── control_unit.sv
│   ├── data_memory.sv
│   ├── hazard_unit.sv
│   ├── instruction_memory.sv
│   ├── instruction_memory_v1.sv
│   ├── mux.sv
│   ├── mux_2.sv
│   ├── mux_3.sv
│   ├── mux_4.sv
│   ├── pip_reg1.sv
│   ├── pip_reg2.sv
│   ├── pip_reg3.sv
│   ├── pip_reg4.sv
│   ├── plus_4.sv
│   ├── program_counter.sv
│   ├── reg_file.sv
│   ├── sign_extend.sv
│   └── top.sv
├── schematic2.png
└── tb
    ├── asm
    │   ├── 1_addi_bne.s
    │   ├── 2_li_add.s
    │   ├── 3_lbu_sb.s
    │   ├── 4_jal_ret.s
    │   ├── 5_pdf.s
    │   ├── auipc.s
    │   ├── f1.s
    │   ├── lbu_lhu.s
    │   └── lui.s
    ├── assemble.sh
    ├── attach_usb.sh
    ├── doit.sh
    ├── f1_test
    │   ├── assemble.sh
    │   ├── f1.sh
    │   ├── f1.vcd
    │   ├── f1_vbuddy.cpp
    │   ├── program.hex
    │   ├── test_out
    │   │   └── f1
    │   │       └── program.dis
    │   ├── vbuddy.cfg
    │   └── vbuddy.cpp
    ├── reference
    │   ├── PDF.vcd
    │   ├── assemble.sh
    │   ├── format_hex.sh
    │   ├── gaussian.mem
    │   ├── noisy.mem
    │   ├── pdf.asm
    │   ├── pdf.out
    │   ├── pdf.out.reloc
    │   ├── pdf.s
    │   ├── program.hex
    │   ├── reference.sh
    │   ├── reference_tb.cpp
    │   ├── sine.mem
    │   ├── test_out
    │   │   └── pdf
    │   │       └── program.dis
    │   ├── triangle.mem
    │   ├── vbuddy.cfg
    │   └── vbuddy.cpp
    ├── test_out
    │   ├── 1_addi_bne
    │   │   ├── data.hex
    │   │   ├── program.dis
    │   │   ├── program.hex
    │   │   └── waveform.vcd
    │   ├── 2_li_add
    │   │   ├── data.hex
    │   │   ├── program.dis
    │   │   ├── program.hex
    │   │   └── waveform.vcd
    │   ├── 3_lbu_sb
    │   │   ├── data.hex
    │   │   ├── program.dis
    │   │   ├── program.hex
    │   │   └── waveform.vcd
    │   ├── 4_jal_ret
    │   │   ├── data.hex
    │   │   ├── program.dis
    │   │   ├── program.hex
    │   │   └── waveform.vcd
    │   └── 5_pdf
    │       ├── data.hex
    │       ├── program.dis
    │       ├── program.hex
    │       └── waveform.vcd
    ├── tests
    │   ├── base_testbench.h
    │   ├── cpu_testbench.h
    │   ├── mux_tb.cpp
    │   ├── reg_file_tb.cpp
    │   └── verify.cpp
    └── waveform.vcd
```

## Schematic
In the schematic below, the mux select wires are unlabelled and several wires have been grouped togethor such as 'Mux 1-7 sel'. This has been done for the sake of clarity.
![mux sel tables](schematic2.png)


## Mux sel table
The table below cotains the select codes for the varying muxes to help make the schematic above clearer. The alu select and branch select remain the same as in single cycle.

![mux sel tables](Muxsel.png)


## Evidence of working cpu
[Youtube playlist](https://www.youtube.com/watch?v=qjUhrumEX5c&list=PL78xv8np-SRZvxV5_pwV2YfbVGvgrlxk_)

