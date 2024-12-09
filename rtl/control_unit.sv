module control_unit (
    input   logic [31:0] instruction,
    output  logic        reg_write_d,  
    output  logic [1:0]  result_src_d,
    output  logic        mem_write_d,
    output  logic        jump_d,
    output  logic        branch_d,
    output  logic [2:0]  alu_control_d,
    output  logic        alu_src_d,
    output  logic [1:0]  imm_src_d
);

    // Extract instruction fields
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    // Main Decoder
    main_decoder main_decoder_unit (
        .opcode(opcode),
        .reg_write_d(reg_write_d),
        .result_src_d(result_src_d),
        .mem_write_d(mem_write_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alu_src_d(alu_src_d),
        .imm_src_d(imm_src_d)
    );

    // ALU Decoder
    alu_decoder alu_decoder_unit (
        .funct3(funct3),
        .funct7(funct7),
        .alu_control_d(alu_control_d)
    );

endmodule
