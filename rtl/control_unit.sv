module control_unit (
    /* verilator lint_off UNUSED */
    input   logic [31:0]                instruction,
    output  logic [4:0]                 alu_src,  
    output  logic [2:0]                 imm_src,
    output  logic [2:0]                 branch_src,
    output  logic                       mem_write, 
    output  logic [1:0]                 alu_mux_src,
    output  logic [1:0]                 wb_src,
    output  logic                       reg_write
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
        .func3(funct3),
        .alu_op(alu_op),
        .imm_src(imm_src),
        .branch_src(branch_src),
        .mem_write(mem_write),
        .alu_mux_src(alu_mux_src),
        .wb_src(wb_src),
        .reg_write(reg_write)     
    );

    alu_decoder alu_decoder_unit (
        .func3(funct3),
        .alu_op(alu_op),
        .func7_5_0(funct7_5_0),
        .alu_src(alu_src)
    );

endmodule
