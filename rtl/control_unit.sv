module control_unit #(
    parameter DATA_WIDTH = 32,
    parameter ALUCTRL_WIDTH = 5,
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]      instruction,
    output  logic                       reg_write, 
    output  logic                       mem_read, 
    output  logic                       meg_write, 
    output  logic                       branch, 
    output logic [ALUCTRL_WIDTH-1:0]    alu_ctrl,  // Adjusted for 5-bit ALU control
    output logic [1:0]                  pc,
    output logic [2:0]                  imm_src
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [1:0] alu_op;
    logic [1:0] funct7_5_0; // New signal for the 5th and 0th bits of funct7

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign funct7_5_0 = {funct7[5], funct7[0]}; // Extract the required bits

    main_decoder main_decoder_unit (
        .opcode(opcode),
        .reg_write(reg_write), 
        .mem_read(mem_read), 
        .mem_write(mem_write),
        .branch(branch), 
        .alu_op(alu_op), 
        .pc_src(pc_src), 
        .imm_src(imm_src)
    );

    alu_decoder alu_decoder_unit (
        .func3(funct3),
        .alu_op(alu_op),
        .func7_5_0(funct7_5_0),
        .alu_ctrl(alu_ctrl)
    );

endmodule
